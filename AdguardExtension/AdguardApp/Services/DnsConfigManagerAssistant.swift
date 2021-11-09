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

    enum DnsAction {
        case modifiedDnsProtectionState
        case modifiedDnsFilters
        case modifiedDnsRules
        case modifiedLowLevelSettings
        case modifiedAdvancedSettings
        case modifiedDnsProviderOrDnsServer // support native
        case modifiedNetworkSettings // support native
        case dnsMigration // support native
    }

    private enum ApplyingPreferenceError: Error, CustomDebugStringConvertible {
        case notSupportedIOSVersion
        case notSupportedActionForNative(DnsAction)
        case missingSelf

        var debugDescription: String {
            switch self {
            case .notSupportedIOSVersion: return "Current iOS version not support native implementation."
            case .notSupportedActionForNative(let action): return "Native implementation not support action = \(action)"
            case .missingSelf: return "Missing SELF"
            }
        }
    }

    // MARK: - Private properties

    private let workingQueue = DispatchQueue(label: "AdGuardApp.DnsConfigManagerAssistantQueue")
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
        workingQueue.async { [weak self] in
            guard let self = self else {
                DispatchQueue.main.async { completion?(ApplyingPreferenceError.missingSelf) }
                return
            }

            switch self.resources.dnsImplementation {
            case .adGuard:
                self.vpnManager.updateSettings { error in
                    guard let completion = completion else { return }
                    self.completionQueue.async { completion(error) }
                }
            case .native:
                self.processNative(action: action) { error in
                    guard let completion = completion else { return }
                    self.completionQueue.async { completion(error )}
                }
            }
        }
    }

    private func processNative(action: DnsAction, completion: @escaping (_ error: Error?) -> Void) {
        if #available(iOS 14.0, *) {
            if isNativeSupported(for: action) {
                self.nativeDnsManager.saveDnsConfig(completion)
            } else {
                completion(ApplyingPreferenceError.notSupportedActionForNative(action))
            }
        } else {
            completion(ApplyingPreferenceError.notSupportedIOSVersion)
        }
    }

    private func isNativeSupported(for action: DnsConfigManagerAssistant.DnsAction) -> Bool {
        return action == .modifiedDnsProviderOrDnsServer ||
        action == .modifiedNetworkSettings ||
        action == .dnsMigration
    }
}
