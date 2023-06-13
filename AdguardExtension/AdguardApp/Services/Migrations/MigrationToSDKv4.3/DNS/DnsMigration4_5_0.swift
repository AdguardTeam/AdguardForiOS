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

import DnsAdGuardSDK
import SharedAdGuardSDK

/// Protocol for DNS migration from 4.3.1 to 4.5.0
protocol DnsMigration4_5_0Protocol {
    func migrate()
}



final class DnsMigration4_5_0 : DnsMigration4_5_0Protocol {
    private let resources: AESharedResourcesProtocol
    private let stateManager: MigrationStateManagerProtocol

    private let oldAdguardDnsFilterUrl = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
    private let newAdGuardDnsFilterUrl = "https://filters.adtidy.org/dns/filter_1_ios.txt"



    init(resources: AESharedResourcesProtocol) {
        self.resources = resources
        self.stateManager = MigrationStateManager(resources: resources, migrationKey: "DnsMigration4_5_0Key")
    }



    func migrate() {
        switch stateManager.state {
            case .notStarted: onNotStarted()
            case .started: onStarted()
            case .finished: Logger.logInfo("(DnsMigration4_5_0) - migrate; Migration already finished")
        }
    }



    private func onNotStarted() {
        Logger.logInfo("(DnsMigration4_5_0) - onNotStarted; Start migration")
        stateManager.start()

        do {
            let migrated = try migrateAdGuardDnsFilterSync()

            if migrated {
                stateManager.finish()
                Logger.logInfo("(DnsMigration4_5_0) - onNotStarted; Migration succeeded")
            } else {
                stateManager.failure()
                Logger.logInfo("(DnsMigration4_5_0) - onNotStarted; Migration failed")
            }

        } catch {
            stateManager.failure()
            Logger.logError("(DnsMigration4_5_0) - onNotStarted; Migration failed: \(error)")
        }
    }

    private func onStarted() {
        Logger.logInfo("(DnsMigration4_5_0) - onStarted; Migration already started. Wait it")
        // wait for finish
        let group = DispatchGroup()
        group.enter()
        stateManager.onMigrationFinished {
            Logger.logInfo("(DnsMigration4_5_0) - onStarted; Migration finished")
            group.leave()
        }

        // The timeout is a crutch because code for IPC is rather bad
        // TODO: - Refactor it later
        let waitResult = group.wait(timeout: .now() + 3.0)

        Logger.logInfo("(DnsMigration4_5_0) - onStarted; The wait is over; waitResult succeeded=\(waitResult == .success)")
    }

    private func migrateAdGuardDnsFilterSync() throws -> Bool {
        guard let filtersData = resources.sharedDefaults().value(forKey: "DnsAdGuardSDK.dnsFiltersKey") as? Data else {
            DDLogWarn("(DnsMigration4_5_0) - migrateAdGuardDnsFilterSync; No DNS fitlers found to migrate")

            // Returns `true` because the user can manually delete all DNS filters or
            // if filters have never been saved in `User Defaults` with the DnsAdGuardSDK.dnsFiltersKey key
            return true
        }

        guard let filterUrl = URL(string: newAdGuardDnsFilterUrl) else {
            DDLogError("(DnsMigration4_5_0) - migrateAdGuardDnsFilterSync; Can't create URL for string=\(newAdGuardDnsFilterUrl)")
            return false
        }

        let decodedFilters = try JSONDecoder().decode([DnsFilter].self, from: filtersData)
        DDLogDebug("(DnsMigration4_5_0) - migrateAdGuardDnsFilterSync; Successfully deocde DnsFilters from storage")

        let filtersToSave = decodedFilters.map { filter in
            let subscriptionUrl = filter.subscriptionUrl.absoluteString == oldAdguardDnsFilterUrl ? filterUrl : filter.subscriptionUrl
            let filterDownloadPage = filter.subscriptionUrl.absoluteString == oldAdguardDnsFilterUrl ? filterUrl.absoluteString : filter.filterDownloadPage

            return DnsFilter(
                filterId: filter.filterId,
                subscriptionUrl: subscriptionUrl,
                isEnabled: filter.isEnabled,
                name: filter.name,
                description: filter.description,
                version: filter.version,
                lastUpdateDate: filter.lastUpdateDate,
                homePage: filter.homePage,
                licensePage: filter.licensePage,
                issuesReportPage: filter.issuesReportPage,
                communityPage: filter.communityPage,
                filterDownloadPage: filterDownloadPage,
                rulesCount: filter.rulesCount
            )
        }

        let dataToSave = try JSONEncoder().encode(filtersToSave)
        DDLogDebug("(DnsMigration4_5_0) - migrateAdGuardDnsFilterSync; Successfully encode \(filtersToSave.count) DnsFilters")

        resources.sharedDefaults().setValue(dataToSave, forKey: "DnsAdGuardSDK.dnsFiltersKey")
        return true
    }
}
