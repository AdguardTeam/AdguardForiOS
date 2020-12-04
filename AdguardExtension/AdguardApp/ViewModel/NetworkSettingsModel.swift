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

protocol NetworkSettingsModelProtocol {
    /* Variables */
    var exceptions: [WifiException] { get }
    var delegate: NetworkSettingsChangedDelegate? { get set }
    var filterWifiDataEnabled: Bool { get set }
    var filterMobileDataEnabled: Bool { get set }
    
    /* Methods */
    func addException(rule: String)
    func delete(rule: String)
    func change(rule: String, newRule: String)
    func change(rule: String, newEnabled: Bool)
    
}

class NetworkSettingsModel: NetworkSettingsModelProtocol {
    
    var filterWifiDataEnabled: Bool {
        get {
            return networkSettingsService.filterWifiDataEnabled
        }
        set {
            networkSettingsService.filterWifiDataEnabled = newValue
            if resources.dnsImplementation == .adGuard {
                vpnManager.updateSettings(completion: nil)
            } else {
                if #available(iOS 14.0, *) {
                    nativeProviders.saveDnsManager { _ in }
                }
            }
        }
    }
    
    var filterMobileDataEnabled: Bool {
        get {
            return networkSettingsService.filterMobileDataEnabled
        }
        set {
            networkSettingsService.filterMobileDataEnabled = newValue
            if resources.dnsImplementation == .adGuard {
                vpnManager.updateSettings(completion: nil)
            } else {
                if #available(iOS 14.0, *) {
                    nativeProviders.saveDnsManager { _ in }
                }
            }
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
    private let vpnManager: VpnManagerProtocol
    private let resources: AESharedResourcesProtocol
    private let nativeProviders: NativeProvidersServiceProtocol
    
    init(networkSettingsService: NetworkSettingsServiceProtocol, vpnManager: VpnManagerProtocol, resources: AESharedResourcesProtocol, nativeProviders: NativeProvidersServiceProtocol) {
        self.networkSettingsService = networkSettingsService
        self.vpnManager = vpnManager
        self.resources = resources
        self.nativeProviders = nativeProviders
    }
    
    // MARK: - Global methods
    
    func addException(rule: String) {
        let exception = WifiException(rule: rule, enabled: true)
        networkSettingsService.add(exception: exception)
        vpnManager.updateSettings(completion: nil)
    }
    
    func delete(rule: String) {
        for exception in exceptions {
            if exception.rule == rule {
                networkSettingsService.delete(exception: exception)
                vpnManager.updateSettings(completion: nil)
            }
        }
    }
    
    func change(rule: String, newRule: String) {
        for exception in exceptions {
            if exception.rule == rule {
                let newException = WifiException(rule: newRule, enabled: exception.enabled)
                networkSettingsService.change(oldException: exception, newException: newException)
                vpnManager.updateSettings(completion: nil)
            }
        }
    }
    
    func change(rule: String, newEnabled: Bool) {
        for exception in exceptions {
            if exception.rule == rule {
                let newException = WifiException(rule: exception.rule, enabled: newEnabled)
                networkSettingsService.change(oldException: exception, newException: newException)
                vpnManager.updateSettings(completion: nil)
            }
        }
    }
    
    // MARK: - Private methods

}
