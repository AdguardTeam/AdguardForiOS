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

/// This protocol helps main app to perform migration from v4.2 to v4.3
public protocol SafariProtectionMigrationsProtocol: AnyObject {
    func getRules(for type: SafariUserRuleType) -> [UserRule]
    func removeRules(for type: SafariUserRuleType)
    func add(rules: [UserRule], for type: SafariUserRuleType, override: Bool) throws
    func setGroup(_ groupType: SafariGroup.GroupType, enabled: Bool) throws
    func setFilter(withId id: Int, _ groupId: Int, enabled: Bool) throws
    func reinitializeGroupsAndFilters() throws
    func convertFiltersAndReloadCbs(onCbReloaded: ((_ error: Error?) -> Void)?)
}

private let LOG = LoggerFactory.getLoggerWrapper("SafariProtection+Migrations")

// TODO: - We should change the way we migrate data in main app and remove this extension
/// This extension is responsible for providing methods for migration in main app
extension SafariProtection: SafariProtectionMigrationsProtocol {

    public func getRules(for type: SafariUserRuleType) -> [UserRule] {
        workingQueue.sync {
            let allRules = getProvider(for: type).allRules
            LOG.info("Getting rules \(allRules.count) for type=\(type)")
            return allRules
        }
    }

    public func removeRules(for type: SafariUserRuleType) {
        LOG.info("Remove all rules for type=\(type)")
        removeAllRules(for: type)
    }

    public func add(rules: [UserRule], for type: SafariUserRuleType, override: Bool) throws {
        try workingQueue.sync {
            LOG.info("Adding \(rules.count) rules; for type=\(type); override=\(override)")

            let provider = self.getProvider(for: type)
            try provider.add(rules: rules, override: override)
        }
    }

    public func setGroup(_ groupType: SafariGroup.GroupType, enabled: Bool) throws {
        try workingQueue.sync {
            LOG.info("Setting group with id=\(groupType.id) to enabled=\(enabled)")
            try filters.setGroup(withId: groupType.id, enabled: enabled)
        }
    }

    public func setFilter(withId id: Int, _ groupId: Int, enabled: Bool) throws {
        try workingQueue.sync {
            LOG.info("Setting filter with id=\(id), group id=\(groupId) to enabled=\(enabled)")
            try self.filters.setFilter(withId: id, groupId, enabled: enabled)
        }
    }

    public func reinitializeGroupsAndFilters() throws {
        try workingQueue.sync {
            try filters.reinitializeGroups()
        }
    }

    public func convertFiltersAndReloadCbs(onCbReloaded: ((_ error: Error?) -> Void)?) {
        BackgroundTaskExecutor.executeAsynchronousTask("SafariProtection+Migrations.convertFiltersAndReloadCbs") { [weak self] onTaskFinished in
            self?.cbQueue.async { [weak self] in
                guard let self = self else {
                    LOG.error("Self is missing!")
                    onCbReloaded?(CommonError.missingSelf)
                    onTaskFinished()
                    return
                }

                do {
                    let convertedfilters = self.converter.convertFiltersAndUserRulesToJsons()
                    try self.cbStorage.save(converterResults: convertedfilters)
                }
                catch {
                    LOG.error("Error conveerting filters: \(error)")
                    self.completionQueue.async {
                        onCbReloaded?(error)
                        onTaskFinished()
                    }
                    return
                }

                self.cbService.updateContentBlockers { [weak self] error in
                    guard let self = self else {
                        LOG.error("Self is missing!")
                        self?.completionQueue.async {
                            onCbReloaded?(CommonError.missingSelf)
                            onTaskFinished()
                        }
                        return
                    }

                    self.completionQueue.async {
                        onCbReloaded?(error)
                        onTaskFinished()
                    }
                }
            }
        }
    }
}
