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
    
    // MARK: - services
    
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
    private var configurationObserver: NotificationToken?
 
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        
        purchaseObserver = NotificationCenter.default.observe(name: Notification.Name(PurchaseService.kPurchaseServiceNotification),
                                                                      object: nil, queue: OperationQueue.main)
        { [weak self](notification) in
            if let info = notification.userInfo {
                self?.processNotification(info: info)
            }
        }
        
        updateUI()
        updateTheme()
        
        configurationObserver = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
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
            purchaseService.login(name: credentials!.name, password: credentials!.password, code2fa: codeTextField.text)
        }
    }
    
    // MARK: - private methods
    
    func updateUI() {
        confirmButton.isEnabled = codeTextField.text?.count ?? 0 > 0
    }
    
    func updateTheme() {
        theme.setupLabels(themableLabels)
        theme.setupTextField(codeTextField)
        theme.setupSeparator(codeLine)
        view.backgroundColor = theme.backgroundColor
        updateControls()
    }
    
    private func processNotification(info: [AnyHashable: Any]) {
        
        confirmButton.isEnabled = true
        
        DispatchQueue.main.async { [weak self] in
            
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
        ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: ACLocalizedString("login_success_message", nil)) { [weak self] in
            
            guard let sSelf = self else { return }
            var toController: UIViewController?
            for controller in sSelf.navigationController!.viewControllers {
                if controller.isKind(of: LoginController.self) || controller.isKind(of: Confirm2FaController.self) {
                    break;
                }
                toController = controller
            }
            
            if toController != nil {
                self?.navigationController?.popToViewController(toController!, animated: true)
            }
        }
    }
    
    private func premiumExpired() {
        ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: ACLocalizedString("login_premium_expired_message", nil), completion: nil)
    }
    
    private func notPremium() {
        ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: ACLocalizedString("not_premium_message", nil), completion: nil)
    }
    
    private func loginFailure(_ error: NSError?) {
        
        if error == nil || error!.domain != LoginService.loginErrorDomain {
            // unknown error
            let errorDescription = error?.localizedDescription ?? "nil"
            DDLogError("(LoginController) processLoginResponse - unknown error: \(errorDescription)")
            let message = ACLocalizedString("login_error_message", nil)
            
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: message, completion: nil)
        }
        
        // some errors we show as red text below password text field, some in alert dialog
        var errorMessage: String?
        var alertMessage: String?
        
        switch error!.code {
            
        // errors to be shown in red label
        case LoginService.outh2FAInvalid:
            errorMessage = ACLocalizedString("invalid_2fa_code_error", nil)
        case LoginService.accountIsDisabled:
            errorMessage = ACLocalizedString("account_is_disabled_error", nil)
        case LoginService.accountIsLocked:
            errorMessage = ACLocalizedString("account_is_locked_error", nil)
            
        // errors to be show as alert
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
        
        if errorMessage != nil {
            errorLabel.text = errorMessage
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
