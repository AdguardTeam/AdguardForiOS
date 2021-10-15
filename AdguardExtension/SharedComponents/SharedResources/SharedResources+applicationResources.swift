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

import DnsAdGuardSDK

extension AESharedResourcesProtocol {
    /// Advanced mode state
    var advancedMode: Bool {
        get {
            sharedDefaults().bool(forKey: AEDefaultsDeveloperMode)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsDeveloperMode)
        }
    }

    var dnsImplementation: DnsImplementation {
        get {
            if let savedImplementation = sharedDefaults().object(forKey: DnsImplementationKey) as? Int {
                return DnsImplementation(rawValue: savedImplementation) ?? .adGuard
            }
            return .adGuard
        }
        set {
            if dnsImplementation != newValue {
                sharedDefaults().set(newValue.rawValue, forKey: DnsImplementationKey)
                NotificationCenter.default.post(name: .dnsImplementationChanged, object: nil)
            }
        }
    }

    var blockingMode: DnsProxyBlockingMode  {
        get {
            guard let value = sharedDefaults().object(forKey: BlockingMode) as? Int else {
                return .defaultMode
            }

            return DnsProxyBlockingMode(rawValue: value) ?? .defaultMode
        }
        set {
            sharedDefaults().setValue(newValue.rawValue, forKey: BlockingMode)
        }
    }

    /// Map that store info about active protocol for specified provider.
    /// Map key: - Int value represent provider Id
    /// Map value: - Selected DNS protocol for specified provider
    var dnsActiveProtocols: [Int: DnsAdGuardSDK.DnsProtocol] {
        get {
            if let data = sharedDefaults().object(forKey: DnsActiveProtocols) as? Data {
                let decoder = JSONDecoder()
                let protocols = try? decoder.decode([Int: DnsAdGuardSDK.DnsProtocol].self, from: data)
                return protocols ?? [:]
            }
            return [:]
        }
        set {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(newValue) {
                sharedDefaults().set(data, forKey: DnsActiveProtocols)
            }
        }
    }

    var tunnelMode: TunnelMode {
        get {
            guard let value = sharedDefaults().object(forKey: AEDefaultsVPNTunnelMode) as? Int else {
                return .split
            }

            return TunnelMode(rawValue:  value) ?? .split
        }
        set {
            sharedDefaults().set(newValue.rawValue, forKey: AEDefaultsVPNTunnelMode)
        }
    }
}
