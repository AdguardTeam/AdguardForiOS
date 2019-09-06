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

class TrialController: UIViewController {
    
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var trialDescriptionLabel: UILabel!
    @IBOutlet weak var tryButton: RoundRectButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    let purchaseService: PurchaseService = ServiceLocator.shared.getService()!
    
    private let mobileImage = UIImage(named: "trial-mobile") ?? UIImage()
    private let ipadImage = UIImage(named: "trial-ipad") ?? UIImage()
    private let ipadLandScape = UIImage(named: "trial-ipad-landscape") ?? UIImage()
    
    private var reach = Reachability.forInternetConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkConnection()
        addObservers()
        displayProduct()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isTranslucent = true
        guard let nav = self.navigationController as? MainNavigationController else { return }
        nav.customStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.navigationBar.isTranslucent = false
        guard let nav = self.navigationController as? MainNavigationController else { return }
        nav.customStatusBarStyle = nil
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        backgroundImageView.image = getBackgroundImage()
    }
    
    override func viewWillLayoutSubviews() {
        initialSetups()
    }
    
    // MARK: - Private methods
    
    private func getBackgroundImage() -> UIImage {
        if UIDevice.current.userInterfaceIdiom == .phone || traitCollection.horizontalSizeClass == .compact{
            return mobileImage
        } else {
            return UIDevice.current.orientation.isLandscape ? ipadLandScape : ipadImage
        }
    }
    
    private func initialSetups(){
        backgroundImageView.image = getBackgroundImage()
        
        if traitCollection.horizontalSizeClass == .regular  {
            trialLabel.font = trialLabel.font.withSize(48.0)
            trialDescriptionLabel.font = trialDescriptionLabel.font.withSize(24.0)
            tryButton.layer.cornerRadius = 30.0
            tryButton.titleLabel?.font = tryButton.titleLabel?.font.withSize(22.0)
            loginButton.titleLabel?.font = loginButton.titleLabel?.font.withSize(22.0)
        } else {
            trialLabel.font = trialLabel.font.withSize(32.0)
            trialDescriptionLabel.font = trialDescriptionLabel.font.withSize(15.0)
            tryButton.layer.cornerRadius = 20.0
            tryButton.titleLabel?.font = tryButton.titleLabel?.font.withSize(17.0)
            loginButton.titleLabel?.font = loginButton.titleLabel?.font.withSize(14.0)
        }
    }
    
    private func getTrialString(period: Period) -> String {
        var formatString : String = ""
        
        switch period.unit {
        case .day:
            formatString = ACLocalizedString("trial_screen_days", nil)
        case .week:
            if period.numberOfUnits == 1 {
                formatString = ACLocalizedString("trial_screen_days", nil)
                return String.localizedStringWithFormat(formatString, 7)
            }
            formatString = ACLocalizedString("trial_screen_weeks", nil)
        case .month:
            formatString = ACLocalizedString("trial_screen_months", nil)
        case .year:
            formatString = ACLocalizedString("trial_screen_years", nil)
        }
        
        let resultString : String = String.localizedStringWithFormat(formatString, period.numberOfUnits)
        
        return resultString
    }
    
    private func checkConnection(){
        guard let reachable = reach?.isReachable() else { return }
        let products = purchaseService.products
        
        if !products.isEmpty {
            tryButton.isEnabled = true
            displayProduct()
        } else if products.isEmpty && !reachable {
            tryButton.isEnabled = false
            showAlert()
        }
        else {
            tryButton.isEnabled = false
        }
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: ACLocalizedString("no_internet", nil), message: ACLocalizedString("no_internet_message", nil), preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: ACLocalizedString("common_action_ok", nil), style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))

        self.present(alert, animated: true)
    }
    
    private func displayProduct(){
        DispatchQueue.main.async {[weak self] in
            let products = self?.purchaseService.products
            for product in products ?? [] {
                if product.type == .subscription && product.trialPeriod != nil {
                    self?.tryButton.isEnabled = true
                    self?.trialLabel.text = self?.getTrialString(period: product.trialPeriod!)
                    break
                }
            }
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name( PurchaseService.kPurchaseServiceNotification), object: nil, queue: nil) {[weak self] (notification) in
            guard let sSelf = self else { return }
            sSelf.displayProduct()
        }
    }
}
