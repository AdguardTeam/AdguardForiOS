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

/// Protocol for safari rules migration from 4.3.0 to 4.3.1
protocol SafariMigration4_3_1Protocol {
    func migrate()
}

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(SafariMigration4_3_1.self)

final class SafariMigration4_3_1: SafariMigration4_3_1Protocol {

    // MARK: - Private properties

    private let stateManager: MigrationStateManagerProtocol
    private let safariProtection: SafariProtectionMigrationsProtocol

    // MARK: - Init

    init(resources: AESharedResourcesProtocol, safariProtection: SafariProtectionMigrationsProtocol) {
        self.safariProtection = safariProtection
        self.stateManager = MigrationStateManager(resources: resources, migrationKey: "SafariMigration4_3_1Key")
    }

    // MARK: - Public methods

    func migrate() {
        LOG.info("Migrate called")
        switch stateManager.state {
        case .notStarted:
            onNotStarted()
        case .finished:
            LOG.info("Migration already finished")
        case .started:
            onStarted()
        }
    }

    // MARK: - Private methods

    private func onNotStarted() {
        LOG.info("Start migration")
        stateManager.start()

        do {
            try migrateSafariRules(for: .blocklist)
            try migrateSafariRules(for: .allowlist)
            try migrateSafariRules(for: .invertedAllowlist)
            stateManager.finish()
            LOG.info("Migration succeeded")

            safariProtection.convertFiltersAndReloadCbs { error in
                if let error = error {
                    LOG.info("Error occurred while reloading CBs; Error: \(error)")
                    return
                }
                LOG.info("Successfully reload CBs after safari user rules migration")
            }
        } catch {
            stateManager.failure()
            LOG.error("Migration failed: \(error)")
        }
    }

    private func onStarted() {
        LOG.info("Migration already started. Wait it")
        // wait for finish
        let group = DispatchGroup()
        group.enter()
        stateManager.onMigrationFinished {
            LOG.info("Migration finished")
            group.leave()
        }

        // The timeout is a crutch because code for IPC is rather bad
        // TODO: - Refactor it later
        let waitResult = group.wait(timeout: .now() + 3.0)

        LOG.info("The wait is over; waitResult succeeded=\(waitResult == .success)")
    }

    private func migrateSafariRules(for type: SafariUserRuleType) throws {
        LOG.info("Starting migrate safari rules for type=\(type)")
        let rules = safariProtection.getRules(for: type)
        if rules.isEmpty {
            LOG.info("Safari rules migration for type=\(type) not started; Reason: nothing to migrate")
            return
        }
        safariProtection.removeRules(for: type)

        var rulesNeedToSet: [UserRule] = []

        for rule in rules {
            let splitedRules = rule.ruleText.components(separatedBy: .newlines)

            if splitedRules.count > 1 {
                let ruleState = rule.isEnabled
                splitedRules.forEach {
                    let userRule = UserRule(ruleText: $0, isEnabled: ruleState)
                    rulesNeedToSet.append(userRule)
                }
            } else {
                rulesNeedToSet.append(rule)
            }
        }

        try safariProtection.add(rules: rulesNeedToSet, for: type, override: true)
        LOG.info("Safari rules migration for type=\(type) ended with success")
    }
}
