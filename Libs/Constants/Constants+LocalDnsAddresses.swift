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

import SharedAdGuardSDK

extension Constants {
    struct LocalDnsAddresses {
        static let ipv4 = "198.18.0.1"
        static let ipv6 = "2001:ad00:ad00::ad00"

        // AdGuard DNS Non-filtering
        static let defaultSystemDnsServers = ["94.140.14.140", "94.140.14.141", "2a10:50c0::1:ff", "2a10:50c0::2:ff"]
    }
}
