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
    var rateAppAlertNeedsShowing: Bool { get }
    
    /* decides how to rate an app by stars number */
    func rateApp(_ starsCount: Int, _ fewStarsAction: ()->())
    
    /* shifts the deadline of showing rate dialog by 7 days */
    func cancelTapped()
    
    /* shows push notification if the app is in the background */
    func showRateNotificationIfNeeded()
}

class RateAppService: RateAppServiceProtocol {
    
    var rateAppAlertNeedsShowing: Bool {
        get {
            guard let firstLaunchDate = resources.firstLaunchDate else { return false }
            if Int(date.currentDate.timeIntervalSince(firstLaunchDate)) < resources.minTimeIntervalToRate || !configuration.allContentBlockersEnabled { return false }
            if configuration.appRated { return false }
            return true
        }
    }
    
    private let reviewUrl = "https://itunes.apple.com/app/id1047223162?action=write-review"
    
    private let resources: AESharedResourcesProtocol
    private let configuration: ConfigurationServiceProtocol
    private let userNotificationService: UserNotificationServiceProtocol
    private let date: TestableDateProtocol
    
    init(resources: AESharedResourcesProtocol, configuration: ConfigurationServiceProtocol, userNotificationService: UserNotificationServiceProtocol, _ date: TestableDateProtocol = Date()) {
        self.resources = resources
        self.configuration = configuration
        self.userNotificationService = userNotificationService
        self.date = date
        
        if resources.firstLaunchDate == nil {
            resources.firstLaunchDate = date.currentDate
        }
    }

    func showRateNotificationIfNeeded() {
        if !rateAppAlertNeedsShowing { return }
        
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
        /*
         If cancelled was already tapped and user types it second time
         we do not disturb him anymore and just return
         */
        if resources.cancelTappedWhenAppRating != nil {
            return
        }
        /*
        If cancelled was initially tapped we shift next
        rate app appearence for 1 week
        */
        else {
            guard let firstLaunchDate = resources.firstLaunchDate else { return }
            let firstLaunch = firstLaunchDate.timeIntervalSinceReferenceDate
            let now = date.currentDate.timeIntervalSinceReferenceDate
            let week: Double = 3600.0 * 7.0 // 7 days
            let newTimeInterval = now - firstLaunch + week
            
            resources.minTimeIntervalToRate = Int(newTimeInterval)
            resources.cancelTappedWhenAppRating = true
        }
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
