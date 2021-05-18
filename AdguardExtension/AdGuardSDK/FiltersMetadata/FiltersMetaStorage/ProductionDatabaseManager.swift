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

protocol ProductionDatabaseManagerProtocol {
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
    
    let filtersDb: Connection
    
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
        self.defaultDatabaseManager = DefaultDatabaseManager(dbContainerUrl: dbContainerUrl)
        
        // Check if adguard.db file exists
        let productionDbExists = fileManager.fileExists(atPath: productionDbFileUrl.path)
        
        if !productionDbExists {
            // When adguard.db is missing we rename default.db -> adguard.db
            let _ = try fileManager.replaceItemAt(defaultDatabaseManager.defaultDbFileUrl, withItemAt: productionDbFileUrl)
        }
        
        /*
         Initialize production.db
         "A connection is initialized with a path to a database
         SQLite will attempt to create the database file if it does not already exist"
         */
        self.filtersDb = try Connection(productionDbFileUrl.path)
        
        // Create adguard.db from schema if it was missing
        if !productionDbExists {
            try createProductionDb()
        }
    }
    
    // MARK: - Public methods
    
    func updateDatabaseIfNeeded() throws {
        // Create default.db from archive to be sure it is the newest one
        try defaultDatabaseManager.updateDefaultDb()
        
        let (shouldUpgradeDb, defaultDbSchemaVersion) = try shouldUpgradeDbScheme()
        
        if shouldUpgradeDb {
            try updateProductionDb(toVersion: defaultDbSchemaVersion)
        }
        
        // Remove default.db when update finished
        try defaultDatabaseManager.removeDefaultDb()
    }
    
    // MARK: - Private methods
    
    /*
     Compares schema version of default.db and adguard.db
     Returns true if adguard.db schema is lower than default.db, alse returns default.db schma version
     */
    private func shouldUpgradeDbScheme() throws -> (Bool, Int) {
        let versionTable = Table("version")
        let versionColumn = Expression<Int>("schema_version")
        
        guard let productionDbSchemaVersion = try filtersDb.pluck(versionTable)?.get(versionColumn),
              let defaultDbSchemaVersion = defaultDatabaseManager.defaultDbSchemaVersion
        else {
            throw ManagerError.unknownDbVersion
        }
        
        return (productionDbSchemaVersion < defaultDbSchemaVersion, defaultDbSchemaVersion)
    }
    
    // Creates production database from schema file
    private func createProductionDb() throws {
        guard let resourcesUrl = Bundle(for: type(of: self)).resourceURL else {
            throw ManagerError.invalidResourcePath
        }
        
        let dbSchemeFileFormat = "schema%@.sql" // %@ stands for schema version
        let version = ""
        let schemaFileName = String(format: dbSchemeFileFormat, version)
        let latestSchemaUrl = resourcesUrl.appendingPathComponent(schemaFileName)
        let schemaQuery = try String(contentsOf: latestSchemaUrl)
        try filtersDb.execute(schemaQuery)
    }
    
    // Updates production database to the specified version
    private func updateProductionDb(toVersion version: Int) throws {
        guard let resourcesUrl = Bundle(for: type(of: self)).resourceURL else {
            throw ManagerError.invalidResourcePath
        }
        
        let dbUpdateFileFormat = "update%@.sql" // %@ stands for update version
        let updateFileName = String(format: dbUpdateFileFormat, version)
        let updateFileUrl = resourcesUrl.appendingPathComponent(updateFileName)
        let updateQuery = try String(contentsOf: updateFileUrl)
        try filtersDb.execute(updateQuery)
    }
}
