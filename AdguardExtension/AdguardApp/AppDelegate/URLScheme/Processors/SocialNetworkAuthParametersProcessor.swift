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

struct SocialNetworkAuthParametersProcessor: IURLSchemeParametersProcessor {
    private let executor: IURLSchemeExecutor
    private let socialErrorUserNotFound = "user_not_found"
    
    init(executor: IURLSchemeExecutor) {
        self.executor = executor
    }
    
    
    func process(parameters: [String : Any]) -> Bool {
        if let error = parameters["error"] as? String {
            socialLoginErrorProcessor(error: error)
            return false
        } else {
            guard let token = parameters["access_token"] as? String, !token.isEmpty else { return false }
            guard let state = parameters["state"] as? String, !state.isEmpty else { return false }
            return executor.login(withAccessToken: token, state: state)
        }
    }
    
    private func socialLoginErrorProcessor(error: String) {
        var userInfo = [AnyHashable: Any]()
        DDLogInfo("(URLSchemeProcessor) Social login error: \(error)")
        switch error {
        case socialErrorUserNotFound:
            userInfo[PurchaseService.kPSNotificationTypeKey] = PurchaseService.kPSNotificationLoginUserNotFound
            userInfo[PurchaseService.kPSNotificationErrorKey] = NSError(domain: LoginService.loginErrorDomain, code: LoginService.socialUserNotFound, userInfo: nil)
            
        default:
            break
        }
        NotificationCenter.default.post(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: self, userInfo: userInfo)
    }
}
