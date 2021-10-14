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

import SharedAdGuardSDK

// TODO: Need tests
public protocol DnsProtectionFiltersProtocol {
    /** Returns DNS filters meta objects */
    var filters: [DnsFilter] { get }

    /**
        This variable is used when initializing DNS-lib to pass information about enabled DNS filters
        Returns enabled DNS filters paths by filters ids
     */
    var dnsLibsFilters: [Int: String] { get }

    /**
     Enables or disables filter by **id**
     - Parameter id: Unique identifier of DNS filter which state should be changed
     - Parameter enabled: New DNS filter state
     */
    func setFilter(withId id: Int, to enabled: Bool) throws

    /**
     Renames DNS filter by **id**
     - Parameter id: Unique identifier of DNS filter which state should be changed
     - Parameter name: New DNS filter name
     */
    func renameFilter(withId id: Int, to name: String) throws

    /**
     Adds new DNS filter to the storage and saves it's meta
     - Parameter name: DNS filter name that user did enter
     - Parameter url: URL where the filter is stored, it should be valid
     - Parameter isEnabled: Current DNS filter state
     - Parameter onFilterAdded: Closure to process an error if it occurs while downloading or saving the filter
     */
    func addFilter(withName name: String, url: URL, isEnabled: Bool, onFilterAdded: @escaping (Error?) -> Void)

    /**
     Removes DNS filter and it's meta from the storage
     - Parameter id: Unique identifier of DNS filter that should be removed
     */
    func removeFilter(withId id: Int) throws

    /**
     Updates the specified DNS filter
     - Parameter id: Unique identifier of DNS filter that should be updated
     - Parameter onFilterUpdated: Closure to process an error if it occurs while downloading or saving new filter data
     */
    func updateFilter(withId id: Int, onFilterUpdated: @escaping (_ error: Error?) -> Void)

    /**
     Updates all filters and metas stored
     - Parameter onFilterUpdated: Closure to process update result
     */
    func updateAllFilters(onFilterUpdated: @escaping (_ result: DnsFiltersUpdateResult) -> Void)
}

extension DnsProtection {

    public var filters: [DnsFilter] {
        workingQueue.sync {
            return dnsFiltersManager.filters
        }
    }

    public var dnsLibsFilters: [Int: String]  {
        workingQueue.sync {
            return dnsFiltersManager.getDnsLibsFilters()
        }
    }

    public func setFilter(withId id: Int, to enabled: Bool) throws {
        try workingQueue.sync {
            try dnsFiltersManager.setFilter(withId: id, to: enabled)
            Logger.logInfo("(DnsProtection+Filters - setFilter; Enabled state for filter with id = \(id) is = \(enabled)")
        }
    }

    public func renameFilter(withId id: Int, to name: String) throws {
        try workingQueue.sync {
            try dnsFiltersManager.renameFilter(withId: id, to: name)
            Logger.logInfo("(DnsProtection+Filters - renameFilter; Filter with id = \(id) was renamed to \(name)")
        }
    }

    public func addFilter(withName name: String, url: URL, isEnabled: Bool, onFilterAdded: @escaping (Error?) -> Void) {
        workingQueue.sync {
            Logger.logInfo("(DnsProtection+Filters - addFilter; Start add filter with name = \(name), url = \(url), is enabled = \(isEnabled)")
            dnsFiltersManager.addFilter(withName: name, url: url, isEnabled: isEnabled, onFilterAdded: onFilterAdded)
        }
    }

    public func removeFilter(withId id: Int) throws {
        try workingQueue.sync {
            try dnsFiltersManager.removeFilter(withId: id)
            Logger.logInfo("(DnsProtection+Filters - removeFilter; Filter with id = \(id) was removed")
        }
    }

    public func updateFilter(withId id: Int, onFilterUpdated: @escaping (_ error: Error?) -> Void) {
        workingQueue.sync {
            Logger.logInfo("(DnsProtection+Filters) - updateFilter; Start updating filter with id = \(id)")
            dnsFiltersManager.updateFilter(withId: id, onFilterUpdated: onFilterUpdated)
        }
    }

    public func updateAllFilters(onFilterUpdated: @escaping (_ result: DnsFiltersUpdateResult) -> Void) {
        workingQueue.sync {
            Logger.logInfo("(DnsProtection+Filters) - updateAllFilters; Start updating all filters")
            dnsFiltersManager.updateAllFilters(onFilterUpdated: onFilterUpdated)
        }
    }
}
