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

@objcMembers class WifiException: NSObject, Codable {
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

@objc
protocol NetworkSettingsChangedDelegate {
    func settingsChanged()
}

@objc
protocol NetworkSettingsServiceProtocol {
    var exceptions: [WifiException] { get }
    var enabledExceptions: [WifiException] { get }
    var filterWifiDataEnabled: Bool { get set }
    var filterMobileDataEnabled: Bool { get set }
    var delegate: NetworkSettingsChangedDelegate? { get set }
    
    func add(exception: WifiException)
    func delete(exception: WifiException)
    func change(oldException: WifiException, newException: WifiException)
    func getCurrentWiFiName() ->  String?
}

@objcMembers
class NetworkSettingsService: NetworkSettingsServiceProtocol {
    
    var delegate: NetworkSettingsChangedDelegate?
    
    var exceptions: [WifiException] = []
    
    var enabledExceptions: [WifiException] {
        get {
            return exceptions.filter { $0.enabled }
        }
    }
    
    var filterWifiDataEnabled: Bool {
        get {
            return resources.sharedDefaults().object(forKey: AEDefaultsFilterWifiEnabled) as? Bool ?? true
        }
        set {
            if filterWifiDataEnabled != newValue {
                resources.sharedDefaults().set(newValue, forKey: AEDefaultsFilterWifiEnabled)
                vpnManager.restartTunnel()
            }
        }
    }
    
    var filterMobileDataEnabled: Bool {
        get {
            return resources.sharedDefaults().object(forKey: AEDefaultsFilterMobileEnabled) as? Bool ?? true
        }
        set {
            if filterMobileDataEnabled != newValue {
                resources.sharedDefaults().set(newValue, forKey: AEDefaultsFilterMobileEnabled)
                vpnManager.restartTunnel()
            }
        }
    }
    
    /* Variables */
    
    // File name is also stored in PacketTunnelProvider and AESSupport
    private let filePath = "NetworkSettings"
    
    /* Services */
    private let resources: AESharedResourcesProtocol
    private let vpnManager: APVPNManagerProtocol
    
    init(resources: AESharedResourcesProtocol, vpnManager: APVPNManagerProtocol) {
        self.resources = resources
        self.vpnManager = vpnManager
        
        exceptions = getExceptionsFromFile()
    }
    
    func add(exception: WifiException){
        if !exceptions.contains(exception){
            exceptions.append(exception)
            
            vpnManager.restartTunnel()
            
            reloadArray()
        }
    }
    
    func delete(exception: WifiException) {
        if let index = exceptions.firstIndex(of: exception){
            exceptions.remove(at: index)
            
            vpnManager.restartTunnel()
            
            reloadArray()
        }
    }
    
    func change(oldException: WifiException, newException: WifiException) {
        if let index = exceptions.firstIndex(of: oldException){
            exceptions[index] = newException
            vpnManager.restartTunnel()
            reloadArray()
        }
    }
    
    func getCurrentWiFiName() ->  String? {
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                 
                if let unsafeInterfaceData = unsafeInterfaceData as? Dictionary<AnyHashable, Any> {
                    return unsafeInterfaceData["SSID"] as? String
                }
            }
        }
        return nil
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
