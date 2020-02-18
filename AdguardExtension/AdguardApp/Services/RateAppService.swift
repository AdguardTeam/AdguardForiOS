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

protocol RateAppServiceProtocol {
    
    /* shows rate dialog if it was not already showed before */
    func showRateDialogIfNeeded(_ controller: UIViewController)
    
    /* decides how to rate an app by stars number */
    func rateApp(_ starsCount: Int, _ fewStarsAction: ()->())
    
    /* shifts the deadline of showing rate dialog */
    func cancelTapped()
}

class RateAppService: RateAppServiceProtocol {
    
    private let reviewUrl = "https://itunes.apple.com/app/id1047223162?action=write-review"
    
    private let minTimeInterValToRate = { 2 * 24 * 3600 }() // 2 days
    
    private let resources: AESharedResourcesProtocol
    private let configuration: ConfigurationServiceProtocol
    
    init(resources: AESharedResourcesProtocol, configuration: ConfigurationServiceProtocol) {
        self.resources = resources
        self.configuration = configuration
        
        if (resources.sharedDefaults().object(forKey: AEDefaultsFirstLaunchDate) as? Date) == nil {
            resources.sharedDefaults().set(Date(), forKey: AEDefaultsFirstLaunchDate)
        }
    }
    
    func showRateDialogIfNeeded(_ controller: UIViewController) {
        guard let firstLaunchDate = resources.sharedDefaults().object(forKey: AEDefaultsFirstLaunchDate) as? Date else { return }
        if Int(Date().timeIntervalSince(firstLaunchDate)) < minTimeInterValToRate || !configuration.allContentBlockersEnabled { return }
        
        showAlert(controller)
    }
    
    func rateApp(_ starsCount: Int, _ fewStarsAction: ()->()){
        if starsCount > 3 {
            rateInAppStore()
        } else {
            fewStarsAction()
        }
    }
    
    func cancelTapped() {
        resources.sharedDefaults().set(Date(), forKey: AEDefaultsFirstLaunchDate)
    }
    
    /* opens appstore to write a review */
    private func rateInAppStore() {
        guard let writeReviewURL = URL(string: reviewUrl) else { return }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
    private func showAlert(_ controller: UIViewController) {
        let rateAppViewController = RateAppController(nibName: "RateAppController", bundle: nil)
        rateAppViewController.modalPresentationStyle = .overCurrentContext
        rateAppViewController.modalTransitionStyle = .coverVertical
        controller.present(rateAppViewController, animated: true, completion: nil)
    }
}
