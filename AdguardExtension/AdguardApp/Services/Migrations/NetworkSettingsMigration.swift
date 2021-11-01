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

/// Network settings migration protocol
protocol NetworkSettingsMigrationProtocol {
    /**
     This method starts network settings migration: fetch old exceptions and save it to the UserDefaults (SharedDefaults).
     After saving removes old exceptions file
     */
    func startMigration()
}

/// Network settings migration service
final class NetworkSettingsMigrations: NetworkSettingsMigrationProtocol {

    // MARK: - Private properties

    private let jsonNetworkSettingsFileName = "NetworkSettings"
    private let networkSettingsService: NetworkSettingsServiceProtocol
    private let resources: AESharedResourcesProtocol

    //MARK: - Init

    init(networkSettingsService: NetworkSettingsServiceProtocol,
         resources: AESharedResourcesProtocol) {
        self.networkSettingsService = networkSettingsService
        self.resources = resources
    }

    // MARK: - Public methods

    func startMigration() {
        let exceptions = fetchOldWifiExceptions()
        if exceptions.isEmpty {
            DDLogWarn("(NetworkSettingsMigration) - startMigration; Nothing to migrate")
            return
        }

        do {
            try exceptions.forEach { try networkSettingsService.add(exception: $0) }
            removeOldExceptionsFile()
            DDLogInfo("(NetworkSettingsMigration) - startMigration; All \(exceptions.count) exceptions successfully migrated")
        } catch {
            DDLogError("(NetworkSettingsMigration) - startMigration; On adding exception error occurred: \(error)")
        }
    }

    //MARK: - Private methods

    private func fetchOldWifiExceptions() -> [WifiException] {
        do {
            guard let data = resources.loadData(fromFileRelativePath: jsonNetworkSettingsFileName) else {
                DDLogError("(NetworkSettingsMigration) - fetchOldWifiException; Failed to load wifi exceptions from file")
                return []
            }
            return try JSONDecoder().decode([WifiException].self, from: data)
        } catch {
            DDLogInfo("(NetworkSettingsMigration) - fetchOldWifiException; Decoding network settings error occurred: \(error)")
            return []
        }
    }

    private func removeOldExceptionsFile() {
        let fileManager = FileManager.default
        do {
            let path = resources.path(forRelativePath: jsonNetworkSettingsFileName)
            guard fileManager.fileExists(atPath: path) else {
                DDLogWarn("(NetworkSettingsMigration) - removeOldExceptionsFile; File doesn't exists")
                return
            }

            try fileManager.removeItem(atPath: path)
            DDLogInfo("(NetworkSettingsMigration) - removeOldExceptionsFile; Exception file successfully removed")
        } catch {
            DDLogError("(NetworkSettingsMigration) - removeOldExceptionsFile; Error occurred while removing exception file: \(error)")
        }
    }
}

