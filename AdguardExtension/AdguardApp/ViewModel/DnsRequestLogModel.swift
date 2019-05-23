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

// MARK: - dta types -
struct LogRecord {
    var name: String?
    var time: String?
    var elapsed: Int
    var type: String?
    var serverName: String?
    var answer: String?
    var ns: String?
    var upstreamAddr: String?
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
            searchRecords = allRecords.filter({ $0.name?.lowercased().contains( searchLowercased ) ?? false })
            recordsObserver?(self.records)
        }
    }
    
    // MARK: - private fields
    
    private let vpnManager: APVPNManager
    private let dateFormatter: DateFormatter
    
    private var allRecords = [LogRecord]()
    private var searchRecords = [LogRecord]()
    
    // MARK: - init
    init(_ vpnManager: APVPNManager) {
        self.vpnManager = vpnManager
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "HH:mm:ss.SSS"
        self.searchString = ""
    }
    
    // MARK: - public methods
    /**
     obtains records array from vpnManager
    */
    func obtainRecords() {
        vpnManager.obtainDnsLogRecords { [weak self] (logRecordsOpt)  in
            guard let sSelf = self else { return }
            sSelf.allRecords = [LogRecord]()
            guard let logRecords = logRecordsOpt else {
                sSelf.recordsObserver?(sSelf.records)
                return
            }
            
            for logRecord in logRecords.reversed() {
                let record = LogRecord(name: logRecord.domain, time: sSelf.dateFromRecord(logRecord), elapsed: logRecord.elapsed, type: logRecord.type, serverName: logRecord.server, answer: logRecord.answer, ns: logRecord.ns, upstreamAddr: logRecord.upstreamAddr)
                sSelf.allRecords.append(record)
            }
            
            sSelf.recordsObserver?(sSelf.records)
        }
    }
    
    // MARK: - private methods
    
    func dateFromRecord (_ record: DnsLogRecord) -> String {
        return dateFormatter.string(from: record.date)
    }
    
}
