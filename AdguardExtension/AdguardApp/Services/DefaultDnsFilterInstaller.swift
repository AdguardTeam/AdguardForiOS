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

protocol DefaultDnsFilterInstallerProtocol: AnyObject {
    func installDefaultDnsFilterIfNeeded()
}

/// This object is responsible for installing default DNS filter if it wasn't installed yet
final class DefaultDnsFilterInstaller: DefaultDnsFilterInstallerProtocol {

    private let resources: AESharedResourcesProtocol
    private let dnsProtection: DnsProtectionProtocol

    init(resources: AESharedResourcesProtocol, dnsProtection: DnsProtectionProtocol) {
        self.resources = resources
        self.dnsProtection = dnsProtection
    }

    func installDefaultDnsFilterIfNeeded() {
        let defaultFilterUrl = URL(string: "https://filters.adtidy.org/dns/filter_1_ios.txt")!

        // Check if filter was already installed
        if resources.defaultDnsFilterWasInstalled {
            return
        }

        // If DNS filter is already in the list then we suppose that user knows what it is and won't set the filter again
        if dnsProtection.filters.map({ $0.subscriptionUrl }).contains(where: { $0 == defaultFilterUrl }) {
            resources.defaultDnsFilterWasInstalled = true
            return
        }

        dnsProtection.addFilter(withName: "AdGuard DNS filter", url: defaultFilterUrl, isEnabled: true) { [weak resources] error in
            if let error = error {
                DDLogError("(DefaultDnsFilterInstaller) - installDefaultDnsFilterIfNeeded; Failed to install default DNS filter with error: \(error)")
                return
            }
            DDLogError("(DefaultDnsFilterInstaller) - installDefaultDnsFilterIfNeeded; Installed default DNS filter")
            resources?.defaultDnsFilterWasInstalled = true
        }
    }
}

fileprivate extension AESharedResourcesProtocol {
    var defaultDnsFilterWasInstalledKey: String { "defaultDnsFilterWasInstalledKey" }

    var defaultDnsFilterWasInstalled: Bool {
        get {
            sharedDefaults().bool(forKey: defaultDnsFilterWasInstalledKey)
        }
        set {
            sharedDefaults().set(newValue, forKey: defaultDnsFilterWasInstalledKey)
        }
    }
}
