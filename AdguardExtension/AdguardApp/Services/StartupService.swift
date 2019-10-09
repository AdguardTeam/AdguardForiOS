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
        
        // init services
        
        let sharedResources: AESharedResourcesProtocol = APSharedResources()
        ServiceLocator.shared.addService(service: sharedResources)
        
        // Registering standard Defaults
        if  let path = Bundle.main.path(forResource: "defaults", ofType: "plist"),
            let defs = NSDictionary(contentsOfFile: path)  as? [String : Any] {
            sharedResources.sharedDefaults().register(defaults: defs)
        }
        
        let dnsTrackerService: DnsTrackerServiceProtocol = DnsTrackerService()
        ServiceLocator.shared.addService(service: dnsTrackerService)
        
        let networkService = ACNNetworking()
        ServiceLocator.shared.addService(service: networkService)
        
        let asDataBase = ASDatabase()
        ServiceLocator.shared.addService(service: asDataBase)
        
        let purchaseService = PurchaseService(network: networkService, resources: sharedResources)
        purchaseService.start()
        ServiceLocator.shared.addService(service: purchaseService)
        
        let safariService = SafariService(resources: sharedResources)
        ServiceLocator.shared.addService(service: safariService)
        
        let contentBlockerService = ContentBlockerService(resources: sharedResources, safariService: safariService)
        ServiceLocator.shared.addService(service: contentBlockerService)
        
        let aeService: AEServiceProtocol = AEService(contentBlocker: contentBlockerService,
                                                     resources: sharedResources,
                                                     networking: networkService, asDataBase: asDataBase)
        
        ServiceLocator.shared.addService(service: aeService)
        
        let configuration: ConfigurationService = ConfigurationService(purchaseService: purchaseService, resources: sharedResources, aeService: aeService, safariService: safariService)
        ServiceLocator.shared.addService(service: configuration)
        
        let themeService: ThemeServiceProtocol = ThemeService(configuration)
        ServiceLocator.shared.addService(service: themeService)
        
        let filtersService: FiltersServiceProtocol = FiltersService(antibanner: aeService.antibanner(), configuration: configuration, contentBlocker: contentBlockerService)
        aeService.onReady {
            filtersService.load(refresh: false) {}
        }
        ServiceLocator.shared.addService(service: filtersService)
        
        let vpnManager: APVPNManager = APVPNManager(resources: sharedResources, configuration: configuration)
        ServiceLocator.shared.addService(service: vpnManager)
        
        let supportService: AESSupport = AESSupport(resources: sharedResources, safariSevice: safariService, aeService: aeService)
        supportService.configurationService = configuration;
        
        ServiceLocator.shared.addService(service: supportService as AESSupportProtocol)

        let userNotificationService: UserNotificationServiceProtocol = UserNotificationService()
        ServiceLocator.shared.addService(service: userNotificationService)

    }
}
