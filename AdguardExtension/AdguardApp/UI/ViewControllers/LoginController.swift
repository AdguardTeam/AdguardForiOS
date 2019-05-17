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

class LoginController: BottomAlertController {
    
    // MARK: - properties
    let purchaseService: PurchaseService = ServiceLocator.shared.getService()!
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private var notificationObserver: Any?
    
    // MARK: - IB outlets
    @IBOutlet weak var nameEdit: UITextField!
    @IBOutlet weak var passwordEdit: UITextField!
    @IBOutlet weak var loginButton: RoundRectButton!
    @IBOutlet weak var nameLine: UIView!
    @IBOutlet weak var passwordLine: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    
    // MARK: - pribate properties
    
    private let enabledColor = UIColor.init(hexString: "D8D8D8")
    private let disabledColor = UIColor.init(hexString: "4D4D4D")
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationObserver = NotificationCenter.default.addObserver(forName: Notification.Name(PurchaseService.kPurchaseServiceNotification),
                                                                      object: nil, queue: nil)
        { [weak self](notification) in
            if let info = notification.userInfo {
                self?.processNotification(info: info)
            }
        }
        
        nameEdit.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        passwordEdit.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        updateLoginButton()
        
        updateTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameEdit.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func loginAction(_ sender: Any) {
        
        if  let name = nameEdit.text,
            let password = passwordEdit.text {
            
            purchaseService.login(withName: name, password: password)
        }
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        updateLoginButton()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - text field delegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateLines()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateLines()
    }
    
    // MARK: - private methods
    
    func updateLines() {
        nameLine.backgroundColor = nameEdit.isEditing ? enabledColor : disabledColor
        passwordLine.backgroundColor = passwordEdit.isEditing ? enabledColor : disabledColor
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
                
            default:
                break
            }
        }
    }
    
    private func loginSuccess(){
        ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: ACLocalizedString("login_success_message", nil)) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func loginFailure(error: NSError?) {
        if error != nil && error!.domain == LoginService.loginErrorDomain && error!.code == LoginService.loginBadCredentials {
            showRetryAlert(message: ACLocalizedString("wrong_login_credintals_message", nil), restoreLogin: true)
        }
        else {
            showRetryAlert(message: ACLocalizedString("login_error_message", nil), restoreLogin: true)
        }
    }
    
    private func premiumExpired() {
        showRetryAlert(message: ACLocalizedString("login_premium_expired_message", nil), restoreLogin: true)
    }
    
    private func notPremium() {
        showRetryAlert(message: ACLocalizedString("not_premium_message", nil), restoreLogin: true)
    }
    
    private func showRetryAlert(message: String, restoreLogin: Bool) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: ACLocalizedString("common_action_cancel", nil), style: .cancel, handler: nil)
            alert.addAction(cancelAction)
   
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func updateLoginButton() {
        loginButton.isEnabled = nameEdit.text?.count ?? 0 > 0 && passwordEdit.text?.count ?? 0 > 0
    }
    
    private func updateTheme() {
        
        contentView.backgroundColor = theme.bottomBarBackgroundColor
        
        theme.setupTextField(nameEdit)
        theme.setupTextField(passwordEdit)
        
        separators.forEach { $0.backgroundColor = theme.separatorColor }
        
        theme.setupLabels(themableLabels)
    }
}
