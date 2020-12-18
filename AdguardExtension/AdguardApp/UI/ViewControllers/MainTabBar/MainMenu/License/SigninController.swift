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

class SigninController: UIViewController {
    
    @IBOutlet var buttons: [LeftAlignedIconButton]!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let notificationService: UserNotificationServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    
    private var notificationToken: NotificationToken?
    private var notificationObserver: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        notificationObserver = NotificationCenter.default.addObserver(forName: Notification.Name(PurchaseService.kPurchaseServiceNotification),
                                                                      object: nil, queue: .main)
        { [weak self](notification) in
            if let info = notification.userInfo {
                self?.processNotification(info: info)
            }
        }
        
        setupBackButton()
        updateTheme()
    }
    
    
    // MARK: - Actions
    
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        makeLogin(with: .apple)
        
    }
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        makeLogin(with: .google)
        
    }
    
    @IBAction func facebookLoginButtonTapped(_ sender: UIButton) {
        makeLogin(with: .facebook)
    }
    
    // MARK: - Private methods
    
    private func prepareButtons() {
        buttons.forEach { $0.applySigninButtonStyle(color: theme.lightGrayTextColor.cgColor ) }
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        prepareButtons()
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupButtons(buttons)
        theme.setupButtonsImage(buttons)
        theme.setupLabels(themableLabels)
    }
    
    private func makeLogin(with socialProvider: SocialProvider) {
        let state = UUID().uuidString
        resources.sharedDefaults().setValue(state, forKey: AEDefaultsAuthStateString)
        SigninHelper.openBrowser(with: socialProvider, state: state)
    }
    
    private func processNotification(info: [AnyHashable: Any]) {
        
        // skip notification if this controler is not placed on top of navigation stack
        if self.navigationController?.viewControllers.last != self {
            return
        }
        
        let type = info[PurchaseService.kPSNotificationTypeKey] as? String
        let error = info[PurchaseService.kPSNotificationErrorKey] as? NSError
        
        switch type {
        
        case PurchaseService.kPSNotificationLoginSuccess:
            self.loginSuccess()
        case PurchaseService.kPSNotificationLoginFailure:
            self.loginFailure(error)
        case PurchaseService.kPSNotificationLoginPremiumExpired:
            self.premiumExpired()
        case PurchaseService.kPSNotificationLoginNotPremiumAccount:
            self.notPremium()
            
        default:
            break
        }
    }
    
    private func loginSuccess() {
        let body = ACLocalizedString("login_success_message", nil)
        navigationController?.popViewController(animated: true)
        notificationService.postNotificationInForeground(body: body, title: "")
    }
    
    private func loginFailure(_ error: NSError?) {
        
        if error == nil || error!.domain != LoginService.loginErrorDomain {
            // unknown error
            let errorDescription = error?.localizedDescription ?? "nil"
            DDLogError("(LoginController) processLoginResponse - unknown error: \(errorDescription)")
            let message = ACLocalizedString("login_error_message", nil)
            
            notificationService.postNotificationInForeground(body: message, title: "")
            return
        }
        
        // errors we show in alert dialog
        var alertMessage: String?
        
        switch error!.code {
        
        case LoginService.loginBadCredentials:
            alertMessage = ACLocalizedString("bad_credentials_error", nil)
        case LoginService.accountIsDisabled:
            alertMessage = ACLocalizedString("account_is_disabled_error", nil)
        case LoginService.accountIsLocked:
            alertMessage = ACLocalizedString("account_is_locked_error", nil)
        case LoginService.loginMaxComputersExceeded:
            alertMessage = ACLocalizedString("login_max_computers_exceeded", nil)
        case LoginService.loginError:
            alertMessage = ACLocalizedString("login_error_message", nil)
        default:
            alertMessage = ACLocalizedString("login_error_message", nil)
        }
        
        if alertMessage != nil {
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: alertMessage, completion: nil)
        }
    }
    
    private func premiumExpired() {
        let body = ACLocalizedString("login_premium_expired_message", nil)
        notificationService.postNotificationInForeground(body: body, title: "")
    }
    
    private func notPremium() {
        let body = ACLocalizedString("not_premium_message", nil)
        notificationService.postNotificationInForeground(body: body, title: "")
    }
}
