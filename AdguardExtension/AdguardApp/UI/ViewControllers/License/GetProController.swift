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

class GetProController: UIViewController, UIViewControllerTransitioningDelegate, GetProTableControllerDelegate, LoginControllerDelegate {
    
    // MARK: - properties
    var notificationObserver: Any?
    
    let purchaseService: PurchaseService = ServiceLocator.shared.getService()!
    let configurationService: ConfigurationService = ServiceLocator.shared.getService()!
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    var showAlertBlock: (()->Void)?
    var canShowAlert = false
    
    // MARK: - IB outlets
    @IBOutlet weak var accountView: UIView!
    
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    
    @IBOutlet var loginBarButton: UIBarButtonItem!
    @IBOutlet var logoutBarButton: UIBarButtonItem!
    @IBOutlet weak var goToMyAccountHeight: NSLayoutConstraint!
    
    var tableController: GetProTableController?
    
    // MARK: - constants
    
    private let accountAction = "account"
    private let from = "license"

    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        updateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "" {
            guard let controller = segue.destination as? GetProTableController else { return }
            tableController = controller
            tableController?.delegate = self
        }
    }
    
    deinit {
        if let observer = notificationObserver {
            NotificationCenter.default.removeObserver(observer)
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
    
    // MARK: - actions
    
    @IBAction func accountAction(_ sender: Any) {
        UIApplication.shared.openAdguardUrl(action: accountAction, from: from)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        showLoginDialog()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: ACLocalizedString("confirm_logout_text", nil), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: ACLocalizedString("common_action_cancel", nil), style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: ACLocalizedString("common_action_yes", nil), style: .default) {
            [weak self] (action) in
            if self?.purchaseService.logout() ?? false {
                DispatchQueue.main.async {
                    self?.updateViews()
                }
            }
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - GetProTableControllerDelegate methods
    
    func subscribeAction() {
        purchaseService.requestPurchase()
    }
    func restorePurchasesAction() {
         purchaseService.requestRestore()
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
    
    private func processNotification(info: [AnyHashable: Any]) {
        
        DispatchQueue.main.async { [weak self] in
            let type = info[PurchaseService.kPSNotificationTypeKey] as? String
            let error = info[PurchaseService.kPSNotificationErrorKey] as? NSError
            
            switch type {
            case PurchaseService.kPSNotificationPurchaseSuccess:
                self?.purchaseSuccess()
            case PurchaseService.kPSNotificationPurchaseFailure:
                self?.purchaseFailure(error: error)
            case PurchaseService.kPSNotificationRestorePurchaseSuccess:
                self?.restoreSucess()
            case PurchaseService.kPSNotificationRestorePurchaseNothingToRestore:
                self?.nothingToRestore()
            case PurchaseService.kPSNotificationRestorePurchaseFailure:
                self?.restoreFailed(error: error)
            case PurchaseService.kPSNotificationReadyToPurchase:
                self?.tableController?.enablePurchaseButtons(true)
                self?.tableController?.setPrice()
                
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
    
    private func purchaseSuccess(){
        ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: ACLocalizedString("purchase_success_message", nil)) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func purchaseFailure(error: Error?) {
        ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: ACLocalizedString("purchase_failure_message", nil))
    }
    
    private func restoreSucess(){
        ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: ACLocalizedString("restore_success_message", nil)) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func nothingToRestore() {
        ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: ACLocalizedString("nothing_to_restore_message", nil))
    }
    
    private func restoreFailed(error: NSError?) {
        ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: ACLocalizedString("restore_purchases_failure_message", nil))
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
    
    private func updateTheme() {
        
        view.backgroundColor = theme.backgroundColor
        separator1.backgroundColor = theme.separatorColor
        separator2.backgroundColor = theme.separatorColor
        theme.setupNavigationBar(navigationController?.navigationBar)
    }
    
    private func updateViews() {
        
        switch (configurationService.proStatus, configurationService.purchasedThroughLogin) {
        case (false, _):
            goToMyAccountHeight.constant = 0
            navigationItem.rightBarButtonItems = [loginBarButton]
        case (true, false):
            goToMyAccountHeight.constant = 0
            navigationItem.rightBarButtonItems = [loginBarButton]
        case (true, true):
            goToMyAccountHeight.constant = 60
            navigationItem.rightBarButtonItems = [logoutBarButton]
        }
        
        (children.first as? UITableViewController)?.tableView.reloadData()
    }
    
    private func showLoginDialog() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "LoginController") as? LoginController else { return }
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
    
    private func showAlertIfPossible() {
        if canShowAlert && showAlertBlock != nil {
            showAlertBlock!()
            showAlertBlock = nil
        }
    }
}
