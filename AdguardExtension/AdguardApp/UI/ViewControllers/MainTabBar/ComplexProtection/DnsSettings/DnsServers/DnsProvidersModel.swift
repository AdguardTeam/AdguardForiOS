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

import Foundation

protocol DnsProvidersModelProtocol {
    var providers: [DnsProviderInfo] { get }
    
    func setServerAsActive(_ server: DnsServerInfo?, serverName: String?)
}

class DnsProvidersModel: DnsProvidersModelProtocol {
    
    // MARK: - Public properties
    var providers: [DnsProviderInfo] {
        if #available(iOS 14.0, *), resources.dnsImplementation == .native {
            return nativeProvidersService.providers
        } else {
            return dnsProvidersService.allProviders
        }
    }
    
    // MARK: - Private properties
    
    
    // MARK: - Services
    private let dnsProvidersService: DnsProvidersServiceProtocol
    private let nativeProvidersService: NativeProvidersServiceProtocol
    private let resources: AESharedResourcesProtocol
    private let vpnManager: VpnManagerProtocol
    
    // MARK: - Initializer
    required init (dnsProvidersService: DnsProvidersServiceProtocol,
                   nativeProvidersService: NativeProvidersServiceProtocol,
                   resources: AESharedResourcesProtocol,
                   vpnManager: VpnManagerProtocol) {
        self.dnsProvidersService = dnsProvidersService
        self.nativeProvidersService = nativeProvidersService
        self.resources = resources
        self.vpnManager = vpnManager
    }
    
    // MARK: - Public methods
    
    func setServerAsActive(_ server: DnsServerInfo?, serverName: String?) {
        if #available(iOS 14.0, *), resources.dnsImplementation == .native {
            // TODO: - Process nil server
            if let server = server {
                nativeProvidersService.setServerAsCurrent(server, name: serverName) { error in
                    if let error = error {
                        DDLogError("Error: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            dnsProvidersService.activeDnsServer = server
            vpnManager.updateSettings(completion: nil)
        }
    }
}
