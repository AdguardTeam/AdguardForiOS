import XCTest

class DnsProvidersManagerTest: XCTestCase {
    
    var configuration: DnsConfigurationMock!
    var userDefaults: UserDefaultsStorageMock!
    var customProviders: CustomDnsProvidersStorageMock!
    var providersManager: DnsProvidersManagerProtocol!
    
    override func setUp() {
        configuration = DnsConfigurationMock()
        userDefaults = UserDefaultsStorageMock()
        customProviders = CustomDnsProvidersStorageMock()
    }
    
    // MARK: - Initialization test
    
    func testInitializationWithoutCustomProvidersWithAdguardImplementation() {
        configuration.dnsImplementation = .adguard
        initialize()
        checkVariables(custom: 0, predefined: 11, servers: 36, providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId, dnsImp: .adguard)
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
    }
    
    func testInitializationWithCustomProvidersWithAdguardImplementation() {
        configuration.dnsImplementation = .adguard
        
        let customServer = CustomDnsServer(upstreams: [], providerId: 1, type: .dnscrypt, id: 10, isEnabled: true)
        let customProvider = CustomDnsProvider(name: "name", server: customServer, providerId: 1, isEnabled: true)
        customProviders.providers = [customProvider]
        initialize()

        checkVariables(custom: 1, predefined: 11, servers: 37, providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId, dnsImp: .adguard)
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
    }
    
    func testInitializationWithoutCustomProvidersWithNativeImplementation() {
        configuration.dnsImplementation = .native
        initialize()
        checkVariables(custom: 0, predefined: 10, servers: 26, providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId, dnsImp: .native)
        checkEnabledProvider(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
    }
    
    func testInitializationWithCustomProvidersWithNativeImplementation() {
        configuration.dnsImplementation = .native
        let customServer = CustomDnsServer(upstreams: [], providerId: 1, type: .dnscrypt, id: 10, isEnabled: true)
        let customProvider = CustomDnsProvider(name: "name", server: customServer, providerId: 1, isEnabled: true)
        customProviders.providers = [customProvider]
        initialize()
        
        checkVariables(custom: 0, predefined: 10, servers: 26, providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId, dnsImp: .native)
        checkEnabledProvider(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
    }
    
    // MARK: - test dnsImplementationChanged
    
    func testDnsImplementationChangedFromNativeToAdguardWithSystemDefaultActive() {
        let activeDns = DnsProvidersManager.ActiveDnsInfo(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
        set(activeDns: activeDns)
        configuration.dnsImplementation = .native
        initialize()
        
        checkVariables(custom: 0, predefined: 10, servers: 26, providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId, dnsImp: .native)
        checkEnabledProvider(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
        
        configuration.dnsImplementation = .adguard
        providersManager.dnsImplementationChanged()
        
        checkVariables(custom: 0, predefined: 11, servers: 36, providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId, dnsImp: .adguard)
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
    }
    
    func testDnsImplementationChangedFromAdguardToNative() {
        let activeDns = DnsProvidersManager.ActiveDnsInfo(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
        set(activeDns: activeDns)
        configuration.dnsImplementation = .adguard
        initialize()
        
        checkVariables(custom: 0, predefined: 11, servers: 36, providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId, dnsImp: .adguard)
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
        
        configuration.dnsImplementation = .native
        providersManager.dnsImplementationChanged()
        
        checkVariables(custom: 0, predefined: 10, servers: 26, providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId, dnsImp: .adguard)
        checkEnabledProvider(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
    }
    
    func testDnsImplementationChangedFromNativeToAdguardWithAdGuardDohActive() {
        let activeDns = DnsProvidersManager.ActiveDnsInfo(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
        set(activeDns: activeDns)
        configuration.dnsImplementation = .native
        initialize()
        
        checkVariables(custom: 0, predefined: 10, servers: 26, providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId, dnsImp: .native)
        checkEnabledProvider(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
        
        configuration.dnsImplementation = .adguard
        providersManager.dnsImplementationChanged()
        
        checkVariables(custom: 0, predefined: 11, servers: 36, providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId, dnsImp: .adguard)
        checkEnabledProvider(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
    }
    
    func testDnsImplementationChangedFromAdguardToNativeWithCustomDnsCryptActive() {
        let providerId = 1
        let serverId = 100000
        let customServer = CustomDnsServer(upstreams: [], providerId: providerId, type: .dnscrypt, id: serverId, isEnabled: true)
        let customProvider = CustomDnsProvider(name: "name", server: customServer, providerId: providerId, isEnabled: true)
        customProviders.providers = [customProvider]
        
        let activeDns = DnsProvidersManager.ActiveDnsInfo(providerId: providerId, serverId: serverId)
        set(activeDns: activeDns)
        
        configuration.dnsImplementation = .adguard
        initialize()
        
        checkVariables(custom: 1, predefined: 11, servers: 37, providerId: providerId, serverId: serverId, dnsImp: .adguard)
        checkEnabledProvider(providerId: providerId, serverId: serverId)
        
        configuration.dnsImplementation = .native
        providersManager.dnsImplementationChanged()
        
        checkVariables(custom: 0, predefined: 10, servers: 26, providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId, dnsImp: .native)
        checkEnabledProvider(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
    }
    
    // MARK: - test selectProvider
    
    func testSelectProviderWithInvalidProviderWithAdguardImplementation() {
        configuration.dnsImplementation = .adguard
        initialize()
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
        
        XCTAssertThrowsError(try providersManager.selectProvider(withId: 900, serverId: 100)) { error in
            if case DnsProvidersManager.DnsProviderError.invalidProvider(providerId: _) = error {}
            else {
                XCTFail()
            }
        }
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
    }
    
    func testSelectProviderWithInvalidProviderWithNativeImplementation() {
        configuration.dnsImplementation = .native
        initialize()
        
        checkEnabledProvider(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
        
        // AdGuard DNS dnscrypt
        XCTAssertThrowsError(try providersManager.selectProvider(withId: 10001, serverId: 2)) { error in
            if case DnsProvidersManager.DnsProviderError.invalidCombination(providerId: _, serverId: _) = error {}
            else {
                XCTFail()
            }
        }
        checkEnabledProvider(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
    }
    
    func testSelectProviderWithInvalidCombinationOfProviderAndServerWithAdguardImplementation() {
        configuration.dnsImplementation = .adguard
        initialize()
        
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
        
        // AdGuard DNS dnscrypt
        XCTAssertThrowsError(try providersManager.selectProvider(withId: 10001, serverId: 10)) { error in
            if case DnsProvidersManager.DnsProviderError.invalidCombination(providerId: _, serverId: _) = error {}
            else {
                XCTFail()
            }
        }
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
    }
    
    func testSelectProviderWithInvalidCombinationOfProviderAndServerWithNativeImplementation() {
        configuration.dnsImplementation = .native
        initialize()
        
        checkEnabledProvider(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
        
        // AdGuard DNS dnscrypt
        XCTAssertThrowsError(try providersManager.selectProvider(withId: 10001, serverId: 10)) { error in
            if case DnsProvidersManager.DnsProviderError.invalidCombination(providerId: _, serverId: _) = error {}
            else {
                XCTFail()
            }
        }
        
        checkEnabledProvider(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
    }
    
    func testSelectProviderWithSuccessWithAdguardImplementation() {
        configuration.dnsImplementation = .adguard
        initialize()
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
        
        // Cisco OpenDNS
        XCTAssertNoThrow(try providersManager.selectProvider(withId: 10015, serverId: 15))
        
        checkEnabledProvider(providerId: 10015, serverId: 15)
    }
    
    func testSelectProviderWithSuccessWithNativeImplementation() {
        configuration.dnsImplementation = .native
        initialize()
        checkEnabledProvider(providerId: PredefinedDnsProvider.adguardDnsProviderId, serverId: PredefinedDnsServer.adguardDohServerId)
        
        // Cisco OpenDNS
        XCTAssertNoThrow(try providersManager.selectProvider(withId: 10015, serverId: 15))
        
        checkEnabledProvider(providerId: 10015, serverId: 15)
    }

    // MARK: - test addCustomProvider
    
    func testAddCustomProviderWithStorageError() {
        customProviders.addCustomProviderResult = .error(CommonError.missingData)
        initialize()
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
        
        XCTAssertThrowsError(try providersManager.addCustomProvider(name: "name", upstreams: [], selectAsCurrent: false)) { error in
            if case CommonError.missingData = error {}
            else {
                XCTFail()
            }
        }
        
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
    }
    
    func testAddCustomProviderWithSelectAsCurrent() {
        let upstream = DnsUpstream(upstream: "1.1.1.1", protocol: .dns)
        let customServer = CustomDnsServer(upstreams: [upstream], providerId: 1, type: .dnscrypt, id: 100010, isEnabled: true)
        let customProvider = CustomDnsProvider(name: "name", server: customServer, providerId: 1, isEnabled: true)
        customProviders.providers = [customProvider]
        customProviders.addCustomProviderResult = .success((1, 100010))
        initialize()
        checkVariables(custom: 1, predefined: 11, servers: 37, providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId, dnsImp: .adguard)
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
        
        XCTAssertNoThrow(try providersManager.addCustomProvider(name: "name", upstreams: ["1.1.1.1"], selectAsCurrent: true))
        
        checkVariables(custom: 1, predefined: 11, servers: 37, providerId: 1, serverId: 100010, dnsImp: .adguard)
        checkEnabledProvider(providerId: 1, serverId: 100010)
    }
    
    func testAddCustomProviderWithoutSelectAsCurrent() {
        let upstream = DnsUpstream(upstream: "1.1.1.1", protocol: .dns)
        let customServer = CustomDnsServer(upstreams: [upstream], providerId: 1, type: .dnscrypt, id: 100010, isEnabled: true)
        let customProvider = CustomDnsProvider(name: "name", server: customServer, providerId: 1, isEnabled: true)
        customProviders.providers = [customProvider]
        customProviders.addCustomProviderResult = .success((1, 100010))
        initialize()
        checkVariables(custom: 1, predefined: 11, servers: 37, providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId, dnsImp: .adguard)
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
        
        XCTAssertNoThrow(try providersManager.addCustomProvider(name: "name", upstreams: ["1.1.1.1"], selectAsCurrent: false))
        
        checkVariables(custom: 1, predefined: 11, servers: 37, providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId, dnsImp: .adguard)
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
    }
    
    // MARK: - test updateCustomProvider
    
    func testUpdateCustomProviderWithStorageError() {
        let upstream = DnsUpstream(upstream: "1.1.1.1", protocol: .dns)
        let customServer = CustomDnsServer(upstreams: [upstream], providerId: 1, type: .dnscrypt, id: 100010, isEnabled: false)
        let customProvider = CustomDnsProvider(name: "name", server: customServer, providerId: 1, isEnabled: false)
        customProviders.providers = [customProvider]
        customProviders.updateCustomProviderError = CommonError.missingData
        initialize()
        
        var pr = providersManager.allProviders.first(where: { $0.providerId == 1 })!
        XCTAssertEqual(pr.name, "name")
        
        XCTAssertThrowsError(try providersManager.updateCustomProvider(withId: 1, newName: "newName", newUpstreams: ["https"], selectAsCurrent: true)) { error in
            if case CommonError.missingData = error {}
            else {
                XCTFail()
            }
        }
        
        pr = providersManager.allProviders.first(where: { $0.providerId == 1 })!
        XCTAssertEqual(pr.name, "name")
    }
    
    func testUpdateCustomProviderWithSuccessWithoutSelectAsCurrent() {
        let upstream = DnsUpstream(upstream: "1.1.1.1", protocol: .dns)
        let customServer = CustomDnsServer(upstreams: [upstream], providerId: 1, type: .dnscrypt, id: 100010, isEnabled: false)
        let customProvider = CustomDnsProvider(name: "name", server: customServer, providerId: 1, isEnabled: false)
        customProviders.providers = [customProvider]
        initialize()
        
        var pr = providersManager.allProviders.first(where: { $0.providerId == 1 })!
        XCTAssertEqual(pr.name, "name")
        
        // Imitate provider update
        let updatedUpstream = DnsUpstream(upstream: "https", protocol: .doh)
        let updatedServer = CustomDnsServer(upstreams: [updatedUpstream], providerId: 1, type: .dnscrypt, id: 100010, isEnabled: false)
        let updatedProvider = CustomDnsProvider(name: "newName", server: updatedServer, providerId: 1, isEnabled: false)
        customProviders.providers = [updatedProvider]
        
        XCTAssertNoThrow(try providersManager.updateCustomProvider(withId: 1, newName: "newName", newUpstreams: ["https"], selectAsCurrent: false))
        
        pr = providersManager.allProviders.first(where: { $0.providerId == 1 })!
        XCTAssertEqual(pr.name, "newName")
    }
    
    func testUpdateCustomProviderWithSuccessWithSelectAsCurrent() {
        let upstream = DnsUpstream(upstream: "1.1.1.1", protocol: .dns)
        let customServer = CustomDnsServer(upstreams: [upstream], providerId: 1, type: .dnscrypt, id: 100010, isEnabled: false)
        let customProvider = CustomDnsProvider(name: "name", server: customServer, providerId: 1, isEnabled: false)
        customProviders.providers = [customProvider]
        initialize()
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
        
        var pr = providersManager.allProviders.first(where: { $0.providerId == 1 })!
        XCTAssertEqual(pr.name, "name")
        
        // Imitate provider update
        let updatedUpstream = DnsUpstream(upstream: "https", protocol: .doh)
        let updatedServer = CustomDnsServer(upstreams: [updatedUpstream], providerId: 1, type: .dnscrypt, id: 100010, isEnabled: false)
        let updatedProvider = CustomDnsProvider(name: "newName", server: updatedServer, providerId: 1, isEnabled: false)
        customProviders.providers = [updatedProvider]
        
        XCTAssertNoThrow(try providersManager.updateCustomProvider(withId: 1, newName: "newName", newUpstreams: ["https"], selectAsCurrent: true))
        
        pr = providersManager.allProviders.first(where: { $0.providerId == 1 })!
        checkEnabledProvider(providerId: 1, serverId: 100010)
        XCTAssertEqual(pr.name, "newName")
    }
    
    // MARK: - test removeCustomProvider
    
    func testRemoveCustomProviderWithStorageError() {
        customProviders.removeCustomProviderError = CommonError.missingData
        initialize()
        
        XCTAssertThrowsError(try providersManager.removeCustomProvider(withId: 1)) { error in
            if case CommonError.missingData = error {}
            else {
                XCTFail()
            }
        }
    }
    
    func testRemoveCustomProviderWhenItIsActive() {
        let upstream = DnsUpstream(upstream: "1.1.1.1", protocol: .dns)
        let customServer = CustomDnsServer(upstreams: [upstream], providerId: 1, type: .dnscrypt, id: 100010, isEnabled: false)
        let customProvider = CustomDnsProvider(name: "name", server: customServer, providerId: 1, isEnabled: false)
        customProviders.providers = [customProvider]
        
        let activeDns = DnsProvidersManager.ActiveDnsInfo(providerId: 1, serverId: 100010)
        set(activeDns: activeDns)
        initialize()
        
        checkVariables(custom: 1, predefined: 11, servers: 37, providerId: 1, serverId: 100010, dnsImp: .adguard)
        checkEnabledProvider(providerId: 1, serverId: 100010)
        
        // Imitate provider removal
        customProviders.providers = []
        
        XCTAssertNoThrow(try providersManager.removeCustomProvider(withId: 1))
        
        checkVariables(custom: 0, predefined: 11, servers: 36, providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId, dnsImp: .adguard)
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
    }
    
    func testRemoveCustomProviderWhenItIsNotActive() {
        let upstream = DnsUpstream(upstream: "1.1.1.1", protocol: .dns)
        let customServer = CustomDnsServer(upstreams: [upstream], providerId: 1, type: .dnscrypt, id: 100010, isEnabled: false)
        let customProvider = CustomDnsProvider(name: "name", server: customServer, providerId: 1, isEnabled: false)
        customProviders.providers = [customProvider]
        
        let activeDns = DnsProvidersManager.ActiveDnsInfo(providerId: 10012, serverId: 12)
        set(activeDns: activeDns)
        initialize()
        
        checkVariables(custom: 1, predefined: 11, servers: 37, providerId: 10012, serverId: 12, dnsImp: .adguard)
        checkEnabledProvider(providerId: 10012, serverId: 12)
        
        // Imitate provider removal
        customProviders.providers = []
        
        XCTAssertNoThrow(try providersManager.removeCustomProvider(withId: 1))
        
        checkVariables(custom: 0, predefined: 11, servers: 36, providerId: 10012, serverId: 12, dnsImp: .adguard)
        checkEnabledProvider(providerId: 10012, serverId: 12)
    }

    // MARK: - test reset
    
    func testReset() {
        let activeDns = DnsProvidersManager.ActiveDnsInfo(providerId: 10012, serverId: 12)
        set(activeDns: activeDns)
        initialize()
        
        try! providersManager.reset()
        XCTAssertEqual(customProviders.resetCalledCount, 1)
        
        checkVariables(custom: 0, predefined: 11, servers: 36, providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId, dnsImp: .adguard)
        checkEnabledProvider(providerId: PredefinedDnsProvider.systemDefaultProviderId, serverId: PredefinedDnsServer.systemDefaultServerId)
    }
    
    // MARK: - Private methods
    
    private func initialize() {
        let providers = try! PredefinedDnsProvidersDecoder(currentLanguage: "en", bundle: Bundle(for: type(of: self)))
        providersManager = DnsProvidersManager(configuration: configuration,
                                               userDefaults: userDefaults,
                                               customProvidersStorage: customProviders,
                                               predefinedProviders: providers)
    }
    
    private func checkVariables(custom: Int, predefined: Int, servers: Int, providerId: Int, serverId: Int, dnsImp: DnsImplementation) {
        XCTAssertEqual(providersManager.customProviders.count, custom)
        XCTAssertEqual(providersManager.predefinedProviders.count, predefined)
        XCTAssertEqual(providersManager.allProviders.count, custom + predefined)
        XCTAssertEqual(providersManager.activeDnsProvider.providerId, providerId)
        XCTAssertEqual(providersManager.activeDnsServer.id, serverId)
        
        let dnsServers = providersManager.allProviders.flatMap { $0.dnsServers }
        XCTAssertEqual(dnsServers.count, servers)
        
        dnsServers.forEach {
            XCTAssert(dnsImp.supportedProtocols.contains($0.type))
            if dnsImp == .native {
                XCTAssertNotEqual($0.providerId, PredefinedDnsProvider.systemDefaultProviderId)
                XCTAssertNotEqual($0.id, PredefinedDnsServer.systemDefaultServerId)
            }
        }
    }
    
    private func checkEnabledProvider(providerId: Int, serverId: Int) {
        providersManager.allProviders.forEach {
            XCTAssertEqual($0.isEnabled, $0.providerId == providerId)
            $0.dnsServers.forEach { server in
                XCTAssertEqual(server.isEnabled, server.id == serverId)
            }
        }
    }
    
    private func set(activeDns: DnsProvidersManager.ActiveDnsInfo) {
        let encoder = JSONEncoder()
        let infoData = try! encoder.encode(activeDns)
        userDefaults.storage.setValue(infoData, forKey: "DnsAdGuardSDK.activeDnsInfoKey")
    }
}
