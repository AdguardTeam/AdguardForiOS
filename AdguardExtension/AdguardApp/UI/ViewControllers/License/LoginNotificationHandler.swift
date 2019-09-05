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

class LoginNotificationHandler {
    
    var auth2FaRequiredCallback:(()->Void)?
    
    private var notificationObserver: Any?
    private var completion: ()->Void
    private var parentController: UIViewController
    
    init(parentController: UIViewController, completion: @escaping ()->Void) {
        self.parentController = parentController
        self.completion = completion
        
        notificationObserver = NotificationCenter.default.addObserver(forName: Notification.Name(PurchaseService.kPurchaseServiceNotification),
                                                                      object: nil, queue: nil)
        { [weak self](notification) in
            if let info = notification.userInfo {
                self?.processNotification(info: info)
            }
        }
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
    
    private func loginCompleteWithMessage(message: String) {
        
        ACSSystemUtils.showSimpleAlert(for: parentController, withTitle: nil, message: message) { [weak self] in
            self?.completion()
        }
    }
    
    private func loginSuccess(){
        loginCompleteWithMessage(message: ACLocalizedString("login_success_message", nil))
    }
    
    private func loginFailure(error: NSError?) {
        if error != nil && error!.domain == LoginService.loginErrorDomain && error!.code == LoginService.loginBadCredentials {
            // todo: change string constant
            loginCompleteWithMessage(message: ACLocalizedString("login_max_computers_exceeded", nil))
        }
        else if error?.domain == LoginService.loginErrorDomain && error?.code == LoginService.loginMaxComputersExceeded {
            loginCompleteWithMessage(message: ACLocalizedString("login_max_computers_exceeded", nil))
        }
        else if error?.domain == LoginService.loginErrorDomain && error?.code == LoginService.auth2FaRequired && auth2FaRequiredCallback != nil {
            auth2FaRequiredCallback?()
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
