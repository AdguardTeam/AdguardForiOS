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

public protocol SafariProtectionFiltersProtocol {
    /// Returns true if filters are converting now
    var filtersAreConverting: Bool { get }

    /// Returns all Safari Groups objects
    var groups: [SafariGroup] { get }

    /// Returns last date of safari filters update. If date were never been seated returns nil
    var lastFiltersUpdateCheckDate: Date? { get }


    /**
     Enables or disables group by **group type**
     - Parameter groupType: type of the group that should be enabled/disabled
     - Parameter enabled: new group state
     */
    func setGroup(groupType: SafariGroup.GroupType, enabled: Bool) throws

    /**
     Enables or disables group by **group type** and reloads CBs than
     - Parameter groupType: type of the group that should be enabled/disabled
     - Parameter enabled: new group state
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func setGroup(groupType: SafariGroup.GroupType, enabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) throws

    /**
     Enables or disables filter by **filter id** and **group id**
     - Parameter id: id of the filter that should be enabled/disabled
     - Parameter groupId: id of the group that filter belongs
     - Parameter enabled: new filter state
     */
    func setFilter(withId id: Int, groupId: Int, enabled: Bool) throws

    /**
     Enables or disables filter by **filter id** and **group id** and reloads CBs than if needed
     - Parameter id: id of the filter that should be enabled/disabled
     - Parameter groupId: id of the group that filter belongs
     - Parameter enabled: new filter state
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func setFilter(withId id: Int, groupId: Int, enabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) throws
    /**
     Adds **customFilter**
     - Parameter customFilter: Meta data of filter
     - Parameter enabled: new filter state
     - Parameter onFilterAddedToDb: Closure that is called when filter is added to DB
     */
    func add(
        customFilter: ExtendedCustomFilterMetaProtocol,
        enabled: Bool,
        onFilterAddedToDb: ((_ error: Error?) -> Void)?)

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
        onFilterAddedToDb: ((_ error: Error?) -> Void)?,
        onCbReloaded: ((_ error: Error?) -> Void)?)

    /**
     Renames filter with **id** to **name**
     - Parameter id: id of the filter that should be deleted
     - Parameter name: new filter name
     - throws: Can throw error if error occured while renaming filter
     */
    func renameCustomFilter(withId id: Int, to name: String) throws

    /**
     Deletes filter with **id**
     - Parameter id: id of the filter that should be deleted
     */
    func deleteCustomFilter(withId id: Int) throws

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

    /**
     Enable predefined groups and filters
     - Throws: Can throw error if error occured while enabling filter or groups
     */
    func enablePredefinedGroupsAndFilters() throws
}

private let LOG = LoggerFactory.getLoggerWrapper(SafariProtection.self)

/* Extension is used to interact with filters and groups object and properly process operations with them */
extension SafariProtection {

    // MARK: - Public variables

    public var filtersAreConverting: Bool { workingQueue.sync { converter.filtersAreConverting } }

    public var groups: [SafariGroup] { workingQueue.sync { filters.groups } }

    public var lastFiltersUpdateCheckDate: Date? {
        workingQueue.sync {
            if filters.lastFiltersUpdateCheckDate == Date(timeIntervalSince1970: 0.0) {
                return nil
            }
            return filters.lastFiltersUpdateCheckDate
        }
    }

    // MARK: - Public methods

    public func setGroup(groupType: SafariGroup.GroupType, enabled: Bool) throws {
        try workingQueue.sync {
            try setGroupInternal(groupType, enabled: enabled)
        }
    }

    public func setGroup(groupType: SafariGroup.GroupType, enabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) throws {
        try workingQueue.sync {
            try executeBlockAndReloadCbs {
                LOG.info("Setting group with id=\(groupType.id) to enabled=\(enabled)")
                try setGroupInternal(groupType, enabled: enabled)
                return true
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    LOG.error("setGroup.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    LOG.error("setGroup.onCbReloaded; Error reloading CBs when setting group with id=\(groupType.id) to enabled=\(enabled): \(error)")
                } else {
                    LOG.info("setGroup.onCbReloaded; Successfully reloaded CBs after setting group with id=\(groupType.id) to enabled=\(enabled)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func setFilter(withId id: Int, groupId: Int, enabled: Bool) throws {
        try workingQueue.sync {
            try setFilterInternal(withId: id, groupId: groupId, enabled: enabled)
        }
    }

    public func setFilter(withId id: Int, groupId: Int, enabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) throws {
        try workingQueue.sync {
            try executeBlockAndReloadCbs {
                LOG.info("Setting filter with id=\(id), group id=\(groupId) to enabled=\(enabled)")
                try setFilterInternal(withId: id, groupId: groupId, enabled: enabled)
                return true
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    LOG.error("setFilter.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    LOG.error("setFilter.onCbReloaded; Error reloading CBs when setting filter with id=\(id), group id=\(groupId) to enabled=\(enabled): \(error)")
                } else {
                    LOG.info("setFilter.onCbReloaded; Successfully reloaded CBs after setting filter with id=\(id), group id=\(groupId) to enabled=\(enabled)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func add(
        customFilter: ExtendedCustomFilterMetaProtocol,
        enabled: Bool,
        onFilterAddedToDb: ((_ error: Error?) -> Void)?
    ) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                LOG.error("Self is missing!")
                DispatchQueue.main.async { onFilterAddedToDb?(CommonError.missingSelf) }
                return
            }

            LOG.info("Add custom filter: \(customFilter)")
            var addError: Error?
            let group = DispatchGroup()
            group.enter()
            self.filters.add(customFilter: customFilter, enabled: enabled) { error in
                addError = error
                group.leave()
            }
            group.wait()

            if let addError = addError {
                LOG.error("Error adding custom filter: \(customFilter) to storage, error: \(addError)")
                self.completionQueue.async { onFilterAddedToDb?(addError) }
                return
            }
            self.completionQueue.async { onFilterAddedToDb?(nil) }
        }
    }

    public func add(
        customFilter: ExtendedCustomFilterMetaProtocol,
        enabled: Bool,
        onFilterAddedToDb: ((_ error: Error?) -> Void)?,
        onCbReloaded: ((_ error: Error?) -> Void)?
    ) {

        add(customFilter: customFilter, enabled: enabled) { [weak self] error in
            guard let self = self else {
                LOG.error("Self is missing!")
                DispatchQueue.main.async { onFilterAddedToDb?(CommonError.missingSelf); onCbReloaded?(CommonError.missingSelf) }
                return
            }

            if let error = error {
                // If error occurred while adding custom filter then call all completions and don't reload CBs
                self.completionQueue.async { onFilterAddedToDb?(error); onCbReloaded?(error) }
                return
            }

            self.completionQueue.async { onFilterAddedToDb?(nil) }

            self.reloadContentBlockers { [weak self] error in
                guard let self = self else {
                    LOG.error("addCustomFilter.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    LOG.error("addCustomFilter.onCbReloaded; Error reloading CBs when adding custom filter: \(customFilter); Error: \(error)")
                } else {
                    LOG.info("addCustomFilter.onCbReloaded; Successfully reloaded CBs after adding custom filter: \(customFilter)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func deleteCustomFilter(withId id: Int) throws {
        try workingQueue.sync {
            try deleteCustomFilterInternal(withId: id)
        }
    }

    public func deleteCustomFilter(withId id: Int, onCbReloaded: ((_ error: Error?) -> Void)?) throws {
        try workingQueue.sync {
            try executeBlockAndReloadCbs {
                LOG.info("Delete custom filter with id=\(id)")
                try deleteCustomFilterInternal(withId: id)
                return true
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    LOG.error("deleteCustomFilter.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    LOG.error("deleteCustomFilter.onCbReloaded; Error reloading CBs when deleting custom filter with id=\(id): \(error)")
                } else {
                    LOG.info("deleteCustomFilter.onCbReloaded; Successfully reloaded CBs after deleting custom filter with id=\(id)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func renameCustomFilter(withId id: Int, to name: String) throws {
        try workingQueue.sync {
            LOG.info("Rename custom filter with id=\(id) to name=\(name)")
            try self.filters.renameCustomFilter(withId: id, to: name)
        }
    }

    public func updateFiltersMetaAndLocalizations(
        _ forcibly: Bool,
        onFiltersUpdated: @escaping (_ error: Result<FiltersUpdateResult>) -> Void,
        onCbReloaded: @escaping (_ error: Error?) -> Void
    ) {
        BackgroundTaskExecutor.executeAsynchronousTask("SafariProtection+Filters.updateFiltersMetaAndLocalizations") { [weak self] onTaskFinished in
            self?.workingQueue.async { [weak self] in
                guard let self = self else {
                    LOG.error("Self is missing!")
                    DispatchQueue.main.async {
                        onFiltersUpdated(.error(CommonError.missingSelf))
                        onCbReloaded(CommonError.missingSelf)
                        onTaskFinished()
                    }
                    return
                }

                LOG.info("Updating filters meta forcibly=\(forcibly)")

                self.filters.updateAllMeta(forcibly: forcibly) { [weak self] result in
                    guard let self = self else {
                        LOG.error("updateFiltersMetaAndLocalizations.updateAllMeta; self is missing!")
                        DispatchQueue.main.async {
                            onFiltersUpdated(.error(CommonError.missingSelf))
                            onCbReloaded(CommonError.missingSelf)
                            onTaskFinished()
                        }
                        return
                    }
                    self.completionQueue.async { onFiltersUpdated(result) }

                    self.workingQueue.sync {

                        self.reloadContentBlockers { [weak self] error in
                            guard let self = self else {
                                LOG.error("updateFiltersMetaAndLocalizations.reloadContentBlockers; self is missing!")
                                DispatchQueue.main.async {
                                    onCbReloaded(CommonError.missingSelf)
                                    onTaskFinished()
                                }
                                return
                            }
                            self.completionQueue.async {
                                onCbReloaded(error)
                                onTaskFinished()
                            }
                        }
                    }
                }
            }
        }
    }

    public func enablePredefinedGroupsAndFilters() throws {
        try workingQueue.sync {
            LOG.info("Start enabling predefined groups and filters")
            try self.filters.enablePredefinedGroupsAndFilters()
            LOG.info("Enabling predefined groups and filters successfully ended")
        }
    }

    // MARK: - Private methods

    private func setGroupInternal(_ groupType: SafariGroup.GroupType, enabled: Bool) throws {
        LOG.info("Setting group with id=\(groupType.id) to enabled=\(enabled)")
        try filters.setGroup(withId: groupType.id, enabled: enabled)
    }

    private func setFilterInternal(withId id: Int, groupId: Int, enabled: Bool) throws {
        LOG.info("Setting filter with id=\(id), group id=\(groupId) to enabled=\(enabled)")
        try self.filters.setFilter(withId: id, groupId, enabled: enabled)
    }

    private func deleteCustomFilterInternal(withId id: Int) throws {
        LOG.info("Delete custom filter with id=\(id)")
        try self.filters.deleteCustomFilter(withId: id)
    }
}
