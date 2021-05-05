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
import Accounts

/**
 this service initializes all shared services and put them into ServiceLocator
 */
class StartupService : NSObject{
    
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
        
        let safariService = SafariService(mainAppBundleId: Bundle.main.bundleIdentifier!)
        locator.addService(service: safariService)
    
        let configuration: ConfigurationService = ConfigurationService(purchaseService: purchaseService, resources: sharedResources, safariService: safariService)
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
        
        let safariProtection =  SafariProtectionService(resources: sharedResources)
        locator.addService(service: safariProtection)
        
        let complexProtection: ComplexProtectionServiceProtocol = ComplexProtectionService(resources: sharedResources, safariService: safariService, configuration: configuration, vpnManager: vpnManager, safariProtection: safariProtection, productInfo: productInfo, nativeProvidersService: nativeProviders)
        locator.addService(service: complexProtection)
        
        vpnManager.complexProtection = complexProtection
        vpnManager.checkVpnInstalled { _ in }
        
        let themeService: ThemeServiceProtocol = ThemeService(configuration)
        locator.addService(service: themeService)
        
        let antibanner: AESAntibannerProtocol = AESAntibanner(resources: sharedResources)
        locator.addService(service: antibanner)
        
        let antibannerController: AntibannerControllerProtocol = AntibannerController(antibanner: antibanner, version: productInfo.version())
        locator.addService(service: antibannerController)
        
        let filtersStorage: FiltersStorageProtocol = FiltersStorage()
        locator.addService(service: filtersStorage)
        
        let sdkResources = Resources(contentFolder: sharedResources.sharedResuorcesURL())
        let contentBlockerService = ContentBlockerService(resources: sdkResources, safariService: safariService, antibanner: antibanner, filtersStorage: filtersStorage)
        locator.addService(service: contentBlockerService)
        
        let httpRequestService: HttpRequestServiceProtocol = HttpRequestService()
        locator.addService(service: httpRequestService)
        
        let version = productInfo.version() ?? ""
        let lang = "\(ADLocales.lang() ?? "en")-\(ADLocales.region() ?? "US")"
        let id = Bundle.main.isPro ? "ios_pro" : "ios"
        let cid = UIDevice.current.identifierForVendor?.uuidString ?? ""

        let filtersService: FiltersServiceProtocol = FiltersService(resources: sdkResources, antibannerController: antibannerController, contentBlocker: contentBlockerService, httpRequestService: httpRequestService, filtersStorage: filtersStorage, version: version, id: id, cid: cid, lang: lang, protectionEnabled: sharedResources.safariProtectionEnabled, userFilterEnabled: sharedResources.safariUserFilterEnabled, whitelistEnabled: sharedResources.safariWhitelistEnabled, invertedWhitelist: sharedResources.invertedWhitelist)
        
        locator.addService(service: filtersService)
        
        let dnsFiltersService : DnsFiltersServiceProtocol = DnsFiltersService(resources: sharedResources, vpnManager: vpnManager, configuration: configuration, complexProtection: complexProtection)
        locator.addService(service: dnsFiltersService)
        
        let keyChainService: KeychainServiceProtocol = KeychainService(resources: sharedResources)
        locator.addService(service: keyChainService)
        
        let supportService: SupportServiceProtocol = SupportService(resources: sharedResources, configuration: configuration, complexProtection: complexProtection, dnsProviders: dnsProviders, networkSettings: networkSettingsService, dnsFilters: dnsFiltersService, productInfo: productInfo, antibanner: antibanner, requestsService: httpRequestService, keyChainService: keyChainService, safariService: safariService)
        locator.addService(service: supportService)

        let userNotificationService: UserNotificationServiceProtocol = UserNotificationService()
        locator.addService(service: userNotificationService)
        
        let dnsLogService: DnsLogRecordsServiceProtocol = DnsLogRecordsService(resources: sharedResources)
        locator.addService(service: dnsLogService)
        
        let dnsStatisticsService: DnsStatisticsServiceProtocol = DnsStatisticsService(resources: sharedResources)
        locator.addService(service: dnsStatisticsService)
        
        let activityStatisticsService: ActivityStatisticsServiceProtocol = ActivityStatisticsService(resources: sharedResources)
        locator.addService(service: activityStatisticsService)
        
        let dnsTrackerService: DnsTrackerServiceProtocol = DnsTrackerService()
        locator.addService(service: dnsTrackerService)
        
        let rateService: RateAppServiceProtocol = RateAppService(resources: sharedResources, configuration: configuration)
        locator.addService(service: rateService)
        
        let domainsParserService: DomainsParserServiceProtocol = DomainsParserService()
        locator.addService(service: domainsParserService)
        
        let migrationService: MigrationServiceProtocol = MigrationService(vpnManager: vpnManager, dnsProvidersService: dnsProviders, resources: sharedResources, antibanner: antibanner, dnsFiltersService: dnsFiltersService, networking: networkService, activityStatisticsService: activityStatisticsService, dnsStatisticsService: dnsStatisticsService, dnsLogService: dnsLogService, configuration: configuration, filtersService: filtersService, productInfo: productInfo, contentBlockerService: contentBlockerService, nativeProviders: nativeProviders, filtersStorage: filtersStorage, safariProtection: safariProtection)
        locator.addService(service: migrationService)
        
        let chartViewModel: ChartViewModelProtocol = ChartViewModel(dnsStatisticsService, resources: sharedResources)
        locator.addService(service: chartViewModel)
        
        let setappService: SetappServiceProtocol = SetappService(purchaseService: purchaseService, resources: sharedResources)
        locator.addService(service: setappService)
        
        let importSettings: ImportSettingsServiceProtocol = ImportSettingsService(antibanner: antibanner, networking: networkService, filtersService: filtersService, dnsFiltersService: dnsFiltersService, dnsProvidersService: dnsProviders, purchaseService: purchaseService, contentBlockerService: contentBlockerService, resources: sharedResources, safariProtection: safariProtection)
        locator.addService(service: importSettings)
        
        let webReporter: ActionWebReporterProtocol = ActionWebReporter(productInfo: productInfo, antibanner: antibanner, complexProtection: complexProtection, dnsProviders: dnsProviders, configuration: configuration, dnsFilters: dnsFiltersService)
        locator.addService(service: webReporter)
    }
}
