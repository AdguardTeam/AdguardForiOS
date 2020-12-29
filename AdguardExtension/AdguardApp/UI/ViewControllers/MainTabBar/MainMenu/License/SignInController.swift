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
import SafariServices

class SignInController: UIViewController, SignInResultProcessor {
    
    @IBOutlet var buttons: [LeftAlignedIconButton]!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let notificationService: UserNotificationServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
    
    
    private var notificationThemeObserver: NotificationToken?
    private var notificationSignInObserver: NotificationToken?
    
    private var sfSafariViewController: SFSafariViewController?
    
    private var signInFailureHandler: SignInFailureHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInFailureHandler = SignInFailureHandler(notificationService: notificationService)
        
        notificationThemeObserver = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        notificationSignInObserver = NotificationCenter.default.observe(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: nil, queue: .main) { [weak self] notification in
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
        buttons.forEach { $0.applyRoundRectStyle(color: theme.lightGrayTextColor.cgColor ) }
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
        guard let url = purchaseService.generateAuthURL(state: state, socialProvider: socialProvider) else { return }
        sfSafariViewController = SFSafariViewController(url: url)
        present(sfSafariViewController!, animated: true, completion: nil)
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
        let message = String.localizedString("login_success_message")
        dismiss(message: message, toMainPage: true, sfSafariViewController: sfSafariViewController)
    }
    
    private func loginFailure(_ error: NSError?) {
        if let alertMessage = signInFailureHandler.loginFailure(error)?.alertMessage {
            dismiss(message: alertMessage, sfSafariViewController: sfSafariViewController)
        }
    }
    
    private func premiumExpired() {
        let body = String.localizedString("login_premium_expired_message")
        dismiss(message: body, sfSafariViewController: sfSafariViewController)
    }
    
    private func notPremium() {
        let body = String.localizedString("not_premium_message")
        dismiss(message: body, sfSafariViewController: sfSafariViewController)
    }
    
    private func dismiss(message: String, toMainPage: Bool = false, sfSafariViewController: UIViewController?) {
        dismissController(toMainPage: toMainPage, sfSafariViewController: sfSafariViewController) { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        } onControllerDismiss: {
            /*
                After calling dismiss SignInController is deiniting and self == nil, to avoid strong self we get Network Service from Service Locator
             */
            let notificationService: UserNotificationServiceProtocol = ServiceLocator.shared.getService()!
            notificationService.postNotificationInForeground(body: message, title: "")
        }
    }
}
