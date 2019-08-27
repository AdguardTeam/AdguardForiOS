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

class LoginController: UIViewController, UITextFieldDelegate {
    
    // MARK: - properties
    
    private let purchaseService: PurchaseService = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private var notificationObserver: Any?
    
    // MARK: - IB outlets
    @IBOutlet weak var nameEdit: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameLine: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    // MARK: - private properties
    
    private let enabledColor = UIColor.init(hexString: "4D4D4D")
    private let disabledColor = UIColor.init(hexString: "D8D8D8")
    
    private var keyboardMover: KeyboardMover!
    
    var showAlertBlock: (()->Void)?
    var canShowAlert = true
    
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardMover = KeyboardMover(bottomConstraint: bottomConstraint, view: view)
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        notificationObserver = NotificationCenter.default.addObserver(forName: Notification.Name(PurchaseService.kPurchaseServiceNotification),
                                                                      object: nil, queue: nil)
        { [weak self](notification) in
            if let info = notification.userInfo {
                self?.processNotification(info: info)
            }
        }
        
        nameEdit.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        updateLoginButton()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        updateTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameEdit.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - Actions
    @IBAction func loginAction(_ sender: Any) {
        login()
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        updateLoginButton()
    }
    
    // MARK: - text field delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        login()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateLines()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateLines()
    }
    
    // MARK: - private methods
    
    func updateLines() {
        nameLine.backgroundColor = nameEdit.isEditing ? enabledColor : disabledColor
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
    
    private func showRetryAlert(message: String, restoreLogin: Bool) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: ACLocalizedString("common_action_cancel", nil), style: .cancel, handler: nil)
            alert.addAction(cancelAction)
   
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func updateLoginButton() {
        loginButton.isEnabled = nameEdit.text?.count ?? 0 > 0
    }
    
    private func updateTheme() {
        
        view.backgroundColor = theme.backgroundColor
        
        theme.setupTextField(nameEdit)
        
        separators.forEach { $0.backgroundColor = theme.separatorColor }
        
        theme.setupLabels(themableLabels)
    }
    
    private func isLicenseKey(text: String)->Bool {
        return !text.isEmpty && text.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
//    private func webAuth(){
//        if let name = nameEdit.text {
//
//            webAuthWithName(name: name)
//        }
//    }
    
    private func login(){
        
        let name = nameEdit.text
        let password: String? = "Kyvedu560" // todo: get password from textfield
        
        if (name?.count ?? 0) > 0 &&
            (password?.count ?? 0) > 0 {
            purchaseService.li
        }
        
        if let name = nameEdit.text {
            if isLicenseKey(text: name) {
                purchaseService.login(withLicenseKey: name)
            }
            else {
//                webAuth()
            }
        }
    }
    
//    private func webAuthWithName(name: String){
//
//           DDLogInfo("(GetProController) - webAuth")
//           guard let url = purchaseService.authUrlWithName(name: name) else { return }
//           let safariController = SFSafariViewController(url: url)
//           present(safariController, animated: true, completion: nil)
//           canShowAlert = false
//       }
       
   private func showAlertIfPossible() {
       if canShowAlert && showAlertBlock != nil {
           showAlertBlock!()
           showAlertBlock = nil
       }
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
    
    private func loginCompleteWithMessage(message: String) {
            
        showAlertBlock = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.removeLoading() {
                ACSSystemUtils.showSimpleAlert(for: sSelf, withTitle: nil, message: message) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        showAlertIfPossible()
    }
    
    private func loginSuccess(){
        loginCompleteWithMessage(message: ACLocalizedString("login_success_message", nil))
    }
    
    private func loginFailure(error: NSError?) {
        if error != nil && error!.domain == LoginService.loginErrorDomain && error!.code == LoginService.loginBadCredentials {
                   webAuth()
        }
        else if error?.domain == LoginService.loginErrorDomain && error?.code == LoginService.loginMaxComputersExceeded {
            loginCompleteWithMessage(message: ACLocalizedString("login_max_computers_exceeded", nil))
        }
        else {
            loginCompleteWithMessage(message: ACLocalizedString("login_error_message", nil))
        }
    }
    
    private func premiumExpired() {
        loginCompleteWithMessage(message: ACLocalizedString("login_premium_expired_message", nil))
    }
    
    private func notPremium() {
        loginCompleteWithMessage(message: ACLocalizedString("not_premium_message", nil))
    }
        
}
