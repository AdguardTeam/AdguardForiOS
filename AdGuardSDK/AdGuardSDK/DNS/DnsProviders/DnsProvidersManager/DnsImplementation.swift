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

/**
 There are 2 possible ways to implement DNS protection:
    1. AdGuard implementation:
        Works as a local "pseudo" VPN. Supports any DNS protocol, allows to inspect DNS activity
    2. Native implementation:
        Provided by the OS itself. Supports only DoH, DoT and regular DNS. Impossible to inspect DNS activity
 */
public enum DnsImplementation {
    case adguard
    case native
    
    var supportedProtocols: [DnsProtocol] {
        switch self {
        case .adguard: return DnsProtocol.allCases
        case .native: return [.doh, .dot, .dns]
        }
    }
}
