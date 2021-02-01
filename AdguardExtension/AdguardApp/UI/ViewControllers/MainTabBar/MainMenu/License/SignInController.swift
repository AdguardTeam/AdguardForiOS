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

class SignInController: UIViewController {
    
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
        setupButtonTitles()
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
        case PurchaseService.kPSNotificationLoginUserNotFound:
            self.userNotFound()

            
        default:
            break
        }
    }
    
    private func loginSuccess() {
        let message = String.localizedString("login_success_message")
        dismiss(toMainPage: true, message: message)
    }
    
    private func loginFailure(_ error: NSError?) {
        if let alertMessage = signInFailureHandler.loginFailure(error)?.alertMessage {
            dismiss(toMainPage: false, message: alertMessage)
        }
    }
    
    private func premiumExpired() {
        let body = String.localizedString("login_premium_expired_message")
        dismiss(toMainPage: false, message: body)
    }
    
    private func notPremium() {
        let body = String.localizedString("not_premium_message")
        dismiss(toMainPage: false, message: body)
    }
    
    private func userNotFound() {
        let message = String(format: String.localizedString("user_not_found_message"), UIApplication.adguardSigninURL)
        dismiss(animated: true) { [weak self] in
            self?.notificationService.postNotificationInForeground(body: message, title: "")
        }
    }
    
    private func dismiss(toMainPage: Bool, message: String) {
        sfSafariViewController?.dismiss(animated: true, completion: { [notificationService] in
            notificationService.postNotificationInForeground(body: message, title: "")
        })
        
        if toMainPage {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.dismissToMainPage()
        } else {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    private func setupButtonTitles() {
        buttons.forEach {
            var text = ""
            switch $0.tag {
            case 0:
                text = String.localizedString("sign_in_via_adguard_title")
            case 1:
                text = String.localizedString("sign_in_via_apple_title")
            case 2:
                text = String.localizedString("sign_in_via_google_title")
            case 3:
                text = String.localizedString("sign_in_via_facebook_title")
            default:
                break
            }
            $0.setTitle(text, for: .normal)
        }
    }
 }
