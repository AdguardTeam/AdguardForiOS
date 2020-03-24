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
    
    var whitelistFilterId: NSNumber?
    var userFilterId: NSNumber?
    var otherFilterIds: [NSNumber]?
    
    var server = ""
    
    private let dnsLogService: DnsLogRecordsServiceProtocol
    private let resources: AESharedResourcesProtocol
    private let activityStatisticsService: ActivityStatisticsServiceWriterProtocol
    
    var dnsStatisticsService: DnsStatisticsServiceProtocol
    
    private var records = [DnsLogRecord]()
    private var activityStatisticsRecords = [String: ActivityStatisticsRecord]()
    private var statistics: [DnsStatisticsType : RequestsStatisticsBlock] = [:]
    
    private let saveRecordsMinimumTime = 3.0 // seconds
    private let saveActivityRecordsMinimumTime = 10.0 // seconds
    private var nextSaveTime: Double
    private var nextStatisticsSaveTime: Double
    private var nextActivityStatisticsSaveTime: Double
    
    private let recordsQueue = DispatchQueue(label: "DnsLogRecordsWriter records queue")
    private let statisticsQueue = DispatchQueue(label: "DnsLogRecordsWriter statistics queue")
    private let activityStatisticsQueue = DispatchQueue(label: "DnsLogRecordsWriter activity statistics queue")
    
    @objc init(resources: AESharedResourcesProtocol, dnsLogService: DnsLogRecordsServiceProtocol, activityStatisticsService: ActivityStatisticsServiceWriterProtocol) {
        self.resources = resources
        self.dnsStatisticsService = DnsStatisticsService(resources: resources)
        self.dnsLogService = dnsLogService
        self.activityStatisticsService = activityStatisticsService
        
        nextSaveTime = Date().timeIntervalSince1970 + saveRecordsMinimumTime
        nextStatisticsSaveTime = Date().timeIntervalSince1970 + dnsStatisticsService.minimumStatisticSaveTime
        nextActivityStatisticsSaveTime = Date().timeIntervalSince1970 + saveActivityRecordsMinimumTime
        
        super.init()
        
        self.loadStatisticsHead()
    }
    
    deinit {
        flush()
    }
    
    func handleEvent(_ event: AGDnsRequestProcessedEvent) {
        if event.error != nil && event.error != "" {
            DDLogError("(DnsLogRecordsWriter) handle event error occured - \(event.error!)")
            return
        }
        
        DDLogInfo("(DnsLogRecordsWriter) handleEvent got answer for domain: \(event.domain ?? "nil") answer: \(event.answer == nil ? "nil" : "nonnil")")
        
        var status: DnsLogRecordStatus
        
        if event.whitelist {
            status = event.filterListIds.contains(whitelistFilterId!) ? .whitelistedByUserFilter : .whitelistedByOtherFilter
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
        
        let tempRequestsCount = resources.sharedDefaults().integer(forKey: AEDefaultsRequests)
        resources.sharedDefaults().set(tempRequestsCount + 1, forKey: AEDefaultsRequests)
        
        let recordIsBlocked = status == .blacklistedByUserFilter || status == .blacklistedByOtherFilter
        
        statisticsQueue.async { [weak self] in
            guard let self = self else { return }
            self.statistics[.all]?.numberOfRequests += 1
            
            if recordIsBlocked {
                let tempBlockedRequestsCount = self.resources.sharedDefaults().integer(forKey: AEDefaultsBlockedRequests)
                self.resources.sharedDefaults().set(tempBlockedRequestsCount + 1, forKey: AEDefaultsBlockedRequests)
                
                self.statistics[.blocked]?.numberOfRequests += 1
            }
        }
        
        let filterIds = event.filterListIds.map { $0.intValue }
        
        let date = Date(timeIntervalSince1970: TimeInterval(event.startTime / 1000))
        
        let record = DnsLogRecord(
            domain: event.domain,
            date: date,
            elapsed: Int(event.elapsed),
            type: event.type,
            answer: event.answer,
            server: server,
            upstreamAddr: event.upstreamAddr,
            bytesSent: Int(event.bytesSent),
            bytesReceived: Int(event.bytesReceived),
            status: status,
            userStatus: .none,
            blockRules: event.rules,
            matchedFilterIds: filterIds,
            originalAnswer: event.originalAnswer,
            answerStatus: event.status
        )
        
        addActivityRecord(domain: event.domain, isBlocked: recordIsBlocked)
        addRecord(record: record)
    }
    
    private func addActivityRecord(domain: String, isBlocked: Bool){
        let now = Date().timeIntervalSince1970
        
        activityStatisticsQueue.async {[weak self] in
            guard let self = self else { return }
            
            let savedKBytes = Int.random(in: 10..<50)
            if let activityRecord = self.activityStatisticsRecords[domain] {
                activityRecord.requests += 1
                if isBlocked {
                    activityRecord.blocked += 1
                }
                activityRecord.savedData += savedKBytes
            } else {
                let activityRecord = ActivityStatisticsRecord(date: Date(), domain: domain, requests: 1, blocked: isBlocked ? 1 : 0, savedData: savedKBytes)
                self.activityStatisticsRecords[domain] = activityRecord
            }
            
            if now > self.nextActivityStatisticsSaveTime{
                self.saveActivityStatistics()
            }
        }
    }
    
    private func addRecord(record: DnsLogRecord) {
        
        let now = Date().timeIntervalSince1970
        
        recordsQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.records.append(record)
            
            if now < self.nextSaveTime{
                return
            }
            
            self.save()
            self.nextSaveTime = now + self.saveRecordsMinimumTime
        }
        
        statisticsQueue.async { [weak self] in
            guard let self = self else { return }
            if now > self.nextStatisticsSaveTime{
                self.saveStatistics()
            }
        }
    }
    
    private func flush() {
        save()
        saveStatistics()
        saveActivityStatistics()
        
        resources.sharedDefaults().set(0, forKey: AEDefaultsRequests)
        resources.sharedDefaults().set(0, forKey: AEDefaultsBlockedRequests)
        resources.sharedDefaults().set(Date(), forKey: LastStatisticsSaveTime)
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
        nextStatisticsSaveTime = now + dnsStatisticsService.minimumStatisticSaveTime
    }
    
    private func saveActivityStatistics(){
        let now = Date().timeIntervalSince1970
        let recordsArray = Array(activityStatisticsRecords.values)
        activityStatisticsService.writeRecords(recordsArray)
        activityStatisticsRecords.removeAll()
        nextActivityStatisticsSaveTime = now + saveActivityRecordsMinimumTime
    }
    
    private func loadStatisticsHead() {
        
        let all = resources.sharedDefaults().integer(forKey: AEDefaultsRequests)
        let blocked = resources.sharedDefaults().integer(forKey: AEDefaultsBlockedRequests)
        
        let date = Date()
        
        statistics[.all] = RequestsStatisticsBlock(date: date, numberOfRequests: all)
        statistics[.blocked] = RequestsStatisticsBlock(date: date, numberOfRequests: blocked)
    }
    
    private func reinitializeStatistics(){
        let date = Date()
        
        statistics[.all] = RequestsStatisticsBlock(date: date, numberOfRequests: 0)
        statistics[.blocked] = RequestsStatisticsBlock(date: date, numberOfRequests: 0)
        
        resources.sharedDefaults().set(0, forKey: AEDefaultsRequests)
        resources.sharedDefaults().set(0, forKey: AEDefaultsBlockedRequests)
        resources.sharedDefaults().set(Date(), forKey: LastStatisticsSaveTime)
    }
}
