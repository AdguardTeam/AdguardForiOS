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

protocol ImportDNSSettingsHelperProtocol {
    /// Imports DNS blocklist rules. If **override** is true then all old rules will be replaced new ones.
    func importDnsBlocklistRules(_ rules: [String], override: Bool)

    /// Imports DNS server with **serverId**. Returns true if server was set
    func importDnsServer(serverId: Int) -> Bool

    /// Imports DNS filters.
    /// If **override** is true then all old filters will be replaced with new ones. Returns import result
    func importDnsFilters(_ filtersContainer: ImportSettingsService.FiltersImportContainer, override: Bool, completion: @escaping ([ImportSettings.FilterSettings]) -> Void)
}

private let LOG = LoggerFactory.getLoggerWrapper(ImportDNSSettingsHelper.self)

/// This object is responsible for importing DNS protection settings
final class ImportDNSSettingsHelper: ImportDNSSettingsHelperProtocol {

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

    func importDnsBlocklistRules(_ rules: [String], override: Bool) {
        workingQueue.sync {

            if override {
                dnsProtection.removeAllRules(for: .blocklist)
            }

            dnsProtection.set(rules: rules, for: .blocklist)
        }
    }

    func importDnsServer(serverId: Int) -> Bool {
        workingQueue.sync {
            guard dnsProvidersManager.activeDnsServer.id != serverId else { return true }
            if let provider = dnsProvidersManager.allProviders.first(where: { $0.dnsServers.contains(where: { $0.id == serverId }) }) {
                do {
                    try dnsProvidersManager.selectProvider(withId: provider.providerId, serverId: serverId)
                    LOG.info("Server with id = \(serverId) and provider = \(provider.name) were successfully selected")
                    return true
                } catch {
                    LOG.error("Error occurred while selecting server with id = \(serverId) and provider = \(provider.name)")
                    return false
                }
            }
            return false
        }
    }

    func importDnsFilters(_ filtersContainer: ImportSettingsService.FiltersImportContainer, override: Bool, completion: @escaping ([ImportSettings.FilterSettings]) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                LOG.error("Missing self")
                DispatchQueue.main.async { completion([]) }
                return
            }

            if override { self.removeAllDnsFilters() }

            var resultDnsFilters: [ImportSettings.FilterSettings] = []

            filtersContainer.toEnableFilters.forEach {
                var filter = $0
                let result = self.setDnsFilter($0)
                filter.status = result ? .successful : .unsuccessful
                resultDnsFilters.append(filter)
            }

            let group = DispatchGroup()

            filtersContainer.toImportFilters.forEach { filter in
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
            LOG.error("Invalid URL string: \(filter.url)")
            completion(false)
            return
        }

        dnsProtection.addFilter(withName: filter.name, url: url, isEnabled: true) { error in
            if let error = error {
                LOG.error("Error occurred while trying to add DNS filter with url = \(url); Error: \(error)")
                completion(false)
                return
            }
            LOG.info("DNS Filter with url = \(url) successfully added")
            completion(true)
        }
    }

    private func setDnsFilter(_ filter: ImportSettings.FilterSettings) -> Bool {
        guard let id = dnsProtection.filters.first(where: { $0.filterDownloadPage == filter.url })?.filterId else {
            LOG.error("Dns filter with url=\(filter.url) not exists")
            return false
        }

        do {
            try dnsProtection.setFilter(withId: id, to: true)
            LOG.info("Successfully enable dns filter with url=\(filter.url)")
            return true
        } catch {
            LOG.error("Dns filter with url=\(filter.url) were not enabled: Error: \(error)")
            return false
        }
    }

    private func removeAllDnsFilters() {
        dnsProtection.filters.forEach {
            do {
                try dnsProtection.removeFilter(withId: $0.filterId)
                LOG.info("DNS filter with id = \($0.filterId) were removed")
            } catch {
                LOG.error("Error occurred while removing filter with id = \($0.filterId)")
            }
        }
    }
}
