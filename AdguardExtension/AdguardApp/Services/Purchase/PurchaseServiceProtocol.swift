//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
import Setapp

protocol PurchaseServiceProtocol: PurchaseStatusProtocol {

    /* star service. It request SKProducts  */
    func start()

    /* request SKProducts. If SKProducts failed on start we must repeat this request  */
    func startProductRequest()

    /**
     returns true if user has been logged in through login
     */
    var purchasedThroughLogin: Bool {get}

    /**
     returns true if user has been logged in through Setapp
     */
    var purchasedThroughSetapp: Bool {get}

    /**
     returns true if premium expired. It works both for in-app purchases and for adguard licenses
     */
    func checkPremiumStatusChanged()

    /**
     returns standart product (currently it is Year subscribtion )
     */
    var standardProduct: Product? { get }

    /**
     return array of products
     */
    var products: [Product] { get }

    /*  login on backend server and check license information
        the results will be posted through notification center

        we can use adguard license in two ways
        1) login through oauth in safari and get access_token. Then we make auth_token request and get license key. Then bind this key to user device id(app_id) through status request with license key in params
        2) login directly with license key. In this case we immediately send status request with this license key
     */
    func login(withAccessToken token: String?, state: String?)
    func login(withLicenseKey key: String, completion: @escaping (Bool)->Void)

    /**
     Log with name and password
     */
    func login(name: String, password: String, code2fa: String?)

    /**
     checks the status of adguard license
     */
    func checkLicenseStatus()

    /**
     deletes all login information
     */
    func logout()->Bool

    /**
     requests an renewable or non-consumable subscription purchase
     */
    func requestPurchase(productId: String)

    /**
     requests restore in-app purchases
     */
    func requestRestore()

    /** resets all login data */
    func reset(completion: @escaping ()->Void )

    /** handle setapp subscription changes */
    func updateSetappState(subscription: SetappSubscription)

    /** generate URL for OAUTH */
    func generateAuthURL(state: String, socialProvider: SocialProvider) -> URL?

}
