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

import SharedAdGuardSDK
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
        case .blocklistedByUserFilter, .blocklistedByDnsFilter, .blocklistedByDnsServer:
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
        case .blocklistedByUserFilter, .blocklistedByDnsFilter, .blocklistedByDnsServer:
            return blockedColor
        }
    }
}

enum DnsLogButtonType {
    case removeDomainFromWhitelist, removeRuleFromUserFilter, addDomainToAllowList, addRuleToUserFlter

    var buttonTitle: String {
        switch self {
        case .removeDomainFromWhitelist:
            return String.localizedString("remove_from_whitelist")
        case .removeRuleFromUserFilter:
            return String.localizedString("remove_from_blacklist")
        case .addDomainToAllowList:
            return String.localizedString("add_to_whitelist")
        case .addRuleToUserFlter:
            return String.localizedString("add_to_blacklist")
        }
    }
}

extension DnsLogRecord {
    func getButtons() -> [DnsLogButtonType] {
        switch (event.processedStatus, userFilterStatus) {
        case (.processed, .none), (.encrypted, .none):
            return [.addRuleToUserFlter]
        case (.processed, .allowlisted), (.encrypted, .allowlisted):
            return [.removeDomainFromWhitelist]
        case (.processed, .blocklisted), (.encrypted, .blocklisted):
            return [.removeRuleFromUserFilter]
        case (.blocklistedByDnsFilter, .none), (.blocklistedByDnsFilter, .blocklisted):
            return [.addDomainToAllowList]
        case (.blocklistedByDnsFilter, .allowlisted):
            return [.removeDomainFromWhitelist]
        case (.blocklistedByDnsServer, _):
            return []
        case (.allowlistedByUserFilter, .none):
            return [.addRuleToUserFlter, .addDomainToAllowList]
        case (.allowlistedByUserFilter, .allowlisted):
            return [.removeDomainFromWhitelist]
        case (.allowlistedByUserFilter, .blocklisted):
            return [.removeRuleFromUserFilter]
        case (.allowlistedByDnsFilter, .none):
            return [.addRuleToUserFlter]
        case (.allowlistedByDnsFilter, .allowlisted):
            return [.removeDomainFromWhitelist]
        case (.allowlistedByDnsFilter, .blocklisted):
            return [.removeRuleFromUserFilter]
        case (.blocklistedByUserFilter, .none):
            return [.addRuleToUserFlter, .addDomainToAllowList]
        case (.blocklistedByUserFilter, .allowlisted):
            return [.removeDomainFromWhitelist]
        case (.blocklistedByUserFilter, .blocklisted):
            return [.removeRuleFromUserFilter]
        }
    }

    /// returnes status title. For example - "Processed(Added to allowlist)"
    func getStatusTitle()->String {
        let eventStatusTitle = event.processedStatus.title

        var additionalTitleKey: String? = nil
        switch (event.processedStatus, userFilterStatus) {
        case (.processed, .allowlisted), (.encrypted, .allowlisted):
            additionalTitleKey = "dns_request_user_status_added_to_whitelist"
        case (.processed, .blocklisted), (.encrypted, .blocklisted):
            additionalTitleKey = "dns_request_user_status_added_to_blacklist"
        case (.blocklistedByDnsFilter, .allowlisted):
            additionalTitleKey = "dns_request_user_status_added_to_whitelist"
        case (.allowlistedByUserFilter, .none):
            additionalTitleKey = "dns_request_user_status_removed_from_whitelist"
        case (.allowlistedByUserFilter, .blocklisted):
            additionalTitleKey = "dns_request_user_status_added_to_blacklist"
        case (.allowlistedByDnsFilter, .blocklisted):
            additionalTitleKey = "dns_request_user_status_added_to_blacklist"
        case (.blocklistedByUserFilter, .none):
            additionalTitleKey = "dns_request_user_status_removed_from_blacklist"
        case (.blocklistedByUserFilter, .allowlisted):
            additionalTitleKey = "dns_request_user_status_added_to_whitelist"
        default:
            break
        }

        if  let key = additionalTitleKey {
            let additionalTitle = String.localizedString(key)
            return "\(eventStatusTitle) (\(additionalTitle))"
        }
        else {
            return eventStatusTitle
        }
    }

    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: event.startDate)
    }
}

extension DnsProtectionUserRulesManagerProtocol {
    func removeDomainFromUserFilter(_ domain: String) throws {
        let subdomains: [String] = String.generateSubDomains(from: domain)
        let domainConverter = DomainConverter()
        var atLeastOneSuccess = false

        for subdomain in subdomains {
            do {
                let rule = domainConverter.userFilterBlockRuleFromDomain(subdomain)
                try self.removeRule(withText: rule, for: .blocklist)
                atLeastOneSuccess = true
            }
            catch {}
        }
        if !atLeastOneSuccess {
            throw UserRulesStorageError.ruleDoesNotExist(ruleString: domainConverter.userFilterBlockRuleFromDomain(domain))
        }
    }

    func removeDomainFromAllowlist(_ domain: String) throws {
        let subdomains: [String] = String.generateSubDomains(from: domain)
        var atLeastOneSuccess = false

        for subdomain in subdomains {
            do {
                try self.removeRule(withText: subdomain, for: .allowlist)
                atLeastOneSuccess = true
            }
            catch {}
        }
        if !atLeastOneSuccess {
            throw UserRulesStorageError.ruleDoesNotExist(ruleString: domain)
        }
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
    private let dnsProtection: DnsProtectionProtocol
    private let domainConverter: DomainConverterProtocol
    private let domainParser: DomainParser?
    private let logRecordHelper: DnsLogRecordHelper

    private var allRecords: [DnsLogRecord] = []
    private var searchRecords: [DnsLogRecord] = []

    private let workingQueue = DispatchQueue(label: "DnsRequestLogViewModel queue")

    // MARK: - init
    init(dnsTrackers: DnsTrackersProviderProtocol, dnsStatistics: DnsLogStatisticsProtocol, dnsProtection: DnsProtectionProtocol, domainConverter: DomainConverterProtocol, domainParser: DomainParserServiceProtocol) {
        self.dnsTrackers = dnsTrackers
        self.dnsStatistics = dnsStatistics
        self.dnsProtection = dnsProtection
        self.domainConverter = domainConverter
        self.domainParser = domainParser.domainParser
        self.searchString = ""
        self.logRecordHelper = DnsLogRecordHelper(dnsProtection: dnsProtection, dnsTrackers: dnsTrackers, domainConverter: domainConverter)
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

    func addDomainToAllowlist(_ domain: String) throws {
        try dnsProtection.add(rule: UserRule(ruleText: domain), override: true, for: .allowlist)
    }

    func addDomainToUserRules(_ domain: String) throws {
        let rule = domainConverter.userFilterBlockRuleFromDomain(domain)
        try dnsProtection.add(rule: UserRule(ruleText: rule), override: true, for: .blocklist)
    }

    func removeDomainFromUserFilter(_ domain: String) throws {
        try dnsProtection.removeDomainFromUserFilter(domain)
    }

    func removeDomainFromAllowlist(_ domain: String) throws {
        try dnsProtection.removeDomainFromAllowlist(domain)
    }

    func updateUserStatuses() {
        for record in allRecords {
            record.userFilterStatus =  logRecordHelper.getUserFilterStatusForDomain(record.event.domain)
        }
    }

    func logRecordViewModelFor(record: DnsLogRecord)->DnsRequestDetailsViewModel {
        return DnsRequestDetailsViewModel(logRecord: record, helper: logRecordHelper)
    }

    // MARK: - private methods

    private func obtainRecordsInternal(for type: BlockedRecordType, domains: Set<String>? = nil) {

        let events = (try? dnsStatistics.getDnsLogRecords()) ?? []
        allRecords = events.map {
            let firstLevelDomain = domainParser?.parse(host: $0.domain)?.domain ?? $0.domain
            let tracker = dnsTrackers.getTracker(by: firstLevelDomain)
            let userFilterStatus = logRecordHelper.getUserFilterStatusForDomain($0.domain)

            return DnsLogRecord(event: $0, tracker: tracker, firstLevelDomain: firstLevelDomain, userFilterStatus: userFilterStatus)
        }

        recordsObserver?(allRecords)
    }

}
