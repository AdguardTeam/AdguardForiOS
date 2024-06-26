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

import DnsAdGuardSDK

extension LowLevelDnsConfiguration {
    static var defaultConfiguration: LowLevelDnsConfiguration {
        LowLevelDnsConfiguration(
            tunnelMode: .split,
            fallbackServers: nil,
            bootstrapServers: nil,
            blockingMode: .defaultMode,
            blockingIpv4:  nil,
            blockingIpv6: nil,
            blockedTtl: 30, // 30 seconds is more than enough to process packet record
            blockIpv6: false,
            restartByReachability: false
        )
    }

    static func fromResources(_ resources: AESharedResourcesProtocol)->LowLevelDnsConfiguration {
        return LowLevelDnsConfiguration(
            tunnelMode: resources.tunnelMode,
            fallbackServers: resources.customFallbackServers,
            bootstrapServers: resources.customBootstrapServers,
            blockingMode: resources.blockingMode,
            blockingIpv4: resources.customBlockingIpv4,
            blockingIpv6: resources.customBlockingIpv6,
            blockedTtl: resources.blockedResponseTtlSecs,
            blockIpv6: resources.blockIpv6,
            restartByReachability: resources.restartByReachability
        )
    }
}
