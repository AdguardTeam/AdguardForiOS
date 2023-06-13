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
    private let dnsProtection: DnsProtectionProtocol
    private let stateManager: MigrationStateManagerProtocol

    private let oldAdguardDnsFilterUrl = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
    private let newAdGuardDnsFilterUrl = "https://filters.adtidy.org/dns/filter_1_ios.txt"



    init(resources: AESharedResourcesProtocol, dnsProtection: DnsProtectionProtocol) {
        self.dnsProtection = dnsProtection
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
            try migrateAdGuardDnsFilterSync()
            stateManager.finish()
            Logger.logInfo("(DnsMigration4_5_0) - onNotStarted; Migration succeeded")
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

    private func migrateAdGuardDnsFilterSync() throws {
        guard let adguardDnsFilter = dnsProtection.filters.first(where: { $0.subscriptionUrl.absoluteString == oldAdguardDnsFilterUrl }) else {
            DDLogWarn("(DnsMigration4_5_0) - migrateAdGuardDnsFilter; AdGuard DNS filter not found, nothing to migrate")
            return
        }

        DDLogInfo("(DnsMigration4_5_0) - migrateAdGuardDnsFilter; Start removing old AdGuard DNS filter")
        try dnsProtection.removeFilter(withId: adguardDnsFilter.filterId)
        DDLogInfo("(DnsMigration4_5_0) - migrateAdGuardDnsFilter; Successfully remove old AdGuard DNS filter")

        guard let url = URL(string: newAdGuardDnsFilterUrl) else {
            DDLogError("(DnsMigration4_5_0) - migrateAdGuardDnsFilter; Can't create URL for string=\(newAdGuardDnsFilterUrl)")
            return
        }

        let group = DispatchGroup()
        var _error: Error?

        group.enter()
        dnsProtection.addFilter(
            withName: adguardDnsFilter.filterName,
            url: url,
            isEnabled: adguardDnsFilter.isEnabled
        ) {
            _error = $0
            group.leave()
        }

        group.wait()

        if let error = _error {
            DDLogError("(DnsMigration4_5_0) - migrateAdGuardDnsFilter; Error occured while add new AdGuard DNS fitler; Error=\(error)")
            throw error
        } else {
            DDLogInfo("(DnsMigration4_5_0) - migrateAdGuardDnsFilter; Successfully add new AdGuard DNS filter")
        }
    }
}
