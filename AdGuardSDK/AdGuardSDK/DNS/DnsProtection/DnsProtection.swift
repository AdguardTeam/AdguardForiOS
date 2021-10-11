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

public typealias DnsProtectionProtocol = DnsProtectionConfigurationProtocol
                                & DnsProtectionUserRulesManagerProtocol
                                & DnsBackgroundFetchUpdateProtocol
                                & DnsProtectionFiltersProtocol
                                & ResetableSyncProtocol

public final class DnsProtection: DnsProtectionProtocol {

    // Serial queue to avoid races in services
    let workingQueue = DispatchQueue(label: "AdGuardSDK.DnsProtection.workingQueue")
    // Queue to call completion handlers
    let completionQueue = DispatchQueue.main

    /* Services */
    var configuration: DnsConfigurationProtocol
    let defaultConfiguration: DnsConfigurationProtocol
    let dnsUserRulesManagerProvider: DnsUserRulesManagersProviderProtocol
    let dnsFiltersManager: DnsFiltersManagerProtocol
    let filterFilesStorage: FilterFilesStorageProtocol

    public init(
        configuration: DnsConfigurationProtocol,
        defaultConfiguration: DnsConfigurationProtocol,
        userDefaults: UserDefaults,
        filterFilesDirectoryUrl: URL) throws {
        let services = try DnsProtectionServiceStorage(configuration: configuration, userDefaults: userDefaults, filterFilesDirectoryUrl: filterFilesDirectoryUrl)
        self.configuration = configuration
        self.defaultConfiguration = defaultConfiguration

        self.dnsUserRulesManagerProvider = services.dnsUserRulesManager
        self.dnsFiltersManager = services.dnsFiltersManager
        self.filterFilesStorage = services.filterFilesStorage
    }

    // Initializer for tests
    init(configuration: DnsConfigurationProtocol,
         defaultConfiguration: DnsConfigurationProtocol,
         dnsUserRulesManagerProvider: DnsUserRulesManagersProviderProtocol,
         dnsFiltersManager: DnsFiltersManagerProtocol,
         filterFilesStorage: FilterFilesStorageProtocol) {

        self.configuration = configuration
        self.defaultConfiguration = defaultConfiguration
        self.dnsUserRulesManagerProvider = dnsUserRulesManagerProvider
        self.dnsFiltersManager = dnsFiltersManager
        self.filterFilesStorage = filterFilesStorage
    }

    public func reset() throws {
        try workingQueue.sync {
            configuration.updateConfig(with: defaultConfiguration)
            try dnsUserRulesManagerProvider.reset()
            try dnsFiltersManager.reset()
            try filterFilesStorage.reset()
        }
    }
}
