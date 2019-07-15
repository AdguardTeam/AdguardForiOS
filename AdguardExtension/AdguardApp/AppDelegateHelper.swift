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

/**
 AppDelegateHelper is a helper class for AppDelegate
 all new functions we must write in this swift class instead of old obj-c AppDelegate
 */

@objcMembers
class AppDelegateHelper: NSObject {
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // request permission for user notifications posting
        let userNotificationService: UserNotificationServiceProtocol = ServiceLocator.shared.getService()!
        userNotificationService.requestPermissions()
        
        // obseve NotificationCenter notifications
        NotificationCenter.default.addObserver(forName: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: nil, queue: nil) { (notification) in
            
            guard let type =  notification.userInfo?[PurchaseService.kPSNotificationTypeKey] as? String else { return }
            
            if type == PurchaseService.kPSNotificationPremiumExpired {
                userNotificationService.postNotification(title: ACLocalizedString("premium_expired_title", nil), body: ACLocalizedString("premium_expired_message", nil))
            }
        }
        
        return true;
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}
