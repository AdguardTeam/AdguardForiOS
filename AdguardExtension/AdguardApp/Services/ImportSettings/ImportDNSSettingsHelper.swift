//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import SharedAdGuardSDK
import DnsAdGuardSDK

/// This struct responsible for imports DNS settings
struct ImportDNSSettingsHelper {

    // MARK: - Private properties

    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let dnsProtection: DnsProtectionProtocol

    // MARK: - Init

    init(dnsProvidersManager: DnsProvidersManagerProtocol, dnsProtection: DnsProtectionProtocol) {
        self.dnsProvidersManager = dnsProvidersManager
        self.dnsProtection = dnsProtection
    }

    // MARK: - DNS protection imports

    /// Imports DNS filters. If **override** is true then all old filters would be replaced new ones. Returns import result
    func importDnsFilters(_ filters: [DnsFilterSettings], override: Bool) -> [DnsFilterSettings] {
        if override { removeAllDnsFilters() }

        var resultDnsFilters: [DnsFilterSettings] = []

        let group = DispatchGroup()
        for var filter in filters {

            if filter.status == .enabled {
                group.enter()

                subscribeDnsFilter(filter) { success in
                    filter.status = success ? .successful : .unsuccessful
                    resultDnsFilters.append(filter)
                    group.leave()
                }
            }
            else {
                resultDnsFilters.append(filter)
            }
        }

        group.wait()

        return resultDnsFilters
    }

    /// Imports DNS server with **serverId**. Return true if server were setted
    func importDnsServer(serverId: Int) -> Bool {
        guard dnsProvidersManager.activeDnsServer.id != serverId else { return false }
        if let provider = dnsProvidersManager.allProviders.first(where: { $0.dnsServers.contains(where: { $0.id == serverId }) }) {
            do {
                try dnsProvidersManager.selectProvider(withId: provider.providerId, serverId: serverId)
                DDLogInfo("(ImportDNSSettingsHelper) - importDnsServer; Server with id = \(serverId) and provider = \(provider.name) were successfully selected")
                return true
            } catch {
                DDLogError("(ImportDNSSettingsHelper) - importDnsServer; Error occurred while selecting server with id = \(serverId) and provider = \(provider.name)")
                return false
            }
        }
        return false
    }

    /// Imports DNS blocklist rules. If **override** is true then all old rules would be replaced new ones. Return true if storage were changed
    func importDnsBlocklistRules(_ rules: [UserRule], override: Bool) -> Bool {
        var result = false

        if override {
            dnsProtection.removeAllRules(for: .blocklist)
            result = true
        }

        rules.forEach {
            do {
                try dnsProtection.add(rule: $0, override: override, for: .blocklist)
                DDLogInfo("(ImportDNSSettingsHelper) - importDnsBlocklistRules; Rule = \($0) were successfully added")
                result = true
            } catch {
                DDLogError("(ImportDNSSettingsHelper) - importDnsBlocklistRules; Error occurred while adding rule = \($0); Error: = \(error)")
            }
        }

        return result
    }

    private func subscribeDnsFilter(_ filter: DnsFilterSettings, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: filter.url) else {
            DDLogError("(ImportDNSSettingsHelper) - subscribeDnsFilter; Invalid URL string: \(filter.url)")
            completion(false)
            return
        }

        dnsProtection.addFilter(withName: filter.name, url: url, isEnabled: true) { error in
            if let error = error {
                DDLogError("(ImportDNSSettingsHelper) - subscribeDnsFilter; Error occurred while trying to add DNS filter with url = \(url); Error: \(error)")
                completion(false)
                return
            }
            DDLogInfo("(ImportDNSSettingsHelper) - subscribeDnsFilter; DNS Filter with url = \(url) successfully added")
            completion(true)
        }
    }

    private func removeAllDnsFilters() {
        dnsProtection.filters.forEach {
            do {
                try dnsProtection.removeFilter(withId: $0.filterId)
                DDLogInfo("(ImportDNSSettingsHelper) - removeAllDnsFilters; DNS filter with id = \($0.filterId) were removed")
            } catch {
                DDLogError("(ImportDNSSettingsHelper) - removeAllDnsFilters; Error occurred while removing filter with id = \($0.filterId)")
            }
        }
    }
}
