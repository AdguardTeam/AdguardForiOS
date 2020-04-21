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

import Foundation

// MARK: - data types -

struct DnsLogRecordCategory{
    let category: String?
    let name: String?
    let isTracked: Bool?
    let url: String?
    let isAdguardJson: Bool
}

class DnsLogRecordExtended {
    let logRecord: DnsLogRecord
    let category: DnsLogRecordCategory
    let dnsFiltersService: DnsFiltersServiceProtocol
    
    init(record: DnsLogRecord, category: DnsLogRecordCategory, dnsFiltersService: DnsFiltersServiceProtocol) {
        self.logRecord = record
        self.category = category
        self.dnsFiltersService = dnsFiltersService
    }
    
    lazy var matchedFilters: String? = {
        let allFilters = dnsFiltersService.filters
        let filterNames = logRecord.matchedFilterIds?.map {(filterId) -> String in
            if filterId == DnsFilter.userFilterId {
                return String.localizedString("system_blacklist")
            }
            if filterId == DnsFilter.whitelistFilterId {
                return String.localizedString("system_whitelist")
            }
            
            let filter = allFilters.first { (filter) in filter.id == filterId }
            return filter?.name ?? ""
        }
        return filterNames?.joined(separator: "\n") ?? nil
    }()
}

// this extension adds ui features to data type
extension DnsLogRecordUserStatus {
    func title()-> String {
        switch self {
        case .none:
            return ""
        case .movedToWhitelist:
            return String.localizedString("dns_request_user_status_added_to_whitelist")
        case .movedToBlacklist:
            return String.localizedString("dns_request_user_status_added_to_blacklist")
        case .removedFromWhitelist:
            return String.localizedString("dns_request_user_status_removed_from_whitelist")
        case .removedFromBlacklist:
            return String.localizedString("dns_request_user_status_removed_from_blacklist")
        }
    }
}
    
enum DnsLogButtonType {
    case removeDomainFromWhitelist, removeRuleFromUserFilter, addDomainToWhitelist, addRuleToUserFlter
}
 
extension DnsLogRecord 
{
    func getButtons() -> [DnsLogButtonType] {
        switch (status, userStatus) {
        case (.encrypted, _):
            return [.addDomainToWhitelist, .addRuleToUserFlter]
        case (_, .movedToBlacklist):
            return [.removeRuleFromUserFilter]
        case (_, .movedToWhitelist):
            return [.removeDomainFromWhitelist]
        case (_, .removedFromWhitelist):
            return [.addDomainToWhitelist]
        case (_, .removedFromBlacklist):
            return [.addRuleToUserFlter]
        case (.blacklistedByUserFilter, _):
            return [.removeRuleFromUserFilter]
        case (.blacklistedByOtherFilter, _):
            return [.addDomainToWhitelist]
        case (.whitelistedByUserFilter, _):
            return [.removeDomainFromWhitelist]
        case (.whitelistedByOtherFilter, _):
            return [.addRuleToUserFlter]
        case (.processed, _):
            return [.addDomainToWhitelist, .addRuleToUserFlter]
        }
    }
    
    func time () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self.date)
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
    var records: [DnsLogRecordExtended] {
        get {
            return searchString.count > 0 ? searchRecords : allRecords
        }
    }
    
    /**
     Type of the displayed statistics
    */
    var displayedStatisticsType: DnsStatisticsDisplayedRequestsType = .allRequests
    
    /**
     records changes observer. It calls when records array changes
     */
    var recordsObserver: (([DnsLogRecordExtended])->Void)?
    
    /**
     search query string
     */
    var searchString: String {
        didSet {
            let searchLowercased = searchString.lowercased()
            searchRecords = allRecords.filter { $0.logRecord.domain.lowercased().contains( searchLowercased ) }
            recordsObserver?(self.records)
        }
    }
    
    var delegate: DnsRequestsDelegateProtocol? = nil
    
    // MARK: - private fields
    
    private let dnsLogService: DnsLogRecordsServiceProtocol
    private let dnsTrackerService: DnsTrackerServiceProtocol
    private let dnsFiltersService: DnsFiltersServiceProtocol
    
    private var allRecords = [DnsLogRecordExtended]()
    private var searchRecords = [DnsLogRecordExtended]()
    
    private let workingQueue = DispatchQueue(label: "DnsRequestLogViewModel queue")
    
    // MARK: - init
    init(dnsLogService: DnsLogRecordsServiceProtocol, dnsTrackerService: DnsTrackerServiceProtocol, dnsFiltersService: DnsFiltersServiceProtocol) {
        self.dnsLogService = dnsLogService
        self.dnsTrackerService = dnsTrackerService
        self.dnsFiltersService = dnsFiltersService
        self.searchString = ""
    }
    
    // MARK: - public methods
    /**
     obtains records array from vpnManager
    */
    func obtainRecords(for type: ChartDateType, domains: Set<String>? = nil) {
        workingQueue.async {[weak self] in
            self?.obtainRecordsInternal(for: type, domains: domains)
        }
    }
    
    func clearRecords(){
        dnsLogService.clearLog()
        allRecords = []
        searchRecords = []
        delegate?.requestsCleared()
    }
    
    private func obtainRecordsInternal(for type: ChartDateType, domains: Set<String>? = nil) {
        let intervalTime = type.getTimeInterval()
        let firstDate = intervalTime.begin
        let lastDate = intervalTime.end
        
        let logRecords = dnsLogService.readRecords()
        allRecords = [DnsLogRecordExtended]()
        
        for logRecord in logRecords.reversed() {
            if let domains = domains, !domains.contains(logRecord.domain) {
                continue
            }
            
            if !(logRecord.date <= firstDate && logRecord.date >= lastDate) {
                continue
            }
            
            if displayedStatisticsType == .blockedRequests {
                if !(logRecord.status == .blacklistedByOtherFilter || logRecord.status == .blacklistedByUserFilter) {
                    continue
                }
            }
            
            if displayedStatisticsType == .allowedRequests {
                if logRecord.status == .blacklistedByOtherFilter || logRecord.status == .blacklistedByUserFilter {
                    continue
                }
            }
            
            
            let info = dnsTrackerService.getTrackerInfo(by: logRecord.domain)
            
            var categoryName: String? = nil
            if let categoryKey = info?.categoryKey {
                categoryName = ACLocalizedString(categoryKey, nil)
            }
            
            let category = DnsLogRecordCategory(category: categoryName, name: info?.name, isTracked: info?.isTracked, url: info?.url, isAdguardJson: info?.isAdguardJson ?? false)
            
            let record = DnsLogRecordExtended(record: logRecord, category: category, dnsFiltersService: dnsFiltersService)
            allRecords.append(record)
        }
        
        recordsObserver?(allRecords)
    }
}
