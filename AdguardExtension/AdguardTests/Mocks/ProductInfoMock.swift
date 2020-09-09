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

class ProductInfoMock: ADProductInfoProtocol {
    
    var buildNumberInternal = "0"
    
    func version() -> String! {
        return "1.0.0"
    }
    
    func versionWithBuildNumber() -> String! {
        return "1.0.0(20)"
    }
    
    func buildVersion() -> String! {
        return "20"
    }
    
    func buildNumber() -> String! {
        return buildNumberInternal
    }
    
    func name() -> String! {
        return ""
    }
    
    func userAgentString() -> String! {
        return ""
    }
    
    func applicationID() -> String! {
        return ""
    }
    
    
}
