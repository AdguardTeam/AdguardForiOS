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

protocol DnsProtectionCustomProvidersMigrationHelperProtocol: AnyObject {
    func getActiveDnsServerInfo() -> (providerId: Int, serverId: Int)?
    func getCustomDnsProviders() -> [SDKDnsMigrationObsoleteCustomDnsProvider]
    func saveCustomDnsProviders(_ providers: [SDKDnsMigrationObsoleteCustomDnsProvider])
    func removeOldCustomDnsProvidersData()
}

final class DnsProtectionCustomProvidersMigrationHelper: DnsProtectionCustomProvidersMigrationHelperProtocol {

    private let resources: AESharedResourcesProtocol

    init(resources: AESharedResourcesProtocol) {
        self.resources = resources

        NSKeyedUnarchiver.setClass(SDKDnsMigrationObsoleteCustomDnsProvider.self, forClassName: "DnsProviderInfo")
        NSKeyedUnarchiver.setClass(SDKDnsMigrationObsoleteCustomDnsServer.self, forClassName: "DnsServerInfo")
    }

    func getActiveDnsServerInfo() -> (providerId: Int, serverId: Int)? {
        guard
            let activeDnsServerData = resources.sharedDefaults().data(forKey: "ActiveDnsServer"),
            let activeDnsServerParamsDict = try? JSONSerialization.jsonObject(with: activeDnsServerData, options: []) as? [String: Any],
            let providerId = activeDnsServerParamsDict["providerId"] as? Int,
            let serverIdString = activeDnsServerParamsDict["serverId"] as? String,
            let serverId = Int(serverIdString)
        else {
            return nil
        }
        return (providerId, serverId)
    }

    func getCustomDnsProviders() -> [SDKDnsMigrationObsoleteCustomDnsProvider] {
        guard
            let data = resources.sharedDefaults().object(forKey: "APDefaultsCustomDnsProviders") as? Data,
            let customProviders = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SDKDnsMigrationObsoleteCustomDnsProvider]
        else {
            return []
        }

        return customProviders
    }

    func saveCustomDnsProviders(_ providers: [SDKDnsMigrationObsoleteCustomDnsProvider]) {

    }

    func removeOldCustomDnsProvidersData() {
        resources.sharedDefaults().removeObject(forKey: "APDefaultsCustomDnsProviders")
        resources.sharedDefaults().removeObject(forKey: "ActiveDnsServer")
    }
}

class SDKDnsMigrationObsoleteCustomDnsProvider: NSObject, NSCoding {
    let name: String
    let providerId: Int
    let server: SDKDnsMigrationObsoleteCustomDnsServer

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(providerId, forKey: "providerId")
        coder.encode([server], forKey: "servers")
    }

    required init?(coder: NSCoder) {
        guard
            let name = coder.decodeObject(forKey: "name") as? String,
            let server = (coder.decodeObject(forKey: "servers") as? [SDKDnsMigrationObsoleteCustomDnsServer])?.first
        else {
            return nil
        }
        self.name = name
        self.providerId = coder.decodeInteger(forKey: "providerId")
        self.server = server
    }
}

class SDKDnsMigrationObsoleteCustomDnsServer: NSObject, NSCoding {
    let serverId: Int
    let providerId: Int
    let name: String
    let upstream: String
    let prot: DnsProtocol

    func encode(with coder: NSCoder) {
        coder.encode(serverId, forKey: "server_id")
        coder.encode(providerId, forKey: "providerId")
        coder.encode(name, forKey: "name")
        coder.encode([upstream], forKey: "upstreams")
    }

    required init?(coder: NSCoder) {
        guard
            let serverIdString = coder.decodeObject(forKey: "server_id") as? String,
            let serverId = Int(serverIdString),
            let providerId = coder.decodeObject(forKey: "providerId") as? Int,
            let name = coder.decodeObject(forKey: "name") as? String,
            let upstream = (coder.decodeObject(forKey: "upstreams") as? [String])?.first,
            let prot = try? NetworkUtils().getProtocol(from: upstream)
        else {
            return nil
        }

        self.serverId = serverId
        self.providerId = providerId
        self.name = name
        self.upstream = upstream
        self.prot = prot
    }
}
