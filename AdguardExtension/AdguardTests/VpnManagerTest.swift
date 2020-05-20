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

import XCTest
import NetworkExtension

class ProviderMock: NETunnelProviderManager {
    class override func loadAllFromPreferences(completionHandler: @escaping ([NETunnelProviderManager]?, Error?) -> Void) {
        loadCalled = true
        completionHandler(savedProviders, nil)
    }
    
    override func saveToPreferences(completionHandler: ((Error?) -> Void)? = nil) {
        ProviderMock.saveCalled = true
        if !ProviderMock.savedProviders.contains(self) {
            ProviderMock.savedProviders.append(self)
        }
        completionHandler?(ProviderMock.saveError)
    }
    
    override func removeFromPreferences(completionHandler: ((Error?) -> Void)? = nil) {
        ProviderMock.removeCalled = true
        ProviderMock.savedProviders.removeAll{ $0 == self }
        completionHandler?(nil)
    }
    
    static var loadCalled = false
    static var saveCalled = false
    static var removeCalled = false
    static var saveError: Error?
    static var savedProviders: [NETunnelProviderManager] = []
    
    class func reset() {
        loadCalled = false
        saveCalled = false
        removeCalled = false
        saveError = nil
        savedProviders = []
    }
}

class VpnManagerTest: XCTestCase {

    var vpnManager: VpnManager!
    var dnsProviders: DnsProvidersServiceProtocol = DnsProvidersServiceMock()
    
    override func setUp() {
        vpnManager = VpnManager(resources: SharedResourcesMock(), configuration: ConfigurationServiceMock(), networkSettings: NetworkSettingsService(resources: SharedResourcesMock()), dnsProviders: dnsProviders)
        
        vpnManager.providerManagerType = ProviderMock.self
        
        let group = DispatchGroup()
        group.enter()
        vpnManager.checkVpnInstalled { _ in
            group.leave()
        }
        group.wait()
        
        ProviderMock.reset()
    }
    
    func testInstall() {
        
        let expectation = XCTestExpectation()
        
        vpnManager.installVpnConfiguration { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        
        XCTAssertTrue(ProviderMock.loadCalled)
        XCTAssertTrue(ProviderMock.saveCalled)
    }
    
    func testInstallError() {
        
        let expectation = XCTestExpectation()
        
        ProviderMock.saveError = NSError(domain: "err", code: 0, userInfo: nil)
        
        vpnManager.installVpnConfiguration { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testOverwite() {
        
        let expectation = XCTestExpectation()
        
        let oldProvider = ProviderMock()
        ProviderMock.savedProviders = [oldProvider]
        
        vpnManager.installVpnConfiguration { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        
        XCTAssertTrue(ProviderMock.loadCalled)
        XCTAssertTrue(ProviderMock.removeCalled)
        XCTAssertTrue(ProviderMock.saveCalled)
        
        XCTAssertTrue(ProviderMock.savedProviders.count == 1)
        XCTAssertNotEqual(oldProvider, ProviderMock.savedProviders.first)
    }
    
    func testVpnInstalled() {
        
        ProviderMock.savedProviders = [ProviderMock()]
        
        vpnManager = VpnManager(resources: SharedResourcesMock(), configuration: ConfigurationServiceMock(), networkSettings: NetworkSettingsService(resources: SharedResourcesMock()), dnsProviders: DnsProvidersServiceMock())
        
        vpnManager.providerManagerType = ProviderMock.self
        
        let group = DispatchGroup()
        group.enter()
        vpnManager.checkVpnInstalled { _ in
            group.leave()
        }
        
        group.wait()
                
        XCTAssertTrue(vpnManager.vpnInstalled)
    }
    
    func testManyConfigurations(){
        
        let expectation = XCTestExpectation()
        
        ProviderMock.savedProviders = [ProviderMock(), ProviderMock(), ProviderMock()]
        vpnManager.updateSettings { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(ProviderMock.savedProviders.count == 1)
    }
    
    func testMigration() {
        
        // set old configuration settings in provider
        let dnsProviders = DnsProvidersServiceMock()
        let oldProvider =  createOldProvider()
        ProviderMock.savedProviders = [oldProvider]
        
        // check there in no settings, saved in shared defaults
        let resources = SharedResourcesMock()
        XCTAssertNil(resources.sharedDefaults().object(forKey: AEDefaultsVPNTunnelMode))
        XCTAssertNil(resources.sharedDefaults().object(forKey: AEDefaultsRestartByReachability))
        XCTAssertNil(dnsProviders.activeDnsServer)
        
        // init vpnManager
        vpnManager = VpnManager(resources: resources, configuration: ConfigurationServiceMock(), networkSettings: NetworkSettingsService(resources: resources), dnsProviders: dnsProviders)
        
        vpnManager.providerManagerType = ProviderMock.self
        
        // checkVpnInstalled() method must force migration
        
        let group = DispatchGroup()
        group.enter()
        vpnManager.migrateOldVpnSettings { _ in
            group.leave()
        }
            
        group.wait()
        
        // check migration succeded
        
        let tunnelMode = resources.sharedDefaults().object(forKey: AEDefaultsVPNTunnelMode) as? UInt
        let restartByReachability = resources.sharedDefaults().object(forKey: AEDefaultsRestartByReachability) as? Bool
        guard let server = dnsProviders.activeDnsServer else {
            XCTFail()
            return
        }
        
        XCTAssertNotNil(tunnelMode)
        XCTAssertNotNil(restartByReachability)
        
        XCTAssert(tunnelMode == APVpnManagerTunnelModeFull.rawValue)
        XCTAssert(restartByReachability == true)
        
        XCTAssert(server.name == "Test server")
        XCTAssert(server.dnsProtocol == .dnsCrypt)
        XCTAssert(server.serverId == "test-server")
        XCTAssert(server.upstreams == ["0.0.0.0"])
    }
    
    private func createOldProvider()->ProviderMock {
        
        let configuration = NETunnelProviderProtocol()
        
        let serverToSave = DnsServerInfo(dnsProtocol: .dnsCrypt, serverId: "test-server", name: "Test server", upstreams: ["0.0.0.0"], anycast: true)
        let serverDataToSave = NSKeyedArchiver.archivedData(withRootObject: serverToSave)
        configuration.providerConfiguration = [
            APVpnManagerParameterTunnelMode: APVpnManagerTunnelModeFull.rawValue,
            APVpnManagerRestartByReachability: true,
            APVpnManagerParameterRemoteDnsServer: serverDataToSave
        ]
        
        let provider = ProviderMock()
        provider.protocolConfiguration = configuration
        
        return provider
    }
}
