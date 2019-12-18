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

@objc
protocol DnsLogRecordsServiceProtocol{
    func writeRecords(_ records: [DnsLogRecord])
    func readRecords()->[DnsLogRecord]
    func setUserStatus(rowId: NSNumber, status: DnsLogRecordUserStatus)
    func clearLog()
}

@objc
class DnsLogRecordsService: NSObject, DnsLogRecordsServiceProtocol {
    
    private let resources: AESharedResourcesProtocol
    
    private var lastPurgeTime = Date().timeIntervalSince1970
    private let purgeTimeInterval: TimeInterval = 60.0      // seconds
     
    private lazy var path = resources.sharedResuorcesURL().appendingPathComponent("dns-log-records.db").absoluteString
    
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
    
    @objc
    init(resources: AESharedResourcesProtocol) {
        self.resources = resources
    }
    
    func writeRecords(_ records: [DnsLogRecord]) {
        
        purgeDnsLog()
        
        writeHandler?.inTransaction{ (db, rollback) in
            let table = ADBTable(rowClass: APDnsLogTable.self, db: db!)
            for item in records {
                table?.insertOrReplace(false, fromRowObject: APDnsLogTable(timestamp: item.date.timeIntervalSince1970, record: item))
            }
        }
    }
    
    func readRecords() -> [DnsLogRecord] {
        
        var result: [APDnsLogTable]?
        readHandler?.inTransaction { (db, handler) in
            let table = ADBTable(rowClass: APDnsLogTable.self, db: db)
            result = table?.select(withKeys: nil, inRowObject: APDnsLogTable.self) as? [APDnsLogTable]
        }
        
        let records = result?.map { (row)->DnsLogRecord in
            let record = row.record
            record.rowid = row.rowid
            return record
        }
        
        return records ?? [DnsLogRecord]();
    }
    
    func clearLog() {
        writeHandler?.inTransaction { (db, rollback) in
            let table = ADBTable(rowClass: APDnsLogTable.self, db: db)
            table?.delete(withKeys: nil, inRowObject: nil)
        }
    }
    
    func setUserStatus(rowId: NSNumber, status: DnsLogRecordUserStatus) {
        
        var result: [APDnsLogTable]?
        readHandler?.inTransaction{ (db, rollback) in
            let table = ADBTable(rowClass: APDnsLogTable.self, db: db)
            let t = APDnsLogTable()
            t.rowid = rowId
            result = table?.select(withKeys: ["rowid"], inRowObject: t) as? [APDnsLogTable]
        }
        
        if result == nil || result?.count == 0 {
            DDLogError("(DnsLogRecordService) setUserStatus error - record not found")
            return
        }
        
        let row = result?.first
        row?.record.userStatus = status
        
        writeHandler?.inTransaction { (db, rollback) in
            let table = ADBTable(rowClass: APDnsLogTable.self, db: db)
            table?.update(withKeys: ["rowid"], fromRowObject: row, updateFields: [], fromRowObject: row)
        }
    }
    
    // MARK: - private methods
    
    private func createDnsLogTable(_ db:FMDatabase) {
        
        let result = db.executeUpdate("CREATE TABLE IF NOT EXISTS APDnsLogTable (timeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, record BLOB)", withParameterDictionary: [:])
        if result {
            db.executeUpdate("CREATE INDEX IF NOT EXISTS mainIndex ON APDnsLogTable (timeStamp)", withParameterDictionary: [:])
        }
    }
    
    private func purgeDnsLog() {
        
        let now = Date().timeIntervalSince1970;
        if (now - lastPurgeTime) > purgeTimeInterval {
            
            lastPurgeTime = now;
            writeHandler!.inTransaction { (db, rollback) in
                db!.executeUpdate("DELETE FROM APDnsLogTable WHERE timeStamp > 0 ORDER BY timeStamp DESC LIMIT -1 OFFSET 1000", withParameterDictionary: [:])
            }
        }
    }
}

