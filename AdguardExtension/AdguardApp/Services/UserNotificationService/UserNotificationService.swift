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

import Foundation
import UserNotifications

// Must support NSSecureCoding thus it is Int
enum PushNotificationCommands: Int {
    typealias RawValue = Int

    static let command: String = "command"

    case openDnsFiltersController = 0
}

protocol UserNotificationServiceProtocol {

    func requestPermissions(_ completion: @escaping (_ permissionGranted: Bool) -> Void)

    /*
     Method to post notifications which come while app is in background
     **/
    func postNotification(title: String, body: String, userInfo: [AnyHashable: Any]?)

    /**
     Posts notification without badge (red circle in the top right corner of app icon)
     */
    func postNotificationWithoutBadge(title: String?, body: String?, onNotificationSent: @escaping () -> Void)

    /*
     Method to post notifications which come while app is in foreground
     **/
    func postNotificationInForeground(body: String, title: String)
}

class UserNotificationService: NSObject, UserNotificationServiceProtocol, UNUserNotificationCenterDelegate {

    @objc static let notificationBody = "notificationBody"
    @objc static let notificationTitle = "notificationTitle"

    /// Requests user permission to send push notification
    ///
    /// - Parameter completion: returns permission status. Warning: called on UNUserNotificationServiceConnection queue
    func requestPermissions(_ completion: @escaping (_ permisdsionGranted: Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { permission, _ in
            completion(permission)
        }
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

    func postNotificationWithoutBadge(title: String?, body: String?, onNotificationSent: @escaping () -> Void) {
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { [weak self] settings in
            if settings.authorizationStatus != .authorized {
                onNotificationSent()
                return
            }

            if settings.alertSetting == .enabled {
                self?.alertNotification(title: title, body: body, badge: nil, userInfo: nil)
            }
            onNotificationSent()
        }
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

        if command == PushNotificationCommands.openDnsFiltersController.rawValue {
            NotificationCenter.default.post(name: NSNotification.Name.showDnsFiltersController, object: nil, userInfo: nil)
            completionHandler()
            return
        }

        completionHandler()
    }

//    func postLocalNotificationInBackgroundForRemoteMigration() {
//        guard UIApplication.shared.applicationState == .background else {
//            DDLogDebug("(UserNotificationService) - App is not in background. Do not post remote migration local push notification")
//            return
//        }
//
//        let title = "TITLE"
//        let description = "DESCRIPTION"
//
//        DDLogDebug("(UserNotificationService) - Start posting remote migration local push notification")
//        postNotification(title: title, body: description, userInfo: nil)
//    }

    // MARK: - private methods

    private func alertNotification(title: String?, body: String?, badge: NSNumber? = 1, userInfo: [AnyHashable : Any]?) {
        let content = UNMutableNotificationContent()

        content.title = title ?? ""
        content.body = body ?? ""
        content.userInfo = userInfo ?? [:]

        content.badge = badge

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.add(request) { (error) in
            if let error = error {
                DDLogError("(UserNotificationService) - alertNotification error : \(error)")
            }
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
