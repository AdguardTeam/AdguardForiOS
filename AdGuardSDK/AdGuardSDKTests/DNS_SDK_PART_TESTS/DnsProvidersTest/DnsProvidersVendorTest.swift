import XCTest

class DnsProvidersVendorTest: XCTestCase {
    var customStorage: CustomDnsProvidersStorageMock!
    var vendor: DnsProvidersVendorProtocol!

    override func setUp() {
        let decoder = try! PredefinedDnsProvidersDecoder(currentLanguage: "en", bundle: Bundle(for: type(of: self)))
        customStorage = CustomDnsProvidersStorageMock()
        vendor = DnsProvidersVendor(predefinedProviders: decoder, customProvidersStorage: customStorage)
    }

    func testProvidersStatesAreSetProperly() {
        let providerId = 10019 // Quad9 DNS
        let serverId = 20 // Quad9 DNS dnscrypt
        let upstream = DnsUpstream(upstream: "1.1.1.1", protocol: .dns)
        let customProvider1 = CustomDnsProvider(name: "custom1",
                                                server: CustomDnsServer(upstreams: [upstream], providerId: 1, type: .dnscrypt, id: 100002, isEnabled: false),
                                                providerId: 1,
                                                isEnabled: false)
        let customProvider2 = CustomDnsProvider(name: "custom2",
                                                server: CustomDnsServer(upstreams: [upstream], providerId: 2, type: .dns, id: 100002, isEnabled: false),
                                                providerId: 1,
                                                isEnabled: false)

        // Test with AdGuard implementation
        customStorage.providers = [customProvider1, customProvider2]
        let adguardProviders = vendor.getProvidersWithState(for: .adGuard, activeDns: DnsProvidersManager.ActiveDnsInfo(providerId: providerId, serverId: serverId))

        let adgProviders: [DnsProviderMetaProtocol] = adguardProviders.predefined + adguardProviders.custom
        XCTAssertEqual(adguardProviders.custom.count, 2)
        XCTAssertEqual(adguardProviders.predefined.count, 11)
        XCTAssertEqual(adguardProviders.activeDnsProvider.name, "Quad9")
 
        checkStates(adgProviders, providerId: providerId, serverId: serverId, implementation: .adGuard)
        checkDefaultServer(adgProviders, matching: 1)

        // Test with Native implementation
        let nativeProviders = vendor.getProvidersWithState(for: .native, activeDns: DnsProvidersManager.ActiveDnsInfo(providerId: providerId, serverId: serverId))

        let natProviders: [DnsProviderMetaProtocol] = nativeProviders.predefined + nativeProviders.custom
        XCTAssertEqual(nativeProviders.custom.count, 1)
        XCTAssertEqual(nativeProviders.predefined.count, 10)
        XCTAssertEqual(nativeProviders.activeDnsProvider.name, "AdGuard DNS")

        checkStates(natProviders, providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId, implementation: .native)
        checkDefaultServer(natProviders, matching: 0)
    }

    func testNativeImplementationWithActiveAdguardDoh() {
        let providerId = 10001
        let serverId = 2

        let providers = vendor.getProvidersWithState(for: .native, activeDns: DnsProvidersManager.ActiveDnsInfo(providerId: providerId, serverId: serverId))
        XCTAssertEqual(providers.custom.count, 0)
        XCTAssertEqual(providers.predefined.count, 10)
        XCTAssertEqual(providers.activeDnsProvider.name, "AdGuard DNS")

        let all: [DnsProviderMetaProtocol] = providers.custom + providers.predefined
        let servers = all.flatMap { $0.servers }
        XCTAssertEqual(servers.count, 26)

        checkStates(all, providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId, implementation: .native)
        checkDefaultServer(all, matching: 0)
    }

    func testAdguardImplementationWithActiveCustomServer() {
        let providerId = 1
        let serverId = 100002
        let upstream = DnsUpstream(upstream: "1.1.1.1", protocol: .dns)
        let customProvider = CustomDnsProvider(name: "custom",
                                                server: CustomDnsServer(upstreams: [upstream],
                                                                        providerId: providerId,
                                                                        type: .dnscrypt,
                                                                        id: serverId,
                                                                        isEnabled: false),
                                                providerId: 1,
                                                isEnabled: false)
        customStorage.providers = [customProvider]
        let providers = vendor.getProvidersWithState(for: .adGuard, activeDns: DnsProvidersManager.ActiveDnsInfo(providerId: providerId, serverId: serverId))

        XCTAssertEqual(providers.custom.count, 1)
        XCTAssertEqual(providers.predefined.count, 11)
        XCTAssertEqual(providers.activeDnsProvider.name, "custom")

        let all: [DnsProviderMetaProtocol] = providers.custom + providers.predefined
        let servers = all.flatMap { $0.servers }
        XCTAssertEqual(servers.count, 37)

        checkStates(all, providerId: providerId, serverId: serverId, implementation: .adGuard)
        checkDefaultServer(all, matching: 1)
    }

    func testNativeImplementationWithActiveCustomQuicServer() {
        let providerId = 1
        let serverId = 100002
        let upstream = DnsUpstream(upstream: "1.1.1.1", protocol: .dns)
        let customProvider = CustomDnsProvider(name: "custom",
                                                server: CustomDnsServer(upstreams: [upstream],
                                                                        providerId: providerId,
                                                                        type: .doq,
                                                                        id: serverId,
                                                                        isEnabled: false),
                                                providerId: 1,
                                                isEnabled: false)
        customStorage.providers = [customProvider]
        let providers = vendor.getProvidersWithState(for: .native, activeDns: DnsProvidersManager.ActiveDnsInfo(providerId: providerId, serverId: serverId))

        XCTAssertEqual(providers.custom.count, 0)
        XCTAssertEqual(providers.predefined.count, 10)
        XCTAssertEqual(providers.activeDnsProvider.name, "AdGuard DNS")

        let all: [DnsProviderMetaProtocol] = providers.custom + providers.predefined
        let servers = all.flatMap { $0.servers }
        XCTAssertEqual(servers.count, 26)

        checkStates(all, providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId, implementation: .native)
        checkDefaultServer(all, matching: 0)
    }

    func testNativeImplementationWithActiveSystemDefaultServer() {
        let providerId = PredefinedDnsProvider.systemDefaultProviderId
        let serverId = PredefinedDnsServer.systemDefaultServerId
        let providers = vendor.getProvidersWithState(for: .native, activeDns: DnsProvidersManager.ActiveDnsInfo(providerId: providerId, serverId: serverId))

        XCTAssertEqual(providers.custom.count, 0)
        XCTAssertEqual(providers.predefined.count, 10)
        XCTAssertEqual(providers.activeDnsProvider.name, "AdGuard DNS")

        let all: [DnsProviderMetaProtocol] = providers.custom + providers.predefined
        let servers = all.flatMap { $0.servers }
        XCTAssertEqual(servers.count, 26)

        checkStates(all, providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId, implementation: .native)
        checkDefaultServer(all, matching: 0)
    }

    private func checkStates(_ providers: [DnsProviderMetaProtocol], providerId: Int, serverId: Int, implementation: DnsImplementation) {
        providers.forEach {
            let isEnabled = $0.providerId == providerId
            XCTAssertEqual($0.isEnabled, isEnabled, "\($0.name) is enabled=\($0.isEnabled) should be enabled=\(isEnabled)")
            $0.servers.forEach { server in
                let isEnabled = serverId == server.id
                XCTAssertEqual(server.isEnabled, isEnabled, "server with id=\(server.id) is enabled=\(server.isEnabled) should be enabled=\(isEnabled)")
            }
        }

        let servers = providers.flatMap { $0.servers }
        let allProtocolsDecoded = servers.map { $0.type }
        let allProtocolsAvailable = DnsImplementation.native.supportedProtocols
        allProtocolsAvailable.forEach { XCTAssert(allProtocolsDecoded.contains($0)) }
    }

    private func checkDefaultServer(_ providers: [DnsProviderMetaProtocol], matching: Int) {
        var counter = 0
        providers.forEach {
            if $0.isDefault {
                XCTAssertEqual($0.providerId, PredefinedDnsProvider.systemDefaultProviderId)
                counter += 1
            } 
        }
        XCTAssertEqual(counter, matching)
    }
}

fileprivate extension DnsProviderMetaProtocol {
    var servers: [DnsServerMetaProtocol] {
        if self.isCustom {
            let customServer = self.custom.server
            return [customServer]
        } else {
            let predefinedServers = self.predefined.servers
            return predefinedServers
        }
    }
}
