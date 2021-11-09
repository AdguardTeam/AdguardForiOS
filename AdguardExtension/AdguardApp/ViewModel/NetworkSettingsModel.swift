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

final class NetworkSettingsModel: RuleDetailsControllerDelegate {

    var filterWifiDataEnabled: Bool {
        get {
            return networkSettingsService.filterWifiDataEnabled
        }
        set {
            networkSettingsService.filterWifiDataEnabled = newValue
            dnsConfigAssistant.applyDnsPreferences(completion: nil)
        }
    }

    var filterMobileDataEnabled: Bool {
        get {
            return networkSettingsService.filterMobileDataEnabled
        }
        set {
            networkSettingsService.filterMobileDataEnabled = newValue
            dnsConfigAssistant.applyDnsPreferences(completion: nil)
        }
    }

    var delegate: NetworkSettingsChangedDelegate? {
        didSet{
            networkSettingsService.delegate = delegate
        }
    }

    var exceptions: [WifiException] {
        get {
            networkSettingsService.exceptions
        }
    }

    // MARK: - Private variables

    private let networkSettingsService: NetworkSettingsServiceProtocol
    private let dnsConfigAssistant: DnsConfigManagerAssistantProtocol

    init(networkSettingsService: NetworkSettingsServiceProtocol, vpnManager: VpnManagerProtocol, resources: AESharedResourcesProtocol, nativeDnsManager: NativeDnsSettingsManagerProtocol) {
        self.networkSettingsService = networkSettingsService
        self.dnsConfigAssistant = DnsConfigManagerAssistant(vpnManager: vpnManager, nativeDnsManager: nativeDnsManager, resource: resources)
    }

    // MARK: - Global methods

    func addException(rule: String) throws {
        let exception = WifiException(rule: rule, enabled: true)
        try networkSettingsService.add(exception: exception)
        dnsConfigAssistant.applyDnsPreferences(completion: nil)
    }

    func changeState(rule: String, enabled: Bool) {
        networkSettingsService.changeState(name: rule, enabled: enabled)
        dnsConfigAssistant.applyDnsPreferences(completion: nil)
    }

    // MARK: - RuleDetailsControllerDelegate methods

    func removeRule(_ ruleText: String, at indexPath: IndexPath) throws {
        let exception = exceptions[indexPath.row]
        networkSettingsService.delete(exception: exception)
        dnsConfigAssistant.applyDnsPreferences(completion: nil)
    }

    func modifyRule(_ oldRuleText: String, newRule: UserRule, at indexPath: IndexPath) throws {
        try networkSettingsService.rename(oldName: oldRuleText, newName: newRule.ruleText)
        dnsConfigAssistant.applyDnsPreferences(completion: nil)
    }
}
