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

import UIKit

class GetProPageController: UIViewController {
    
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var tryButton: UIButton!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
    
    private var themeNotificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityImage.image = UIImage(named: "other-group-icon")
        
        let product = purchaseService.standardProduct
    
        titleLabel.text = getTitleString(product: product).uppercased()
    
        tryButton.accessibilityLabel = String.localizedString("try_for_free")
        
        updateTheme()
        
        themeNotificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tryButton.layer.cornerRadius = tryButton.frame.height / 2
    }
    
    private func getTitleString(product: Product?) -> String {
        
        let period = product?.trialPeriod?.unit ?? .week
        let numberOfUnits = product?.trialPeriod?.numberOfUnits ?? 1
        
        var formatString : String = ""
        
        switch period {
        case .day:
            formatString = ACLocalizedString("getPro_full_access_days", nil)
        case .week:
            if numberOfUnits == 1 {
                formatString = ACLocalizedString("getPro_full_access_days", nil)
                return String.localizedStringWithFormat(formatString, 7)
            }
            formatString = ACLocalizedString("getPro_full_access_weeks", nil)
        case .month:
            formatString = ACLocalizedString("getPro_full_access_months", nil)
        case .year:
            formatString = ACLocalizedString("getPro_full_access_years", nil)
        }
        
        let resultString : String = String.localizedStringWithFormat(formatString, numberOfUnits)
        
        return resultString
    }
    
    private func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
    }
}
