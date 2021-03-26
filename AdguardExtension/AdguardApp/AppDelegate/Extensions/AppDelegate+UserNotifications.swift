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


// Handle UserNotificationService notifications
extension AppDelegate {
    func subscribeToUserNotificationServiceNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertNotification(notification:)), name: .showCommonAlert, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openDnsFiltersController(notification:)), name: .showDnsFiltersController, object: nil)
    }
    
    @objc private func showAlertNotification(notification: Notification) {
        let body = notification.userInfo?[UserNotificationService.notificationBody] as? String
        let title = notification.userInfo?[UserNotificationService.notificationTitle] as? String
        showCommonAlertForTopVc(body, title)
    }
    
    @objc private func openDnsFiltersController(notification: Notification) {
        let success = presentDnsFiltersController()
        DDLogInfo("Presented DnsFiltersController successfully = \(success ? "Yes" : "No")")
    }
    
    private func showCommonAlertForTopVc(_ body: String?, _ title: String?) {
        DispatchQueue.main.async {
            if let topVC = AppDelegate.topViewController() {
                ACSSystemUtils.showSimpleAlert(for: topVC, withTitle: body, message: title)
            }
        }
    }
}
