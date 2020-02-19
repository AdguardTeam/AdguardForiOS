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
import StoreKit

@objc protocol RateAppServiceProtocol {
    
    /* shows rate dialog if it was not already showed before */
    func showRateDialogIfNeeded(showAlert: ()->())
    
    /* decides how to rate an app by stars number */
    func rateApp(_ starsCount: Int, _ fewStarsAction: ()->())
    
    /* shifts the deadline of showing rate dialog by 7 days */
    func cancelTapped()
    
    /* shows push notification if the app is in the background */
    func showRateNotificationIfNeeded()
}

class RateAppService: RateAppServiceProtocol {
    
    private let reviewUrl = "https://itunes.apple.com/app/id1047223162?action=write-review"
    
    private var minTimeIntervalToRate: Int  {
        if let time = resources.sharedDefaults().value(forKey: MinTimeIntervalToRate) as? Int {
            return time
        } else {
            return 24 * 3600 // 1 day
        }
    }
    
    private let resources: AESharedResourcesProtocol
    private let configuration: ConfigurationServiceProtocol
    private let userNotificationService: UserNotificationServiceProtocol
    
    init(resources: AESharedResourcesProtocol, configuration: ConfigurationServiceProtocol, userNotificationService: UserNotificationServiceProtocol) {
        self.resources = resources
        self.configuration = configuration
        self.userNotificationService = userNotificationService
        
        if (resources.sharedDefaults().object(forKey: AEDefaultsFirstLaunchDate) as? Date) == nil {
            resources.sharedDefaults().set(Date(), forKey: AEDefaultsFirstLaunchDate)
        }
    }
    
    func showRateDialogIfNeeded(showAlert: ()->()) {
//        guard let firstLaunchDate = resources.sharedDefaults().object(forKey: AEDefaultsFirstLaunchDate) as? Date else { return }
//        if Int(Date().timeIntervalSince(firstLaunchDate)) < minTimeIntervalToRate || !configuration.allContentBlockersEnabled { return }
//        if configuration.appRated { return }
        
        showAlert()
    }
    
    func showRateNotificationIfNeeded() {
//        guard let firstLaunchDate = resources.sharedDefaults().object(forKey: AEDefaultsFirstLaunchDate) as? Date else { return }
//        if Int(Date().timeIntervalSince(firstLaunchDate)) < minTimeIntervalToRate || !configuration.allContentBlockersEnabled { return }
//        if configuration.appRated { return }
        
        let title = String.localizedString("rate_notification_title")
        let body = String.localizedString("rate_notification_message")
        let userInfo: [String : Int] = [PushNotificationCommands.command : PushNotificationCommands.openRateAppDialogController.rawValue]
        userNotificationService.postNotification(title: title, body: body, userInfo: userInfo)
    }
    
    func rateApp(_ starsCount: Int, _ fewStarsAction: ()->()){
        if starsCount > 3 {
            rateInAppStore()
        } else {
            fewStarsAction()
        }
    }
    
    func cancelTapped() {
        let week = 3600 * 7 // 7 days
        resources.sharedDefaults().set(Date(), forKey: AEDefaultsFirstLaunchDate)
        resources.sharedDefaults().set(week, forKey: MinTimeIntervalToRate)
    }
    
    /* opens appstore to write a review */
    private func rateInAppStore() {
        guard let writeReviewURL = URL(string: reviewUrl) else { return }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        configuration.appRated = true
    }
}

extension Notification.Name {
    static let showCommonAlert = Notification.Name("showCommonAlert")
    static let openRateAppDialogController = Notification.Name("openRateAppDialogController")
}

@objc extension NSNotification {
    public static let showCommonAlert = Notification.Name.showCommonAlert
    public static let openRateAppDialogController = Notification.Name.openRateAppDialogController
}
