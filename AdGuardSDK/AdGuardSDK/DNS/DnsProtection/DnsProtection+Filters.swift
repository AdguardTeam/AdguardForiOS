

import Foundation

protocol DnsProtectionFiltersProtocol {
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
    func setFilter(withId id: Int, to enabled: Bool)
    
    /**
     Renames DNS filter by **id**
     - Parameter id: Unique identifier of DNS filter which state should be changed
     - Parameter name: New DNS filter name
     */
    func renameFilter(withId id: Int, to name: String)
    
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
    func removeFilter(withId id: Int)
    
    /**
     Removes DNS filters and it's meta from the storage
     - Parameter ids: Unique identifiers of DNS filters that should be removed
     */
    func removeFilters(withIds ids: [Int])
    
    
    /**
     Updates the specified DNS filter
     - Parameter id: Unique identifier of DNS filter that should be removed
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
    
    public func setFilter(withId id: Int, to enabled: Bool) {
        workingQueue.sync {
            do {
                try dnsFiltersManager.setFilter(withId: id, to: enabled)
                Logger.logInfo("(DnsProtection+Filters - setFilter; Enabled state for filter with id = \(id) is = \(enabled)")
            } catch {
                Logger.logError("(DnsProtection+Filters - setFilter; Error occurred while setting filter with id = \(id) to enabled state = \(enabled); error = \(error)")
            }
        }
    }
    
    public func renameFilter(withId id: Int, to name: String) {
        workingQueue.sync {
            do {
                try dnsFiltersManager.renameFilter(withId: id, to: name)
                Logger.logInfo("(DnsProtection+Filters - renameFilter; Filter with id = \(id) was renamed to \(name)")
            } catch {
                Logger.logError("(DnsProtection+Filters - renameFilter; Error occurred while renaming filter with id = \(id) to name = \(name)")
            }
        }
    }
    
    public func addFilter(withName name: String, url: URL, isEnabled: Bool, onFilterAdded: @escaping (Error?) -> Void) {
        workingQueue.sync {
            Logger.logInfo("(DnsProtection+Filters - addFilter; Start add filter with name = \(name), url = \(url), is enabled = \(isEnabled)")
            dnsFiltersManager.addFilter(withName: name, url: url, isEnabled: isEnabled, onFilterAdded: onFilterAdded)
        }
    }
    
    public func removeFilter(withId id: Int) {
        workingQueue.sync {
            do {
                try dnsFiltersManager.removeFilter(withId: id)
                Logger.logInfo("(DnsProtection+Filters - removeFilter; Filter with id = \(id) was removed")
            } catch {
                Logger.logError("(DnsProtection+Filters - removeFilter; Error occurred while removing filter with id = \(id)")
            }
        }
    }
    
    public func removeFilters(withIds ids: [Int]) {
        ids.forEach { removeFilter(withId: $0) }
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
