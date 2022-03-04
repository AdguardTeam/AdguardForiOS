//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import SafariAdGuardSDK
import DnsAdGuardSDK
import SharedAdGuardSDK

protocol ServiceInitializerProtocol  {
    var networkService: ACNNetworkingProtocol { get }
    var productInfo: ADProductInfoProtocol { get }

    var safariProtection: SafariProtectionProtocol { get }
    var complexProtection: ComplexProtectionServiceProtocol { get }
    var dnsProvidersManager: DnsProvidersManagerProtocol { get }
    var activityStatistics: ActivityStatisticsProtocol { get }
}

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(ServiceInitializer.self)

final class ServiceInitializer: ServiceInitializerProtocol {
    let networkService: ACNNetworkingProtocol = ACNNetworking()
    let productInfo: ADProductInfoProtocol = ADProductInfo()

    let safariProtection: SafariProtectionProtocol
    let complexProtection: ComplexProtectionServiceProtocol
    let dnsProvidersManager: DnsProvidersManagerProtocol
    let activityStatistics: ActivityStatisticsProtocol

    init(resources: AESharedResourcesProtocol) throws {
        LOG.info("(TodayViewController) - init services start")
        let networkService = ACNNetworking()
        let productInfo = ADProductInfo()
        let purchaseService = PurchaseService(network: networkService, resources: resources, productInfo: productInfo)

        let sharedStorageUrls = SharedStorageUrls()

        LOG.info("(TodayViewController) - init safari protection service")
        let safariConfiguration = SafariConfiguration(
            resources: resources, 
            isProPurchased: purchaseService.isProPurchased
        )

        self.safariProtection = try SafariProtection(
            configuration: safariConfiguration,
            defaultConfiguration: safariConfiguration,
            filterFilesDirectoryUrl: sharedStorageUrls.filtersFolderUrl,
            dbContainerUrl: sharedStorageUrls.dbFolderUrl,
            jsonStorageUrl: sharedStorageUrls.cbJsonsFolderUrl,
            userDefaults: resources.sharedDefaults()
        )

        let networkSettings = NetworkSettingsService(resources: resources)

        let configuration = ConfigurationService(
            purchaseService: purchaseService,
            resources: resources,
            safariProtection: safariProtection
        )

        let dnsConfiguration = DnsConfiguration(
            resources: resources,
            isProPurchased: purchaseService.isProPurchased
        )

        LOG.info("(TodayViewController) - init dns protection service")

        self.dnsProvidersManager = try DnsProvidersManager(configuration: dnsConfiguration, userDefaults: resources.sharedDefaults(), networkUtils: NetworkUtils())

        let nativeDnsSettingsManager = NativeDnsSettingsManager(networkSettingsService: networkSettings, dnsProvidersManager: dnsProvidersManager, configuration: configuration, resources: resources)

        let vpnManager = VpnManager(
            resources: resources,
            configuration: configuration,
            networkSettings: NetworkSettingsService(resources: resources)
        )

        self.complexProtection = ComplexProtectionService(
            resources: resources,
            configuration: configuration,
            vpnManager: vpnManager,
            productInfo: productInfo,
            nativeDnsSettingsManager: nativeDnsSettingsManager,
            safariProtection: safariProtection
        )

        // MARK: - ActivityStatistics

        LOG.info("(TodayViewController) - init activity statistics service")

        self.activityStatistics = try ActivityStatistics(statisticsDbContainerUrl: sharedStorageUrls.statisticsFolderUrl, readOnly: true)

        LOG.info("(TodayViewController) - init services end")
    }
}
