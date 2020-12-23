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

class NativeProvidersServiceTest: XCTestCase {
    
    func testInitialization() {
        let dnsProviders = DnsProvidersServiceMock(allProviders: generateProviders())
        let nativeProviders = NativeProvidersService(dnsProvidersService: dnsProviders, networkSettingsService: NetworkSettingsServiceMock(), resources: SharedResourcesMock(), configuration: ConfigurationServiceMock())
        
        let providersToCheck = nativeProviders.providers
        let supportedProtocols = NativeProvidersService.supportedProtocols
        providersToCheck.forEach { provider in
            let servers = provider.servers!
            servers.forEach { XCTAssert(supportedProtocols.contains($0.dnsProtocol)) }
            XCTAssertFalse(servers.isEmpty)
        }
    }
    
    // MARK: - Private methods
    
    private func generateProviders() -> [DnsProviderInfo] {
        var adguardProviders: [DnsProviderInfo] = []
        for i in 0..<10 {
            let providerId = i
            let servers = generateServers(providerId: providerId)
            let protocols = servers.map { $0.dnsProtocol }
            let provider = DnsProviderInfo(name: "name\(i)", logo: "logo\(i)", logoDark: "logoDark\(i)", summary: "summary\(i)", protocols: protocols, features: [], website: "website\(i)", servers: servers, providerId: providerId)
            adguardProviders.append(provider)
        }
        return adguardProviders
    }
    
    private func generateServers(providerId: Int) -> [DnsServerInfo] {
        let dnsProtocols = DnsProtocol.allCases.shuffled()
        let serverProtocolsNumber = Int.random(in: 0..<dnsProtocols.count)
        
        var servers: [DnsServerInfo] = []
        for i in 0..<serverProtocolsNumber {
            let dnsProtocol = dnsProtocols[i]
            let upstream = [generateUpstream(forProtocol: dnsProtocol)]
            let server = DnsServerInfo(dnsProtocol: dnsProtocol, serverId: "id\(i)", name: "serverName\(i)", upstreams: upstream, providerId: providerId)
            servers.append(server)
        }
        return servers
    }
    
    private func generateUpstream(forProtocol dnsProtocol: DnsProtocol) -> String {
        if let prefix = DnsProtocol.prefixByProtocol[dnsProtocol] {
            return prefix + String.randomString(length: 10)
        }
        
        // Regular type
        let number = Int.random(in: 1...9)
        return "\(number).\(number).\(number).\(number)"
    }
}
