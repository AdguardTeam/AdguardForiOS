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


class GetProController: UIViewController {
    
    // MARK: - properties
    var notificationObserver: Any?
    
    let purchaseService: PurchaseService = ServiceLocator.shared.getService()!
    let configurationService: ConfigurationService = ServiceLocator.shared.getService()!
    
    // MARK: - IB outlets
    @IBOutlet weak var upgradeButton: UIBarButtonItem!
    @IBOutlet weak var signInButton: RoundRectButton!
    @IBOutlet weak var restoreButton: RoundRectButton!
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationObserver = NotificationCenter.default.addObserver(forName: Notification.Name(PurchaseService.kPurchaseServiceNotification),
                                               object: nil, queue: nil)
        { [weak self](notification) in
            if let info = notification.userInfo {
                self?.processNotification(info: info)
                self?.enableButtons(true)
            }
        }
        
        setUpgrateButtonTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.barStyle = .default
    }
    
    deinit {
        if let observer = notificationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLoginSegue" {
            let controller = segue.destination as! LoginController
            controller.purchaseService = purchaseService
        }
    }
    
    // MARK: - actions
    
    @IBAction func upgradeAction(_ sender: Any) {
        enableButtons(false)
        purchaseService.requestPurchase()
    }
    
    @IBAction func restorePurchasesAction(_ sender: Any) {
        enableButtons(false)
        purchaseService.requestRestore()
    }
    
    // MARK: - private methods
    
    private func processNotification(info: [AnyHashable: Any]) {
        
        let type = info[PurchaseService.kPSNotificationTypeKey] as? String
        let error = info[PurchaseService.kPSNotificationErrorKey] as? NSError
        
        switch type {
        case PurchaseService.kPSNotificationPurchaseSuccess:
            purchaseSuccess()
        case PurchaseService.kPSNotificationPurchaseFailure:
            purchaseFailure(error: error)
        case PurchaseService.kPSNotificationRestorePurchaseSuccess:
            restoreSucess()
        case PurchaseService.kPSNotificationRestorePurchaseNothingToRestore:
            nothingToRestore()
        case PurchaseService.kPSNotificationRestorePurchaseFailure:
            restoreFailed(error: error)
        case PurchaseService.kPSNotificationReadyToPurchase:
            setUpgrateButtonTitle()
            
        default:
            break
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
    
    private func setUpgrateButtonTitle() {
        if purchaseService.ready {
            upgradeButton.title = String(format: ACLocalizedString("upgrade_button_title_format", nil), purchaseService.price)
            upgradeButton.isEnabled = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            upgradeButton.title = ACLocalizedString("upgrade_button_title", nil)
            upgradeButton.isEnabled = false
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    private func enableButtons(_ enable: Bool) {
        upgradeButton.isEnabled = enable
        signInButton.isEnabled = enable
        restoreButton.isEnabled = enable
    }
}
