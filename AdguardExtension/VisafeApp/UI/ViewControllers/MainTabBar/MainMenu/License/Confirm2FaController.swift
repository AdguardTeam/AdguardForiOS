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


class Confirm2FaController : UIViewController, UITextFieldDelegate {
    
    // MARK: - public properties
    
    var credentials: (name: String, password: String)?
    var fromOnboarding = false
    
    // MARK: - services
    
    private let notificationService: UserNotificationServiceProtocol = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - IB outlets
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var codeLine: UIView!
    @IBOutlet weak var confirmButton: RoundRectButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - private properties
    
    private var purchaseObserver: NotificationToken?
 
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        
        fromOnboarding = self.tabBarController == nil
        
        purchaseObserver = NotificationCenter.default.observe(name: Notification.Name(PurchaseService.kPurchaseServiceNotification),
                                                                      object: nil, queue: OperationQueue.main)
        { [weak self](notification) in
            if let info = notification.userInfo {
                self?.processNotification(info: info)
            }
        }
        
        updateUI()
        updateTheme()
        setupBackButton()
        confirmButton.applyStandardGreenStyle()
        
        confirmButton.makeTitleTextUppercased()
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        codeTextField.becomeFirstResponder()
        super.viewDidAppear(animated)
    }
    
    // MARK: - textView methods
    @IBAction func editingChange(_ sender: Any) {
        updateControls()
    }
    
    @IBAction func startEditing(_ sender: Any) {
        updateControls()
    }
    
    @IBAction func endEditing(_ sender: Any) {
        updateControls()
    }
    
    
    // MARK: - actions
    @IBAction func confirmAction(_ sender: Any) {
        if credentials != nil {
            confirmButton.isEnabled = false
            confirmButton.startIndicator()
            purchaseService.login(name: credentials!.name, password: credentials!.password, code2fa: codeTextField.text)
        }
    }
    
    // MARK: - private methods
    
    func updateUI() {
        confirmButton.isEnabled = codeTextField.text?.count ?? 0 > 0
    }
    
    private func processNotification(info: [AnyHashable: Any]) {
                
        DispatchQueue.main.async { [weak self] in
            
            self?.confirmButton.isEnabled = true
            self?.confirmButton.stopIndicator()

            
            let type = info[PurchaseService.kPSNotificationTypeKey] as? String
            let error = info[PurchaseService.kPSNotificationErrorKey] as? NSError
            
            switch type {
                
            case PurchaseService.kPSNotificationLoginSuccess:
                self?.loginSuccess()
            case PurchaseService.kPSNotificationLoginFailure:
                self?.loginFailure(error)
            case PurchaseService.kPSNotificationLoginPremiumExpired:
                self?.premiumExpired()
            case PurchaseService.kPSNotificationLoginNotPremiumAccount:
                self?.notPremium()
                
            default:
                break
            }
        }
    }
    
    private func loginSuccess() {
        let message = String.localizedString("login_success_message")

        /*
            If there is no tab bar this mean that we trying to login from onboarding license screen and we must dismiss it after successful login
        */

        if !fromOnboarding {
            self.navigationController?.popToRootViewController(animated: false)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.dismissToMainPage(animated: true)
            notificationService.postNotificationInForeground(body: message, title: "")
        } else {
            let proController = self.navigationController?.viewControllers.first { $0 is GetProController } as? GetProController
            self.navigationController?.dismiss(animated: true) { [weak self] in
                self?.notificationService.postNotificationInForeground(body: message, title: "")
                proController?.getProControllerDelegate?.getProControllerClosed()
            }
        }
    }
    
    private func premiumExpired() {
        guard let controller = self.navigationController?.viewControllers.first(where: { $0 is GetProController }) else { return }
        let message = String.localizedString("login_premium_expired_message")
        self.navigationController?.popToViewController(controller, animated: true)
        notificationService.postNotificationInForeground(body: message, title: "")
    }
    
    private func notPremium() {
        guard let controller = self.navigationController?.viewControllers.first(where: { $0 is GetProController }) else { return }
        let message = String.localizedString("not_premium_message")
        self.navigationController?.popToViewController(controller, animated: true)
        notificationService.postNotificationInForeground(body: message, title: "")
    }
    
    private func loginFailure(_ error: NSError?) {
        let signInHelper = SignInFailureHandler(notificationService: notificationService)
        let messages = signInHelper.loginFailure(error)
        
        if let message = messages?.alertMessage {
            notificationService.postNotificationInForeground(body: message, title: "")
        }
        
        if let message = messages?.errorMessage {
            errorLabel.text = message
            codeLine.backgroundColor = theme.errorRedColor
        }
        else {
            errorLabel.text = ""
            codeLine.backgroundColor = theme.editLineColor
        }
    }
    
    private func updateControls() {
        confirmButton.isEnabled = codeTextField.text?.count ?? 0 > 0
        codeLine.backgroundColor = codeTextField.isEditing ? theme.editLineSelectedColor : theme.editLineColor
    }
}

extension Confirm2FaController: ThemableProtocol {
    func updateTheme() {
        theme.setupLabels(themableLabels)
        theme.setupTextField(codeTextField)
        theme.setupSeparator(codeLine)
        view.backgroundColor = theme.backgroundColor
        updateControls()
    }
}
