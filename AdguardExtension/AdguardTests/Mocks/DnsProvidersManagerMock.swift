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
import SharedAdGuardSDK

class DnsProvidersManagerMock : DnsProvidersManagerProtocol {
    private var customProviderId: Int {
        customProviders.reduce(into: 1) { $0 += $1.providerId }
    }

    private var customDnsServerId: Int {
        customProviders.reduce(into: 1) { $0 += $1.server.id }
    }

    var allProviders: [DnsAdGuardSDK.DnsProviderMetaProtocol] = []

    var predefinedProviders: [DnsAdGuardSDK.DnsProviderProtocol] = []

    var customProviders: [DnsAdGuardSDK.CustomDnsProviderProtocol] = []

    var activeDnsProvider: DnsAdGuardSDK.DnsProviderMetaProtocol

    var activeDnsServer: DnsAdGuardSDK.DnsServerMetaProtocol

    init() {
        let server = CustomDnsServer(upstreams: [], providerId: -1, type: .dns, id: -1, isEnabled: true)

        activeDnsProvider = CustomDnsProvider(name: "default", server: server, providerId: -1, isEnabled: true)
        activeDnsServer = server
    }

    func update(dnsImplementation: DnsAdGuardSDK.DnsImplementation) {

    }

    func selectProvider(withId id: Int, serverId: Int) throws {

    }

    var addCustomProviderCalled: Bool = false
    var addCustomProviderCalledNumber: Int = 0
    var addCustomProviderError: Error?
    func addCustomProvider(name: String, upstreams: [String], selectAsCurrent: Bool, isMigration: Bool) throws {
        addCustomProviderCalled = true
        addCustomProviderCalledNumber += 1
        if let error = addCustomProviderError { throw error }

        let dnsUpstreams = upstreams.map { DnsUpstream(upstream: $0, protocol: .dns) }
        let providerId = customProviderId
        let serverId = customDnsServerId
        let server = CustomDnsServer(upstreams: dnsUpstreams, providerId: customProviderId, type: .dns, id: serverId, isEnabled: selectAsCurrent)
        let provider = CustomDnsProvider(name: name, server: server, providerId: providerId, isEnabled: selectAsCurrent)
        customProviders.append(provider)
    }

    var updateCustomProviderCalled = false
    var updateCustomProviderCalledNumber = 0
    var updateCustomProviderError: Error?
    func updateCustomProvider(withId id: Int, newName: String, newUpstreams: [String], selectAsCurrent: Bool) throws {
        updateCustomProviderCalled = true
        updateCustomProviderCalledNumber += 1
        if let error = updateCustomProviderError { throw error }

        guard let providerIndex = customProviders.firstIndex(where: { $0.providerId == id }) else { return }
        let provider = customProviders[providerIndex]

        let newDnsUpstreams = newUpstreams.map { DnsUpstream(upstream: $0, protocol: .dns) }
        let newServer = CustomDnsServer(
            upstreams: newDnsUpstreams,
            providerId: provider.providerId,
            type: provider.server.type,
            id: provider.server.id,
            isEnabled: selectAsCurrent
        )

        let newCustomProvider = CustomDnsProvider(name: provider.name, server: newServer, providerId: provider.providerId, isEnabled: selectAsCurrent)

        customProviders[providerIndex] = newCustomProvider
    }

    func removeCustomProvider(withId id: Int) throws {

    }

    func reset() throws {

    }
}
