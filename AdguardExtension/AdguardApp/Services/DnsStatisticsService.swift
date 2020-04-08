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

enum DynamicStatisticSaveTime: Int {
    typealias RawValue = Int
    
    case ten_seconds = 10
    case thirty_seconds = 30
    case one_minute = 60
    case five_minutes = 300
    case ten_minutes = 600
    
    func getNextCase() -> DynamicStatisticSaveTime {
        switch self {
        case .ten_seconds:
            return .thirty_seconds
        case .thirty_seconds:
            return .one_minute
        case .one_minute:
            return .five_minutes
        case .five_minutes:
            return .ten_minutes
        case .ten_minutes:
            return .ten_minutes
        }
    }
}

protocol DnsStatisticsServiceProtocol {
    var minimumStatisticSaveTime: Double { get }
    
    func writeRecord(_ record: DnsStatisticsRecord)
    
    func getAllRecords() -> [DnsStatisticsRecord]
    
    func getRecords(by type: ChartDateType)  -> [DnsStatisticsRecord]
    
    func getRecordsCount() -> Int
    
    func deleteAllRecords()
}

class DnsStatisticsService: NSObject, DnsStatisticsServiceProtocol {
    
    var minimumStatisticSaveTime: Double {
        return Double(statisticSaveTime.rawValue)
    }
    
    private var statisticSaveTime: DynamicStatisticSaveTime {
        get {
            let statisticsSaveTime = resources.sharedDefaults().integer(forKey: StatisticsSaveTime)
            return DynamicStatisticSaveTime(rawValue: statisticsSaveTime) ?? .ten_seconds
        }
        set {
            resources.sharedDefaults().set(newValue.rawValue, forKey: StatisticsSaveTime)
        }
    }
    
    private let resources: AESharedResourcesProtocol
    
    private lazy var path =  { self.resources.sharedResuorcesURL().appendingPathComponent("dns-statistics.db").absoluteString }()
    
    private let statisticsRecordsLimit = 1500   // 1500 records
    private let statisticsSectorsLimit = 150   // 1500 records -> 150 records
    
    private lazy var dbHandler: FMDatabaseQueue? = {
        let handler = FMDatabaseQueue.init(path: path, flags: SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
        
        handler?.inTransaction{[weak self] (db, rollback) in
            self?.createStatisticsTable(db!)
        }
        
        return handler
    }()
    
    // MARK: - init
    
    init(resources: AESharedResourcesProtocol) {
        self.resources = resources
        super.init()
        // lazy vars are not thread safe
        // force load lazy vars in init
        let _ = self.dbHandler
    }
    
    // MARK: - public methods
    
    func writeRecord(_ record: DnsStatisticsRecord) {
        let group = DispatchGroup()
        group.enter()
        
        dbHandler?.inTransaction { (db, rollback) in
            defer { group.leave() }
            guard let db = db else { return }
            
            let dateString = ISO8601DateFormatter().string(from: record.date)
            
            let result = db.executeUpdate("INSERT INTO DnsStatisticsTable (timeStamp, requests, encrypted, elapsedSumm) VALUES (?, ?, ?, ?)", withArgumentsIn: [dateString, record.requests, record.encrypted, record.elapsedSumm])
            rollback?.pointee = ObjCBool(!result)
            
            if !result {
                DDLogError("DnsStatisticsService Error in writeRecord; Error: \(db.lastError().debugDescription)")
            }
        }
        
        group.wait()
        
        rearrangeRecordsIfNeeded()
    }
    
    func getAllRecords() -> [DnsStatisticsRecord] {
        var records = [DnsStatisticsRecord]()
        
        let group = DispatchGroup()
        group.enter()
        
        ProcessInfo().performExpiringActivity(withReason: "read statistics in background") { [weak self] (expired) in
            DDLogInfo("(DnsStatisticsService) getAllRecords - performExpiringActivity")
            ACLLogger.singleton()?.flush()
            if expired {
                DDLogInfo("(DnsStatisticsService) getAllRecords - performExpiringActivity expired")
                ACLLogger.singleton()?.flush()
                return
            }
            
            self?.dbHandler?.inTransaction{ (db, rollback) in
                defer { group.leave() }
                guard let db = db else { return }
                
                if let resultSet = db.executeQuery("SELECT * FROM DnsStatisticsTable ORDER BY timeStamp", withArgumentsIn: []) {
                    while resultSet.next() {
                        if let record = DnsStatisticsRecord(resultSet) {
                            records.append(record)
                        }
                    }
                }
            }
        }
        
        group.wait()
        return records
    }
    
    func getRecords(by type: ChartDateType) -> [DnsStatisticsRecord] {
        var records = [DnsStatisticsRecord]()
        
        let group = DispatchGroup()
        group.enter()
        
        ProcessInfo().performExpiringActivity(withReason: "read statistics in background") { [weak self] (expired) in
            DDLogInfo("(DnsStatisticsService) getAllRecords - performExpiringActivity")
            ACLLogger.singleton()?.flush()
            if expired {
                DDLogInfo("(DnsStatisticsService) getAllRecords - performExpiringActivity expired")
                ACLLogger.singleton()?.flush()
                return
            }
            
            self?.dbHandler?.inTransaction{ (db, rollback) in
                defer { group.leave() }
                guard let db = db else { return }
                let intervalTime = type.getTimeInterval()
                
                let firstDate = ISO8601DateFormatter().string(from: intervalTime.begin)
                let lastDate = ISO8601DateFormatter().string(from: intervalTime.end)
                
                if let resultSet = db.executeQuery("SELECT * FROM DnsStatisticsTable WHERE timeStamp <= ? AND timeStamp >= ? ORDER BY timeStamp", withArgumentsIn: [firstDate, lastDate]) {
                    while resultSet.next() {
                        if let record = DnsStatisticsRecord(resultSet) {
                            records.append(record)
                        }
                    }
                }
            }
        }
        
        group.wait()
        return records
    }
    
    func getRecordsCount() -> Int {
        var recordsCount = 0
        let group = DispatchGroup()
        group.enter()
        
        dbHandler?.inTransaction({ (db, rollback) in
            defer { group.leave() }
            guard let db = db else { return }
            
            if let result = db.executeQuery("SELECT count(*) AS count FROM DnsStatisticsTable", withArgumentsIn: []), result.next() == true {
                recordsCount = Int(result.int(forColumn: "count"))
            }
        })
        
        group.wait()
        return recordsCount
    }
    
    func deleteAllRecords() {
        let group = DispatchGroup()
        group.enter()
        
        dbHandler?.inTransaction { [weak self] (db, rollback) in
            defer { group.leave() }
            guard let db = db else { return }
            
            let result = db.executeUpdate("DELETE FROM DnsStatisticsTable", withArgumentsIn: [])
            rollback?.pointee = ObjCBool(!result)
            
            if result {
                self?.statisticSaveTime = .ten_seconds
                self?.resources.sharedDefaults().set(0, forKey: AEDefaultsRequests)
                self?.resources.sharedDefaults().set(0, forKey: AEDefaultsEncryptedRequests)
                self?.resources.sharedDefaults().set(Date(), forKey: LastStatisticsSaveTime)
            } else {
                DDLogError("DnsStatisticsService Error in deleteAllRecords; Error: \(db.lastError().debugDescription)")
            }
        }
        
        group.wait()
    }
    
    // MARK: - private methods
    
    private func createStatisticsTable(_ db:FMDatabase) {
        let result = db.executeUpdate("CREATE TABLE IF NOT EXISTS DnsStatisticsTable (timeStamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP PRIMARY KEY, requests INTEGER NOT NULL DEFAULT 0, encrypted INTEGER NOT NULL DEFAULT 0, elapsedSumm INTEGER NOT NULL DEFAULT 0)", withParameterDictionary: [:])
        if !result {
            DDLogError("DnsStatisticsService Error in createStatisticsTable; Error: \(db.lastError().debugDescription)")
        }
    }
    
    private func rearrangeRecordsIfNeeded() {
        let recordsCount = getRecordsCount()
        
        if recordsCount >= statisticsRecordsLimit {
            let records = getAllRecords()
            
            statisticSaveTime = statisticSaveTime.getNextCase()
                    
            /* If table is needed to be rearranged we delete old records and rearrange them */
            deleteAllRecords()
            rearrangeRecords(records)
        }
    }
    
    private func rearrangeRecords(_ records: [DnsStatisticsRecord]){
        guard let oldestDate = records.first?.date, let newestDate = records.last?.date else { return }
        
        let sectorsDateIntervals = getTimeIntervalsForRearrangedRecords(newestDate: newestDate, oldestDate: oldestDate)
        
        for interval in sectorsDateIntervals {
            /* Filter records that fit interval */
            let recordsFittingInterval = records.filter({ interval.contains($0.date) })
            
            /* Getting middle date from interval for new record */
            let middleDate = getMiddleDate(interval)
            
            let newRecord = DnsStatisticsRecord(date: middleDate)
            
            for record in recordsFittingInterval {
                newRecord.requests += record.requests
                newRecord.encrypted += record.encrypted
                newRecord.elapsedSumm += record.elapsedSumm
            }
            
            /* Appending new rearranged record to db */
            writeRecord(newRecord)
        }
    }
    
    private func getTimeIntervalsForRearrangedRecords(newestDate: Date, oldestDate: Date) -> [DateInterval] {
        /* Difference in seconds between newest and oldest date */
        let difference = newestDate.timeIntervalSinceReferenceDate - oldestDate.timeIntervalSinceReferenceDate
        
        /* Divide difference by number of new sectors and getting one sector duration */
        let sectorDuration = difference / Double(statisticsSectorsLimit)
        
        /* Array of DateInterval to return */
        var dateIntervals: [DateInterval] = []
        
        /* Date to change in cycle, it used to initialize DateInterval */
        var startDate = oldestDate
        
        /* Generating DateInterval for each new sector */
        for _ in 1...statisticsSectorsLimit {
            let dateInterval = DateInterval(start: startDate, duration: sectorDuration)
            dateIntervals.append(dateInterval)

            startDate = startDate.addingTimeInterval(sectorDuration)
        }
        
        return dateIntervals
    }
    
    /* Returns middle between two dates */
    private func getMiddleDate(_ dateInterval: DateInterval) -> Date {
        let startDate = dateInterval.start.timeIntervalSinceReferenceDate
        let endDate = dateInterval.end.timeIntervalSinceReferenceDate
        let middleDateInterval = startDate + (endDate - startDate) / 2.0
        return Date(timeIntervalSinceReferenceDate: middleDateInterval)
    }
}
