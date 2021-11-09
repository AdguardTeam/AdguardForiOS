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

protocol DnsConfigManagerAssistantProtocol {
    /// Updates VPN manager or saves DNS config for native mode
    func applyDnsPreferences(completion: ((_ error: Error?) -> Void)?)
}

/// This structure is responsible for updating DNS preferences for AdGuard or native implementations
struct DnsConfigManagerAssistant: DnsConfigManagerAssistantProtocol {

    // MARK: - Private properties

    private let vpnManager: VpnManagerProtocol
    private let nativeDnsManager: NativeDnsSettingsManagerProtocol
    private let resources: AESharedResourcesProtocol

    // MARK: - Init

    init(vpnManager: VpnManagerProtocol, nativeDnsManager: NativeDnsSettingsManagerProtocol, resource: AESharedResourcesProtocol) {
        self.vpnManager = vpnManager
        self.nativeDnsManager = nativeDnsManager
        self.resources = resource
    }

    // MARK: - Public methods

    func applyDnsPreferences(completion: ((_ error: Error?) -> Void)?) {
        if resources.dnsImplementation == .adGuard {
            vpnManager.updateSettings(completion: completion)
        } else if #available(iOS 14.0, *) {
            nativeDnsManager.saveDnsConfig { error in
                completion?(error)
            }
        }
    }
}
