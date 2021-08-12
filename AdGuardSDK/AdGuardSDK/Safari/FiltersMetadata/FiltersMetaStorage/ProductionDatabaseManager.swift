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
import SQLite

protocol ProductionDatabaseManagerProtocol: ResetableSyncProtocol {
    /*
     Database connections are established using the Connection class.
     filtersDb is thread safe, the doc to SQLite says:
     "Every Connection comes equipped with its own serial queue for statement execution and can be safely accessed across threads"
     */
    var filtersDb: Connection { get }
    
    /*
     Checks default.db schema version, because it must be the newest one
     Updates adguard.db if schema version differs
     */
    func updateDatabaseIfNeeded() throws
}

final class ProductionDatabaseManager: ProductionDatabaseManagerProtocol {
    
    enum ManagerError: Error, CustomDebugStringConvertible {
        case invalidResourcePath
        case unknownDbVersion
        
        var debugDescription: String {
            switch self {
            case .invalidResourcePath: return "Bundle.resourceURL is nil"
            case .unknownDbVersion: return "Failed to reveal database version"
            }
        }
    }
    
    // MARK: - Public properties
    
    var filtersDb: Connection
    
    // MARK: - Private properties
    
    // Production database file name
    private let dbFile = "adguard.db"
    
    private let fileManager = FileManager.default
    
    // adguard.db file URL
    private let productionDbFileUrl: URL
    
    // URL where db files should be located
    private let dbContainerUrl: URL
    
    // Manager for default.db with all info about it
    private let defaultDatabaseManager: DefaultDatabaseManagerProtocol
    
    // MARK: - Initialization
    
    init(dbContainerUrl: URL) throws {
        self.productionDbFileUrl = dbContainerUrl.appendingPathComponent(dbFile)
        self.dbContainerUrl = dbContainerUrl
        self.defaultDatabaseManager = try DefaultDatabaseManager(dbContainerUrl: dbContainerUrl)
        
        // Check if adguard.db file exists
        let productionDbExists = fileManager.fileExists(atPath: productionDbFileUrl.path)
        
        if !productionDbExists {
            
            // Check if default.db exists and create it otherwise
            if !defaultDatabaseManager.defaultDbFileExists {
                try defaultDatabaseManager.updateDefaultDb()
            }
            
            // When adguard.db is missing we rename default.db -> adguard.db
            let _ = try fileManager.replaceItemAt(productionDbFileUrl, withItemAt: defaultDatabaseManager.defaultDbFileUrl)
        }
        
        /*
         Initialize production.db
         "A connection is initialized with a path to a database
         SQLite will attempt to create the database file if it does not already exist"
         */
        self.filtersDb = try Connection(productionDbFileUrl.path)
    }
    
    // MARK: - Public methods
    
    func updateDatabaseIfNeeded() throws {
        Logger.logInfo("(ProductionDatabaseManager) - updateDatabaseIfNeeded start")
        
        try defaultDatabaseManager.updateDefaultDb()
        
        let (shouldUpgradeDb, updateVersions) = try shouldUpgradeDbScheme()
        
        if shouldUpgradeDb {
            for version in updateVersions {
                try updateProductionDb(toVersion: version)
            }
        }
        
        // Remove default.db when update finished
        try defaultDatabaseManager.removeDefaultDb()
        
        Logger.logInfo("(ProductionDatabaseManager) - updateDatabaseIfNeeded finished; shouldUpgradeDb=\(shouldUpgradeDb); updateVersions=\(updateVersions)")
    }
    
    func reset() throws {
        Logger.logInfo("(ProductionDatabaseManager) - reset start")
        
        // Update default.db to the latest saved
        try defaultDatabaseManager.updateDefaultDb()
        
        // Replace existing production db with default one
        let _ = try fileManager.replaceItemAt(productionDbFileUrl, withItemAt: defaultDatabaseManager.defaultDbFileUrl)
        
        // Reinitialize database object
        filtersDb = try Connection(productionDbFileUrl.path)
        
        Logger.logInfo("(ProductionDatabaseManager) - reset; Successfully reset adguard.db")
    }
    
    // MARK: - Private methods
    
    /*
     Compares schema version of default.db and adguard.db
     Returns true if adguard.db schema is lower than default.db and string of version number
     */
    private func shouldUpgradeDbScheme() throws -> (Bool, [String]) {
        let versionTable = Table("version")
        let versionColumn = Expression<String>("schema_version")
        
        guard let productionDbSchemaVersion = try filtersDb.pluck(versionTable)?.get(versionColumn),
              let defaultDbSchemaVersion = defaultDatabaseManager.defaultDbSchemaVersion
        else {
            throw ManagerError.unknownDbVersion
        }
        
        let shouldUpdate = defaultDbSchemaVersion.compare(productionDbSchemaVersion, options: .numeric) == .orderedDescending
        if shouldUpdate {
            return (shouldUpdate, calculateUpdateVersions(toVersion: defaultDbSchemaVersion, fromVersion: productionDbSchemaVersion))
        }
        return (shouldUpdate, [])
    }
    
    // Updates production database to the specified version
    private func updateProductionDb(toVersion version: String) throws {
        guard let resourcesUrl = Bundle(for: type(of: self)).resourceURL else {
            throw ManagerError.invalidResourcePath
        }
        
        let dbUpdateFileFormat = "update%@.sql" // %@ stands for update version
        let updateFileName = String(format: dbUpdateFileFormat, version)
        let updateFileUrl = resourcesUrl.appendingPathComponent(updateFileName)
        let updateQuery = try String(contentsOf: updateFileUrl)
        try filtersDb.execute(updateQuery)
    }
    
    private func calculateUpdateVersions(toVersion: String, fromVersion: String) -> [String] {
        guard let toVersion = Double(toVersion) else { return [] }
        guard var fromVersion = Double(fromVersion) else { return [] }
        
        var result = [String]()
        
        repeat {
            result.append(String(format: "%.3f", fromVersion))
            fromVersion += 0.001
        } while fromVersion < toVersion
        return result
    }
}
