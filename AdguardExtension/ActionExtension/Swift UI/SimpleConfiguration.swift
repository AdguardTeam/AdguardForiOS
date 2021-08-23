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

class SimpleConfigurationSwift: NSObject, ConfigurationServiceProtocol{
    
    var advancedMode: Bool = false
    
    var showStatusBar: Bool = false
    
    var appRated: Bool = false
    
    var userThemeMode: ThemeMode {
        get {
            guard let themeMode = resources.sharedDefaults().object(forKey: AEDefaultsDarkTheme) as? Int else {
                if #available(iOS 13.0, *) {
                    return .systemDefault
                } else {
                    return .light
                }
            }
            return ThemeMode(rawValue: themeMode) ?? .light
        }
        set {
            
        }
    }
    
    var systemAppearenceIsDark: Bool = false
    
    var resources: AESharedResourcesProtocol!
    var purchaseService: PurchaseServiceProtocol?
    
    var darkTheme: Bool {
        switch userThemeMode {
        case .systemDefault: return systemAppearenceIsDark
        case .light: return false
        case .dark: return true
        }
    }
    
    var proStatus: Bool {
        return purchaseService?.isProPurchased ?? false
    }
    
    var purchasedThroughLogin: Bool {
        return false
    }
    
    @objc init(withResources resources: AESharedResourcesProtocol, systemAppearenceIsDark: Bool) {
        super.init()
        initialize(withResources: resources, systemAppearenceIsDark: systemAppearenceIsDark, purchaseService: nil)
    }
    
    init(withResources resources: AESharedResourcesProtocol, systemAppearenceIsDark: Bool, purchaseService: PurchaseServiceProtocol?) {
        super.init()
        initialize(withResources: resources, systemAppearenceIsDark: systemAppearenceIsDark, purchaseService: purchaseService)
    }
    
    func initialize(withResources resources: AESharedResourcesProtocol, systemAppearenceIsDark: Bool, purchaseService: PurchaseServiceProtocol?) {
        self.resources = resources
        self.systemAppearenceIsDark = systemAppearenceIsDark
        self.purchaseService = purchaseService
    }
    
    var allContentBlockersEnabled: Bool = true
    
    var someContentBlockersEnabled: Bool = true
    
    func checkContentBlockerEnabled() {
        
    }
}
