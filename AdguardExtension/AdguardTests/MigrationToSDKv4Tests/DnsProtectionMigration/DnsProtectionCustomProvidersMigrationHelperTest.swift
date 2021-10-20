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

    private let activeCustomDnsServer: [String: Any] = ["providerId": 1,
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
        XCTAssertNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        createOldCustomProviders(providers: singleProvider)
        createActiveDnsServer(activeServer: activeCustomDnsServer)
        XCTAssertNotNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        let providers = migration.getCustomDnsProviders()
        XCTAssertEqual(providers.count, 1)
        try! migration.saveCustomDnsProviders(providers)
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderCount, 1)
        // TODO: Dont forget this
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderParameters?.selectAsCurrent, true)
    }

    func testSaveCustomDnsProvidersWithCorruptedActiveServerData() {
        XCTAssertNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        createOldCustomProviders(providers: singleProvider)
        createActiveDnsServer(activeServer: [:])
        XCTAssertNotNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        let providers = migration.getCustomDnsProviders()
        XCTAssertEqual(providers.count, 1)
        try! migration.saveCustomDnsProviders(providers)
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderCount, 1)
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderParameters?.selectAsCurrent, false)
    }

    func testSaveCustomDnsProvidersWithEmptyProviders() {
        XCTAssertNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        createOldCustomProviders(providers: singleProvider)
        createActiveDnsServer(activeServer: activeCustomDnsServer)
        XCTAssertNotNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        let providers = migration.getCustomDnsProviders()
        XCTAssertEqual(providers.count, 1)
        try! migration.saveCustomDnsProviders([])
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderCount, 0)
        XCTAssertNil(dnsProvidersManager.invokedAddCustomProviderParameters?.selectAsCurrent)
    }

    func testSaveCustomDnsProvidersWithFailure() {
        XCTAssertNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        createOldCustomProviders(providers: singleProvider)
        createActiveDnsServer(activeServer: activeCustomDnsServer)
        dnsProvidersManager.stubbedAddCustomProviderError = error
        XCTAssertNotNil(resources.sharedDefaults().object(forKey:customProvidersKey))
        XCTAssertNotNil(resources.sharedDefaults().object(forKey: activeDnsServerKey))
        let providers = migration.getCustomDnsProviders()
        XCTAssertEqual(providers.count, 1)
        XCTAssertThrowsError(try migration.saveCustomDnsProviders(providers))
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderCount, 1)
        XCTAssertEqual(dnsProvidersManager.invokedAddCustomProviderParameters?.selectAsCurrent, true)
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
        let data = NSKeyedArchiver.archivedData(withRootObject: providers)
        resources.sharedDefaults().set(data, forKey: customProvidersKey)
    }

    private func createActiveDnsServer(activeServer: [String: Any]) {
        let data = try! JSONSerialization.data(withJSONObject: activeServer, options: [])
        resources.sharedDefaults().set(data, forKey: activeDnsServerKey)
    }
}
