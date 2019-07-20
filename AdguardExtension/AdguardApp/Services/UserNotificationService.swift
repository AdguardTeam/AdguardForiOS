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
import UserNotifications

protocol UserNotificationServiceProtocol {

    func requestPermissions()
    func postNotification(title: String, body: String)
    func removeNotifications()
}

class UserNotificationService: UserNotificationServiceProtocol {
    
    func requestPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
        }
    }
    
    func postNotification(title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { [weak self] (settings) in
            
            if settings.authorizationStatus != .authorized {
                return
            }
            
            if settings.alertSetting == .enabled {
                self?.alertNotification(title: title, body: body)
            }
            else {
                self?.badgeAndSound()
            }
        }
    }
    
    // MARK: - private methods
    
    private func alertNotification(title: String?, body: String?) {
        let content = UNMutableNotificationContent()
        
        if body != nil && title != nil {
            content.title = title!
            content.body = body!
        }
        
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { (error) in
            if error != nil { DDLogError("(UserNotificationService) - alertNotification error : \(error!)") }
        }
    }
    
    private func badgeAndSound() {
        alertNotification(title: nil, body: nil)
    }
    
    func removeNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
    }
}
