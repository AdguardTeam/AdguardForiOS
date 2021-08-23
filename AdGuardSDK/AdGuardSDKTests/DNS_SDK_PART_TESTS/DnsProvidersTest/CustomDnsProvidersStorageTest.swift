import XCTest

class CustomDnsProvidersStorageTest: XCTestCase {
    
    var userDefaults: UserDefaultsStorageMock!
    var networkUtils: NetworkUtilsMock!
    var storage: CustomDnsProvidersStorageProtocol!
    
    override func setUp() {
        userDefaults = UserDefaultsStorageMock()
        networkUtils = NetworkUtilsMock()
        storage = CustomDnsProvidersStorage(userDefaults: userDefaults, networkUtils: networkUtils)
    }
    
    func testProviders() {
        let upstream = DnsUpstream(upstream: "1.1.1.1", protocol: .dns)
        let customProvider1 = CustomDnsProvider(name: "custom1",
                                                server: CustomDnsServer(upstreams: [upstream], providerId: 1, type: .dnscrypt, id: 100002, isEnabled: false),
                                                providerId: 1,
                                                isEnabled: false)
        let customProvider2 = CustomDnsProvider(name: "custom2",
                                                server: CustomDnsServer(upstreams: [upstream], providerId: 2, type: .dns, id: 100003, isEnabled: false),
                                                providerId: 2,
                                                isEnabled: false)
        
        setProviders([customProvider1, customProvider2])
        XCTAssertEqual(storage.providers as! [CustomDnsProvider], [customProvider1, customProvider2])
        
        setProviders([])
        XCTAssert(storage.providers.isEmpty)
    }
    
    // MARK: - addCustomProvider tests
    
    func testAddCustomProviderWithEmptyUpstreams() {
        XCTAssert(storage.providers.isEmpty)
        XCTAssertThrowsError(try storage.addCustomProvider(name: "name", upstreams: [])) { error in
            if case CustomDnsProvidersStorage.CustomDnsProvidersStorageError.emptyUpstreams = error {}
            else {
                XCTFail()
            }
        }
        XCTAssert(storage.providers.isEmpty)
    }
    
    func testAddCustomProviderWithWithInvalidUpstream() {
        XCTAssert(storage.providers.isEmpty)
        
        networkUtils.getProtocolResult = .error(CommonError.missingData)
        XCTAssertThrowsError(try storage.addCustomProvider(name: "name", upstreams: ["1.1.1.1"])) { error in
            if case CommonError.missingData = error {}
            else {
                XCTFail()
            }
        }
        
        XCTAssert(storage.providers.isEmpty)
    }
    
    func testAddCustomProviderWithDifferentProtocols() {
        networkUtils.getProtocolListResult = [DnsProtocol.dns, .doh].makeIterator()
        XCTAssertThrowsError(try storage.addCustomProvider(name: "name", upstreams: ["1.1.1.1", "https"])) { error in
            if case CustomDnsProvidersStorage.CustomDnsProvidersStorageError.differentDnsProtocols(upstreams: _) = error {}
            else {
                XCTFail()
            }
        }
        XCTAssert(storage.providers.isEmpty)
    }
    
    func testAddCustomProviderWithUnreachableUpstream() {
        networkUtils.upstreamIsValidResult = false
        XCTAssertThrowsError(try storage.addCustomProvider(name: "name", upstreams: ["1.1.1.1", "https"])) { error in
            if case CustomDnsProvidersStorage.CustomDnsProvidersStorageError.invalidUpstream(upstream: _) = error {}
            else {
                XCTFail()
            }
        }
        XCTAssert(storage.providers.isEmpty)
    }
    
    func testAddCustomProviderIdsOfNewProviders() {
        XCTAssert(storage.providers.isEmpty)
        let ids1 = try! storage.addCustomProvider(name: "name1", upstreams: ["1.1.1.1"])
        let ids2 = try! storage.addCustomProvider(name: "name2", upstreams: ["2.2.2.2"])
        
        XCTAssertEqual(ids1.providerId, 1)
        XCTAssertEqual(ids2.providerId, 2)
        
        XCTAssertEqual(ids1.serverId, 100001)
        XCTAssertEqual(ids2.serverId, 100002)
        
        XCTAssertEqual(storage.providers.count, 2)
        
        XCTAssertEqual(storage.providers[0].providerId, 1)
        XCTAssertEqual(storage.providers[1].providerId, 2)
        
        XCTAssertEqual(storage.providers[0].server.id, 100001)
        XCTAssertEqual(storage.providers[1].server.id, 100002)
    }
    
    func testAddCustomProviderWithSuccess() {
        XCTAssert(storage.providers.isEmpty)
        XCTAssertNoThrow(try storage.addCustomProvider(name: "name1", upstreams: ["1.1.1.1"]))
        XCTAssertNoThrow(try storage.addCustomProvider(name: "name2", upstreams: ["2.2.2.2"]))
        XCTAssertEqual(storage.providers.count, 2)
    }
    
    // MARK: - updateCustomProvider tests
    
    func testUpdateCustomProviderWithAbcentProvider() {
        XCTAssert(storage.providers.isEmpty)
        XCTAssertThrowsError(try storage.updateCustomProvider(withId: 1, newName: "newName", newUpstreams: ["1.1.1.1"])) { error in
            if case CustomDnsProvidersStorage.CustomDnsProvidersStorageError.providerAbsent(providerId: _) = error {}
            else {
                XCTFail()
            }
        }
        XCTAssert(storage.providers.isEmpty)
    }
    
    func testUpdateCustomProviderWithEmptyUpstreams() {
        let ids = try! storage.addCustomProvider(name: "name", upstreams: ["1.1.1.1"])
        XCTAssertEqual(storage.providers.count, 1)
        XCTAssertEqual(storage.providers[0].name, "name")
        XCTAssertEqual(storage.providers[0].server.upstreams, [DnsUpstream(upstream: "1.1.1.1", protocol: .dns)])
        
        XCTAssertThrowsError(try storage.updateCustomProvider(withId: ids.providerId, newName: "newName", newUpstreams: [])) { error in
            if case CustomDnsProvidersStorage.CustomDnsProvidersStorageError.emptyUpstreams = error {}
            else {
                XCTFail()
            }
        }
        
        XCTAssertEqual(storage.providers.count, 1)
        XCTAssertEqual(storage.providers[0].name, "name")
        XCTAssertEqual(storage.providers[0].server.upstreams, [DnsUpstream(upstream: "1.1.1.1", protocol: .dns)])
    }
    
    func testUpdateCustomProviderWithWithInvalidUpstream() {
        let ids = try! storage.addCustomProvider(name: "name", upstreams: ["1.1.1.1"])
        XCTAssertEqual(storage.providers.count, 1)
        XCTAssertEqual(storage.providers[0].name, "name")
        XCTAssertEqual(storage.providers[0].server.upstreams, [DnsUpstream(upstream: "1.1.1.1", protocol: .dns)])
        
        networkUtils.getProtocolResult = .error(CommonError.missingData)
        XCTAssertThrowsError(try storage.updateCustomProvider(withId: ids.providerId, newName: "newName", newUpstreams: ["2.2.2.2"])) { error in
            if case CommonError.missingData = error {}
            else {
                XCTFail()
            }
        }
        
        XCTAssertEqual(storage.providers.count, 1)
        XCTAssertEqual(storage.providers[0].name, "name")
        XCTAssertEqual(storage.providers[0].server.upstreams, [DnsUpstream(upstream: "1.1.1.1", protocol: .dns)])
    }
    
    func testUpdateCustomProviderWithDifferentProtocols() {
        let ids = try! storage.addCustomProvider(name: "name", upstreams: ["1.1.1.1"])
        XCTAssertEqual(storage.providers.count, 1)
        XCTAssertEqual(storage.providers[0].name, "name")
        XCTAssertEqual(storage.providers[0].server.upstreams, [DnsUpstream(upstream: "1.1.1.1", protocol: .dns)])
        
        networkUtils.getProtocolListResult = [DnsProtocol.dns, .doh].makeIterator()
        XCTAssertThrowsError(try storage.updateCustomProvider(withId: ids.providerId, newName: "newName", newUpstreams: ["2.2.2.2", "3.3.3.3"])) { error in
            if case CustomDnsProvidersStorage.CustomDnsProvidersStorageError.differentDnsProtocols(upstreams: _) = error {}
            else {
                XCTFail()
            }
        }
        
        XCTAssertEqual(storage.providers.count, 1)
        XCTAssertEqual(storage.providers[0].name, "name")
        XCTAssertEqual(storage.providers[0].server.upstreams, [DnsUpstream(upstream: "1.1.1.1", protocol: .dns)])
    }
    
    func testUpdateCustomProviderWithUnreachableUpstream() {
        let ids = try! storage.addCustomProvider(name: "name", upstreams: ["1.1.1.1"])
        XCTAssertEqual(storage.providers.count, 1)
        XCTAssertEqual(storage.providers[0].name, "name")
        XCTAssertEqual(storage.providers[0].server.upstreams, [DnsUpstream(upstream: "1.1.1.1", protocol: .dns)])
        
        networkUtils.upstreamIsValidResult = false
        XCTAssertThrowsError(try storage.updateCustomProvider(withId: ids.providerId, newName: "newName", newUpstreams: ["2.2.2.2", "3.3.3.3"])) { error in
            if case CustomDnsProvidersStorage.CustomDnsProvidersStorageError.invalidUpstream(upstream: _) = error {}
            else {
                XCTFail()
            }
        }
        
        XCTAssertEqual(storage.providers.count, 1)
        XCTAssertEqual(storage.providers[0].name, "name")
        XCTAssertEqual(storage.providers[0].server.upstreams, [DnsUpstream(upstream: "1.1.1.1", protocol: .dns)])
    }
    
    func testUpdateCustomProviderWithSuccess() {
        let ids1 = try! storage.addCustomProvider(name: "name1", upstreams: ["1.1.1.1"])
        XCTAssertEqual(storage.providers.count, 1)
        XCTAssertEqual(storage.providers[0].name, "name1")
        XCTAssertEqual(storage.providers[0].server.upstreams, [DnsUpstream(upstream: "1.1.1.1", protocol: .dns)])
        XCTAssertEqual(storage.providers[0].providerId, ids1.providerId)
        XCTAssertEqual(storage.providers[0].server.id, ids1.serverId)
        
        let ids2 = try! storage.addCustomProvider(name: "name2", upstreams: ["2.2.2.2"])
        XCTAssertEqual(storage.providers.count, 2)
        XCTAssertEqual(storage.providers[1].name, "name2")
        XCTAssertEqual(storage.providers[1].server.upstreams, [DnsUpstream(upstream: "2.2.2.2", protocol: .dns)])
        XCTAssertEqual(storage.providers[1].providerId, ids2.providerId)
        XCTAssertEqual(storage.providers[1].server.id, ids2.serverId)
        
        XCTAssertNoThrow(try storage.updateCustomProvider(withId: ids2.providerId, newName: "newName", newUpstreams: ["https"]))
        
        XCTAssertEqual(storage.providers.count, 2)
        XCTAssertEqual(storage.providers[0].name, "name1")
        XCTAssertEqual(storage.providers[0].server.upstreams, [DnsUpstream(upstream: "1.1.1.1", protocol: .dns)])
        XCTAssertEqual(storage.providers[0].providerId, ids1.providerId)
        XCTAssertEqual(storage.providers[0].server.id, ids1.serverId)
        
        XCTAssertEqual(storage.providers.count, 2)
        XCTAssertEqual(storage.providers[1].name, "newName")
        XCTAssertEqual(storage.providers[1].server.upstreams, [DnsUpstream(upstream: "https", protocol: .dns)])
        XCTAssertEqual(storage.providers[1].providerId, ids2.providerId)
        XCTAssertEqual(storage.providers[1].server.id, ids2.serverId)
    }
    
    // MARK: - removeCustomProvider tests
    
    func testRemoveCustomProviderWithMissingProvider() {
        XCTAssert(storage.providers.isEmpty)
        XCTAssertThrowsError(try storage.removeCustomProvider(withId: 1)) { error in
            if case CustomDnsProvidersStorage.CustomDnsProvidersStorageError.providerAbsent(providerId: _) = error {}
            else {
                XCTFail()
            }
        }
    }
    
    func testRemoveCustomProviderWithSuccess() {
        let providerId = 1
        let customProvider = CustomDnsProvider(name: "custom",
                                               server: CustomDnsServer(upstreams: [DnsUpstream(upstream: "1.1.1.1", protocol: .dns)], providerId: providerId, type: .dnscrypt, id: 100002, isEnabled: false),
                                               providerId: providerId,
                                               isEnabled: false)
        setProviders([customProvider])
        XCTAssertEqual(storage.providers as! [CustomDnsProvider], [customProvider])
        
        XCTAssertNoThrow(try storage.removeCustomProvider(withId: providerId))
        XCTAssert(storage.providers.isEmpty)
    }
    
    func testReset() {
        let _ = try! storage.addCustomProvider(name: "name1", upstreams: ["1.1.1.1"])
        let _ = try! storage.addCustomProvider(name: "name2", upstreams: ["2.2.2.2"])
        XCTAssertEqual(storage.providers.count, 2)
        
        XCTAssertNoThrow(try storage.reset())
        
        XCTAssert(storage.providers.isEmpty)
    }
    
    private func setProviders(_ providers: [CustomDnsProvider]) {
        let key = "DnsAdGuardSDK.customProvidersKey"
        let encoder = JSONEncoder()
        let providersData = try! encoder.encode(providers)
        userDefaults.storage.set(providersData, forKey: key)
    }
}
