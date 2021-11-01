///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import Foundation
import SQLite

public protocol AdGuardSDKBuilderProtocol {
    /// loads metadata and all filters synchronously and store them in urls sent to constructor
    func loadAll() throws
}

public class AdGuardSDKBuilder: AdGuardSDKBuilderProtocol {

    let filtersService: FiltersServiceForBuilderProtocol
    public init (filtersStorageUrl: URL, dbUrl: URL) {
        let configuration = SafariConfiguration(iosVersion: 13, currentLocale: Locale.current, proStatus: false, safariProtectionEnabled: true, advancedBlockingIsEnabled: true, blocklistIsEnabled: true, allowlistIsEnabled: true, allowlistIsInverted: false, appBundleId: Bundle.main.bundleIdentifier ?? "", appProductVersion: "", appId: "builder", cid: "")

        let filtersStorage = try! FilterFilesStorage(filterFilesDirectoryUrl: filtersStorageUrl)

        let dbManager = BuilderDbManager(dbContainerFolderUrl: dbUrl)
        let metaStorage = MetaStorage(productionDbManager: dbManager)

        let defaults = UserDefaultsStorage(storage: UserDefaults())

        let api = SafariProtectionApiMethods()

        filtersService = try! FiltersService(configuration: configuration, filterFilesStorage: filtersStorage, metaStorage: metaStorage, userDefaultsStorage: defaults, apiMethods: api)
    }

    public func loadAll() throws {
        try filtersService.downloadAndSaveFiltersMeta()
    }
}

fileprivate final class BuilderDbManager: ProductionDatabaseManagerProtocol {

    let filtersDb: Connection

    init(dbContainerFolderUrl: URL) {
        let dbPath = dbContainerFolderUrl.appendingPathComponent(Constants.Files.defaultDbFileName).absoluteString

        let filePaths = try! FileManager.default.contentsOfDirectory(atPath: dbContainerFolderUrl.path)
        for filePath in filePaths {
            try! FileManager.default.removeItem(atPath: dbContainerFolderUrl.appendingPathComponent(filePath).path)
        }

        filtersDb = try! Connection(dbPath)

        let schemaUrl = Bundle(for: type(of: self)).url(forResource: "schema", withExtension: "sql")!
        let createQuery = try! String(contentsOf: schemaUrl)
        try! filtersDb.execute(createQuery)
    }

    func updateDatabaseIfNeeded() throws {
    }

    func reset() throws {
    }
}
