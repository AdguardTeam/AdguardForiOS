/**
       This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
       Copyright © Adguard Software Limited. All rights reserved.
 
       Adguard for iOS is free software: you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation, either version 3 of the License, or
       (at your option) any later version.
 
       Adguard for iOS is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.
 
       You should have received a copy of the GNU General Public License
       along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

import DnsAdGuardSDK

// MARK: - data types -

// this extension adds ui features to data type
extension DnsRequestProcessedEvent.ProcessedStatus {
    var title: String {
        switch self {
        case .processed:
            return String.localizedString("dns_request_status_processed")
        case .encrypted:
            return String.localizedString("dns_request_status_encrypted")
        case .allowlistedByUserFilter, .allowlistedByDnsFilter:
            return String.localizedString("dns_request_status_allowlisted")
        case .blocklistedByUserFilter, .blocklistedByDnsFilter:
            return String.localizedString("dns_request_status_blocked")
        }
    }

    var textColor: UIColor {
        let allowedColor = UIColor.AdGuardColor.lightGreen1
        let blockedColor = UIColor.AdGuardColor.red
        let processedColor = UIColor.AdGuardColor.yellow2

        switch self {
        case .processed:
            return processedColor
        case .encrypted:
            return allowedColor
        case .allowlistedByUserFilter, .allowlistedByDnsFilter:
            return allowedColor
        case .blocklistedByUserFilter, .blocklistedByDnsFilter:
            return blockedColor
        }
    }
}
    
enum DnsLogButtonType {
    case removeDomainFromWhitelist, removeRuleFromUserFilter, addDomainToWhitelist, addRuleToUserFlter

    var buttonTitle: String {
        switch self {
        case .removeDomainFromWhitelist:
            return String.localizedString("remove_from_whitelist")
        case .removeRuleFromUserFilter:
            return String.localizedString("remove_from_blacklist")
        case .addDomainToWhitelist:
            return String.localizedString("add_to_whitelist")
        case .addRuleToUserFlter:
            return String.localizedString("add_to_blacklist")
        }
    }
}

extension DnsLogRecord
{
    func getButtons() -> [DnsLogButtonType] {
        switch (event.processedStatus) {
        case .blocklistedByUserFilter:
            return [.removeRuleFromUserFilter]
        case .blocklistedByDnsFilter:
            return [.addDomainToWhitelist]
        case .allowlistedByUserFilter:
            return [.removeDomainFromWhitelist]
        case .allowlistedByDnsFilter:
            return [.addRuleToUserFlter]
        case .processed:
            return [.addDomainToWhitelist, .addRuleToUserFlter]
        case .encrypted:
            return [.addDomainToWhitelist, .addRuleToUserFlter]
        }
    }

    func time () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: event.startDate)
    }
}

protocol DnsRequestsDelegateProtocol {
    func requestsCleared()
}

enum DnsStatisticsDisplayedRequestsType {
    case allRequests, allowedRequests, blockedRequests
}

// MARK: - DnsRequestLogModel -
/**
 view model for ActivityViewController
 */
class DnsRequestLogViewModel {
    
    // MARK: - pubic fields
    /**
     array of log records. If search is active it returns filtered array
     */
    var records: [DnsLogRecord] {
        get {
            workingQueue.sync {
                return searchString.count > 0 ? searchRecords : allRecords
            }
        }
    }
    
    /**
     Type of the displayed statistics
    */
    var displayedStatisticsType: DnsStatisticsDisplayedRequestsType = .allRequests
    
    /**
     records changes observer. It calls when records array changes
     */
    var recordsObserver: (([DnsLogRecord])->Void)?
    
    /**
     search query string
     */
    var searchString: String {
        didSet {
            workingQueue.sync { [weak self] in
                guard let searchLowercased = self?.searchString.lowercased() else { return }
                guard let allRecords = self?.allRecords else { return }
                self?.searchRecords = allRecords.filter { $0.event.domain.lowercased().contains( searchLowercased ) }
            }
            recordsObserver?(records)
        }
    }
    
    var delegate: DnsRequestsDelegateProtocol? = nil
    
    // MARK: - private fields
    
    private let dnsTrackers: DnsTrackersProviderProtocol
    private let dnsStatistics: DnsLogStatisticsProtocol
    
    private var allRecords: [DnsLogRecord] = []
    private var searchRecords: [DnsLogRecord] = []
    
    private let workingQueue = DispatchQueue(label: "DnsRequestLogViewModel queue")
    
    // MARK: - init
    init(dnsTrackers: DnsTrackersProviderProtocol, dnsStatistics: DnsLogStatisticsProtocol) {
        self.dnsTrackers = dnsTrackers
        self.dnsStatistics = dnsStatistics
        self.searchString = ""
    }
    
    // MARK: - public methods
    /**
     obtains records array from vpnManager
    */
    func obtainRecords(for type: BlockedRecordType, domains: Set<String>? = nil) {
        workingQueue.async {[weak self] in
            self?.obtainRecordsInternal(for: type, domains: domains)
        }
    }
    
    func clearRecords(){
        workingQueue.sync { [weak self] in
            self?.allRecords = []
            self?.searchRecords = []
        }
        delegate?.requestsCleared()
    }
    
    private func obtainRecordsInternal(for type: BlockedRecordType, domains: Set<String>? = nil) {

        let events = (try? dnsStatistics.getDnsLogRecords()) ?? []
        let domainParser = try? DomainParser()
        allRecords = events.map {
            let firstLevelDomain = domainParser?.parse(host: $0.domain)?.domain
            let tracker = firstLevelDomain == nil ? nil : dnsTrackers.getTracker(by: firstLevelDomain!)
            return DnsLogRecord(event: $0, tracker: tracker)
        }

        recordsObserver?(allRecords)
    }
}
