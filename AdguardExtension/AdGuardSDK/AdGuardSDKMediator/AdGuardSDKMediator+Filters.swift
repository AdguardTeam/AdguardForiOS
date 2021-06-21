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

public protocol AdGuardSDKMediatorFiltersProtocol {
    /**
     Returns all Groups objects
     */
    var groups: [SafariGroupProtocol] { get }
    
    /**
     Enables or disables group by **group type**
     - Parameter type: type of the group that should be enabled/disabled
     - Parameter enabled: new group state
     - Parameter onGroupSet: closure to handle error if exists
     */
    func setGroup(_ groupType: SafariGroup.GroupType, enabled: Bool, onGroupSet: @escaping (_ error: Error?) -> Void)
    
    /**
     Enables or disables filter by **filter id** and **group id**
     - Parameter id: id of the filter that should be enabled/disabled
     - Parameter groupId: id of the group that filter belongs
     - Parameter enabled: new filter state
     - Parameter onFilterSet: closure to handle error if exists
     */
    func setFilter(withId id: Int, _ groupId: Int, enabled: Bool, _ onFilterSet: @escaping (_ error: Error?) -> Void)
    
    /**
     Adds **customFilter**
     - Parameter customFilter: Meta data of filter
     - Parameter enabled: new filter state
     - Parameter onFilterAdded: closure to handle error if exists
     */
    func add(customFilter: ExtendedCustomFilterMetaProtocol, enabled: Bool, _ onFilterAdded: @escaping (_ error: Error?) -> Void)
    
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
     - Parameter onFilterDeleted: closure to handle error if exists
     */
    func deleteCustomFilter(withId id: Int, _ onFilterDeleted: @escaping (_ error: Error?) -> Void)
}

extension AdGuardSDKMediator {
    
    // MARK: - Public variables
    
    public var groups: [SafariGroupProtocol] {
        return workingQueue.sync {
            return filters.groups
        }
    }
    
    // MARK: - Public methods
    
    public func setGroup(_ groupType: SafariGroup.GroupType, enabled: Bool, onGroupSet: @escaping (_ error: Error?) -> Void) {
        workingQueue.async { [unowned self] in
            executeBlockAndReloadCbs {
                Logger.logInfo("(AdGuardSDKMediator) - setGroup; Setting group with id=\(groupType.id) to enabled=\(enabled)")
                try filters.setGroup(withId: groupType.id, enabled: enabled)
            } onCbReloaded: { error in
                if let error = error {
                    Logger.logError("(AdGuardSDKMediator) - setGroup; Error reloading CBs when setting group with id=\(groupType.id) to enabled=\(enabled): \(error)")
                } else {
                    Logger.logInfo("(AdGuardSDKMediator) - setGroup; Successfully reloaded CBs after setting group with id=\(groupType.id) to enabled=\(enabled)")
                }
                completionQueue.async { onGroupSet(error) }
            }
        }
    }
    
    public func setFilter(withId id: Int, _ groupId: Int, enabled: Bool, _ onFilterSet: @escaping (_ error: Error?) -> Void) {
        workingQueue.async { [unowned self] in
            executeBlockAndReloadCbs {
                Logger.logInfo("(AdGuardSDKMediator) - setFilter; Setting filter with id=\(id), group id=\(groupId) to enabled=\(enabled)")
                try filters.setFilter(withId: id, groupId, enabled: enabled)
            } onCbReloaded: { error in
                if let error = error {
                    Logger.logError("(AdGuardSDKMediator) - setFilter; Error reloading CBs when setting filter with id=\(id), group id=\(groupId) to enabled=\(enabled): \(error)")
                } else {
                    Logger.logInfo("(AdGuardSDKMediator) - setFilter; Successfully reloaded CBs after setting filter with id=\(id), group id=\(groupId) to enabled=\(enabled)")
                }
                completionQueue.async { onFilterSet(error) }
            }
        }
    }
    
    public func add(customFilter: ExtendedCustomFilterMetaProtocol, enabled: Bool, _ onFilterAdded: @escaping (_ error: Error?) -> Void) {
        workingQueue.async { [unowned self] in
            Logger.logInfo("(AdGuardSDKMediator) - addCustomFilter; Add custom filter: \(customFilter)")
            var addError: Error?
            let group = DispatchGroup()
            group.enter()
            filters.add(customFilter: customFilter, enabled: enabled) { error in
                addError = error
                group.leave()
            }
            group.wait()
            
            if let addError = addError {
                Logger.logError("(AdGuardSDKMediator) - addCustomFilter; Error adding custom filter: \(customFilter) to storage, error: \(addError)")
                completionQueue.async { onFilterAdded(addError) }
                return
            }
            
            reloadContentBlockers { error in
                if let error = error {
                    Logger.logError("(AdGuardSDKMediator) - addCustomFilter; Error reloading CBs when adding custom filter: \(customFilter); Error: \(error)")
                } else {
                    Logger.logInfo("(AdGuardSDKMediator) - addCustomFilter; Successfully reloaded CBs after adding custom filter: \(customFilter)")
                }
                completionQueue.async { onFilterAdded(error) }
            }
        }
    }
    
    public func deleteCustomFilter(withId id: Int, _ onFilterDeleted: @escaping (_ error: Error?) -> Void) {
        workingQueue.async { [unowned self] in
            executeBlockAndReloadCbs {
                Logger.logInfo("(AdGuardSDKMediator) - deleteCustomFilter; Delete custom filter with id=\(id)")
                try filters.deleteCustomFilter(withId: id)
            } onCbReloaded: { error in
                if let error = error {
                    Logger.logError("(AdGuardSDKMediator) - deleteCustomFilter; Error reloading CBs when deleting custom filter with id=\(id): \(error)")
                } else {
                    Logger.logInfo("(AdGuardSDKMediator) - deleteCustomFilter; Successfully reloaded CBs after deleting custom filter with id=\(id)")
                }
                completionQueue.async { onFilterDeleted(error) }
            }
        }
    }
    
    public func renameCustomFilter(withId id: Int, to name: String) throws {
        try workingQueue.sync { [unowned self] in
            Logger.logInfo("(AdGuardSDKMediator) - renameCustomFilter; Rename custom filter with id=\(id) to name=\(name)")
            try filters.renameCustomFilter(withId: id, to: name)
        }
    }
}
