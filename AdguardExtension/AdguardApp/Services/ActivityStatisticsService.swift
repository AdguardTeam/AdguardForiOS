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

// Protocols are devided not to mark all of them as @objc

@objc protocol ActivityStatisticsServiceWriterProtocol {
    func writeRecords(_ records: [ActivityStatisticsRecord])
    func deleteAllRecords()
    
    /* Using two methods, because DnsStatisticsService uses the same db file, and
    we need to close connection before deleting db file */
    func stopDb()
    func startDb()
}

protocol ActivityStatisticsServiceReaderProtocol {
    func getAllRecords() -> [ActivityStatisticsRecord]
    func getRecords(by type: ChartDateType) -> [ActivityStatisticsRecord]
}

typealias ActivityStatisticsServiceProtocol = ActivityStatisticsServiceWriterProtocol & ActivityStatisticsServiceReaderProtocol

@objc class ActivityStatisticsService: NSObject, ActivityStatisticsServiceProtocol {
    
    // MARK: - Services
    
    private let resources: AESharedResourcesProtocol
    
    // MARK: - Private variables
    
    private lazy var path =  { resources.sharedResuorcesURL().appendingPathComponent("dns-statistics.db").absoluteString }()
    
    private var dbHandler: FMDatabaseQueue?
        
    // MARK: - Init
    
    @objc init(resources: AESharedResourcesProtocol) {
        self.resources = resources
        super.init()
        
        dbHandler = FMDatabaseQueue.init(path: path, flags: SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
        dbHandler?.inTransaction{[weak self] (db, rollback) in
            self?.createDnsLogTable(db!)
        }
    }
    
    // MARK: - Public methods
    
    func writeRecords(_ records: [ActivityStatisticsRecord]){
        dbHandler?.inTransaction{ (db, rollback) in
            guard let db = db else { return }
            
            for record in records {
                let dateString = ISO8601DateFormatter().string(from: record.date)
            
                var result = db.executeUpdate("INSERT INTO ActivityStatisticsTable (timeStamp, domain, requests, encrypted, elapsedSumm) VALUES (?, ?, ?, ?, ?)", withArgumentsIn: [dateString, record.domain, record.requests, record.encrypted, record.elapsedSumm])

                if !result {
                    result = db.executeUpdate("UPDATE ActivityStatisticsTable SET requests = requests + ?, encrypted = encrypted + ?, elapsedSumm = elapsedSumm + ? WHERE timeStamp = ? AND domain = ?", withArgumentsIn: [record.requests, record.encrypted, record.elapsedSumm, dateString, record.domain])
                }
                
                rollback?.pointee = ObjCBool(!result)
                
                if !result {
                    DDLogError("ActivityStatisticsService Error in writeRecords; Error: \(db.lastError().debugDescription)")
                }
            }
        }
    }
    
    func getAllRecords() -> [ActivityStatisticsRecord] {
        var activityRecords = [ActivityStatisticsRecord]()
        dbHandler?.inTransaction{ (db, rollback) in
            guard let db = db else { return }
    
            if let resultSet = db.executeQuery("SELECT * FROM ActivityStatisticsTable", withArgumentsIn: []) {
                while resultSet.next() {
                    if let record = ActivityStatisticsRecord(resultSet) {
                        activityRecords.append(record)
                    }
                }
            }
        }
        return activityRecords
    }
    
    func getRecords(by type: ChartDateType) -> [ActivityStatisticsRecord] {
        var activityRecords = [ActivityStatisticsRecord]()
        
        dbHandler?.inTransaction{ (db, rollback) in
            guard let db = db else { return }
            let intervalTime = type.getTimeInterval()
            
            let firstDate = ISO8601DateFormatter().string(from: intervalTime.begin)
            let lastDate = ISO8601DateFormatter().string(from: intervalTime.end)
            
            if let resultSet = db.executeQuery("SELECT * FROM ActivityStatisticsTable WHERE timeStamp <= ? AND timeStamp >= ? ORDER BY timeStamp DESC, domain ASC", withArgumentsIn: [firstDate, lastDate]) {
                while resultSet.next() {
                    if let record = ActivityStatisticsRecord(resultSet) {
                        activityRecords.append(record)
                    }
                }
            }
        }
        return activityRecords
    }
    
    func deleteAllRecords() {
        dbHandler?.inTransaction{ (db, rollback) in
            guard let db = db else { return }
            
            let result = db.executeUpdate("DELETE FROM ActivityStatisticsTable", withArgumentsIn: [])
            rollback?.pointee = ObjCBool(!result)
            if !result {
                DDLogError("ActivityStatisticsService Error in deleteAllRecords; Error: \(db.lastError().debugDescription)")
            }
        }
    }

    func stopDb() {
        dbHandler?.inTransaction({ (db, rollback) in
            db?.close()
        })
        dbHandler = nil
    }
    
    func startDb() {
        dbHandler = FMDatabaseQueue.init(path: path, flags: SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
        dbHandler?.inTransaction{[weak self] (db, rollback) in
            self?.createDnsLogTable(db!)
        }
    }
    
    // MARK: - private methods
    
    private func createDnsLogTable(_ db: FMDatabase) {
        let result = db.executeUpdate("CREATE TABLE IF NOT EXISTS ActivityStatisticsTable (timeStamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, domain TEXT NOT NULL DEFAULT '', requests INTEGER NOT NULL DEFAULT 0, encrypted INTEGER NOT NULL DEFAULT 0, elapsedSumm INTEGER NOT NULL DEFAULT 0, PRIMARY KEY(timeStamp, domain))", withParameterDictionary: [:])
        if !result {
            DDLogError("ActivityStatisticsService Error in createDnsLogTable; Error: \(db.lastError().debugDescription)")
        }
    }
}
