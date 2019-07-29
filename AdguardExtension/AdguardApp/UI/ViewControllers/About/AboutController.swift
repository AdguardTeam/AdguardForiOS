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
import SafariServices

class AboutController : UIViewController, UIViewControllerTransitioningDelegate, LoginControllerDelegate {
    
    let otherPlatformsAction = "http://agrd.io/ios_adguard_products"
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var logoImage: ThemeableImageView!
    @IBOutlet var loginButton: UIBarButtonItem!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseService = ServiceLocator.shared.getService()!
    
    private var notificationObserver: Any?
    var canShowAlert = false
    var showAlertBlock: (()->Void)?
    
    // UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLabel.text = ADProductInfo.versionWithBuildNumber()
        
        notificationObserver = NotificationCenter.default.addObserver(forName: Notification.Name(PurchaseService.kPurchaseServiceNotification),
                                                                      object: nil, queue: nil)
        { [weak self](notification) in
            
            DispatchQueue.main.async {
                if let info = notification.userInfo {
                    self?.processNotification(info: info)
                    self?.updateViews()
                    self?.updateTheme()
                }
            }
        }
        
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    // MARK: - Actions
    
    
    @IBAction func otherPlatformsAction(_ sender: Any) {
        if let url = URL(string : otherPlatformsAction) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func login(_ sender: Any) {
        showLoginDialog()
    }
    
    // MARK: - Presentation delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    // MARK: - LoginControllerDelegate methods
    
    func loginAction(name: String) {
        webAuthWithName(name: name)
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupLabels(themableLabels)
        theme.setupImage(logoImage)
    }
    
    private func showLoginDialog() {
        let storyboard = UIStoryboard(name: "GetPro", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "LoginController") as? LoginController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    private func webAuthWithName(name: String){
        
        DDLogInfo("(GetProController) - webAuth")
        guard let url = purchaseService.authUrlWithName(name: name) else { return }
        let safariController = SFSafariViewController(url: url)
        present(safariController, animated: true, completion: nil)
        canShowAlert = false
    }
    
    private func processNotification(info: [AnyHashable: Any]) {
        
        DispatchQueue.main.async { [weak self] in
            let type = info[PurchaseService.kPSNotificationTypeKey] as? String
            let error = info[PurchaseService.kPSNotificationErrorKey] as? NSError
            
            switch type {
            case PurchaseService.kPSNotificationLoginSuccess:
                self?.loginSuccess()
            case PurchaseService.kPSNotificationLoginFailure:
                self?.loginFailure(error: error)
            case PurchaseService.kPSNotificationLoginPremiumExpired:
                self?.premiumExpired()
            case PurchaseService.kPSNotificationLoginNotPremiumAccount:
                self?.notPremium()
                
            case PurchaseService.kPSNotificationOauthSucceeded:
                self?.authSucceeded()
                
            default:
                break
            }
        }
    }
    
    private func loginSuccess(){
        loginCompleteWithMessage(message: ACLocalizedString("login_success_message", nil))
    }
    
    private func loginFailure(error: NSError?) {
        loginCompleteWithMessage(message: ACLocalizedString("login_error_message", nil))
    }
    
    private func premiumExpired() {
        loginCompleteWithMessage(message: ACLocalizedString("login_premium_expired_message", nil))
    }
    
    private func notPremium() {
        loginCompleteWithMessage(message: ACLocalizedString("not_premium_message", nil))
    }
    
    private func loginCompleteWithMessage(message: String) {
        
        showAlertBlock = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.removeLoading() {
                ACSSystemUtils.showSimpleAlert(for: sSelf, withTitle: nil, message: message)
            }
        }
        
        showAlertIfPossible()
    }
    
    func authSucceeded() {
        if self.presentedViewController != nil {
            
            self.presentedViewController?.dismiss(animated: true) { [weak self] in
                guard let sSelf = self else { return }
                sSelf.canShowAlert = true
                sSelf.showAlertIfPossible()
            }
        }
    }
    
    private func showAlertIfPossible() {
        if canShowAlert && showAlertBlock != nil {
            showAlertBlock!()
            showAlertBlock = nil
        }
    }
    
    private func updateViews() {
        let loggedIn = purchaseService.isProPurchased && purchaseService.purchasedThroughLogin
        self.navigationItem.rightBarButtonItem = loggedIn ? nil : loginButton
    }
}
