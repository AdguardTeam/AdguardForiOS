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
        
        let purchaseService:PurchaseServiceProtocol = PurchaseService(network: networkService, resources: sharedResources)
        purchaseService.start()
        locator.addService(service: purchaseService)
        
        let safariService = SafariService(resources: sharedResources)
        locator.addService(service: safariService)
    
        let configuration: ConfigurationService = ConfigurationService(purchaseService: purchaseService, resources: sharedResources, safariService: safariService)
        locator.addService(service: configuration)
        
        let dnsProviders: DnsProvidersService = DnsProvidersService(resources: sharedResources)
        locator.addService(service: dnsProviders)
        
        let networkSettingsService: NetworkSettingsServiceProtocol = NetworkSettingsService(resources: sharedResources)
        ServiceLocator.shared.addService(service: networkSettingsService)
        
        let vpnManager: VpnManager = VpnManager(resources: sharedResources, configuration: configuration, networkSettings: networkSettingsService, dnsProviders: dnsProviders)

        locator.addService(service: vpnManager as VpnManagerProtocol)
        
        let safariProtection =  SafariProtectionService(resources: sharedResources)
        locator.addService(service: safariProtection)
        
        let complexProtection: ComplexProtectionServiceProtocol = ComplexProtectionService(resources: sharedResources, safariService: safariService, configuration: configuration, vpnManager: vpnManager, safariProtection: safariProtection)
        locator.addService(service: complexProtection)
        
        vpnManager.complexProtection = complexProtection
        vpnManager.checkVpnInstalled { _ in }
        
        let themeService: ThemeServiceProtocol = ThemeService(configuration)
        locator.addService(service: themeService)
        
        let antibanner: AESAntibannerProtocol = AESAntibanner(networking: networkService, resources: sharedResources)
        locator.addService(service: antibanner)
        
        let antibannerController: AntibannerControllerProtocol = AntibannerController(antibanner: antibanner, resources: sharedResources)
        locator.addService(service: antibannerController)
        
        let contentBlockerService = ContentBlockerService(resources: sharedResources, safariService: safariService, antibanner: antibanner, safariProtection: safariProtection)
        locator.addService(service: contentBlockerService)
        
        let filtersService: FiltersServiceProtocol = FiltersService(antibannerController: antibannerController, configuration: configuration, contentBlocker: contentBlockerService)
        
        locator.addService(service: filtersService)
        
        let dnsFiltersService : DnsFiltersServiceProtocol = DnsFiltersService(resources: sharedResources, vpnManager: vpnManager, configuration: configuration, complexProtection: complexProtection)
        locator.addService(service: dnsFiltersService)
        
        let supportService: AESSupport = AESSupport(resources: sharedResources, safariSevice: safariService, antibanner: antibanner, dnsFiltersService: dnsFiltersService)
        
        supportService.configurationService = configuration;
        
        locator.addService(service: supportService as AESSupportProtocol)

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
        
        let rateService: RateAppServiceProtocol = RateAppService(resources: sharedResources)
        locator.addService(service: rateService)
        
        let httpRequestService: HttpRequestServiceProtocol = HttpRequestService()
        locator.addService(service: httpRequestService)
        
        let keyChainService: KeychainServiceProtocol = KeychainService(resources: sharedResources)
        locator.addService(service: keyChainService)
    }
}
