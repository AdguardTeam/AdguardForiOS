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
struct LogRecord {
    let category: String?
    let status: DnsLogStatus
    let name: String?
    let company: String?
    let domain: String?
    let time: String?
    let elapsed: Int
    let type: String?
    let serverName: String?
    let answer: String?
    let upstreamAddr: String?
    let bytesSent: Int
    let bytesReceived: Int
    let isTracked: Bool?
    let rules: [String]?
    
    enum DnsLogStatus: String { 
        case processed = "Processed"
        case blockedWithDns = "Blocked with DNS"
        case blockedWithDnsFilter = "Blocked with DNS filter"
        case blockedWithDnsBlacklist = "Blocked with DNS blacklist"
        case whitelisted = "Whitelisted"
        
        func status() -> String {
            return self.rawValue
        }
        
        func color() -> UIColor {
            switch self {
            case .processed:
                return UIColor(hexString: "#eb9300")
            case .whitelisted:
                return UIColor(hexString: "#67b279")
            default:
                return UIColor(hexString: "#df3812")
            }
        }
    }
    
    enum ButtonType {
        case removeDomainFromWhitelist, removeRuleFromUserFilter, addDomainToWhitelist, addRuleToUserFlter
    }
    
    func getButtons() -> [ButtonType] {
        switch status {
        case .blockedWithDns:
            return [.addDomainToWhitelist]
        case .blockedWithDnsFilter:
            return [.addDomainToWhitelist]
        case .blockedWithDnsBlacklist:
            return [.removeRuleFromUserFilter]
        case .whitelisted:
            return [.removeDomainFromWhitelist]
        case .processed:
            return [.addDomainToWhitelist, .addRuleToUserFlter]
        }
    }
    
//    private func removeDomainFromDnsWhitelist() -> ButtonType {
//        let button = BottomShadowButton()
//        button.title = ACLocalizedString("remove_from_whitelist", nil)
//        button.titleColor = UIColor(hexString: "#eb9300")
//        button.buttonAction {
//            print(button.title)
//        }
//
//        return button
//    }
//
//    private func removeDomainFromDnsBlacklistButton() -> ButtonType {
//        let button = BottomShadowButton()
//        button.title = ACLocalizedString("remove_from_blacklist", nil)
//        button.titleColor = UIColor(hexString: "#eb9300")
//        button.buttonAction {
//            print(button.title)
//        }
//
//        return button
//    }
//
//    private func addDomainToDnsWhitelistButton() -> ButtonType {
//        let button = BottomShadowButton()
//        button.title = ACLocalizedString("add_to_whitelist", nil)
//        button.titleColor = UIColor(hexString: "#67b279")
//        button.buttonAction {
//            print(button.title)
//        }
//
//        return button
//    }
//
//    private func addDomainToDnsBlacklistButton() -> ButtonType {
//        let button = BottomShadowButton()
//        button.title = ACLocalizedString("add_to_blacklist", nil)
//        button.titleColor = UIColor(hexString: "#df3812")
//        button.buttonAction {
//            print(button.title)
//        }
//
//        return button
//    }
}

protocol DnsRequestsDelegateProtocol {
    func requestsCleared()
}

// MARK: - DnsRequestLogModel -
/**
 view model for DnsLogController
 */
class DnsRequestLogViewModel {
    
    // MARK: - pubic fields
    /**
     array of log records. If search is active it returns filtered array
     */
    var records: [LogRecord] {
        get {
            return searchString.count > 0 ? searchRecords : allRecords
        }
    }
    
    /**
     records changes observer. It calls when records array changes
     */
    var recordsObserver: (([LogRecord])->Void)?
    
    /**
     search query string
     */
    var searchString: String {
        didSet {
            let searchLowercased = searchString.lowercased()
            searchRecords = allRecords.filter({ $0.domain?.lowercased().contains( searchLowercased ) ?? false })
            recordsObserver?(self.records)
        }
    }
    
    var delegate: DnsRequestsDelegateProtocol? = nil
    
    // MARK: - private fields
    
    private let dnsLogService: DnsLogRecordsServiceProtocol
    private let dnsTrackerService: DnsTrackerServiceProtocol
    private let dnsFiltersService: DnsFiltersServiceProtocol
    
    private let dateFormatter: DateFormatter
    
    private var allRecords = [LogRecord]()
    private var searchRecords = [LogRecord]()
    
    // MARK: - init
    init(dnsLogService: DnsLogRecordsServiceProtocol, dnsTrackerService: DnsTrackerServiceProtocol, dnsFiltersService: DnsFiltersServiceProtocol) {
        self.dnsLogService = dnsLogService
        self.dnsTrackerService = dnsTrackerService
        self.dnsFiltersService = dnsFiltersService
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "HH:mm:ss.SSS"
        self.searchString = ""
    }
    
    // MARK: - public methods
    /**
     obtains records array from vpnManager
    */
    func obtainRecords() {
        let logRecords = dnsLogService.readRecords()
        
        allRecords = [LogRecord]()
        
        for logRecord in logRecords.reversed() {
            let info = dnsTrackerService.getCategoryAndName(by: logRecord.domain)
            let name = info.name
            let isTracked = info.isTracked
            
            var categoryName: String? = nil
            if let categoryKey = info.categoryKey {
                categoryName = ACLocalizedString(categoryKey, nil)
            }
            
            let record = LogRecord(category: categoryName, status: .processed, name: name, company: "company", domain: logRecord.domain, time: dateFromRecord(logRecord), elapsed: logRecord.elapsed, type: logRecord.type, serverName: logRecord.server, answer: logRecord.answer, upstreamAddr: logRecord.upstreamAddr, bytesSent: logRecord.bytesSent, bytesReceived: logRecord.bytesReceived, isTracked: isTracked, rules: logRecord.blockRules)
            allRecords.append(record)
        }
        
        recordsObserver?(records)
    }
    
    func clearRecords(){
        dnsLogService.clearLog()
        allRecords = []
        searchRecords = []
        delegate?.requestsCleared()
    }
    
    // MARK: - private methods
    
    private func dateFromRecord (_ record: DnsLogRecord) -> String {
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: record.date)
    }
    
}
