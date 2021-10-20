import XCTest
import DnsAdGuardSDK

class DnsProtectionCustomProvidersMigrationHelperTest: XCTestCase {
    private var migration: DnsProtectionCustomProvidersMigrationHelperProtocol!
    private var resources: SharedResourcesMock!
    private var dnsProvidersManager: InAppDnsProvidersManagerMock!
    private let customProvidersKey = "APDefaultsCustomDnsProviders"
    private let activeDnsServerKey = "ActiveDnsServer"

    private var singleProvider: [SDKDnsMigrationObsoleteCustomDnsProvider] {
        let server = SDKDnsMigrationObsoleteCustomDnsServer(serverId: 100_000, providerId: 1, name: "custom_server#1", upstream: "upstream#1")
        let provider = SDKDnsMigrationObsoleteCustomDnsProvider(name: "name#1", providerId: 1, server: server)
        return [provider]
    }

    private var providers: [SDKDnsMigrationObsoleteCustomDnsProvider] {
        var servers: [SDKDnsMigrationObsoleteCustomDnsServer] = []
        for i in 0...2 {
            servers.append(SDKDnsMigrationObsoleteCustomDnsServer(serverId: 100_000 + i, providerId: 1 + i, name: "custom_server#\(i)", upstream: "upstream#\(i)"))
        }


        return servers.enumerated().map {
            return SDKDnsMigrationObsoleteCustomDnsProvider(name: "provider#\(1 + $0.offset)",
                                                     providerId: 1 + $0.offset,
                                                     server: $0.element)
        }
    }

    private var providersWithRangedIds: [SDKDnsMigrationObsoleteCustomDnsProvider] {
        var servers: [SDKDnsMigrationObsoleteCustomDnsServer] = []
        servers.append(SDKDnsMigrationObsoleteCustomDnsServer(serverId: 100_000, providerId: 5, name: "custom_server#5", upstream: "upstream#5"))
        servers.append(SDKDnsMigrationObsoleteCustomDnsServer(serverId: 100_004, providerId: 10, name: "custom_server#10", upstream: "upstream#10"))
        servers.append(SDKDnsMigrationObsoleteCustomDnsServer(serverId: 100_010, providerId: 15, name: "custom_server#15", upstream: "upstream#15"))

        activeCustomDnsServer["providerId"] = 10
        activeCustomDnsServer["serverId"] = "100004"

        return servers.map {
            SDKDnsMigrationObsoleteCustomDnsProvider(name: "provider#\($0.providerId)",
                                                     providerId: $0.providerId,
                                                     server: $0)
        }
    }

    private var metaDnsProvider: [DnsProviderMetaProtocol] {
        let server = DnsServer(features: [], upstreams: [], providerId: 1, type: .doh, id: 1, name: "server#1", isEnabled: true)
        return [DnsProvider(name: "name#1",
                           providerDescription: "description",
                           servers: [server],
                           providerId: 1,
                           logo: nil,
                           logoDark: nil,
                           homepage: "homepage",
                           isEnabled: true)]
    }

    private let activeDnsServer: [String: Any] = ["providerId": 1,
                                                  "serverId": "1"]

    private var activeCustomDnsServer: [String: Any] = ["providerId": 1,
                                                        "serverId": "100000"]

    private let error = NSError(domain: "test_error", code: 1, userInfo: nil)

    override func setUp() {
        resources = SharedResourcesMock()
        dnsProvidersManager = InAppDnsProvidersManagerMock()
        migration = DnsProtectionCustomProvidersMigrationHelper(resources: resources,
                                                    dnsProvidersManager: dnsProvidersManager)
        resources.sharedDefaults().removeObject(forKey: customProvidersKey)
        resources.sharedDefaults().removeObject(forKey: activeDnsServerKey)
    }

    // MARK: - getCustomDnsProviders method tests

    func testGetCustomDnsProvidersWithSuccess() {
        XCTAssertNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        createOldCustomProviders(providers: singleProvider)
        XCTAssertNotNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        let providers = migration.getCustomDnsProviders()
        XCTAssertEqual(providers.count, 1)
        XCTAssertEqual(providers.first?.name, "name#1")
        XCTAssertEqual(providers.first?.providerId, 1)
        XCTAssertEqual(providers.first?.server.serverId, 100_000)
        XCTAssertEqual(providers.first?.server.providerId, 1)
        XCTAssertEqual(providers.first?.server.name, "custom_server#1")
        XCTAssertEqual(providers.first?.server.upstream, "upstream#1")
    }

    func testGetCustomDnsProvidersWithManyProviders() {
        XCTAssertNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        createOldCustomProviders(providers: providers)
        XCTAssertNotNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        let providers = migration.getCustomDnsProviders()
        XCTAssertEqual(providers.count, 3)

        providers.enumerated().forEach {
            XCTAssertEqual($0.element.name, "provider#\(1 + $0.offset)")
            XCTAssertEqual($0.element.providerId, 1 + $0.offset)
            XCTAssertEqual($0.element.server.serverId, 100_000 + $0.offset)
            XCTAssertEqual($0.element.server.providerId, 1 + $0.offset)
            XCTAssertEqual($0.element.server.name, "custom_server#\($0.offset)")
            XCTAssertEqual($0.element.server.upstream, "upstream#\($0.offset)")
        }
    }

    func testGetCustomDnsProvidersWithEmptyArray() {
        XCTAssertNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        createOldCustomProviders(providers: [])
        XCTAssertNotNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        let providers = migration.getCustomDnsProviders()
        XCTAssertEqual(providers.count, 0)
    }

    func testGetCustomDnsProvidersWithCorruptedData() {
        XCTAssertNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        resources.sharedDefaults().set("some_corrupted_data".data(using: .utf8), forKey: "APDefaultsCustomDnsProviders")
        XCTAssertNotNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        let providers = migration.getCustomDnsProviders()
        XCTAssertEqual(providers.count, 0)
    }

    // MARK: - saveCustomDnsProviders method tests

    func testSaveCustomDnsProvidersWithSuccess() {
        createActiveDnsServer(activeServer: activeCustomDnsServer)
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        try! migration.saveCustomDnsProviders(providers)
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderCount, 3)
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderParametersList.count, 3)
        dnsProvidersManager.invokedAddCustomProviderParametersList.forEach {
            if $0.name == "provider#1" {
                XCTAssertEqual($0.selectAsCurrent, true)
            } else {
                XCTAssertEqual($0.selectAsCurrent, false)
            }
        }
    }

    func testSaveCustomDnsProvidersWithRangedProviders() {
        let providers = providersWithRangedIds
        createActiveDnsServer(activeServer: activeCustomDnsServer)
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        try! migration.saveCustomDnsProviders(providers)
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderCount, 3)
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderParametersList.count, 3)
        dnsProvidersManager.invokedAddCustomProviderParametersList.forEach {
            if $0.name == "provider#10" {
                XCTAssertEqual($0.selectAsCurrent, true)
            } else {
                XCTAssertEqual($0.selectAsCurrent, false)
            }
        }
    }

    func testSaveCustomDnsProvidersWithCorruptedActiveServerData() {
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        createActiveDnsServer(activeServer: [:])
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        try! migration.saveCustomDnsProviders(providers)
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderCount, 3)
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderParametersList.count, 3)
        dnsProvidersManager.invokedAddCustomProviderParametersList.forEach {
            XCTAssertEqual($0.selectAsCurrent, false)
        }
    }

    func testSaveCustomDnsProvidersWithEmptyProviders() {
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        createActiveDnsServer(activeServer: activeCustomDnsServer)
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        try! migration.saveCustomDnsProviders([])
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderCount, 0)
        XCTAssert(dnsProvidersManager.invokedAddCustomProviderParametersList.isEmpty)
    }

    func testSaveCustomDnsProvidersWithFailure() {
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        createActiveDnsServer(activeServer: activeCustomDnsServer)
        dnsProvidersManager.stubbedAddCustomProviderError = error
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        XCTAssertThrowsError(try migration.saveCustomDnsProviders(providers))
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderCount, 1)
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderParametersList.count, 1)
        dnsProvidersManager.invokedAddCustomProviderParametersList.forEach {
            XCTAssertEqual($0.selectAsCurrent, true)
        }
    }

    // MARK: - selectActiveDnsServer method tests

    func testSelectActiveDnsServerWithSuccess() {
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        createActiveDnsServer(activeServer: activeDnsServer)
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        XCTAssertEqual(dnsProvidersManager.invokedSelectProviderCount, 0)
        XCTAssertNil(resources.dnsActiveProtocols[1])
        dnsProvidersManager.stubbedAllProviders = metaDnsProvider
        try! migration.selectActiveDnsServer()
        XCTAssertEqual(dnsProvidersManager.invokedSelectProviderCount, 1)
        XCTAssertEqual(resources.dnsActiveProtocols[1], .dns)
    }

    func testSelectActiveDnsServerWithCustomServer() {
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        createActiveDnsServer(activeServer: activeCustomDnsServer)
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        XCTAssertEqual(dnsProvidersManager.invokedSelectProviderCount, 0)
        XCTAssertNil(resources.dnsActiveProtocols[1])
        try! migration.selectActiveDnsServer()
        XCTAssertEqual(dnsProvidersManager.invokedSelectProviderCount, 0)
        XCTAssertNil(resources.dnsActiveProtocols[1])
    }

    func testSelectActiveDnsServerWithMissedActiveDnsServer() {
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        XCTAssertEqual(dnsProvidersManager.invokedSelectProviderCount, 0)
        XCTAssertNil(resources.dnsActiveProtocols[1])
        try! migration.selectActiveDnsServer()
        XCTAssertEqual(dnsProvidersManager.invokedSelectProviderCount, 0)
        XCTAssertNil(resources.dnsActiveProtocols[1])
    }

    func testSelectActiveDnsServerWithFailure() {
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        createActiveDnsServer(activeServer: activeDnsServer)
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        XCTAssertEqual(dnsProvidersManager.invokedSelectProviderCount, 0)
        XCTAssertNil(resources.dnsActiveProtocols[1])
        dnsProvidersManager.stubbedAllProviders = metaDnsProvider
        dnsProvidersManager.stubbedSelectProviderError = error
        XCTAssertThrowsError(try migration.selectActiveDnsServer())
        XCTAssertEqual(dnsProvidersManager.invokedSelectProviderCount, 1)
        XCTAssertNil(resources.dnsActiveProtocols[1])
    }

    func testSelectActiveDnsServerWithMissedProvidersInProvidersManager() {
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        createActiveDnsServer(activeServer: activeDnsServer)
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        XCTAssertEqual(dnsProvidersManager.invokedSelectProviderCount, 0)
        XCTAssertNil(resources.dnsActiveProtocols[1])
        dnsProvidersManager.stubbedAllProviders = []
        try! migration.selectActiveDnsServer()
        XCTAssertEqual(dnsProvidersManager.invokedSelectProviderCount, 1)
        XCTAssertNil(resources.dnsActiveProtocols[1])
    }

    // MARK: - removeOldCustomDnsProvidersData method test

    func testRemoveOldCustomDnsProvidersDataWithSuccess() {
        XCTAssertNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        createOldCustomProviders(providers: singleProvider)
        createActiveDnsServer(activeServer: activeDnsServer)
        XCTAssertNotNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        migration.removeOldCustomDnsProvidersData()
        XCTAssertNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
    }

    func testRemoveOldCustomDnsProvidersDataWithMissedData() {
        XCTAssertNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        migration.removeOldCustomDnsProvidersData()
        XCTAssertNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
    }

    // MARK: - Private methods

    private func createOldCustomProviders(providers: [SDKDnsMigrationObsoleteCustomDnsProvider]) {
        NSKeyedUnarchiver.setClass(SDKDnsMigrationObsoleteCustomDnsProvider.self, forClassName: "DnsProviderInfo")
        NSKeyedUnarchiver.setClass(SDKDnsMigrationObsoleteCustomDnsServer.self, forClassName: "DnsServerInfo")
        let data = NSKeyedArchiver.archivedData(withRootObject: providers)
        resources.sharedDefaults().set(data, forKey: customProvidersKey)
    }

    private func createActiveDnsServer(activeServer: [String: Any]) {
        let data = try! JSONSerialization.data(withJSONObject: activeServer, options: [])
        resources.sharedDefaults().set(data, forKey: activeDnsServerKey)
    }
}
