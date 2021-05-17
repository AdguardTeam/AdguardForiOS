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
import Zip
import SQLite

protocol DefaultDatabaseManagerProtocol {
    // default.db schema version
    var defaultDbSchemaVersion: String? { get }
    
    // default.db file URL
    var defaultDbFileUrl: URL { get }
    
    /*
     Unarchives default.db and places it to the specified folder
     Returns true if update was successful
     */
    func updateDefaultDb() -> Bool
}

final class DefaultDatabaseManager: DefaultDatabaseManagerProtocol {
    
    // MARK: - Public properties
    
    var defaultDbSchemaVersion: String? {
        guard let db = try? Connection(defaultDbFileUrl.path) else {
            return nil
        }
        
        let versionTable = Table("version")
        let versionColumn = Expression<String>("schema_version")
        return try? db.pluck(versionTable)?.get(versionColumn)
    }
    
    lazy var defaultDbFileUrl: URL = { dbContainerUrl.appendingPathComponent(dbFile) }()
    
    // MARK: - Private properties
    
    // Default database archive file name
    private let defaultDbArchiveFile = "default.db.zip"
    
    // Default database file name
    private let dbFile = "default.db"
    
    // URL where db files should be located
    private let dbContainerUrl: URL
    
    // MARK: - Initialization
    
    init(dbContainerUrl: URL) {
        self.dbContainerUrl = dbContainerUrl
        
        // Create default.db file if missing
        if !FileManager.default.fileExists(atPath: defaultDbFileUrl.path) {
            let success = updateDefaultDb()
            Logger.logInfo("default.db file was missing, created new one with success = \(success)")
        }
    }
    
    // MARK: - Public methods
    
    func updateDefaultDb() -> Bool {
        guard let dbFileUrl = getDefaultDbUnzippedData() else {
            Logger.logError("Failed to unarchive default.db")
            return false
        }
        
        do {
            let _ = try FileManager.default.replaceItemAt(defaultDbFileUrl, withItemAt: dbFileUrl)
            try FileManager.default.removeItem(at: dbFileUrl)
            
            return true
        } catch {
            Logger.logError("Error replacinf default.db file from URL = \(defaultDbFileUrl); to URL = \(dbFileUrl); error: \(error)")
            return false
        }
    }
    
    // MARK: - Private methods
    
    // Unarchives default database archive and returns an URL of default.db file
    private func getDefaultDbUnzippedData() -> URL? {
        guard let resourcesUrl = Bundle(for: type(of: self)).resourceURL else {
            return nil
        }
        let defaultDbArchiveUrl = resourcesUrl.appendingPathComponent(defaultDbArchiveFile)
        let targetDbFileUrl = resourcesUrl.appendingPathComponent(dbFile)
        do {
            try Zip.unzipFile(defaultDbArchiveUrl, destination: resourcesUrl, overwrite: true, password: nil)
            try FileManager.default.removeItem(at: defaultDbArchiveUrl)
            
            return targetDbFileUrl
        } catch {
            Logger.logError("Error unarchiving default.db file from URL = \(defaultDbArchiveUrl.path); error: \(error)")
            return nil
        }
    }
}
