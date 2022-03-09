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

/// Protocol for safari rules migration from 4.3.0 to 4.3.1
protocol DnsMigration4_3_1Protocol {
    func migrate()
}

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(DnsMigration4_3_1.self)

final class DnsMigration4_3_1: DnsMigration4_3_1Protocol {

    // MARK: - Private properties

    private let dnsProtection: DnsProtectionProtocol
    private let stateManager: MigrationStateManagerProtocol

    // MARK: - Init

    init(resources: AESharedResourcesProtocol, dnsProtection: DnsProtectionProtocol) {
        self.dnsProtection = dnsProtection
        self.stateManager = MigrationStateManager(resources: resources, migrationKey: "DnsMigration4_3_1Key")
    }

    // MARK: - Public methods

    func migrate() {
        switch stateManager.state {
        case .notStarted:
            onNotStarted()
        case .finished:
            LOG.info("(DnsMigration4_3_1) - migrate; Migration already finished")
        case .started:
            onStarted()
        }
    }

    // MARK: - Private methods

    private func onNotStarted() {
        LOG.info("(DnsMigration4_3_1) - onNotStarted; Start migration")
        stateManager.start()

        do {
            try migrateDnsRules(for: .blocklist)
            try migrateDnsRules(for: .allowlist)
            stateManager.finish()
            LOG.info("(DnsMigration4_3_1) - onNotStarted; Migration succeeded")
        } catch {
            stateManager.failure()
            LOG.error("(DnsMigration4_3_1) - onNotStarted; Migration failed: \(error)")
        }
    }

    private func onStarted() {
        LOG.info("(DnsMigration4_3_1) - onStarted; Migration already started. Wait it")
        // wait for finish
        let group = DispatchGroup()
        group.enter()
        stateManager.onMigrationFinished {
            LOG.info("DnsMigration4_3_1) - onStarted; Migration finished")
            group.leave()
        }

        // The timeout is a crutch because code for IPC is rather bad
        // TODO: - Refactor it later
        let waitResult = group.wait(timeout: .now() + 3.0)

        LOG.info("DnsMigration4_3_1) - onStarted; The wait is over; waitResult succeeded=\(waitResult == .success)")
    }

    private func migrateDnsRules(for type: DnsUserRuleType) throws {
        LOG.info("(DnsMigration4_3_1) - migrateDnsRules; Starting migrate safari rules for type=\(type)")
        let rules = dnsProtection.allRules(for: type)
        if rules.isEmpty {
            LOG.info("(DnsMigration4_3_1) - migrateDnsRules; Dns rules migration for type=\(type) not started; Reason: nothing to migrate")
            return
        }
        dnsProtection.removeAllRules(for: type)

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

        try dnsProtection.add(rules: rulesNeedToSet, override: true, for: type)
        LOG.info("(DnsMigration4_3_1) - migrateDnsRules; Dns rules migration for type=\(type) ended with success")
    }
}
