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

@objc enum DnsStatisticsType: Int {
    case all, blocked
}

protocol DnsStatisticsServiceProtocol {
    func writeStatistics(_ statistics: [DnsStatisticsType: RequestsStatisticsBlock])
    
    func readStatistics()->[DnsStatisticsType:[RequestsStatisticsBlock]]
    
    func clearStatistics()
}

class DnsStatisticsService: NSObject, DnsStatisticsServiceProtocol {
    
    private let resources: AESharedResourcesProtocol
    
    private lazy var path =  { self.resources.sharedResuorcesURL().appendingPathComponent("dns-statistics.db").absoluteString }()
    
    private let statisticsRearrangeLimit:Double = 3600   // 1 hour
    private let statisticsRecordsLimit = 1500   // 1500 records
    private let statisticsSectorsLimit = 150   // 1500 records -> 150 records
    
    private lazy var lastStatisticsRearrangeTime: TimeInterval = Date().timeIntervalSince1970 + statisticsRearrangeLimit
    
    private lazy var writeHandler: FMDatabaseQueue? = {
        let handler = FMDatabaseQueue.init(path: path, flags: SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
        
        handler?.inTransaction{ (db, rollback) in
            self.createStatisticsTable(db!)
        }
        
        return handler
    }()
    
    private lazy var readHandler: FMDatabaseQueue? = {
        return FMDatabaseQueue.init(path: path, flags: SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
    }()
    
    // MARK: - init
    
    init(resources: AESharedResourcesProtocol) {
        self.resources = resources
        super.init()
    }
    
    // MARK: - public methods
    
    func writeStatistics(_ statistics: [DnsStatisticsType : RequestsStatisticsBlock]) {
        
        rearrangeStatistics()
        
        writeHandler?.inTransaction { (db, rollback) in
            let table = ADBTable(rowClass: APStatisticsTable.self, db: db)
            let row = APStatisticsTable()
            row.allStatisticsBlocks = statistics[.all]
            row.blockedStatisticsBlocks = statistics[.blocked]
            table?.insertOrReplace(false, fromRowObject: row)
        }
    }
    
    func readStatistics()->[DnsStatisticsType:[RequestsStatisticsBlock]] {
        
        var statistics = [DnsStatisticsType:[RequestsStatisticsBlock]]()
        
        ProcessInfo().performExpiringActivity(withReason: "read statistics in background") { [weak self] (expired) in
            self?.readHandler?.inTransaction { (db, rollback) in
                let table = ADBTable(rowClass: APStatisticsTable.self, db: db)
                guard let result = table?.select(withKeys: nil, inRowObject: nil) as? [APStatisticsTable] else { return }
                
                if result.count > 0 {
                    statistics[.all] = result.map { $0.allStatisticsBlocks }
                    statistics[.blocked] = result.map { $0.blockedStatisticsBlocks }
                }
            }
        }
        
        return statistics;
    }
    
    func clearStatistics() {
        writeHandler?.inTransaction { [weak self] (db, rollback) in
            let table = ADBTable(rowClass: APStatisticsTable.self, db: db)
            let success = table?.delete(withKeys: nil, inRowObject: nil)
            if success ?? false {
                self?.resources.sharedDefaults().set(0, forKey: AEDefaultsRequests)
                self?.resources.sharedDefaults().set(0, forKey: AEDefaultsBlockedRequests)
            }
        }
    }
    
    // MARK: - private methods
    
    private func createStatisticsTable(_ db:FMDatabase) {
        
        let result = db.executeUpdate("CREATE TABLE IF NOT EXISTS APStatisticsTable (timeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, allStatisticsBlocks BLOB, blockedStatisticsBlocks BLOB)", withParameterDictionary: [:])
        if result {
            db.executeUpdate("CREATE INDEX IF NOT EXISTS mainIndex ON APStatisticsTable (timeStamp)", withParameterDictionary: [:])
        }
    }
    
    private func rearrangeStatistics() {
        let now = Date().timeIntervalSince1970
        if now - lastStatisticsRearrangeTime > statisticsRearrangeLimit {
            lastStatisticsRearrangeTime = now
            
            let statistics = readStatistics()
            
            if statistics.count > statisticsRecordsLimit {
                rearrangeDb(statistics)
            }
        }
    }
    
    private func rearrangeDb(_ statistics: [DnsStatisticsType:[RequestsStatisticsBlock]]) {
        
        let rearrangedAll = rearrangeRow(statistics[.all]!)
        let rearrangedBlocked = rearrangeRow(statistics[.blocked]!)
        
        if removeStatistics() {
            for i in 0..<rearrangedAll.count {
                var newStatistics = [DnsStatisticsType: RequestsStatisticsBlock]()
                newStatistics[.all] = rearrangedAll[i]
                newStatistics[.blocked] = rearrangedBlocked[i]
                writeStatistics(newStatistics)
            }
        }
    }
    
    private func rearrangeRow(_ row: [RequestsStatisticsBlock])->[RequestsStatisticsBlock] {
        
        if row.count < 2 {
            return row
        }
        
        // Number of new sectors in db, for example
        // We had 1500 blocks, after rearranging we'll have 150
        let numberOfSectors = statisticsSectorsLimit
        
        // Sort all blocks by date
        let sorted = row.sorted { $0.date > $1.date }
        
        // Getting dates from blocks
        let sortedDates = sorted.map { $0.date }
        
        // Newest and oldest dates
        // sortedDates array looks like this
        // [oldest_date...some_date...some_date...some_date...newest_date]
        let oldestDate = sortedDates.first!.timeIntervalSinceReferenceDate
        let newestDate = sortedDates.last!.timeIntervalSinceReferenceDate
        
        // Devide all dates to equal sectors by date, not by number of elements
        let step = (newestDate - oldestDate) / Double(numberOfSectors);
        
        // separatorsDates are borders for new blocks
        var separatorsDates: [TimeInterval] = []
        var dateIterator = oldestDate
        while dateIterator < newestDate {
            separatorsDates.append(dateIterator)
            dateIterator += step;
        }
        
        separatorsDates.append(newestDate)
        
        var copySorted = Array(sorted)
        var returnArray:[RequestsStatisticsBlock] = []
        
        var iterator = 0
        var elementsToCut = 0
        var newSum = 0
        var dateSum:TimeInterval = 0
        
        // Iterating through array and summing up blocks between generated borders
        // If there were no blocks between two borders than we add a block with zero value
        while copySorted.count != 0 && iterator < separatorsDates.count - 1 {
            let leftBorder = separatorsDates[iterator]
            let rightBorder = separatorsDates[iterator + 1]
            
            for i in 0..<(copySorted.count - 1) {
                let block = copySorted[i]
                let nextBlock = copySorted[i+1]
                
                let date = block.date.timeIntervalSinceReferenceDate
                let nextDate = nextBlock.date.timeIntervalSinceReferenceDate
                let number = block.numberOfRequests
                let nextNumber = nextBlock.numberOfRequests
                
                if date >= leftBorder && date < rightBorder{
                    newSum += number
                    dateSum += date
                    elementsToCut += 1
                    
                    if nextDate >= rightBorder {
                        
                        if nextDate == newestDate {
                            newSum += nextNumber
                            dateSum += nextDate
                            elementsToCut += 1
                        }
                        
                        let newDate = Date(timeIntervalSinceReferenceDate: elementsToCut == 0 ? leftBorder : dateSum / Double(elementsToCut))
                            
                        let newBlock = RequestsStatisticsBlock(date: newDate, numberOfRequests: newSum)
                        returnArray.append(newBlock)
                        
                        iterator += 1
                        newSum = 0
                        dateSum = 0
                        break;
                    }
                } else {
                    let newDate = Date(timeIntervalSinceReferenceDate: leftBorder)
                    let newBlock = RequestsStatisticsBlock(date: newDate, numberOfRequests: 0)
                    returnArray.append(newBlock)
                    
                    iterator += 1
                    elementsToCut = 0
                    break;
                }
            }
            
            copySorted.removeFirst(elementsToCut)
            elementsToCut = 0
        }
        // returning new blocks
        return returnArray;
    }
    
    private func removeStatistics()->Bool {
        var result = false
        writeHandler?.inTransaction { (db, rollback) in
            let table = ADBTable(rowClass: APStatisticsTable.self, db: db)!
            result = table.delete(withKeys: nil, inRowObject: nil)
        }
    
        return result
    }

}
