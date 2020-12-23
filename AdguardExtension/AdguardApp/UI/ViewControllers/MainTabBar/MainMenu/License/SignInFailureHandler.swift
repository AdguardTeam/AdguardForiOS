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


class SignInFailureHandler {
    let notificationService: UserNotificationServiceProtocol

    init(notificationService: UserNotificationServiceProtocol) {
        self.notificationService = notificationService
    }
    
    func loginFailure(_ error: NSError?, auth2Fa: (() -> ())? = nil ) -> (errorMessage: String?, alertMessage: String?)? {
        
        if error == nil || error!.domain != LoginService.loginErrorDomain {
            // unknown error
            let errorDescription = error?.localizedDescription ?? "nil"
            DDLogError("(LoginController) processLoginResponse - unknown error: \(errorDescription)")
            let message = ACLocalizedString("login_error_message", nil)
            
            notificationService.postNotificationInForeground(body: message, title: "")
            return nil
        }
        
        // some errors we show as red text below password text field, some in alert dialog
        var errorMessage: String?
        var alertMessage: String?
        
        switch error!.code {
            
        // errors to be shown in red label
        case LoginService.loginBadCredentials:
            errorMessage = ACLocalizedString("bad_credentials_error", nil)
        case LoginService.accountIsDisabled:
            errorMessage = ACLocalizedString("account_is_disabled_error", nil)
        case LoginService.accountIsLocked:
            errorMessage = ACLocalizedString("account_is_locked_error", nil)
        
        // errors to be show as alert
        case LoginService.loginMaxComputersExceeded:
            alertMessage = ACLocalizedString("login_max_computers_exceeded", nil)
        case LoginService.loginError:
            alertMessage = ACLocalizedString("login_error_message", nil)
        
        // 2fa required
        case LoginService.auth2FaRequired:
            auth2Fa?()
            
        default:
            alertMessage = ACLocalizedString("login_error_message", nil)
        }
        
        return (errorMessage: errorMessage, alertMessage: alertMessage)
    }
}
