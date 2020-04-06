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

// Must support NSSecureCoding thus it is Int
enum PushNotificationCommands: Int {
    typealias RawValue = Int
    
    static let command: String = "command"
    
    case openopenDnsFiltersController = 0
}

protocol UserNotificationServiceProtocol {

    func requestPermissions()
    
    /*
     Method to post notifications which come while app is in background
     **/
    func postNotification(title: String, body: String, userInfo: [AnyHashable : Any]?)
    func removeNotifications()
    
    /*
     Method to post notifications which come while app is in foreground
     **/
    func postNotificationInForeground(body: String, title: String)
}

class UserNotificationService: NSObject, UserNotificationServiceProtocol, UNUserNotificationCenterDelegate {
    
    @objc static let notificationBody = "notificationBody"
    @objc static let notificationTitle = "notificationTitle"
    
    func requestPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func postNotification(title: String, body: String, userInfo: [AnyHashable : Any]? = nil) {
        let center = UNUserNotificationCenter.current()
    
        center.getNotificationSettings { [weak self] (settings) in
            
            if settings.authorizationStatus != .authorized {
                return
            }
            
            if settings.alertSetting == .enabled {
                self?.alertNotification(title: title, body: body, userInfo: userInfo)
            }
            else {
                self?.badgeAndSound()
            }
        }
    }
    
    func removeNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
    }
    
    func postNotificationInForeground(body: String, title: String) {
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings {[weak self] (settings) in
            if settings.authorizationStatus == .authorized && settings.alertSetting == .enabled {
                self?.alertNotification(title: title, body: body, userInfo: nil)
            } else {
                let userInfo = [UserNotificationService.notificationBody : body,
                                UserNotificationService.notificationTitle : title]
                NotificationCenter.default.post(name: .showCommonAlert, object: nil, userInfo: userInfo)
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate methods
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let command = userInfo[PushNotificationCommands.command] as? Int else {
            completionHandler()
            return
        }
        
        if command == PushNotificationCommands.openopenDnsFiltersController.rawValue {
            NotificationCenter.default.post(name: NSNotification.Name.showDnsFiltersController, object: nil, userInfo: nil)
            completionHandler()
            return
        }
        
        completionHandler()
    }
    
    // MARK: - private methods
    
    private func alertNotification(title: String?, body: String?, userInfo: [AnyHashable : Any]?) {
        let content = UNMutableNotificationContent()
        
        content.title = title ?? ""
        content.body = body ?? ""
        content.userInfo = userInfo ?? [:]
        
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.add(request) { (error) in
            if error != nil { DDLogError("(UserNotificationService) - alertNotification error : \(error!)") }
        }
    }
    
    private func badgeAndSound() {
        alertNotification(title: nil, body: nil, userInfo: nil)
    }
}

extension Notification.Name {
    static let showCommonAlert = Notification.Name("showCommonAlert")
    static let showDnsFiltersController = Notification.Name("showDnsFiltersController")
}

@objc extension NSNotification {
    public static let showCommonAlert = Notification.Name.showCommonAlert
    public static let showDnsFiltersController = Notification.Name.showDnsFiltersController
}
