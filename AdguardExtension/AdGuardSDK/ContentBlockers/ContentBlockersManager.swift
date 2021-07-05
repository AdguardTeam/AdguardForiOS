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

/*
 This manager is a wrapper for SafariService responsible for Content blockers
 We use it in order to be able to test code in ContentBlockerService
 */
protocol ContentBlockersManagerProtocol {
    func reloadContentBlocker(withId id: String, _ onContentBlockerReloaded: @escaping (_ error: Error?) -> Void)
    func getStateOfContentBlocker(withId id: String, _ onContentBlockerStateRevealed: @escaping (_ result: Result<Bool>) -> Void)
}

struct ContentBlockersManager: ContentBlockersManagerProtocol {
    
    func reloadContentBlocker(withId id: String, _ onContentBlockerReloaded: @escaping (_ error: Error?) -> Void) {
        if #available(iOS 10.0, *) {
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: id, completionHandler: onContentBlockerReloaded)
        }
    }
    
    func getStateOfContentBlocker(withId id: String, _ onContentBlockerStateRevealed: @escaping (Result<Bool>) -> Void) {
        if #available(iOS 10.0, *) {
            SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: id) { state, error in
                if let error = error {
                    onContentBlockerStateRevealed(.error(error))
                    return
                }
                if let state = state {
                    onContentBlockerStateRevealed(.success(state.isEnabled))
                    return
                }
                onContentBlockerStateRevealed(.error(NSError(domain: "AdGuardSDK.ContentBlockersManager.unknownError", code: 1, userInfo: nil)))
            }
        }
    }
}
