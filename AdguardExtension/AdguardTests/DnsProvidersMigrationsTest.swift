import XCTest

class DnsProvidersMigrationsTest: XCTestCase {
    
    var resources: AESharedResourcesProtocol!
    var vpnManager: VpnManagerMock!
    var dnsProviders: DnsProvidersServiceProtocol?
    
    override func setUp() {
        resources = SharedResourcesMock()
        dnsProviders = DnsProvidersService(resources: resources)
        vpnManager = VpnManagerMock()
        dnsProviders?.vpnManager = vpnManager
    }
    
    func testReinitializeDnsProvidersObjectsAndSetIdsAndFlags() {
        fillCustomProviders()
        
        dnsProviders!.customProviders.forEach { provider in
            XCTAssertEqual(provider.providerId, 0)
            provider.servers?.forEach { XCTAssertNil($0.providerId) }
        }
        
        let currentServer = dnsProviders!.activeDnsServer
        currentServer?.providerId = 0
        XCTAssertEqual(currentServer?.upstreams, ["1.1.1.1"])
        XCTAssertEqual(currentServer?.name, "Test Provider 2")
        XCTAssertEqual(currentServer?.providerId, 0)
        
        // Save server like it was saved before 593 build
        let serverData = NSKeyedArchiver.archivedData(withRootObject: currentServer!)
        resources.sharedDefaults().setValue(serverData, forKey: "AEDefaultsActiveDnsServer")
        
        let dnsProvidersMigratable = dnsProviders as! DnsProvidersServiceMigratable
        dnsProvidersMigratable.reinitializeDnsProvidersObjectsAndSetIdsAndFlags(resources: resources)
        
        XCTAssertEqual(dnsProviders!.activeDnsServer?.upstreams, ["1.1.1.1"])
        XCTAssertEqual(dnsProviders!.activeDnsServer?.name, "Test Provider 2")
        XCTAssertEqual(dnsProviders!.activeDnsServer?.providerId, 2)
        
        for (index, provider) in dnsProviders!.customProviders.enumerated() {
            XCTAssertEqual(provider.providerId, index + 1)
            XCTAssert(provider.isCustomProvider)
            provider.servers?.forEach { XCTAssert($0.providerId == provider.providerId) }
        }
        
        // Check that data was saved properly after migration
        dnsProviders = nil
        dnsProviders = DnsProvidersService(resources: resources)
        
        XCTAssertEqual(dnsProviders!.activeDnsServer?.upstreams, ["1.1.1.1"])
        XCTAssertEqual(dnsProviders!.activeDnsServer?.name, "Test Provider 2")
        XCTAssertEqual(dnsProviders!.activeDnsServer?.providerId, 2)
        
        for (index, provider) in dnsProviders!.customProviders.enumerated() {
            XCTAssertEqual(provider.providerId, index + 1)
            XCTAssert(provider.isCustomProvider)
            provider.servers?.forEach { XCTAssert($0.providerId == provider.providerId) }
        }
    }
    
    // MARK: - test changeQuicCustomServersPort
    
    func testChangeQuicCustomServersPort() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        
        dnsProviders!.addCustomProvider(name: "Test Provider 1", upstream: "quic://doh.tiar.app") {
            group.leave()
        }
        dnsProviders!.addCustomProvider(name: "Test Provider 2", upstream: "quic://dns.adguard.com") {
            group.leave()
        }
        dnsProviders!.addCustomProvider(name: "Test Provider 3", upstream: "quic://doh.tiar.app:333") {
            group.leave()
        }
        
        // quic://doh.tiar.app encoded to sdns
        dnsProviders!.addCustomProvider(name: "Test Provider 4", upstream: "sdns://BAcAAAAAAAAAAAAMZG9oLnRpYXIuYXBw") {
            group.leave()
        }
        
        // quic://doh.tiar.app:382 encoded to sdns
        dnsProviders!.addCustomProvider(name: "Test Provider 5", upstream: "sdns://BAcAAAAAAAAAAAAQZG9oLnRpYXIuYXBwOjM4Mg") {
            group.leave()
        }
        
        group.wait()
        
        let tiarServer = dnsProviders!.customProviders.first!.servers!.first!
        dnsProviders!.activeDnsServer = DnsServerInfo(dnsProtocol: tiarServer.dnsProtocol, serverId: tiarServer.serverId, name: tiarServer.name, upstreams: tiarServer.upstreams, providerId: tiarServer.providerId)
        
        XCTAssertEqual(dnsProviders!.customProviders.count, 5)
        
        let dnsProvidersMigratable = dnsProviders as! DnsProvidersServiceMigratable
        dnsProvidersMigratable.changeQuicCustomServersPort()
        
        XCTAssertEqual(dnsProviders!.customProviders[0].name, "Test Provider 1")
        XCTAssertEqual(dnsProviders!.customProviders[0].servers![0].upstreams[0], "quic://doh.tiar.app:784")
        
        XCTAssertEqual(dnsProviders!.customProviders[1].name, "Test Provider 2")
        XCTAssertEqual(dnsProviders!.customProviders[1].servers![0].upstreams[0], "quic://dns.adguard.com:784")
        
        XCTAssertEqual(dnsProviders!.customProviders[2].name, "Test Provider 3")
        XCTAssertEqual(dnsProviders!.customProviders[2].servers![0].upstreams[0], "quic://doh.tiar.app:333")
        
        XCTAssertEqual(dnsProviders!.customProviders[3].name, "Test Provider 4")
        XCTAssertEqual(dnsProviders!.customProviders[3].servers![0].upstreams[0], "sdns://BAcAAAAAAAAAAAAQZG9oLnRpYXIuYXBwOjc4NA" /*quic://doh.tiar.app:784*/)
        
        XCTAssertEqual(dnsProviders!.customProviders[4].name, "Test Provider 5")
        XCTAssertEqual(dnsProviders!.customProviders[4].servers![0].upstreams[0], "sdns://BAcAAAAAAAAAAAAQZG9oLnRpYXIuYXBwOjM4Mg" /*quic://doh.tiar.app:382*/)
        
        // charck active server migrated
        XCTAssertEqual(dnsProviders!.activeDnsServer?.upstreams.first, "quic://doh.tiar.app:784")
        
        XCTAssert(vpnManager.updateCalled)
    }
    
    // MARK: - Private methods
    
    private func fillCustomProviders() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        dnsProviders!.addCustomProvider(name: "Test Provider 1", upstream: "8.8.8.8") {
            group.leave()
        }
        // This server will be active because it is the last server to be added
        dnsProviders!.addCustomProvider(name: "Test Provider 2", upstream: "1.1.1.1") {
            group.leave()
        }
        group.wait()
        
        /*
         In build 593 we've added 'isCustomProvider', 'providerId' for DnsProviderInfo and 'providerId' for DnsServerInfo
         Here we set parameters like as they we initialized before 593
         */
        dnsProviders!.customProviders.forEach { provider in
            provider.providerId = 0
            provider.servers?.forEach { $0.providerId = nil }
        }
    }
}
