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
 ConfigurationService - the service is responsible for current application configuration
 */
class ConfigurationService : NSObject, ConfigurationServiceProtocol {
    
    @objc static let themeChangeNotification = "themeChangeNotification"
    
    // MARK: - private fields
    private var purchaseService : PurchaseServiceProtocol
    private var resources: AESharedResourcesProtocol
    private var safariProtection: SafariProtectionProtocol
    var notificationObserver: Any?
    
    // MARK: - init

    init(purchaseService : PurchaseServiceProtocol, resources: AESharedResourcesProtocol, safariProtection: SafariProtectionProtocol) {
        self.purchaseService = purchaseService
        self.resources = resources
        self.safariProtection = safariProtection
        super.init()
        
        notificationObserver = NotificationCenter.default.observe(name: Notification.Name(PurchaseService.kPurchaseServiceNotification),
                                                                      object: nil, queue: nil)
        {
            [weak self](notification) in
            guard let sSelf = self else { return }
            if notification.userInfo?[PurchaseService.kPSNotificationTypeKey] as! String == PurchaseService.kPSNotificationPremiumStatusChanged {
                                
                    sSelf.willChangeValue(for: \.proStatus)
                    sSelf.didChangeValue(for: \.proStatus)
                }
        }
    }
    
    // MARK: - puplic fields
    
    /**
     this flag indicates that pro fetures are purchased
    */
    @objc dynamic var proStatus : Bool {
        get {
            if Bundle.main.isPro {
                return true
            }
            else {
                return purchaseService.isProPurchased
            }
        }
    }
    
    @objc dynamic var purchasedThroughLogin: Bool {
        get {
            return purchaseService.purchasedThroughLogin
        }
    }
    
    /**
     this flag indicates that all safari content blockers are enabled in safari settings
     */
    dynamic var contentBlockerEnabled: [ContentBlockerType : Bool]?
    
    var allContentBlockersEnabled: Bool {
        return contentBlockerEnabled?.reduce(true, { (result, state) -> Bool in return result && state.value }) ?? true
    }
    
    /**
    this flag indicates that at least one safari content blocker is enabled in safari settings
    */
    var someContentBlockersEnabled: Bool {
        return contentBlockerEnabled?.values.contains(true) ?? false
    }
    
    /**
     dark or light theme of app UI
    */
    @objc dynamic var darkTheme: Bool {
        switch userThemeMode {
        case AESystemDefaultThemeMode:
            return systemAppearenceIsDark
        case AELightThemeMode:
            return false
        case AEDarkThemeMode:
            return true
        default:
            return false
        }
    }
    
    /**
     user theme mode of app UI
     */
    @objc dynamic var userThemeMode: AEThemeMode {
        set {
            resources.sharedDefaults().set(newValue.rawValue, forKey: AEDefaultsDarkTheme)
            NotificationCenter.default.post(name: Notification.Name(ConfigurationService.themeChangeNotification), object: self)
        }
        get {
            guard let themeMode = resources.sharedDefaults().object(forKey: AEDefaultsDarkTheme) as? UInt else {
                if #available(iOS 13.0, *){
                    return AESystemDefaultThemeMode
                } else {
                    return AELightThemeMode
                }
            }
            return AEThemeMode.init(themeMode)
        }
    }
    
    /**
     system appearence style
     */
    @objc dynamic var systemAppearenceIsDark: Bool {
        set {
            resources.sharedDefaults().set(newValue, forKey: AEDefaultsSystemAppearenceStyle)
            NotificationCenter.default.post(name: Notification.Name(ConfigurationService.themeChangeNotification), object: self)
        }
        get {
            return resources.sharedDefaults().bool(forKey: AEDefaultsSystemAppearenceStyle)
        }
    }
    
    /**
     Advanced mode state
     */
    @objc dynamic var advancedMode: Bool {
        set {
            resources.sharedDefaults().set(newValue, forKey: AEDefaultsDeveloperMode)
        }
        get {
            return resources.sharedDefaults().bool(forKey: AEDefaultsDeveloperMode)
        }
    }
    
    @objc dynamic var showStatusBar: Bool {
        get {
            let showStatusBar: Bool = resources.sharedDefaults().object(forKey: AEDefaultsShowStatusBar) as? Bool ?? true
            return showStatusBar && advancedMode
        }
        set{
            resources.sharedDefaults().set(newValue, forKey: AEDefaultsShowStatusBar)
        }
    }
    
    /**
     checks that all safari content blockers are enabled.
     you need observe @contentBlockerEnabled property to get the result
    */
    @objc func checkContentBlockerEnabled() {
        // todo: maybe it must be called on async queue
        self.contentBlockerEnabled = safariProtection.allContentBlockersStates
    }
}


