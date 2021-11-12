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

import SafariAdGuardSDK
import SharedAdGuardSDK

/// This object is responsible for migrating data related with Safari protection when transitioning the app to v4.3
protocol SafariMigration4_3Protocol {
    func migrate()
}

class SafariMigration4_3: SafariMigration4_3Protocol {

    private let stateManager: MigrationStateManagerProtocol

    private let safariProtection: SafariProtectionMigrationsProtocol
    private let filtersDbMigration: SafariProtectionFiltersDatabaseMigrationHelperProtocol
    private let allowlistRulesMigration: SafariProtectionAllowlistRulesMigrationHelperProtocol
    private let customFiltersMigration: SafariProtectionCustomFiltersMigrationHelperProtocol

    init(resources: AESharedResourcesProtocol, safariProtection: SafariProtectionProtocol) throws {
        self.safariProtection = safariProtection as! SafariProtectionMigrationsProtocol
        self.stateManager = MigrationStateManager(resources: resources, migrationKey: "SafariMigration4_3Key")

        filtersDbMigration = try SafariProtectionFiltersDatabaseMigrationHelper(
            oldAdguardDBFilePath: resources.sharedResuorcesURL().appendingPathComponent("adguard.db").path,
            oldDefaultDBFilePath: resources.sharedResuorcesURL().appendingPathComponent("default.db").path
        )
        allowlistRulesMigration = SafariProtectionAllowlistRulesMigrationHelper(rulesContainerDirectoryPath: resources.sharedResuorcesURL().path)
        customFiltersMigration = try SafariProtectionCustomFiltersMigrationHelper(
            newDBFilePath: SharedStorageUrls().dbFolderUrl.appendingPathComponent("adguard.db").path,
            filtersDirectoryUrl: SharedStorageUrls().filtersFolderUrl
        )
    }

    func migrate() {

        Logger.logInfo("(SafariMigration4_3) migrate called")
        switch stateManager.state {
        case .notStarted:
            Logger.logInfo("(SafariMigration4_3) start migration")
            stateManager.start()

            do {
                try migrateSafariProtection()
                stateManager.finish()

                Logger.logInfo("(SafariMigration4_3) migration succeeded")
            }
            catch {
                stateManager.failure()
                Logger.logError("(SafariMigration4_3) migration failed: \(error)")
            }
        case .finished:
            Logger.logInfo("(SafariMigration4_3) migration allready finished")
            return
        case .started:
            Logger.logInfo("(SafariMigration4_3) migration allready started. Wait it")
            // wait for finish
            let group = DispatchGroup()
            group.enter()
            stateManager.onReady {
                group.leave()
            }
            group.wait()

            Logger.logInfo("(SafariMigration4_3) the wait is over")
            return
        }
    }

    // MARK: - private methods

    private func migrateSafariProtection() throws {
        /* Rules migration */
        let userRules = try filtersDbMigration.getUserRules()
        let allowlistRules = try allowlistRulesMigration.getAllowlistRules()
        let invertedAllowlistRules = try allowlistRulesMigration.getInvertedAllowlistRules()

        try migrate(userRules: userRules, for: .blocklist)
        try migrate(userRules: allowlistRules, for: .allowlist)
        try migrate(userRules: invertedAllowlistRules, for: .invertedAllowlist)

        /* DB migration */
        let customFilters = try filtersDbMigration.getCustomFilters()
        try customFiltersMigration.migrateCustomFilters(customFilters)

        let groupStates = try filtersDbMigration.getGroupsStates()
        try groupStates.forEach {
            if let groupType = SafariGroup.GroupType(rawValue: $0.groupId) {
                try safariProtection.setGroup(groupType, enabled: $0.isEnabled)
            }
        }

        let filtersStates = try filtersDbMigration.getFiltersStates()
        try filtersStates.forEach { try safariProtection.setFilter(withId: $0.filterId, $0.groupId, enabled: $0.isEnabled) }

        try safariProtection.reinitializeGroupsAndFilters()

        /* Remove old files */
        try allowlistRulesMigration.removeOldRuleFiles()
        try filtersDbMigration.removeOldDBFiles()

        safariProtection.convertFiltersAndReloadCbs(onCbReloaded: nil)
    }

    private func migrate(userRules: [SDKSafariMigrationRule], for type: SafariUserRuleType) throws {
        let rules = userRules.map { UserRule(ruleText: $0.ruleText, isEnabled: $0.isEnabled) }
        try safariProtection.add(rules: rules, for: type, override: true)
    }
}
