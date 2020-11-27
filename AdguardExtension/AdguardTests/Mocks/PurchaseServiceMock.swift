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
import Setapp

class PurchaseServiceMock: PurchaseServiceProtocol {
    
    var purchasedThroughSetapp: Bool = false
    
    func updateSetappState(subscription: SetappSubscription) {
    }
    
    var activateLicesnseCalled = false
    
    func start() {
    }
    
    func startProductRequest() {
    }
    
    var isProPurchased: Bool = false
    
    var purchasedThroughLogin: Bool = false
    
    func checkPremiumStatusChanged() {
    }
    
    var standardProduct: Product?
    
    var products: [Product] = []
    
    func login(withAccessToken token: String?, state: String?) {
    }
    
    func login(withLicenseKey key: String) {
        activateLicesnseCalled = true
    }
    
    func login(name: String, password: String, code2fa: String?) {
    }
    
    func checkLicenseStatus() {
    }
    
    func logout() -> Bool {
        return true
    }
    
    func requestPurchase(productId: String) {
    }
    
    func requestRestore() {
    }
    
    func reset(completion: @escaping () -> Void) {
    }
}
