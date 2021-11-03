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

/// This object is responsible for importing DNS protection settings
final class ImportDNSSettingsHelper {

    // MARK: - Private properties

    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let dnsProtection: DnsProtectionProtocol

    private let workingQueue = DispatchQueue(label: "AdGuardApp.ImportDNSSettingsHelperQueue")
    private let completionQueue = DispatchQueue(label: "AdGuardApp.ImportDNSSettingsHelperCompletionQueue")

    // MARK: - Init

    init(dnsProvidersManager: DnsProvidersManagerProtocol, dnsProtection: DnsProtectionProtocol) {
        self.dnsProvidersManager = dnsProvidersManager
        self.dnsProtection = dnsProtection
    }

    // MARK: - DNS protection imports

    /// Imports DNS blocklist rules. If **override** is true then all old rules will be replaced new ones. Returns true if storage was changed
    func importDnsBlocklistRules(_ rules: [String], override: Bool) -> Bool {
        workingQueue.sync {
            var result = false

            if override {
                dnsProtection.removeAllRules(for: .blocklist)
                result = true
            }

            if !rules.isEmpty {
                dnsProtection.set(rules: rules, for: .blocklist)
                result = true
            }

            return result
        }
    }

    /// Imports DNS server with **serverId**. Returns true if server was setted
    func importDnsServer(serverId: Int) -> Bool {
        workingQueue.sync {
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
    }

    /// Imports DNS filters.
    /// If **override** is true then all old filters will be replaced with new ones. Returns import result
    func importDnsFilters(_ filters: [ImportSettings.FilterSettings], override: Bool, completion: @escaping ([ImportSettings.FilterSettings]) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                DDLogError("(ImportDNSSettingsHelper) - importDnsFilters; Missing self")
                DispatchQueue.main.async { completion([]) }
                return
            }

            if override { self.removeAllDnsFilters() }

            var resultDnsFilters: [ImportSettings.FilterSettings] = []
            let group = DispatchGroup()

            filters.forEach { filter in
                group.enter()
                self.subscribe(filter) { settings in
                    resultDnsFilters.append(settings)
                    group.leave()
                }
            }

            group.wait()
            self.completionQueue.async { completion(resultDnsFilters) }
        }
    }

    // MARK: - Private methods

    private func subscribe(_ filter: ImportSettings.FilterSettings, completion: @escaping (ImportSettings.FilterSettings) -> Void) {
        var filter = filter
        if filter.isImportEnabled {
            addDnsFilter(filter) { success in
                filter.status = success ? .successful : .unsuccessful
                completion(filter)
            }
        } else {
            completion(filter)
        }
    }

    private func addDnsFilter(_ filter: ImportSettings.FilterSettings, completion: @escaping (_ success: Bool) -> Void) {
        guard let url = URL(string: filter.url) else {
            DDLogError("(ImportDNSSettingsHelper) - subscribeDnsFilter; Invalid URL string: \(filter.url)")
            self.completionQueue.async { completion(false) }
            return
        }

        dnsProtection.addFilter(withName: filter.name, url: url, isEnabled: true) { error in
            if let error = error {
                DDLogError("(ImportDNSSettingsHelper) - subscribeDnsFilter; Error occurred while trying to add DNS filter with url = \(url); Error: \(error)")
                self.completionQueue.async { completion(false) }
                return
            }
            DDLogInfo("(ImportDNSSettingsHelper) - subscribeDnsFilter; DNS Filter with url = \(url) successfully added")
            self.completionQueue.async { completion(true) }
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
