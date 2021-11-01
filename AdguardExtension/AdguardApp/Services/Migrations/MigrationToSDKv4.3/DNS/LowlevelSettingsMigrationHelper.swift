///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///
  

import Foundation
import SharedAdGuardSDK

/** this essence is responsible for low level settings migration */
protocol LowlevelSettingsMigrationHelperProtocol {
    /// in v4.2 we stored an array of custom blocking IPs
    /// in 4.3 we store separate IPv4 and IPv6 custom blocking IPs
    func migrateCustomBlockingIps()
}

final class LowlevelSettingsMigrationHelper: LowlevelSettingsMigrationHelperProtocol {

    private let resources: AESharedResourcesProtocol

    init(resources: AESharedResourcesProtocol) {
        self.resources = resources
    }

    func migrateCustomBlockingIps() {
        guard let customBlockingIps = resources.sharedDefaults().object(forKey: "CustomBlockingIp") as? [String] else {
            return
        }

        let ipv4 = customBlockingIps.first { UrlUtils.isIpv4($0) }
        let ipv6 = customBlockingIps.first { UrlUtils.isIpv6($0) }

        resources.customBlockingIpv4 = ipv4
        resources.customBlockingIpv6 = ipv6

        resources.sharedDefaults().removeObject(forKey: "CustomBlockingIp")
    }
}
