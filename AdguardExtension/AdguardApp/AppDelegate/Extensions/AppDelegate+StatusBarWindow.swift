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

//Notification onbservers for managing statusBarWindow
extension AppDelegate {
    func initStatusBarNotifications(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        statusBarWindow.createStatusBarWindow()
        statusBarWindow.statusBarWindowIsHidden = true
        
        showStatusBarNotification = NotificationCenter.default.observe(name: .ShowStatusView, object: nil, queue: nil, using: { [weak self] (notification) in
            guard let self = self else { return }
            self.statusBarWindow.showStatusViewIfNeeded(notification: notification)
        })
        
        hideStatusBarNotification = NotificationCenter.default.observe(name: .HideStatusView, object: nil, queue: nil, using: { [weak self] (notification) in
            guard let self = self else { return }
            self.statusBarWindow.hideStatusViewIfNeeded()
        })
        
        orientationChangeNotification = NotificationCenter.default.observe(name: UIDevice.orientationDidChangeNotification, object: nil, queue: nil, using: { [weak self] (notification) in
            self?.statusBarWindow.changeOrientation()
        })
    }
}
