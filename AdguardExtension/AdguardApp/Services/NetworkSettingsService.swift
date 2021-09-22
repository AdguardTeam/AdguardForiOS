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
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

class WifiException: NSObject, Codable {
    @objc var rule: String
    @objc var enabled: Bool
    
    init(rule: String, enabled: Bool) {
        self.rule = rule
        self.enabled = enabled
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? WifiException {
            return self.rule == object.rule
        }
        return false
    }
}

protocol NetworkSettingsChangedDelegate {
    func settingsChanged()
}

protocol NetworkSettingsServiceProtocol: AnyObject {
    var exceptions: [WifiException] { get }
    var enabledExceptions: [WifiException] { get }
    var filterWifiDataEnabled: Bool { get set }
    var filterMobileDataEnabled: Bool { get set }
    var delegate: NetworkSettingsChangedDelegate? { get set }
    var onDemandRules: [NEOnDemandRule] { get }
    
    func add(exception: WifiException)
    func delete(exception: WifiException)
    func change(oldException: WifiException, newException: WifiException)
    func fetchCurrentWiFiName(callback: @escaping (String?)->Void)
}

class NetworkSettingsService: NetworkSettingsServiceProtocol {
    
    var filterWifiDataEnabled: Bool {
        get { return resources.filterWifiDataEnabled }
        set { resources.filterWifiDataEnabled = newValue }
    }
    
    var filterMobileDataEnabled: Bool {
        get { return resources.filterMobileDataEnabled }
        set { resources.filterMobileDataEnabled = newValue }
    }
    
    var delegate: NetworkSettingsChangedDelegate?
    
    var exceptions: [WifiException] = []
    
    var enabledExceptions: [WifiException] {
        get {
            return exceptions.filter { $0.enabled }
        }
    }
    
    var onDemandRules: [NEOnDemandRule] {
        get {
            var onDemandRules = [NEOnDemandRule]()
            
            let SSIDs = enabledExceptions.map{ $0.rule }
            if SSIDs.count > 0 {
                let disconnectRule = NEOnDemandRuleDisconnect()
                disconnectRule.ssidMatch = SSIDs
                onDemandRules.append(disconnectRule)
            }
            
            let disconnectRule = NEOnDemandRuleDisconnect()
            
            switch (filterWifiDataEnabled, filterMobileDataEnabled) {
            case (false, false):
                disconnectRule.interfaceTypeMatch = .any
                onDemandRules.append(disconnectRule)
            case (false, _):
                disconnectRule.interfaceTypeMatch = .wiFi
                onDemandRules.append(disconnectRule)
            case (_, false):
                disconnectRule.interfaceTypeMatch = .cellular
                onDemandRules.append(disconnectRule)
            default:
                break
            }
            
            let connectRule = NEOnDemandRuleConnect()
            connectRule.interfaceTypeMatch = .any
            
            onDemandRules.append(connectRule)
            return onDemandRules
        }
    }
    
    /* Variables */
    
    private let filePath = "NetworkSettings"
    
    /* Services */
    private let resources: AESharedResourcesProtocol
    
    init(resources: AESharedResourcesProtocol) {
        self.resources = resources
        
        exceptions = getExceptionsFromFile()
    }
    
    func add(exception: WifiException){
        if !exceptions.contains(exception){
            exceptions.append(exception)
            
            reloadArray()
        }
    }
    
    func delete(exception: WifiException) {
        if let index = exceptions.firstIndex(of: exception){
            exceptions.remove(at: index)

            reloadArray()
        }
    }
    
    func change(oldException: WifiException, newException: WifiException) {
        if let index = exceptions.firstIndex(of: oldException){
            exceptions[index] = newException
            reloadArray()
        }
    }
    
    func fetchCurrentWiFiName(callback: @escaping (String?) -> Void) {
        if #available(iOS 14.0, *) {
            NEHotspotNetwork.fetchCurrent { network in
                guard let network = network else {
                    callback(nil)
                    return
                }
                callback(network.ssid)
            }
        } else {
            if let interfaces = CNCopySupportedInterfaces() as NSArray? {
                for interface in interfaces {
                    if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                        let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                        callback(ssid)
                    }
                }
            }
        }
        
        callback(nil)
    }
    
    // MARK: - Private methods
    
    private func getExceptionsFromFile() -> [WifiException] {
        guard let data = resources.loadData(fromFileRelativePath: filePath) else {
            DDLogError("Failed to load Wifi exceptions from file")
            return []
        }
        if data.count == 0 {
            DDLogInfo("(NetworkSettingsService) getExceptionsFromFile - file is empty")
            return []
        }
        let decoder = JSONDecoder()
        do {
            let exceptions = try decoder.decode([WifiException].self, from: data)
            return exceptions
        } catch {
            DDLogError("Failed to decode Wifi exceptions from data")
        }
        return []
    }
    
    private func saveExceptionsToFile() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(exceptions)
            resources.save(data, toFileRelativePath: filePath)
        } catch {
            DDLogError("Failed to encode Wifi exceptions to data")
        }
    }
    
    private func reloadArray(){
        saveExceptionsToFile()
        exceptions = getExceptionsFromFile()
        delegate?.settingsChanged()
    }
}

fileprivate extension AESharedResourcesProtocol {
    
    var wifiExceptionsEnabledKey: String { "AEDefaultsWifiExceptionsEnabled" }
    var filterMobileEnabledKey: String { "AEDefaultsFilterMobileEnabled" }

    var filterWifiDataEnabled: Bool {
        get {
            return sharedDefaults().object(forKey: wifiExceptionsEnabledKey) as? Bool ?? true
        }
        set {
            if filterWifiDataEnabled != newValue {
                sharedDefaults().set(newValue, forKey: wifiExceptionsEnabledKey)
            }
        }
    }
    
    var filterMobileDataEnabled: Bool {
        get {
            return sharedDefaults().object(forKey: filterMobileEnabledKey) as? Bool ?? true
        }
        set {
            if filterMobileDataEnabled != newValue {
                sharedDefaults().set(newValue, forKey: filterMobileEnabledKey)
            }
        }
    }
}
