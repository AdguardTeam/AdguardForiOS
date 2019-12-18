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

class DnsLogRecordsWriter: NSObject, DnsLogRecordsWriterProtocol {
    
    var userFilterId: NSNumber?
    var otherFilterIds: [NSNumber]?
    
    var server = ""
    
    private let dnsLogService: DnsLogRecordsServiceProtocol
    private let resources: AESharedResourcesProtocol
    
    var dnsStatisticsService: DnsStatisticsServiceProtocol
    
    private var records = [DnsLogRecord]()
    private var statistics: [DnsStatisticsType : RequestsStatisticsBlock] = [:]
    
    
    private let saveRecordsMinimumTime = 3.0 // seconds
    private let saveStatisticsMinimumTime = 60.0*10.0 // seconds - 10 minutes
    private var nextSaveTime: Double
    private var nextStatisticsSaveTime: Double
    
    private let recordsQueue = DispatchQueue(label: "DnsLogRecordsWriter recods queue")
    
    @objc init(resources: AESharedResourcesProtocol, dnsLogService: DnsLogRecordsServiceProtocol) {
        self.resources = resources
        self.dnsStatisticsService = DnsStatisticsService()
        self.dnsLogService = dnsLogService
        
        nextSaveTime = Date().timeIntervalSince1970 + saveRecordsMinimumTime
        nextStatisticsSaveTime = Date().timeIntervalSince1970 + saveStatisticsMinimumTime
        
        super.init()
        
        self.reinitializeStatistics()
    }
    
    deinit {
        flush()
    }
    
    func handleEvent(_ event: AGDnsRequestProcessedEvent) {
        if event.error != nil && event.error != "" {
            DDLogError("(DnsLogRecordsWriter) handle event error occured - \(event.error!)")
            return
        }
        
        var status: DnsLogRecordStatus
        
        if event.whitelist {
            status = .whitelisted
        }
        else if userFilterId != nil && event.filterListIds.contains(userFilterId!) {
            status = .blacklistedByUserFilter
        }
        else if otherFilterIds?.contains(where: { event.filterListIds.contains($0) }) ?? false {
            status = .blacklistedByOtherFilter
        }
        else {
            status = .processed
        }
        
        let totalRequestsCount = resources.sharedDefaults().integer(forKey: AEDefaultsRequests)
        resources.sharedDefaults().set(totalRequestsCount + 1, forKey: AEDefaultsRequests)
        statistics[.all]?.numberOfRequests += 1
        
        if (isBlocked(event.answer)) {
            let blockedRequestsCount = resources.sharedDefaults().integer(forKey: AEDefaultsBlockedRequests)
            resources.sharedDefaults().set(blockedRequestsCount + 1, forKey: AEDefaultsBlockedRequests)
            statistics[.blocked]?.numberOfRequests += 1
        }
        
        
        let record = DnsLogRecord(domain: event.domain, date: Date(timeIntervalSince1970: TimeInterval(event.startTime / 1000)), elapsed: Int(event.elapsed), type: event.type, answer: event.answer, server: server, upstreamAddr: event.upstreamAddr, bytesSent: Int(event.bytesSent), bytesReceived: Int(event.bytesReceived), status: status, userStatus: .none, blockRules: event.rules)
        
        addRecord(record: record)
    }
    
    private func addRecord(record: DnsLogRecord) {
        
        recordsQueue.async { [weak self] in
            guard let sSelf = self else { return }
            
            sSelf.records.append(record)
            
            let now = Date().timeIntervalSince1970
            
            if now > sSelf.nextStatisticsSaveTime{
                sSelf.saveStatistics()
            }
            
            if now < sSelf.nextSaveTime{
                return
            }
            
            sSelf.save()
            sSelf.nextSaveTime = now + sSelf.saveRecordsMinimumTime
        }
    }
    
    private func flush() {
        recordsQueue.async { [weak self] in
            self?.save()
            self?.saveStatistics()
        }
    }
    
    private func save() {
        dnsLogService.writeRecords(records)
        records.removeAll()
    }
    
    private func saveStatistics(){
        let now = Date().timeIntervalSince1970
        dnsStatisticsService.writeStatistics(statistics)
        statistics.removeAll()
        reinitializeStatistics()
        nextStatisticsSaveTime = now + saveStatisticsMinimumTime
    }
    
    private func reinitializeStatistics(){
        let date = Date()
        
        statistics[.all] = RequestsStatisticsBlock(date: date, numberOfRequests: 0)
        statistics[.blocked] = RequestsStatisticsBlock(date: date, numberOfRequests: 0)
    }
    
    private func isBlocked(_ answer: String?) -> Bool {
        if answer == nil || answer == "" {
            // Mark all NXDOMAIN responses as blocked
            return true
        }

        if answer!.contains("0.0.0.0") ||
            answer!.contains("127.0.0.1") ||
            answer!.contains("[::]")  {
            return true
        }

        return false
    }
}
