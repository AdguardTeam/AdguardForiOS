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
import SafariAdGuardSDK

/**
 this service initializes all shared services and put them into ServiceLocator
 */
final class StartupService : NSObject{
    
    @objc
    static func start() {
        
        let locator = ServiceLocator.shared
        
        // init services
        
        let sharedResources: AESharedResourcesProtocol = AESharedResources()
        locator.addService(service: sharedResources)
        
        // Registering standard Defaults
        if  let path = Bundle.main.path(forResource: "defaults", ofType: "plist"),
            let defs = NSDictionary(contentsOfFile: path)  as? [String : Any] {
            sharedResources.sharedDefaults().register(defaults: defs)
        }
        
        let networkService = ACNNetworking()
        locator.addService(service: networkService)
        
        let productInfo: ADProductInfoProtocol = ADProductInfo()
        locator.addService(service: productInfo)
        
        let purchaseService:PurchaseServiceProtocol = PurchaseService(network: networkService, resources: sharedResources, productInfo: productInfo)
        purchaseService.start()
        locator.addService(service: purchaseService)
    
        let sharedUrls = SharedStorageUrls()
        let preloadedFilesManager = PreloadedFilesManager(sharedStorageUrls: sharedUrls)
        try! preloadedFilesManager.processPreloadedFiles()
        
        /* Initializing SDK */
        let appBundleId = Bundle.main.bundleIdentifier ?? ""
        let appProductVersion = productInfo.version() ?? ""
        let currentLanguage = "\(ADLocales.lang() ?? "en")-\(ADLocales.region() ?? "US")"
        let appId = Bundle.main.isPro ? "ios_pro" : "ios"
        let cid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        let safariProtectionConfiguration = SafariConfiguration(
            currentLanguage: currentLanguage,
            proStatus: purchaseService.isProPurchased,
            safariProtectionEnabled: sharedResources.safariProtectionEnabled,
            blocklistIsEnabled: sharedResources.safariUserFilterEnabled,
            allowlistIsEnbaled: sharedResources.safariWhitelistEnabled,
            allowlistIsInverted: sharedResources.invertedWhitelist,
            appBundleId: appBundleId,
            appProductVersion: appProductVersion,
            appId: appId,
            cid: cid
        )
        
        let defaultConfiguration = SafariConfiguration(
            currentLanguage: currentLanguage,
            proStatus: false,
            safariProtectionEnabled: true,
            blocklistIsEnabled: false,
            allowlistIsEnbaled: false,
            allowlistIsInverted: false,
            appBundleId: appBundleId,
            appProductVersion: appProductVersion,
            appId: appId,
            cid: cid
        )
        
        // TODO: - try! is bad
        let safariProtection: SafariProtectionProtocol = try! SafariProtection(
            configuration: safariProtectionConfiguration,
            defaultConfiguration: defaultConfiguration,
            filterFilesDirectoryUrl: sharedUrls.filtersFolderUrl,
            dbContainerUrl: sharedUrls.dbFolderUrl,
            jsonStorageUrl: sharedUrls.cbJsonsFolderUrl,
            userDefaults: sharedResources.sharedDefaults()
        )
        
        locator.addService(service: safariProtection)
        
        /* End of initializing SDK */
        
        let configuration: ConfigurationService = ConfigurationService(purchaseService: purchaseService, resources: sharedResources, safariProtection: safariProtection)
        locator.addService(service: configuration)
        
        let dnsProviders: DnsProvidersServiceProtocol = DnsProvidersService(resources: sharedResources)
        locator.addService(service: dnsProviders)
        
        let networkSettingsService: NetworkSettingsServiceProtocol = NetworkSettingsService(resources: sharedResources)
        ServiceLocator.shared.addService(service: networkSettingsService)
        
        let nativeProviders: NativeProvidersServiceProtocol = NativeProvidersService(dnsProvidersService: dnsProviders, networkSettingsService: networkSettingsService, resources: sharedResources, configuration: configuration)
        dnsProviders.delegate = nativeProviders as? NativeProvidersService
        locator.addService(service: nativeProviders)
        
        let vpnManager: VpnManager = VpnManager(resources: sharedResources, configuration: configuration, networkSettings: networkSettingsService, dnsProviders: dnsProviders)
        locator.addService(service: vpnManager as VpnManagerProtocol)
        dnsProviders.vpnManager = vpnManager
        
        let safariProtectionState =  SafariProtectionService(resources: sharedResources)
        locator.addService(service: safariProtectionState)
        
        let complexProtection: ComplexProtectionServiceProtocol = ComplexProtectionService(resources: sharedResources, configuration: configuration, vpnManager: vpnManager, productInfo: productInfo, nativeProvidersService: nativeProviders, safariProtection: safariProtection)
        locator.addService(service: complexProtection)
        
        vpnManager.complexProtection = complexProtection
        vpnManager.checkVpnInstalled { _ in }
        
        let themeService: ThemeServiceProtocol = ThemeService(configuration)
        locator.addService(service: themeService)
        
        let dnsFiltersService : DnsFiltersServiceProtocol = DnsFiltersService(resources: sharedResources, vpnManager: vpnManager, complexProtection: complexProtection)
        locator.addService(service: dnsFiltersService)
        
        let keyChainService: KeychainServiceProtocol = KeychainService(resources: sharedResources)
        locator.addService(service: keyChainService)
        
        let supportService: SupportServiceProtocol = SupportService(resources: sharedResources, configuration: configuration, complexProtection: complexProtection, dnsProviders: dnsProviders, dnsFilters: dnsFiltersService, productInfo: productInfo, keyChainService: keyChainService, safariProtection: safariProtection, networkSettings: networkSettingsService)
        locator.addService(service: supportService)

        let userNotificationService: UserNotificationServiceProtocol = UserNotificationService()
        locator.addService(service: userNotificationService)
    
        let dnsTrackerService: DnsTrackerServiceProtocol = DnsTrackerService()
        locator.addService(service: dnsTrackerService)
        
        let rateService: RateAppServiceProtocol = RateAppService(resources: sharedResources, configuration: configuration)
        locator.addService(service: rateService)
        
        let domainsParserService: DomainsParserServiceProtocol = DomainsParserService()
        locator.addService(service: domainsParserService)
        
//        let migrationService: MigrationServiceProtocol = MigrationService(vpnManager: vpnManager, dnsProvidersService: dnsProviders, resources: sharedResources, antibanner: antibanner, dnsFiltersService: dnsFiltersService, networking: networkService, activityStatisticsService: activityStatisticsService, dnsStatisticsService: dnsStatisticsService, dnsLogService: dnsLogService, configuration: configuration, filtersService: filtersService, productInfo: productInfo, contentBlockerService: contentBlockerService, nativeProviders: nativeProviders, filtersStorage: filtersStorage, safariProtection: safariProtection)
//        locator.addService(service: migrationService)
        
        let chartViewModel: ChartViewModelProtocol = ChartViewModel(resources: sharedResources)
        locator.addService(service: chartViewModel)
        
        let setappService: SetappServiceProtocol = SetappService(purchaseService: purchaseService, resources: sharedResources)
        locator.addService(service: setappService)
        
        let importSettings: ImportSettingsServiceProtocol = ImportSettingsService(networking: networkService, dnsFiltersService: dnsFiltersService, dnsProvidersService: dnsProviders, purchaseService: purchaseService, resources: sharedResources, safariProtection: safariProtection)
        locator.addService(service: importSettings)
        
        let webReporter: ActionWebReporterProtocol = ActionWebReporter(productInfo: productInfo, complexProtection: complexProtection, dnsProviders: dnsProviders, configuration: configuration, dnsFilters: dnsFiltersService, safariProtection: safariProtection)
        locator.addService(service: webReporter)
    }
}
