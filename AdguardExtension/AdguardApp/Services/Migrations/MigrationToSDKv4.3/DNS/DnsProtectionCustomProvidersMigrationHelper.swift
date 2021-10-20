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

/// This object is a helper for `SDKMigrationServiceHelper`
/// It is responsible for providing old DNS custom providers objects, saving them to SDK storage, selecting and removing old data
protocol DnsProtectionCustomProvidersMigrationHelperProtocol: AnyObject {
    /// Returns old objects of DNS custom providers
    func getCustomDnsProviders() -> [SDKDnsMigrationObsoleteCustomDnsProvider]

    /// Saves old DNS custom providers objects to new storage in SDK
    func saveCustomDnsProviders(_ providers: [SDKDnsMigrationObsoleteCustomDnsProvider]) throws

    /// Selects active DNS server and provider if was selected
    func selectActiveDnsServer() throws

    /// Removes old objects from storage
    func removeOldCustomDnsProvidersData()
}

/// Implementation for `DnsProtectionCustomProvidersMigrationHelperProtocol`
final class DnsProtectionCustomProvidersMigrationHelper: DnsProtectionCustomProvidersMigrationHelperProtocol {

    private let resources: AESharedResourcesProtocol
    private let dnsProvidersManager: DnsProvidersManagerProtocol

    init(resources: AESharedResourcesProtocol, dnsProvidersManager: DnsProvidersManagerProtocol) {
        self.resources = resources
        self.dnsProvidersManager = dnsProvidersManager

        NSKeyedUnarchiver.setClass(SDKDnsMigrationObsoleteCustomDnsProvider.self, forClassName: "DnsProviderInfo")
        NSKeyedUnarchiver.setClass(SDKDnsMigrationObsoleteCustomDnsServer.self, forClassName: "DnsServerInfo")
    }

    func getCustomDnsProviders() -> [SDKDnsMigrationObsoleteCustomDnsProvider] {
        guard
            let data = resources.sharedDefaults().object(forKey: "APDefaultsCustomDnsProviders") as? Data,
            let customProviders = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SDKDnsMigrationObsoleteCustomDnsProvider]
        else {
            DDLogInfo("(DnsProtectionCustomProvidersMigrationHelper) - getCustomDnsProviders; Failed to find custom DNS providers")
            return []
        }

        DDLogInfo("(DnsProtectionCustomProvidersMigrationHelper) - getCustomDnsProviders; Found \(customProviders.count) custom DNS providers")
        return customProviders
    }

    func saveCustomDnsProviders(_ providers: [SDKDnsMigrationObsoleteCustomDnsProvider]) throws {
        DDLogInfo("(DnsProtectionCustomProvidersMigrationHelper) - saveCustomDnsProviders; Saving \(providers.count) providers to SDK")

        let activeServerInfo = getActiveDnsServerInfo()

        try providers.forEach {
            let selectAsCurrent = activeServerInfo != nil && $0.providerId == activeServerInfo?.providerId && $0.server.serverId == activeServerInfo?.serverId
            try dnsProvidersManager.addCustomProvider(name: $0.name, upstreams: [$0.server.upstream], selectAsCurrent: selectAsCurrent)
        }
        DDLogInfo("(DnsProtectionCustomProvidersMigrationHelper) - saveCustomDnsProviders; Saved \(providers.count) providers to SDK")
    }

    func selectActiveDnsServer() throws {
        DDLogInfo("(DnsProtectionCustomProvidersMigrationHelper) - selectActiveDnsServer; Selecting active server")

        guard let activeServerInfo = getActiveDnsServerInfo() else {
            DDLogInfo("(DnsProtectionCustomProvidersMigrationHelper) - selectActiveDnsServer; Server wasn't selected")
            return
        }

        let isCustomServer = activeServerInfo.serverId >= 100000 && activeServerInfo.providerId < 10000

        // Check if active server is not custom. Custom servers do not support protocol selection
        if isCustomServer {
            return
        }
        // If server is not custom we need to set predefined DNS server as active
        else {
            try dnsProvidersManager.selectProvider(withId: activeServerInfo.providerId, serverId: activeServerInfo.serverId)
        }

        // We need to save selected custom DNS provider, otherwise user'll see wrong info in UI
        guard
            let selectedProvider = dnsProvidersManager.allProviders.first(where: { $0.providerId == activeServerInfo.providerId }),
            let selectedServer = selectedProvider.dnsServers.first(where: { $0.id == activeServerInfo.serverId })
        else {
            return
        }
        let activeDnsProtocol = selectedServer.type
        resources.dnsActiveProtocols[activeServerInfo.providerId] = activeDnsProtocol
    }

    func removeOldCustomDnsProvidersData() {
        resources.sharedDefaults().removeObject(forKey: "APDefaultsCustomDnsProviders")
        resources.sharedDefaults().removeObject(forKey: "ActiveDnsServer")
    }

    /// Returns active DNS provider id and server id. If nothing was selected return nil
    private func getActiveDnsServerInfo() -> (providerId: Int, serverId: Int)? {
        guard
            let activeDnsServerData = resources.sharedDefaults().data(forKey: "ActiveDnsServer"),
            let activeDnsServerParamsDict = try? JSONSerialization.jsonObject(with: activeDnsServerData, options: []) as? [String: Any],
            let providerId = activeDnsServerParamsDict["providerId"] as? Int,
            let serverIdString = activeDnsServerParamsDict["serverId"] as? String,
            let serverId = Int(serverIdString)
        else {
            DDLogInfo("(DnsProtectionCustomProvidersMigrationHelper) - getActiveDnsServerInfo; Active DNS server wasn't saved")
            return nil
        }

        DDLogInfo("(DnsProtectionCustomProvidersMigrationHelper) - getActiveDnsServerInfo; Active DNS server provider id=\(providerId); server id=\(serverId)")
        return (providerId, serverId)
    }
}

class SDKDnsMigrationObsoleteCustomDnsProvider: NSObject, NSCoding {
    let name: String
    let providerId: Int
    let server: SDKDnsMigrationObsoleteCustomDnsServer

    // Encoder used only for tests
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

    // Init for tests
    init(name: String, providerId: Int, server: SDKDnsMigrationObsoleteCustomDnsServer) {
        self.name = name
        self.providerId = providerId
        self.server = server
    }
}

class SDKDnsMigrationObsoleteCustomDnsServer: NSObject, NSCoding {
    let serverId: Int
    let providerId: Int
    let name: String
    let upstream: String

    // Encoder used only for tests
    func encode(with coder: NSCoder) {
        let stringServerId = String(serverId)
        let number = NSNumber(value: providerId)
        coder.encode(stringServerId, forKey: "server_id")
        coder.encode(number, forKey: "providerId")
        coder.encode(name, forKey: "name")
        coder.encode([upstream], forKey: "upstreams")
    }

    required init?(coder: NSCoder) {
        guard
            let serverIdString = coder.decodeObject(forKey: "server_id") as? String,
            let serverId = Int(serverIdString),
            let providerId = coder.decodeObject(forKey: "providerId") as? Int,
            let name = coder.decodeObject(forKey: "name") as? String,
            let upstream = (coder.decodeObject(forKey: "upstreams") as? [String])?.first
        else {
            return nil
        }

        self.serverId = serverId
        self.providerId = providerId
        self.name = name
        self.upstream = upstream
    }

    // Init for tests
    init(serverId: Int, providerId: Int, name: String, upstream: String) {
        self.serverId = serverId
        self.providerId = providerId
        self.name = name
        self.upstream = upstream
    }
}
