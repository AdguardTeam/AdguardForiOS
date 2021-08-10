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

public protocol DnsConfigurationProtocol: ConfigurationProtocol {
    var blocklistIsEnabled: Bool { get set }
    var allowlistIsEnbaled: Bool { get set }
    var dnsFilteringIsEnabled: Bool { get set }
    var dnsImplementation: DnsImplementation { get set }
}

public final class DnsConfiguration: DnsConfigurationProtocol {
    public var currentLanguage: String
    public var proStatus: Bool
    public var dnsFilteringIsEnabled: Bool
    public var dnsImplementation: DnsImplementation
    public var blocklistIsEnabled: Bool
    public var allowlistIsEnbaled: Bool
    
    public init(currentLanguage: String, proStatus: Bool, dnsFilteringIsEnabled: Bool, dnsImplementation: DnsImplementation, blocklistIsEnabled: Bool, allowlistIsEnbaled: Bool) {
        self.currentLanguage = currentLanguage
        self.proStatus = proStatus
        self.dnsFilteringIsEnabled = dnsFilteringIsEnabled
        self.dnsImplementation = dnsImplementation
        self.blocklistIsEnabled = blocklistIsEnabled
        self.allowlistIsEnbaled = allowlistIsEnbaled
    }
}
