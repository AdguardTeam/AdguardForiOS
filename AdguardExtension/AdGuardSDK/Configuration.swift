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

protocol ConfigurationProtocol {
    var currentLanguage: String { get set } // Language preferred by user
    
    var proStatus: Bool { get set } // Shows if user has Premium app version
    
    // Application user configuration
    var blocklistIsEnabled: Bool { get set }
    var allowlistIsEnbaled: Bool { get set }
    var allowlistIsInverted: Bool { get set }
    
    // Application information
    var appProductVersion: String { get set } // Application product version for example 4.1.1 for AdGuard
    var appId: String { get set } // Application id for example "ios_pro" or "ios"
    var cid: String { get set } // UIDevice.current.identifierForVendor?.uuidString should be passed
}

final class Configuration: ConfigurationProtocol {
    
    var currentLanguage: String {
        get {
            return "en"
        }
        set {
            
        }
    }
    
    var proStatus: Bool {
        get {
            return false
        }
        set {
            
        }
    }
    
    var blocklistIsEnabled: Bool {
        get {
            return false
        }
        set {
            
        }
    }
    
    var allowlistIsEnbaled: Bool {
        get {
            return false
        }
        set {
            
        }
    }
    
    var allowlistIsInverted: Bool {
        get {
            return false
        }
        set {
            
        }
    }
    
    var appProductVersion: String {
        get {
            return ""
        }
        set {
            
        }
    }
    
    var appId: String {
        get {
            return ""
        }
        set {
            
        }
    }
    
    var cid: String {
        get {
            return ""
        }
        set {
            
        }
    }
}
