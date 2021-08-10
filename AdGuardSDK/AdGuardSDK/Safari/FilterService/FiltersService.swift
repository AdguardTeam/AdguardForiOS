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

// MARK: - FiltersUpdateResult

/**
 This object is needed to provide user with information about filters and groups meta updates
 If you want to get more info about filters or groups themselves you can searh them by filter or group id respectively
 */
public struct FiltersUpdateResult {
    public var updatedFilterIds: [Int] = [] // Identifiers of filters that were successfully updated
    public var failedFilterIds: [Int] = [] // Identifiers of filters that failed to update
    public var addedFilterIds: [Int] = [] // Identifiers of filters that were successfully added while updating
    public var removedFiltersIds: [Int] = [] // Identifiers of filters that were successfully removed
    public var error: Error? // If this object exists and was passed till SafariProtection the only step where error can occur is Reloading CBs
}

// MARK: - FiltersService

protocol FiltersServiceProtocol: ResetableAsyncProtocol {
    /**
     Returns all Groups objects
     */
    var groups: [SafariGroup] { get }
    
    /**
     Checks update conditions for meta and updates them if needed
     - Parameter forcibly: ignores update conditions and immediately updates filters
     - Parameter onFiltersUpdated: closure to handle update **result**
     */
    func updateAllMeta(forcibly: Bool, onFiltersUpdated: @escaping (_ result: Result<FiltersUpdateResult>) -> Void)
    
    /**
     Enables or disables group by **group id**
     - Parameter id: id of the group that should be enabled/disabled
     - Parameter enabled: new group state
     */
    func setGroup(withId id: Int, enabled: Bool) throws
  
    /**
     Enables or disables filter by **filter id** and **group id**
     - Parameter id: id of the filter that should be enabled/disabled
     - Parameter groupId: id of the group that filter belongs
     - Parameter enabled: new filter state
     */
    func setFilter(withId id: Int, _ groupId: Int, enabled: Bool) throws
    
    
    // MARK: - Custom filters methods
    
    /**
     Adds **customFilter**
     - Parameter customFilter: Meta data of filter
     - Parameter enabled: new filter state
     - Parameter onFilterAdded: closure to handle error if exists
     */
    func add(customFilter: ExtendedCustomFilterMetaProtocol, enabled: Bool, _ onFilterAdded: @escaping (_ error: Error?) -> Void)
    
    /**
     Deletes filter with **id**
     - Parameter id: id of the filter that should be deleted
     - throws: Can throw error if error occured while deleting filter
     */
    func deleteCustomFilter(withId id: Int) throws

    /**
     Renames filter with **id** to **name**
     - Parameter id: id of the filter that should be deleted
     - Parameter name: new filter name
     - throws: Can throw error if error occured while renaming filter
     */
    func renameCustomFilter(withId id: Int, to name: String) throws
}

/*
 This class is a proxy between filters, groups objects and SQLite database.
 It is used to get or modify filters objects.
 */
final class FiltersService: FiltersServiceProtocol {
    
    // MARK: - FilterServiceError
    
    enum FilterServiceError: Error, CustomDebugStringConvertible {
        case invalidCustomFilterId(filterId: Int)
        case updatePeriodError(lastUpdateTime: Int)
        case missedFilterDownloadPage(filterName: String)
        case nonExistingGroupId(groupId: Int)
        case nonExistingFilterId(filterId: Int)
        case unknownError
        
        var debugDescription: String {
            switch self {
            case .invalidCustomFilterId(let filterId): return "Custom filter id must be greater or equal than \(CustomFilterMeta.baseCustomFilterId), actual filter id=\(filterId)"
            case .updatePeriodError(let lastUpdateTime): return "Last update was \(lastUpdateTime) hours ago. Minimum update period is \(Int(FiltersService.updatePeriod / 3600)) hours"
            case .missedFilterDownloadPage(let filterName): return "Filter download page is missed for filter with name \(filterName)"
            case .nonExistingGroupId(groupId: let id): return "Group with id: \(id) not exists"
            case .nonExistingFilterId(filterId: let id): return "Filter with id: \(id) not exists"
            case .unknownError: return "Unknown error"
            }
        }
    }
    
    // MARK: - Public properties
    
    var groups: [SafariGroup] { _groupsAtomic.wrappedValue }
    
    // MARK: - Private properties
    
    // Filters update period; We should check filters updates once per 6 hours
    private static let updatePeriod: TimeInterval = 3600 * 6
    
    // Helper variable to make groups variable thread safe
    @Atomic private var groupsAtomic: [SafariGroup] = []
    
    // Working queue
    private let workingQueue = DispatchQueue(label: "AdGuardSDK.FiltersService.workingQueue")
    
    // Queue to call completion blocks
    private let completionQueue = DispatchQueue.main
    
    /* Services */
    let configuration: SafariConfigurationProtocol
    let filterFilesStorage: FilterFilesStorageProtocol
    let metaStorage: MetaStorageProtocol
    let userDefaultsStorage: UserDefaultsStorageProtocol
    let metaParser: CustomFilterMetaParserProtocol
    let apiMethods: SafariProtectionApiMethodsProtocol
    
    // MARK: - Initialization
    
    init(
        configuration: SafariConfigurationProtocol,
        filterFilesStorage: FilterFilesStorageProtocol,
        metaStorage: MetaStorageProtocol,
        userDefaultsStorage: UserDefaultsStorageProtocol,
        metaParser: CustomFilterMetaParserProtocol = CustomFilterMetaParser(),
        apiMethods: SafariProtectionApiMethodsProtocol
    ) throws {
        self.configuration = configuration
        self.filterFilesStorage = filterFilesStorage
        self.metaStorage = metaStorage
        self.userDefaultsStorage = userDefaultsStorage
        self.metaParser = metaParser
        self.apiMethods = apiMethods
        try self._groupsAtomic.mutate { $0.append(contentsOf: try getAllLocalizedGroups()) }
    }
    
    // MARK: - Public methods
    
    func updateAllMeta(forcibly: Bool, onFiltersUpdated: @escaping (_ result: Result<FiltersUpdateResult>) -> Void) {
        var preconditionError: Error?
        var updateMetadataError: Error?
        var groupsUpdateError: Error?
        
        var updateResult = FiltersUpdateResult()
        
        let comletionGroup = DispatchGroup()
        
        workingQueue.async(group: comletionGroup) { [weak self] in
            guard let self = self else {
                preconditionError = CommonError.missingSelf
                return
            }
            
            // Check update conditions
            let now = Date().timeIntervalSince(self.userDefaultsStorage.lastFiltersUpdateCheckDate)
            if now < Self.updatePeriod && !forcibly {
                preconditionError = FilterServiceError.updatePeriodError(lastUpdateTime: Int(now / 3600))
                Logger.logError("(FiltersService) - Update period error: \(preconditionError!)")
                return
            }
            
            // Notify that filters started to update
            NotificationCenter.default.filtersUpdateStarted()
            
            var updatedFilterFilesIds: Set<Int> = []
            
            // Update filters file content
            let group = DispatchGroup()
            group.enter()
            self.updateFiltersFileContent { result in
                updatedFilterFilesIds = result.0
                updateResult.failedFilterIds = result.1.sorted()
                
                group.leave()
            }
            // Wait when files finish updating
            group.wait()
            
            // Update filters metadata
            group.enter()
            self.updateMetadataForFilters(withIds: updatedFilterFilesIds) { result in
                switch result {
                case .success(let metaResult):
                    updateResult.addedFilterIds = metaResult.0
                    updateResult.removedFiltersIds = metaResult.1
                    updateResult.updatedFilterIds = metaResult.2
                case .error(let error):
                    updateMetadataError = error
                }
                group.leave()
            }
            // Wait when meta finishes updating
            group.wait()
            
            // Fill groups with actual objects
            // Even if updateMetadataError exists we update groups variable to make it actual as DB could change
            do {
                try self._groupsAtomic.mutate { $0 = try self.getAllLocalizedGroups() }
            } catch {
                groupsUpdateError = error
                Logger.logError("(FiltersService) - updateAllMeta; Localized groups fetching error: \(error)")
            }
            
            // Notify that filters finished updating
            NotificationCenter.default.filtersUpdateFinished()
        }
        
        // Save filters update time if filters were successfully updated
        if preconditionError == nil, updateMetadataError == nil, groupsUpdateError == nil {
            userDefaultsStorage.lastFiltersUpdateCheckDate = Date()
        }
        comletionGroup.notify(queue: .main) {
            if let preconditionError = preconditionError {
                onFiltersUpdated(.error(preconditionError))
            }
            else if let updateMetadataError = updateMetadataError {
                onFiltersUpdated(.error(updateMetadataError))
            }
            else if let groupsUpdateError = groupsUpdateError {
                onFiltersUpdated(.error(groupsUpdateError))
            }
            else {
                onFiltersUpdated(.success(updateResult))
            }
        }
    }
    
    func setGroup(withId id: Int, enabled: Bool) throws {
        try workingQueue.sync {
            do {
                try metaStorage.setGroup(withId: id, enabled: enabled)
                if let groupIndex = groupsAtomic.firstIndex(where: { $0.groupId == id }) {
                    _groupsAtomic.mutate { $0[groupIndex].isEnabled = enabled }
                    Logger.logDebug("(FiltersService) - setGroup; Group with id=\(id) was successfully set to enabled=\(enabled)")
                } else {
                    Logger.logDebug("(FiltersService) - setGroup; Group with id=\(id) not exists")
                    throw FilterServiceError.nonExistingGroupId(groupId: id)
                }
            } catch {
                Logger.logError("(FiltersService) - setGroup; Error setting group with id=\(id) to enabled=\(enabled): \(error)")
                throw error
            }
        }
    }
    
    func setFilter(withId id: Int, _ groupId: Int, enabled: Bool) throws {
        try workingQueue.sync {
            do {
                try metaStorage.setFilter(withId: id, enabled: enabled)
                if let groupIndex = groupsAtomic.firstIndex(where: { $0.groupType.id == groupId }),
                   let filterIndex = groupsAtomic[groupIndex].filters.firstIndex(where: { $0.filterId == id }) {
                    
                    _groupsAtomic.mutate { $0[groupIndex].filters[filterIndex].isEnabled = enabled }
                    Logger.logDebug("(FiltersService) - setFilter; Filter id=\(id); group id=\(groupId) was successfully set to enabled=\(enabled)")
                } else {
                    Logger.logDebug("(FiltersService) - setFilter; Filter id=\(id) or group id=\(groupId) not exists")
                    throw FilterServiceError.nonExistingFilterId(filterId: id)
                }

            } catch {
                Logger.logError("(FiltersService) - setFilter; Error setting filtrer with id=\(id); group id=\(groupId) to enabled=\(enabled): \(error)")
                throw error
            }
        }
    }
    
    func add(customFilter: ExtendedCustomFilterMetaProtocol, enabled: Bool, _ onFilterAdded: @escaping (_ error: Error?) -> Void) {
        workingQueue.async { [weak self] in
            
            guard let self = self,
                  let filterDownloadPage = customFilter.filterDownloadPage,
                  let subscriptionUrl = URL(string: filterDownloadPage)
            else {
                let error = FilterServiceError.missedFilterDownloadPage(filterName: customFilter.name ?? "nil")
                Logger.logError("(FiltersService) - add custom filter; \(error)")
                DispatchQueue.main.async { onFilterAdded(error) }
                return
            }
            
            let filterId = self.metaStorage.nextCustomFilterId
            let customGroup = self.groupsAtomic.first(where: { $0.groupType == .custom })!
            let filterToAdd = ExtendedFiltersMeta.Meta(customFilterMeta: customFilter, filterId: filterId, displayNumber: filterId, group: customGroup)
            
            do {
                try self.addCustomFilterSync(withId: filterId, subscriptionUrl: subscriptionUrl)
                try self.metaStorage.add(filter: filterToAdd, enabled: enabled)
            }
            catch {
                Logger.logError("(FiltersService) - add custom filter; Errow while adding: \(error)")
                self.completionQueue.async { onFilterAdded(error) }
                return
            }
            
            let customGroupIndex = self.groupsAtomic.firstIndex(where: { $0.groupType == .custom })!
            let safariFilter = SafariGroup.Filter(customFilter: customFilter,
                                                  filterId: filterId,
                                                  isEnabled: true,
                                                  group: self.groupsAtomic[customGroupIndex],
                                                  displayNumber: filterId)
            self._groupsAtomic.mutate { $0[customGroupIndex].filters.append(safariFilter) }
            
            Logger.logInfo("(FiltersService) - add customFilter; Custom filter with id = \(filterId) was successfully added")
            self.completionQueue.async { onFilterAdded(nil) }
        }
    }
    
    func deleteCustomFilter(withId id: Int) throws {
        try workingQueue.sync {
            guard id >= CustomFilterMeta.baseCustomFilterId else {
                let error = FilterServiceError.invalidCustomFilterId(filterId: id)
                Logger.logError("(FiltersService) - deleteCustomFilter; Invalid custom filter id: \(error)")
                throw error
            }
            try metaStorage.deleteFilter(withId: id)
            try filterFilesStorage.deleteFilter(withId: id)
            
            let customGroupIndex = groupsAtomic.firstIndex(where: { $0.groupType == .custom })!
            _groupsAtomic.mutate { $0[customGroupIndex].filters.removeAll(where: { $0.filterId == id }) }
            Logger.logDebug("(FiltersService) - deleteCustomFilter; Custom filter with id = \(id) was successfully deleted")
        }
    }
    
    func renameCustomFilter(withId id: Int, to name: String) throws {
        try workingQueue.sync {
            guard id >= CustomFilterMeta.baseCustomFilterId else {
                let error = FilterServiceError.invalidCustomFilterId(filterId: id)
                Logger.logError("(FiltersService) - renameCustomFilter; Invalid custom filter id: \(error)")
                throw error
            }
            try metaStorage.renameFilter(withId: id, name: name)
            let customGroupIndex = groupsAtomic.firstIndex(where: { $0.groupType == .custom })!
            let filterIndex = groupsAtomic[customGroupIndex].filters.firstIndex(where: { $0.filterId == id })!
            let filter = groupsAtomic[customGroupIndex].filters[filterIndex]
            let newFilter = SafariGroup.Filter(name: name,
                                               description: filter.description,
                                               isEnabled: filter.isEnabled,
                                               filterId: filter.filterId,
                                               version: filter.version,
                                               lastUpdateDate: filter.lastUpdateDate,
                                               updateFrequency: filter.updateFrequency,
                                               group: filter.group,
                                               displayNumber: filter.displayNumber,
                                               languages: filter.languages,
                                               tags: filter.tags,
                                               homePage: filter.homePage,
                                               filterDownloadPage: filter.filterDownloadPage,
                                               rulesCount: filter.rulesCount)
            
            _groupsAtomic.mutate { $0[customGroupIndex].filters[filterIndex] = newFilter }
            Logger.logDebug("(FiltersService) - renameCustomFilter; Custom filter with id = \(id) was successfully renamed")
        }
    }
    
    /* Resets all data stored to default */
    func reset(_ onResetFinished: @escaping (Error?) -> Void) {
        workingQueue.async { [weak self] in
            Logger.logInfo("(FiltersService) - reset start")
            
            guard let self = self else {
                onResetFinished(CommonError.missingSelf)
                return
            }
            
            do {
                try self.metaStorage.reset()
                try self.filterFilesStorage.reset()
            }
            catch {
                Logger.logInfo("(FiltersService) - reset; Error: \(error)")
                onResetFinished(error)
                return
            }
            
            self.userDefaultsStorage.lastFiltersUpdateCheckDate = Date(timeIntervalSince1970: 0.0)
            
            self.updateAllMeta(forcibly: true) { result in
                if case .error(let error) = result {
                    Logger.logError("(FiltersService) - reset; Error updating meta after reset; Error: \(error)")
                } else {
                    Logger.logInfo("(FiltersService) - reset; Successfully reset all groups")
                }
                
                do {
                    try self._groupsAtomic.mutate { $0 = try self.getAllLocalizedGroups() }
                    Logger.logInfo("(FiltersService) - reset; Successfully updated groups")
                }
                catch {
                    Logger.logError("(FiltersService) - reset; Error updating groups; Error: \(error)")
                    onResetFinished(error)
                    return
                }
                
                switch result {
                case .success(_): onResetFinished(nil)
                case .error(let error): onResetFinished(error)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    /**
     Adds info about filter to all storages
     First it downloads the filter file from the server and saves it to our file system
     Than it saves all filter meta to the database
     */
    private func add(filter: ExtendedFilterMetaProtocol, _ onFilterAdded: @escaping (_ error: Error?) -> Void) {
        Logger.logInfo("(FiltersService) - addFilter; Received new filter with id=\(filter.filterId) from server, add it now")
        
        filterFilesStorage.updateFilter(withId: filter.filterId) { [weak self] error in
            guard let self = self else {
                onFilterAdded(CommonError.missingSelf)
                return
            }
            
            if let error = error {
                Logger.logError("(FiltersService) - addFilter; Content for filter with id=\(filter.filterId) wasn't loaded. Error: \(error)")
                onFilterAdded(error)
                return
            }
            Logger.logInfo("(FiltersService) - addFilter; Content for filter with id=\(filter.filterId) was loaded and saved")
            
            do {
                try self.metaStorage.add(filter: filter, enabled: false)
                try self.metaStorage.updateAll(tags: filter.tags, forFilterWithId: filter.filterId)
                try self.metaStorage.updateAll(langs: filter.languages, forFilterWithId: filter.filterId)
                Logger.logInfo("(FiltersService) - addFilter; Filter with id=\(filter.filterId) was added")
                onFilterAdded(nil)
            }
            catch {
                Logger.logError("(FiltersService) - addFilter; Meta for filter with id=\(filter.filterId) wasn't updated. Error: \(error)")
                onFilterAdded(error)
                return
            }
        }
    }
    
    /**
     It's a wrapper for **addFilter** function to add multiple filters syncroniously
     - Returns ids of filters that were successfully added to our storage
     */
    func add(filters: [ExtendedFilterMetaProtocol]) -> [Int] {
        Logger.logInfo("(FiltersService) - addFilters; Trying to add \(filters.count) filters")
        
        @Atomic var addedFiltersIds: [Int] = []
        
        let group = DispatchGroup()
        for filter in filters {
            group.enter()
            add(filter: filter) { error in
                if let error = error {
                    Logger.logError("(FiltersService) - addFilters; Filter with id=\(filter.filterId) wasn't added. Error: \(error)")
                } else {
                    _addedFiltersIds.mutate { $0.append(filter.filterId) }
                }
                group.leave()
            }
        }
        group.wait()
        
        return addedFiltersIds
    }
    
    /**
     Removes all filters data for passed filter ids
     - Parameter ids: ids of filters that should be deleted
     - Returns ids of filters that were successfully removed from our storage
     */
    private func removeFilters(withIds ids: [Int]) -> [Int] {
        Logger.logInfo("(FiltersService) - removeFilters; Trying to remove \(ids.count) filters")
        
        var removedFiltersIds: [Int] = []
        for id in ids {
            do {
                try metaStorage.deleteFilter(withId: id)
                try filterFilesStorage.deleteFilter(withId: id)
                removedFiltersIds.append(id)
            }
            catch {
                Logger.logError("(FiltersService) - removeFilters; Filter with id=\(id) wasn't removed. Error: \(error)")
            }
        }
        
        return removedFiltersIds
    }
    
    /* Returns all groups from database with filters and localizations */
    private func getAllLocalizedGroups() throws -> [SafariGroup] {
        let localizedGroupsMeta = try metaStorage.getAllLocalizedGroups(forLanguage: configuration.currentLanguage)
        return try localizedGroupsMeta.map { groupMeta in
            let group = SafariGroup(dbGroup: groupMeta, filters: [])
            let groupFilters = try getFilters(forGroup: group)
            
            return SafariGroup(filters: groupFilters,
                               isEnabled: group.isEnabled,
                               groupType: group.groupType,
                               groupName: group.groupName,
                               displayNumber: group.displayNumber)
        }
    }
    
    /* Returns filters meta for sprecified group */
    private func getFilters(forGroup group: SafariGroupProtocol) throws -> [SafariGroup.Filter] {
        let localizedFiltersMeta = try metaStorage.getLocalizedFiltersForGroup(withId: group.groupId, forLanguage: configuration.currentLanguage)
        return try localizedFiltersMeta.map { dbFilter in
            // TODO: - Maybe we should store rulesCount in database
            let meta = getMetaForFilter(withId: dbFilter.filterId)
            let languages = try metaStorage.getLangsForFilter(withId: dbFilter.filterId)
            let tags = try metaStorage.getTagsForFilter(withId: dbFilter.filterId)
            return SafariGroup.Filter(dbFilter: dbFilter,
                                      group: group,
                                      rulesCount: meta?.rulesCount,
                                      languages: languages,
                                      tags: tags,
                                      filterDownloadPage: dbFilter.subscriptionUrl)
        }
    }
    
    /* Gets filter file content, parses it's meta and returns it */
    private func getMetaForFilter(withId id: Int) -> ExtendedCustomFilterMetaProtocol? {
        guard let filterContent = filterFilesStorage.getFilterContentForFilter(withId: id) else {
            Logger.logError("(FiltersService) - getRulesCountForFilter; received nil for filter with id=\(id)")
            return nil
        }
        
        do {
            return try metaParser.parse(filterContent, for: .safari)
        } catch {
            Logger.logError("(FiltersService) - getRulesCountForFilter; received error for filter with id=\(id); error: \(error)")
            return nil
        }
    }
    
    /**
     Updates filters file content
     - Returns ids of groups which filters were updated; ids of filters that were updated; ids of filters that failed to update
     */
    private typealias FiltersFileUpdateResult = (updatedFilterIds: Set<Int>, failedFilterIds: Set<Int>)
    private func updateFiltersFileContent(onFilesUpdated: @escaping (FiltersFileUpdateResult) -> Void) {
        @Atomic var successfullyLoadedFilterIds: Set<Int> = []
        @Atomic var failedFilterIds: Set<Int> = []
        
        let group = DispatchGroup()
        let allFilters = groupsAtomic.flatMap { $0.filters }
        
        guard allFilters.count > 0 else {
            onFilesUpdated(([], []))
            return
        }
        
        allFilters.forEach { filter in
            group.enter()
            
            // Update filter file
            updateFilterFileContent(filter: filter) { error in
                if let error = error {
                    Logger.logError("(FiltersService) - updateFiltersFileContent; Failed to download content of filter with id=\(filter.filterId); Error: \(error)")
                    _failedFilterIds.mutate { $0.insert(filter.filterId) }
                } else {
                    Logger.logDebug("(FiltersService) - updateFiltersFileContent; Successfully downloaded content of filter with id=\(filter.filterId)")
                    _successfullyLoadedFilterIds.mutate { $0.insert(filter.filterId) }
                }
                group.leave()
            }
        }
        let result = (_successfullyLoadedFilterIds.wrappedValue, _failedFilterIds.wrappedValue)
        group.notify(queue: .main) { onFilesUpdated(result) }
    }
    
    /**
     Downloads filter metadata and metadata localizations and saves it to database
     While updating meta we can obtain some new filters or find out that some filters no longer exist
     If update was successfull we return update result with new filter ids and removed filter ids in completion
     If update fails we provide an error in completion
     */
    private func updateMetadataForFilters(withIds ids: Set<Int>, onFiltersMetaUpdated: @escaping (_ result: Result<FiltersMetaUpdateResult>) -> Void) {
        var resultError: Error?
        var metaUpdateResult: FiltersMetaUpdateResult?
        let group = DispatchGroup()
        
        group.enter()
        apiMethods.loadFiltersMetadata(version: configuration.appProductVersion,
                                               id: configuration.appId,
                                               cid: configuration.cid,
                                               lang: configuration.currentLanguage) { [weak self] filtersMeta in
            if let meta = filtersMeta {
                do {
                    metaUpdateResult = try self?.save(filtersMeta: meta, filtersIdsToUpdate: ids)
                } catch {
                    resultError = error
                    Logger.logError("(FiltersService) - Saving filters metadata error: \(error)")
                }
            }
            group.leave()
        }
        
        group.enter()
        apiMethods.loadFiltersLocalizations { [weak self] filtersMetaLocalizations in
            if let localizations = filtersMetaLocalizations {
                do {
                    try self?.save(localizations: localizations, filtersIdsToSave: ids)
                } catch {
                    resultError = error
                    Logger.logError("(FiltersService) - Saving filters localizations error: \(error)")
                }
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = resultError {
                onFiltersMetaUpdated(.error(error))
            } else if let metaUpdateResult = metaUpdateResult {
                onFiltersMetaUpdated(.success(metaUpdateResult))
            } else {
                onFiltersMetaUpdated(.error(CommonError.missingData))
            }
        }
    }
    
    /**
     Updates filters and groups meta in database that were downloaded
     Also checks if new filters were received and existing became obsolete
     - Parameter filtersMeta: Meta that was loaded from the server
     - Parameter filtersIdsToUpdate: Ids of filters that were successfully downloaded from the server
     - Parameter groupIds: Ids of groups which filters were successfully downloaded from the server
     - Returns ids of filters that were successfully added; ids of filters that were successfully removed
     */
    private typealias FiltersMetaUpdateResult = (addedFilterIds: [Int], removedFiltersIds: [Int], updatedFiltersIds: [Int])
    private func save(filtersMeta: ExtendedFiltersMeta, filtersIdsToUpdate: Set<Int>) throws -> FiltersMetaUpdateResult {
        // Meta received from the server
        let allGroupsMeta = filtersMeta.groups
        let allFiltersMeta = filtersMeta.filters
        
        // Meta we should try to update in database
        let filtersToUpdate = allFiltersMeta.filter { filtersIdsToUpdate.contains($0.filterId) }
        
        // Update Groups meta
        if !allGroupsMeta.isEmpty {
            try metaStorage.update(groups: allGroupsMeta)
        }
        
        // Update Filters meta
        var updatedFiltersIds: [Int] = []
        if !filtersToUpdate.isEmpty {
            updatedFiltersIds = try metaStorage.update(filters: filtersToUpdate)
        }
        
        // Update Tags and Langs meta only for updated filters
        let updatedFilters = filtersToUpdate.filter { updatedFiltersIds.contains($0.filterId) }
        try updatedFilters.forEach {
            try metaStorage.updateAll(tags: $0.tags, forFilterWithId: $0.filterId)
            try metaStorage.updateAll(langs: $0.languages, forFilterWithId: $0.filterId)
        }
        
        let existingFilterIds = groupsAtomic.flatMap { $0.filters }.map { $0.filterId }
        let receivedMetaFilterIds = allFiltersMeta.map { $0.filterId }
        
        // Add new filters if appeared
        let newFilterIds = Set(receivedMetaFilterIds).subtracting(existingFilterIds)
        let filtersToAdd = allFiltersMeta.filter { newFilterIds.contains($0.filterId) }
        let addedFilterIds = add(filters: filtersToAdd)
        
        // Remove filters if removed on the server
        let obsoleteFilterIds = Set(existingFilterIds).subtracting(receivedMetaFilterIds)
        let removedFiltersIds = removeFilters(withIds: obsoleteFilterIds.sorted())
        
        return (addedFilterIds, removedFiltersIds, updatedFiltersIds)
    }
    
    /* Updates filters and groups localizations in database that were downloaded */
    private func save(localizations: ExtendedFiltersMetaLocalizations, filtersIdsToSave: Set<Int>) throws {
        // Groups localizations received from the server
        let allGroupsLocalizations = localizations.groups
        let allGroupIdsReceived = allGroupsLocalizations.keys
        
        // Updating groups localizations in database
        for groupId in allGroupIdsReceived {
            let localizationsByLangs = allGroupsLocalizations[groupId] ?? [:]
            let langs = localizationsByLangs.keys
            for lang in langs {
                let localization = localizationsByLangs[lang]!
                try metaStorage.updateLocalizationForGroup(withId: groupId, forLanguage: lang, localization: localization)
            }
        }
        
        // Filters localizations received from the server
        let allFilterLocalizations = localizations.filters
        let allFilterIdsReceived = allFilterLocalizations.keys
        
        // Updating filters localizations in database
        for filterId in allFilterIdsReceived {
            let localizationsByLangs = allFilterLocalizations[filterId] ?? [:]
            let langs = localizationsByLangs.keys
            for lang in langs {
                let localization = localizationsByLangs[lang]!
                try metaStorage.updateLocalizationForFilter(withId: filterId, forLanguage: lang, localization: localization)
            }
        }
    }
    
    /* Updates file filter's file content */
    private func updateFilterFileContent(filter: SafariFilterProtocol, onFilesUpdated: @escaping (_ error: Error?) -> Void) {
        if filter.group.groupId == SafariGroup.GroupType.custom.id {
            guard let filterDownloadPage = filter.filterDownloadPage,
                    let subscriptionUrl = URL(string: filterDownloadPage)
            else {
                Logger.logError("(FiltersService) - updateCustomFilter; filterDownloadPage is missed for filter with id = \(filter.filterId)")
                onFilesUpdated(FilterServiceError.missedFilterDownloadPage(filterName: "\(filter.name ?? "nil") and filter id = \(filter.filterId))"))
                return
            }
                
            filterFilesStorage.updateCustomFilter(withId: filter.filterId, subscriptionUrl: subscriptionUrl, onFilterUpdated: onFilesUpdated)
        } else {
            filterFilesStorage.updateFilter(withId: filter.filterId, onFilterUpdated: onFilesUpdated)
        }
    }
    
    /* Adds custom filter to files storage syncroniously */
    private func addCustomFilterSync(withId id: Int, subscriptionUrl: URL) throws {
        var resultError: Error?
        
        let group = DispatchGroup()
        group.enter()
        filterFilesStorage.updateCustomFilter(withId: id, subscriptionUrl: subscriptionUrl) { error in
            resultError = error
            group.leave()
        }
        group.wait()
        
        if let error = resultError {
            throw error
        }
    }
}

// MARK: - UserDefaultsStorageProtocol + FilterService variables

fileprivate extension UserDefaultsStorageProtocol {
    private var lastFiltersUpdateCheckDateKey: String { "AdGuardSDK.lastFiltersUpdateCheckDateKey" }
    
    var lastFiltersUpdateCheckDate: Date {
        get {
            if let date = storage.value(forKey: lastFiltersUpdateCheckDateKey) as? Date {
                return date
            }
            return Date(timeIntervalSince1970: 0.0)
        }
        set {
            storage.setValue(newValue, forKey: lastFiltersUpdateCheckDateKey)
        }
    }
}

// MARK: - NotificationCenter + FilterService events

fileprivate extension NSNotification.Name {
    static var filtersUpdateStarted: NSNotification.Name { .init(rawValue: "AdGuardSDK.filtersUpdateStarted") }
    static var filtersUpdateFinished: NSNotification.Name { .init(rawValue: "AdGuardSDK.filtersUpdateFinished") }
}

fileprivate extension NotificationCenter {
    func filtersUpdateStarted() {
        self.post(name: .filtersUpdateStarted, object: self, userInfo: nil)
        Logger.logDebug("(FiltersService) - filtersUpdateStarted; Notification filtersUpdateStarted posted")
    }
    
    func filtersUpdateFinished() {
        self.post(name: .filtersUpdateFinished, object: self, userInfo: nil)
        Logger.logDebug("(FiltersService) - filtersUpdateFinished; Notification filtersUpdateFinished posted")
    }
}

public extension NotificationCenter {
    func filtersUpdateStart(handler: @escaping () -> Void, queue: OperationQueue? = .main) -> NotificationToken {
        return self.observe(name: .filtersUpdateStarted, object: nil, queue: queue) { _ in
            handler()
        }
    }
    
    func filtersUpdateFinished(handler: @escaping () -> Void, queue: OperationQueue? = .main) -> NotificationToken {
        return self.observe(name: .filtersUpdateFinished, object: nil, queue: queue) { _ in
            handler()
        }
    }
}
