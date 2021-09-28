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

public protocol SafariProtectionFiltersProtocol {
    /// Returns true if filters are converting now
    var filtersAreConverting: Bool { get }

    /// Returns all Safari Groups objects
    var groups: [SafariGroup] { get }

    /**
     Enables or disables group by **group type** and reloads CBs than
     - Parameter groupType: type of the group that should be enabled/disabled
     - Parameter enabled: new group state
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func setGroup(_ groupType: SafariGroup.GroupType, enabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) throws

    /**
     Enables or disables filter by **filter id** and **group id** and reloads CBs than
     - Parameter id: id of the filter that should be enabled/disabled
     - Parameter groupId: id of the group that filter belongs
     - Parameter enabled: new filter state
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func setFilter(withId id: Int, _ groupId: Int, enabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) throws

    /**
     Adds **customFilter** and reloads CBs than
     - Parameter customFilter: Meta data of filter
     - Parameter enabled: new filter state
     - Parameter onFilterAddedToDb: Closure that is called when filter is added to DB
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func add(
        customFilter: ExtendedCustomFilterMetaProtocol,
        enabled: Bool,
        onFilterAddedToDb: @escaping (_ error: Error?) -> Void,
        onCbReloaded: @escaping (_ error: Error?) -> Void
    )

    /**
     Renames filter with **id** to **name**
     - Parameter id: id of the filter that should be deleted
     - Parameter name: new filter name
     - throws: Can throw error if error occured while renaming filter
     */
    func renameCustomFilter(withId id: Int, to name: String) throws

    /**
     Deletes filter with **id** and reloads CBs than
     - Parameter id: id of the filter that should be deleted
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func deleteCustomFilter(withId id: Int, onCbReloaded: ((_ error: Error?) -> Void)?) throws

    /**
     Checks update conditions for meta and updates them if needed and reloads CBs than
     - Parameter forcibly: ignores update conditions and immediately updates filters
     - Parameter onFiltersUpdated: Closure that is called when filters data was saved after update
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func updateFiltersMetaAndLocalizations(
        _ forcibly: Bool,
        onFiltersUpdated: @escaping (_ error: Result<FiltersUpdateResult>) -> Void,
        onCbReloaded: @escaping (_ error: Error?) -> Void
    )
}

/* Extension is used to interact with filters and groups object and properly process operations with them */
extension SafariProtection {

    // MARK: - Public variables

    public var filtersAreConverting: Bool { workingQueue.sync { converter.filtersAreConverting } }

    public var groups: [SafariGroup] { workingQueue.sync { filters.groups } }

    // MARK: - Public methods

    public func setGroup(_ groupType: SafariGroup.GroupType, enabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) throws {
        try workingQueue.sync {
            try executeBlockAndReloadCbs {
                Logger.logInfo("(SafariProtection+Filters) - setGroup; Setting group with id=\(groupType.id) to enabled=\(enabled)")
                try filters.setGroup(withId: groupType.id, enabled: enabled)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Filters) - setGroup.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+Filters) - setGroup; Error reloading CBs when setting group with id=\(groupType.id) to enabled=\(enabled): \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Filters) - setGroup; Successfully reloaded CBs after setting group with id=\(groupType.id) to enabled=\(enabled)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func setFilter(withId id: Int, _ groupId: Int, enabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) throws {
        try workingQueue.sync {
            try executeBlockAndReloadCbs {
                Logger.logInfo("(SafariProtection+Filters) - setFilter; Setting filter with id=\(id), group id=\(groupId) to enabled=\(enabled)")
                try self.filters.setFilter(withId: id, groupId, enabled: enabled)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Filters) - setFilter.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+Filters) - setFilter; Error reloading CBs when setting filter with id=\(id), group id=\(groupId) to enabled=\(enabled): \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Filters) - setFilter; Successfully reloaded CBs after setting filter with id=\(id), group id=\(groupId) to enabled=\(enabled)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func add(
        customFilter: ExtendedCustomFilterMetaProtocol,
        enabled: Bool,
        onFilterAddedToDb: @escaping (_ error: Error?) -> Void,
        onCbReloaded: @escaping (_ error: Error?) -> Void
    ) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection+Filters) - addCustomFilter; self is missing!")
                DispatchQueue.main.async { onFilterAddedToDb(CommonError.missingSelf); onCbReloaded(CommonError.missingSelf) }
                return
            }

            Logger.logInfo("(SafariProtection+Filters) - addCustomFilter; Add custom filter: \(customFilter)")
            var addError: Error?
            let group = DispatchGroup()
            group.enter()
            self.filters.add(customFilter: customFilter, enabled: enabled) { error in
                addError = error
                group.leave()
            }
            group.wait()

            if let addError = addError {
                Logger.logError("(SafariProtection+Filters) - addCustomFilter; Error adding custom filter: \(customFilter) to storage, error: \(addError)")
                self.completionQueue.async { onFilterAddedToDb(addError); onCbReloaded(addError) }
                return
            }
            self.completionQueue.async { onFilterAddedToDb(nil) }

            self.reloadContentBlockers { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Filters) - addCustomFilter.reloadContentBlockers; self is missing!")
                    DispatchQueue.main.async { onCbReloaded(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+Filters) - addCustomFilter; Error reloading CBs when adding custom filter: \(customFilter); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Filters) - addCustomFilter; Successfully reloaded CBs after adding custom filter: \(customFilter)")
                }
                self.completionQueue.async { onCbReloaded(error) }
            }
        }
    }

    public func deleteCustomFilter(withId id: Int, onCbReloaded: ((_ error: Error?) -> Void)?) throws {
        try workingQueue.sync {
            try executeBlockAndReloadCbs {
                Logger.logInfo("(SafariProtection+Filters) - deleteCustomFilter; Delete custom filter with id=\(id)")
                try self.filters.deleteCustomFilter(withId: id)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Filters) - deleteCustomFilter.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+Filters) - deleteCustomFilter; Error reloading CBs when deleting custom filter with id=\(id): \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Filters) - deleteCustomFilter; Successfully reloaded CBs after deleting custom filter with id=\(id)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func renameCustomFilter(withId id: Int, to name: String) throws {
        try workingQueue.sync {
            Logger.logInfo("(SafariProtection+Filters) - renameCustomFilter; Rename custom filter with id=\(id) to name=\(name)")
            try self.filters.renameCustomFilter(withId: id, to: name)
        }
    }

    public func updateFiltersMetaAndLocalizations(
        _ forcibly: Bool,
        onFiltersUpdated: @escaping (_ error: Result<FiltersUpdateResult>) -> Void,
        onCbReloaded: @escaping (_ error: Error?) -> Void
    ) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection+Filters) - updateFiltersMetaAndLocalizations; self is missing!")
                DispatchQueue.main.async { onFiltersUpdated(.error(CommonError.missingSelf)); onCbReloaded(CommonError.missingSelf) }
                return
            }

            Logger.logInfo("(SafariProtection+Filters) - updateFiltersMetaAndLocalizations; Updating filters meta forcibly=\(forcibly)")

            self.filters.updateAllMeta(forcibly: forcibly) { [weak self] result in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Filters) - updateFiltersMetaAndLocalizations.updateAllMeta; self is missing!")
                    DispatchQueue.main.async { onFiltersUpdated(.error(CommonError.missingSelf)); onCbReloaded(CommonError.missingSelf) }
                    return
                }
                self.completionQueue.async { onFiltersUpdated(result) }

                self.workingQueue.sync {

                    self.reloadContentBlockers { [weak self] error in
                        guard let self = self else {
                            Logger.logError("(SafariProtection+Filters) - updateFiltersMetaAndLocalizations.reloadContentBlockers; self is missing!")
                            DispatchQueue.main.async { onCbReloaded(CommonError.missingSelf) }
                            return
                        }
                        self.completionQueue.async { onCbReloaded(error) }
                    }
                }
            }
        }
    }
}
