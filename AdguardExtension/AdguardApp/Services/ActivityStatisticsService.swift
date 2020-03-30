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
}

protocol ActivityStatisticsServiceReaderProtocol {
    func getAllRecords(completion: @escaping ([ActivityStatisticsRecord]) -> ())
    func getRecords(by type: ChartDateType, completion: @escaping ([ActivityStatisticsRecord]) -> ())
}

typealias ActivityStatisticsServiceProtocol = ActivityStatisticsServiceWriterProtocol & ActivityStatisticsServiceReaderProtocol

@objc class ActivityStatisticsService: NSObject, ActivityStatisticsServiceProtocol {
    
    // MARK: - Services
    
    private let resources: AESharedResourcesProtocol
    
    // MARK: - Private variables
    
    private lazy var path =  { self.resources.sharedResuorcesURL().appendingPathComponent("dns-statistics.db").absoluteString }()
    
    private lazy var writeHandler: FMDatabaseQueue? = {
        let handler = FMDatabaseQueue.init(path: path, flags: SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
        
        handler?.inTransaction{ (db, rollback) in
            self.createDnsLogTable(db!)
        }
        
        return handler
    }()
    
    private lazy var readHandler: FMDatabaseQueue? = {
        return FMDatabaseQueue.init(path: path, flags: SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
    }()
    
    // MARK: - Init
    
    @objc init(resources: AESharedResourcesProtocol) {
        self.resources = resources
        super.init()
        // lazy vars are not thread safe
        // force load lazy vars in init
        let _ = self.readHandler
        let _ = self.writeHandler
    }
    
    // MARK: - Public methods
    
    func writeRecords(_ records: [ActivityStatisticsRecord]){
        writeHandler?.inTransaction{ (db, rollback) in
            guard let db = db else { return }
            
            for record in records {
                let dateString = record.date.iso8601YyyyMmDdFormatter()
                
                let result = db.executeUpdate("INSERT INTO ActivityStatisticsTable (timeStamp, domain, requests, blocked, savedData) VALUES(? , ?, ?, ?, ?) ON CONFLICT(timeStamp, domain) DO UPDATE SET requests = requests + ?, blocked = blocked + ?, savedData = savedData + ? WHERE timeStamp = ? and domain = ?", withArgumentsIn: [dateString, record.domain, record.requests, record.blocked, record.savedData, record.requests, record.blocked, record.savedData, dateString, record.domain])
                rollback?.pointee = ObjCBool(!result)
                
                if !result {
                    DDLogError("ActivityStatisticsService Error in writeRecords")
                }
            }
        }
    }
    
    func getAllRecords(completion: @escaping ([ActivityStatisticsRecord]) -> ()) {
        readHandler?.inTransaction{ (db, rollback) in
            guard let db = db else { return }
            var activityRecords = [ActivityStatisticsRecord]()
            
            if let resultSet = db.executeQuery("SELECT * FROM ActivityStatisticsTable", withArgumentsIn: []) {
                while resultSet.next() {
                    if let record = ActivityStatisticsRecord(resultSet) {
                        activityRecords.append(record)
                    }
                }
                completion(activityRecords)
            } else {
                completion([])
            }
        }
    }
    
    func getRecords(by type: ChartDateType, completion: @escaping ([ActivityStatisticsRecord]) -> ()) {
        readHandler?.inTransaction{ (db, rollback) in
            guard let db = db else { return }
            var activityRecords = [ActivityStatisticsRecord]()
            let intervalTime = type.getTimeInterval()
            
            let firstDate = intervalTime.begin.iso8601YyyyMmDdFormatter()
            let lastDate = intervalTime.end.iso8601YyyyMmDdFormatter()
            
            if let resultSet = db.executeQuery("SELECT * FROM ActivityStatisticsTable WHERE timeStamp <= ? AND timeStamp >= ? ORDER BY timeStamp DESC, domain ASC", withArgumentsIn: [firstDate, lastDate]) {
                while resultSet.next() {
                    if let record = ActivityStatisticsRecord(resultSet) {
                        activityRecords.append(record)
                    }
                }
                completion(activityRecords)
            } else {
                completion([])
            }
        }
    }
    
    func deleteAllRecords() {
        readHandler?.inTransaction{ (db, rollback) in
            guard let db = db else { return }
            
            let result = db.executeUpdate("DELETE FROM ActivityStatisticsTable", withArgumentsIn: [])
            rollback?.pointee = ObjCBool(!result)
            if !result {
                DDLogError("ActivityStatisticsService Error in deleteAllRecords")
            }
        }
    }

    
    // MARK: - private methods
    
    private func createDnsLogTable(_ db: FMDatabase) {
        let result = db.executeUpdate("CREATE TABLE IF NOT EXISTS ActivityStatisticsTable (timeStamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, domain TEXT NOT NULL DEFAULT '', requests INTEGER NOT NULL DEFAULT 0, blocked INTEGER NOT NULL DEFAULT 0, savedData INTEGER NOT NULL DEFAULT 0, PRIMARY KEY(timeStamp, domain))", withParameterDictionary: [:])
        if !result {
            DDLogError("ActivityStatisticsService Error in createDnsLogTable")
        }
    }
}
