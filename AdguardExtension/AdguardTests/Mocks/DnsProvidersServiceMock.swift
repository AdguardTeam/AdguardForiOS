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

class DnsProvidersServiceMock:DnsProvidersServiceProtocol {
    var adguardDohServer: DnsServerInfo? { return nil }
    
    var adguardFamilyDohServer: DnsServerInfo? { return nil }
    
    func reset() { }
    
    var allProviders: [DnsProviderInfo] = []
    
    var predefinedProviders: [DnsProviderInfo] = []
    
    var customProviders: [DnsProviderInfo] = []
    
    var activeDnsServer: DnsServerInfo?
    
    var activeDnsProvider: DnsProviderInfo?
    
    var currentServerName: String = ""
    
    func addCustomProvider(name: String, upstream: String) -> DnsProviderInfo {
        return DnsProviderInfo(name: "")
    }
    
    func deleteProvider(_ provider: DnsProviderInfo) {
    }
    
    func updateProvider(_ provider: DnsProviderInfo) {
    }
    
    func isCustomProvider(_ provider: DnsProviderInfo) -> Bool {
        return true
    }
    
    func isCustomServer(_ server: DnsServerInfo) -> Bool {
        return true
    }
    
    func isActiveProvider(_ provider: DnsProviderInfo) -> Bool {
        return true
    }    
}
