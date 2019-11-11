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
import Mobile

class DnsLogRecordsWriter: NSObject, DnsLogRecordsWriterProtocol {
    
    var server = ""
    
    private let resources: APSharedResources
    private var records = [DnsLogRecord]()
    private let dnsTrackerService: DnsTrackerServiceProtocol
    
    private let saveRecordsMinimumTime = 3.0 // seconds
    private var nextSaveTime: Double
    
    private let recordsQueue = DispatchQueue(label: "DnsLogRecordsWriter recods queue")
    
    @objc init(resources: APSharedResources, dnsTrackerService: DnsTrackerServiceProtocol) {
        self.resources = resources
        self.dnsTrackerService = dnsTrackerService
        
        nextSaveTime = Date().timeIntervalSince1970 + saveRecordsMinimumTime
    }
    
    deinit {
        flush()
    }
    
    func dnsRequestProcessed(_ event: MobileDNSRequestProcessedEvent) {
        if event.error != nil && event.error != "" {
            // Ignore errors
            return
        }
        
        let info = dnsTrackerService.getCategoryAndName(by: event.domain ?? "")
        let type = isBlocked(event.answer, isTracked: info?.isTracked)
        
        let number = resources.defaultRequestsNumber.intValue
        resources.defaultRequestsNumber = NSNumber(integerLiteral: number + 1)
        
        switch type {
        case .blocked:
            let number = resources.blockedRequestsNumber.intValue
            resources.blockedRequestsNumber = NSNumber(integerLiteral: number + 1)
        case .tracked:
            let number = resources.countersRequestsNumber.intValue
            resources.countersRequestsNumber = NSNumber(integerLiteral: number + 1)
        default:
            break
        }

        let record = DnsLogRecord(domain: event.domain, date: Date(timeIntervalSince1970: TimeInterval(event.startTime / 1000)), elapsed: event.elapsed, type: event.type, answer: event.answer, server: server, upstreamAddr: event.upstreamAddr, bytesSent: event.bytesSent, bytesReceived: event.bytesReceived, blockRecordType: type, name: info?.name, company: info?.company, category: info?.categoryKey)
        addRecord(record: record, flush: false)
    }
    
    private func addRecord(record: DnsLogRecord, flush: Bool) {
        
        recordsQueue.async { [weak self] in
            guard let sSelf = self else { return }
            
            sSelf.records.append(record)
            
            let now = Date().timeIntervalSince1970
            if now < sSelf.nextSaveTime && !flush {
                return
            }
            
            sSelf.save()
            sSelf.nextSaveTime = now + sSelf.saveRecordsMinimumTime
        }
    }
    
    private func flush() {
        recordsQueue.async { [weak self] in
            self?.save()
        }
    }
    
    private func save() {
        resources.write(to: records)
        records.removeAll()
    }
    
    private func isBlocked(_ answer: String?, isTracked: Bool?) -> BlockedRecordType {
        if answer == nil || answer == "" {
            // Mark all NXDOMAIN responses as blocked
            return .blocked
        }

        if answer!.contains("0.0.0.0") ||
            answer!.contains("127.0.0.1") ||
            answer!.contains("[::]")  {
            return .blocked
        }

        if isTracked ?? false {
            return .tracked
        }
        
        return .normal
    }
}
