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

protocol SignInResultProcessor {}
extension SignInResultProcessor where Self: UIViewController {
    /*
     If there is no tab bar this mean that we trying to login from onboarding license screen and we must dismiss it after successful login
     */
    func dismissController(toMainPage: Bool = false,
                           sfSafariViewController: UIViewController? = nil,
                           onControllerPresentation: (() -> Void)? = nil,
                           onControllerDismiss: (() -> Void)? = nil) {
        
        if let _ = self.tabBarController {
            
            sfSafariViewController?.dismiss(animated: true, completion: {
                onControllerDismiss?()
            })
            
            if toMainPage {
                let controller = self.tabBarController?.viewControllers?.first
                self.tabBarController?.selectedViewController = controller
                self.navigationController?.popToRootViewController(animated: false)
            } else {
                onControllerPresentation?()
            }
            (sfSafariViewController != nil) ? () : onControllerDismiss?()
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: {
                onControllerDismiss?()
            })
        }
    }
}
