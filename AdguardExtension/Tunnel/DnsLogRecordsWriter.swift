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
    
    weak var dnsProxyService: DnsProxyServiceProtocol?
    
    private let dnsLogService: DnsLogRecordsServiceProtocol
    private let resources: AESharedResourcesProtocol
    private let activityStatisticsService: ActivityStatisticsServiceWriterProtocol
    private let dnsStatisticsService: DnsStatisticsServiceProtocol
    
    private var records = [DnsLogRecord]()
    private var activityStatisticsRecords = [String: ActivityStatisticsRecord]()
    private var dnsStatisticsRecord = DnsStatisticsRecord()
    
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
        
        let domain: String = event.domain.hasSuffix(".") ? String(event.domain.dropLast()) : event.domain
        
        DDLogInfo("(DnsLogRecordsWriter) handleEvent got answer for domain: \(domain) answer: \(event.answer == nil ? "nil" : "nonnil")")
        
        let dnsProxyUpstream = dnsProxyService?.upstreamsById[event.upstreamId]
        let recordIsEncrypted = dnsProxyUpstream?.isCrypto ?? false
        let upstreamAddr = dnsProxyUpstream?.upstream
        
        let status = getEventStatus(event, isEncrypted: recordIsEncrypted)
        
        let filterIds = event.filterListIds.map { $0.intValue }
        
        let date = Date(timeIntervalSince1970: TimeInterval(event.startTime / 1000))
        
        let record = DnsLogRecord(
            domain: domain,
            date: date,
            elapsed: Int(event.elapsed),
            type: event.type,
            answer: event.answer,
            server: server,
            upstreamAddr: upstreamAddr,
            bytesSent: Int(event.bytesSent),
            bytesReceived: Int(event.bytesReceived),
            status: status,
            userStatus: .none,
            blockRules: event.rules,
            matchedFilterIds: filterIds,
            originalAnswer: event.originalAnswer,
            answerStatus: event.status
        )
        
        addRecord(record: record)
        addActivityRecord(domain: domain, isEncrypted: recordIsEncrypted, elapsed: event.elapsed)
        addDnsStatisticsRecord(isEncrypted: recordIsEncrypted, elapsed: event.elapsed)
    }
    
    private func addDnsStatisticsRecord(isEncrypted: Bool, elapsed: Int) {
        statisticsQueue.async { [weak self] in
            guard let self = self else { return }
            self.resources.tempRequestsCount += 1
            
            self.dnsStatisticsRecord.requests += 1
            self.dnsStatisticsRecord.elapsedSumm += elapsed
            
            if isEncrypted {
                self.resources.tempEncryptedRequestsCount += 1
                self.dnsStatisticsRecord.encrypted += 1
            }
            
            let now = Date().timeIntervalSince1970
            if now > self.nextStatisticsSaveTime{
                self.saveStatistics()
            }
        }
    }
    
    private func addActivityRecord(domain: String, isEncrypted: Bool, elapsed: Int){
        activityStatisticsQueue.async {[weak self] in
            guard let self = self else { return }
            
            let now = Date().timeIntervalSince1970
            
            if let activityRecord = self.activityStatisticsRecords[domain] {
                activityRecord.requests += 1
                activityRecord.elapsedSumm += elapsed
                if isEncrypted {
                    activityRecord.encrypted += 1
                }
            } else {
                let activityRecord = ActivityStatisticsRecord(date: Date(), domain: domain, requests: 1, encrypted: isEncrypted ? 1 : 0, elapsedSumm: elapsed)
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
    }
    
    private func flush() {
        save()
        saveStatistics()
        saveActivityStatistics()
        
        resources.sharedDefaults().set(0, forKey: AEDefaultsRequests)
        resources.sharedDefaults().set(0, forKey: AEDefaultsEncryptedRequests)
        resources.sharedDefaults().set(Date(), forKey: LastStatisticsSaveTime)
    }
    
    private func save() {
        dnsLogService.writeRecords(records)
        records.removeAll()
    }
    
    private func saveStatistics(){
        let now = Date().timeIntervalSince1970
        dnsStatisticsService.writeRecord(dnsStatisticsRecord)
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
        let requests = resources.tempRequestsCount
        let encrypted = resources.tempEncryptedRequestsCount
        
        dnsStatisticsRecord.requests += requests
        dnsStatisticsRecord.encrypted += encrypted
    }
    
    private func reinitializeStatistics(){
        dnsStatisticsRecord = DnsStatisticsRecord()
        
        resources.tempRequestsCount = 0
        resources.tempEncryptedRequestsCount = 0
        resources.sharedDefaults().set(Date(), forKey: LastStatisticsSaveTime)
    }
    
    private func getEventStatus(_ event: AGDnsRequestProcessedEvent, isEncrypted: Bool) -> DnsLogRecordStatus {
        if event.whitelist {
            return event.filterListIds.contains(whitelistFilterId!) ? .whitelistedByUserFilter : .whitelistedByOtherFilter
        }
        else if userFilterId != nil && event.filterListIds.contains(userFilterId!) {
            return .blacklistedByUserFilter
        }
        else if otherFilterIds?.contains(where: { event.filterListIds.contains($0) }) ?? false {
            return .blacklistedByOtherFilter
        } else if isEncrypted {
            return .encrypted
        }
        else {
            return .processed
        }
    }
}
