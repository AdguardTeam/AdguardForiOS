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

protocol DnsConfigManagerAssistantProtocol {
    /// Updates VPN manager or saves DNS config for native mode
    /// - Parameter action: Describe a case in which need to update preferences
    /// - Parameter completion: Closure to handle errors after applying preferences
    func applyDnsPreferences(for action: DnsConfigManagerAssistant.DnsAction, completion: ((_ error: Error?) -> Void)?)
}

/// This class is responsible for updating DNS preferences for AdGuard or native implementations
final class DnsConfigManagerAssistant: DnsConfigManagerAssistantProtocol {

    enum DnsAction: CaseIterable {
        case modifiedDnsFilters
        case modifiedDnsRules
        case modifiedLowLevelSettings
        case modifiedAdvancedSettings
        case modifiedDnsServer // support native
        case modifiedNetworkSettings // support native
        case modifiedDnsSettings // support native

        static let nativeActions: [DnsAction] = [.modifiedDnsServer, .modifiedNetworkSettings, modifiedDnsSettings]
        static let adguardActions: [DnsAction] = DnsAction.allCases
    }

    // MARK: - Private properties

    private let completionQueue = DispatchQueue(label: "AdGuardApp.DnsConfigManagerAssistantCompletionQueue")
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

    func applyDnsPreferences(for action: DnsConfigManagerAssistant.DnsAction, completion: ((_ error: Error?) -> Void)?) {

        switch self.resources.dnsImplementation {
        case .adGuard:
            vpnManager.updateSettings { [weak self] error in
                guard let completion = completion else { return }
                self?.completionQueue.async { completion(error) }
            }
        case .native:
            processNative(action: action) { [weak self] error in
                guard let completion = completion else { return }
                self?.completionQueue.async { completion(error )}
            }
        }
    }

    // MARK: - Private methods

    private func processNative(action: DnsAction, completion: @escaping (_ error: Error?) -> Void) {
        if #available(iOS 14.0, *) {
            if DnsAction.nativeActions.contains(action) {
                self.nativeDnsManager.saveDnsConfig(completion)
            } else {
                completion(nil)
            }
        } else {
            assertionFailure("Current iOS version doesn't support native implementation")
            completion(nil)
        }
    }
}
