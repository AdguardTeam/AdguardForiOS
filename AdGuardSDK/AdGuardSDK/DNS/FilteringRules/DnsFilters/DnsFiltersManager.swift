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

protocol DnsFiltersManagerProtocol: ResetableSyncProtocol {
    
    /* Returns DNS filters meta objects */
    var filters: [DnsFilter] { get }
    
    /**
     Enables or disables filter by **id**
     - Parameter id: Unique identifier of DNS filter which state should be changed
     - Parameter enabled: New DNS filter state
     - Throws an error if there is no filter with such id
     */
    func setFilter(withId id: Int, to enabled: Bool) throws
    
    /**
     Renames DNS filter by **id**
     - Parameter id: Unique identifier of DNS filter which state should be changed
     - Parameter name: New DNS filter name
     - Throws an error if there is no filter with such id
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
     - Throws an error if saving to the storage failed
     */
    func removeFilter(withId id: Int) throws
    
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
    func updateAllFilters(onFilterUpdated: @escaping (_ result: DnsFiltersManager.UpdateResult) -> Void)
    
    /**
     This method is used when initializing DNS-lib to pass information about enabled DNS filters
     - Returns enabled DNS filters paths by filters ids
     */
    func getDnsLibsFilters() -> [Int: String]
}

/**
 This class is responsible for managing DNS filters files, meta from server and meta from user
 It also allows user to configure editable DNS filter meta and control filters state
 */
final class DnsFiltersManager: DnsFiltersManagerProtocol {
    // MARK: - Internal properties
    
    private(set) var filters: [DnsFilter] {
        get {
            return userDefaults.dnsFilters
        }
        set {
            userDefaults.dnsFilters = newValue
        }
    }
    
    // MARK: - Private properties
    
    private var nextFilterId: Int {
        let maxId = filters.max(by: { $0.filterId < $1.filterId })?.filterId ?? 0
        return maxId + 1
    }
    
    /* Services */
    private let userDefaults: UserDefaultsStorageProtocol
    private let filterFilesStorage: CustomFilterFilesStorageProtocol
    private let metaParser: CustomFilterMetaParserProtocol
    
    // MARK: - Initialization
    
    init(userDefaults: UserDefaultsStorageProtocol, filterFilesStorage: CustomFilterFilesStorageProtocol, metaParser: CustomFilterMetaParserProtocol) {
        self.userDefaults = userDefaults
        self.filterFilesStorage = filterFilesStorage
        self.metaParser = metaParser
    }
    
    // MARK: - Internal methods
    
    func setFilter(withId id: Int, to enabled: Bool) throws {
        Logger.logInfo("(DnsFiltersService) - setFilter; Trying to set filter with id=\(id) to enabled=\(enabled)")
        
        if let filterIndex = filters.firstIndex(where: { $0.filterId == id }) {
            filters[filterIndex].isEnabled = enabled
        } else {
            throw DnsFilterError.dnsFilterAbsent(filterId: id)
        }
        
        Logger.logInfo("(DnsFiltersService) - setFilter; Set filter with id=\(id) to enabled=\(enabled)")
    }
    
    func renameFilter(withId id: Int, to name: String) throws {
        Logger.logInfo("(DnsFiltersService) - renameFilter; Renaming filter with id=\(id) to name=\(name)")
        
        if let filterIndex = filters.firstIndex(where: { $0.filterId == id }) {
            filters[filterIndex].name = name
        } else {
            throw DnsFilterError.dnsFilterAbsent(filterId: id)
        }
        
        Logger.logInfo("(DnsFiltersService) - renameFilter; Renamed filter with id=\(id) to name=\(name)")
    }
    
    func addFilter(withName name: String, url: URL, isEnabled: Bool, onFilterAdded: @escaping (Error?) -> Void) {
        Logger.logInfo("(DnsFiltersService) - addFilter; Trying to add filter with name=\(name) url=\(url)")
        
        let filterId = nextFilterId
        filterFilesStorage.updateCustomFilter(withId: filterId, subscriptionUrl: url) { [weak self] error in
            guard let self = self else {
                onFilterAdded(CommonError.missingSelf)
                return
            }
            
            if let error = error {
                Logger.logError("(DnsFiltersService) - addFilter; Error adding custom filter to storage; Error: \(error)")
                onFilterAdded(error)
                return
            }
            
            var filterMeta: ExtendedCustomFilterMetaProtocol?
            if let filterContent = self.filterFilesStorage.getFilterContentForFilter(withId: filterId) {
                filterMeta = try? self.metaParser.parse(filterContent, for: .system)
            }
            let filter = DnsFilter(meta: filterMeta, name: name, filterId: filterId, subscriptionUrl: url, isEnabled: isEnabled)
            self.filters.append(filter)
            
            Logger.logInfo("(DnsFiltersService) - addFilter; Added DNS filter with name=\(name) url=\(url)")
            onFilterAdded(nil)
        }
    }
    
    func removeFilter(withId id: Int) throws {
        try filterFilesStorage.deleteFilter(withId: id)
        filters.removeAll(where: { $0.filterId == id })
    }
    
    func updateFilter(withId id: Int, onFilterUpdated: @escaping (Error?) -> Void) {
        Logger.logInfo("(DnsFiltersService) - updateFilter; Trying to update DNS filter with id=\(id)")
        
        guard let dnsFilterIndex = filters.firstIndex(where: { $0.filterId == id }) else {
            onFilterUpdated(DnsFilterError.dnsFilterAbsent(filterId: id))
            return
        }
        let dnsFilter = filters[dnsFilterIndex]
        
        filterFilesStorage.updateCustomFilter(withId: id, subscriptionUrl: dnsFilter.subscriptionUrl) { [weak self] error in
            guard let self = self else {
                onFilterUpdated(CommonError.missingSelf)
                return
            }
            
            if let error = error {
                Logger.logError("(DnsFiltersService) - updateFilter; Error updating custom DNS filter; Error: \(error)")
                onFilterUpdated(error)
                return
            }
            
            var filterMeta: ExtendedCustomFilterMetaProtocol?
            if let filterContent = self.filterFilesStorage.getFilterContentForFilter(withId: dnsFilter.filterId) {
                filterMeta = try? self.metaParser.parse(filterContent, for: .system)
            }
            
            let newFilter = DnsFilter(meta: filterMeta, name: dnsFilter.name ?? "", filterId: dnsFilter.filterId, subscriptionUrl: dnsFilter.subscriptionUrl, isEnabled: dnsFilter.isEnabled)
            self.filters[dnsFilterIndex] = newFilter
            
            Logger.logInfo("(DnsFiltersService) - updateFilter; Updated DNS filter with id=\(id)")
            onFilterUpdated(nil)
        }
    }
    
    func updateAllFilters(onFilterUpdated: @escaping (DnsFiltersManager.UpdateResult) -> Void) {
        Logger.logInfo("(DnsFiltersService) - updateAllFilters; Start")
        
        let group = DispatchGroup()
        
        var updatedIds: [Int] = []
        var unupdatedIds: [Int] = []
        for filter in filters {
            group.enter()
            updateFilter(withId: filter.filterId) { error in
                if error == nil {
                    updatedIds.append(filter.filterId)
                } else {
                    unupdatedIds.append(filter.filterId)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            onFilterUpdated(DnsFiltersManager.UpdateResult(updatedFiltersIds: updatedIds, unupdatedFiltersIds: unupdatedIds))
        }
    }
    
    func getDnsLibsFilters() -> [Int: String] {
        Logger.logInfo("(DnsFiltersService) - getDnsLibsFilters; Start")
        let enabledFiltersIds = filters.compactMap { $0.isEnabled ? $0.filterId : nil }
        
        var pathById: [Int: String] = [:]
        enabledFiltersIds.forEach { pathById[$0] = filterFilesStorage.getUrlForFilter(withId: $0).path }
        return pathById
    }
    
    func reset() throws {
        try filters.forEach { filter in
            try filterFilesStorage.deleteFilter(withId: filter.filterId)
            filters.removeAll(where: { $0.filterId == filter.filterId })
        }
    }
}

// MARK: - DnsFilterService + Helper objects
extension DnsFiltersManager {
    // MARK: - UpdateResult
    struct UpdateResult {
        let updatedFiltersIds: [Int]
        let unupdatedFiltersIds: [Int]
    }
    
    enum DnsFilterError: Error, CustomDebugStringConvertible {
        case dnsFilterAbsent(filterId: Int)
        
        var debugDescription: String {
            switch self {
            case .dnsFilterAbsent(let filterId): return "DNS filter with id=\(filterId) doesn't exist"
            }
        }
    }
}

// MARK: - UserDefaultsStorageProtocol + dnsFilters
fileprivate extension UserDefaultsStorageProtocol {
    private var dnsFiltersKey: String { "DnsAdGuardSDK.dnsFiltersKey" }
    
    var dnsFilters: [DnsFilter] {
        get {
            if let filtersData = storage.data(forKey: dnsFiltersKey) {
                let decoder = JSONDecoder()
                let filters = try? decoder.decode([DnsFilter].self, from: filtersData)
                return filters ?? []
            }
            return []
        }
        set {
            let encoder = JSONEncoder()
            if let filtersData = try? encoder.encode(newValue) {
                storage.setValue(filtersData, forKey: dnsFiltersKey)
                return
            }
            storage.setValue(Data(), forKey: dnsFiltersKey)
        }
    }
}
