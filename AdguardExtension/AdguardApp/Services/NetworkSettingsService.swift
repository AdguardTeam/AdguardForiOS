///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///

import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import SharedAdGuardSDK

/** struct for using in NetworkSettingsTableController */
struct WifiException: Equatable, Codable {
    // rule - ssid the wi-fi network in which the dns filtering should not work
    let rule: String

    // state of rule
    let enabled: Bool
}

/** delegate protocol is used for notification about chnges in view model */
protocol NetworkSettingsChangedDelegate {

    // called on any change of model
    func settingsChanged()
}

/** The NetworkSettingsService is responsible for storing DNS Network settings
    Also it constructs ondemand rules for vpn manager.
 */
protocol NetworkSettingsServiceProtocol: AnyObject {
    // wi-fi exception rules
    var exceptions: [WifiException] { get }

    // array of active wi-fi exceptions
    var enabledExceptions: [WifiException] { get }

    // DNS filtering is enabled when connected to Wi-Fi
    var filterWifiDataEnabled: Bool { get set }

    // DNS filtering is enabled when connected to mobile network
    var filterMobileDataEnabled: Bool { get set }

    // delegate for change notifications
    var delegate: NetworkSettingsChangedDelegate? { get set }

    // ondemand rules based on network settings and used by the vpn manager
    var onDemandRules: [NEOnDemandRule] { get }

    // adds an exception. Throws error if such ssid already exists in the exclusion list
    func add(exception: WifiException) throws

    // deletes an exception
    func delete(exception: WifiException)

    // changes name of exception. Throws error if error if newName already exists in the exclusion list
    func rename(oldName: String, newName: String) throws

    // changes enabled state of exception with name
    func changeState(name: String, enabled: Bool)

    // fetches current wi-fi name. Wi-fi name returns in completionHandler asyncronously in main thread
    // it returns nil on ios 15 due to ios bug https://developer.apple.com/forums/thread/670970
    func fetchCurrentWiFiName(_ completionHandler: @escaping (String?)->Void)
}

final class NetworkSettingsService: NetworkSettingsServiceProtocol {

    var filterWifiDataEnabled: Bool {
        get { return resources.filterWifiDataEnabled }
        set { resources.filterWifiDataEnabled = newValue }
    }

    var filterMobileDataEnabled: Bool {
        get { return resources.filterMobileDataEnabled }
        set { resources.filterMobileDataEnabled = newValue }
    }

    var delegate: NetworkSettingsChangedDelegate?

    var exceptions: [WifiException] = [] {
        didSet {
            saveExceptions()
        }
    }

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

        exceptions = resources.wifiExceptions
    }

    func add(exception: WifiException) throws {
        if !exceptions.contains(where: { $0.rule == exception.rule }){
            exceptions.append(exception)
        }
        else {
            throw UserRulesStorageError.ruleAlreadyExists(ruleString: exception.rule)
        }
    }

    func delete(exception: WifiException) {
        if let index = exceptions.firstIndex(of: exception){
            exceptions.remove(at: index)
        }
    }

    func rename(oldName: String, newName: String) throws {
        if exceptions.contains(where: { $0.rule == newName }) {
            throw UserRulesStorageError.ruleAlreadyExists(ruleString: newName)
        }

        if let index = exceptions.firstIndex(where: { $0.rule == oldName }){
            let newException = WifiException(rule: newName, enabled: exceptions[index].enabled)
            exceptions[index] = newException
        }
    }

    func changeState(name: String, enabled: Bool) {
        if let index = exceptions.firstIndex(where: { $0.rule == name }){
            let newException = WifiException(rule: name, enabled: enabled)
            exceptions[index] = newException
        }
    }

    func fetchCurrentWiFiName(_ completionHandler: @escaping (String?) -> Void) {
        if #available(iOS 14.0, *) {
            NEHotspotNetwork.fetchCurrent { network in
                guard let network = network else {
                    completionHandler(nil)
                    return
                }
                completionHandler(network.ssid)
            }
        } else {
            if let interfaces = CNCopySupportedInterfaces() as NSArray? {
                for interface in interfaces {
                    if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                        let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                        // NEHotspotNetwork.fetchCurrent callback called on main queue.
                        // Here we call the completionHandler on the main queue for consistency
                        DispatchQueue.asyncSafeMain {
                            completionHandler(ssid)
                        }
                    }
                }
            }
        }

        completionHandler(nil)
    }

    // MARK: - Private methods

    private func saveExceptions(){
        resources.wifiExceptions = exceptions
        delegate?.settingsChanged()
    }
}

fileprivate extension AESharedResourcesProtocol {

    var wifiExceptionsEnabledKey: String { "AEDefaultsWifiExceptionsEnabled" }
    var filterMobileEnabledKey: String { "AEDefaultsFilterMobileEnabled" }
    var wifiExceptionsKey: String { "wifiExceptionsKey" }

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

    // TODO: write migration
    // in v4.2 Wi-Fi exceptions were saved in the json file. We now store them in user defaults.
    var wifiExceptions: [WifiException] {
        get {
            guard let decoded = sharedDefaults().object(forKey: wifiExceptionsKey) as? Data else {
                return []
            }

            let exceptions = try? JSONDecoder().decode([WifiException].self, from: decoded)
            return exceptions ?? []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                sharedDefaults().set(encoded, forKey: wifiExceptionsKey)
            }
        }
    }
}
