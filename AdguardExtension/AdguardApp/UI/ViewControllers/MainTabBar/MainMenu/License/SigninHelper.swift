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

enum SocialProvider: String {
    case google
    case apple
    case facebook
}

class SigninHelper {
    
    static func openBrowser(with socialProvider: SocialProvider, state: String) {
        let params =
            ["response_type" : "token",
            "client_id" : "adguard-ios",
            "scope" : "trust",
            "redirect_uri" : "adguard://auth",
            "state" : state,
            "social_provider" : socialProvider.rawValue]
        
        guard let urlString = params.parceParamsWith(url: "https://auth.adguard.com/oauth/authorize") else { return }
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
