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

protocol FiltersServiceNewProtocol {
    var groups: [SafariGroup] { get }
    
    /**
     Checks update conditions for meta and updates them if needed
     - Parameter forcibly: ignores update conditions and immediately updates filters
     - Parameter onFiltersUpdated: closure to handle update **error**
     */
    func updateAllMeta(forcibly: Bool, onFiltersUpdated: @escaping (_ error: Error?) -> Void)
    
    /**
     Enables or disables group by **group id**
     - Parameter id: id of the group that should be enabled/disabled
     - Parameter enabled: new group state
     */
    func setGroup(withId id: Int, enabled: Bool) throws
  
    /**
     Enables or disables filter by **filter id**
     - Parameter id: id of the filter that should be enabled/disabled
     - Parameter groupId: id of the group that filter belongs
     - Parameter enabled: new filter state
     */
    func setFilter(withId id: Int, _ groupId: Int, enabled: Bool) throws
    
    
    // MARK: - Custom filters methods
    
    /**
     Add filter with **customFilter**
     - Parameter customFilter: Meta data of filter
     - Parameter enabled: new filter state
     */
    func add(customFilter: ExtendedCustomFilterMetaProtocol, enabled: Bool) throws
    
    /**
     Delte filter with **id**
     - Parameter id: id of the filter that should be deleted
     */
    func deleteCustomFilter(withId id: Int) throws

    /**
     Rename filter with **id** to **name**
     - Parameter id: id of the filter that should be deleted
     - Parameter name: new filter name
     */
    func renameCustomFilter(withId id: Int, to name: String) throws
}

/*
 This class is a proxy between filters, groups objects and SQLite database.
 It is used to get or modify filters objects.
 */

final class FiltersServiceNew: FiltersServiceNewProtocol {
    
    enum FilterServiceError: Error, CustomDebugStringConvertible {
        case invalidCustomFilterId(filterId: Int)
        case updatePeriodError(lastUpdateTime: Int)
        case missedFilterDownloadPage(filterName: String)
        case setGroupError(groupId: Int)
        case setFilterError(filterId: Int)
        case unknownError
        
        var debugDescription: String {
            switch self {
            case .invalidCustomFilterId(let filterId): return "Custom filter id must be greater or equal than \(CustomFilterMeta.baseCustomFilterId), actual filter id=\(filterId)"
            case .updatePeriodError(let lastUpdateTime): return "Last update was \(lastUpdateTime) hours ago. Minimum update period is \(Int(FiltersServiceNew.updatePeriod / 3600)) hours"
            case .missedFilterDownloadPage(let filterName): return "Filter download page is missed for filter with name \(filterName)"
            case .setGroupError(let groupId): return "Error setting group with id=\(groupId)"
            case .setFilterError(let filterId): return "Error setting filtrer with id=\(filterId)"
            case .unknownError: return "Unknown error"
            }
        }
    }
    
    // MARK: - Public properties
    
    var groups: [SafariGroup] { groupsModificationQueue.sync { _groups } }
    
    // MARK: - Private properties
    
    // Filters update period; We should check filters updates once per 6 hours
    private static let updatePeriod: TimeInterval = 3600 * 6
    
    // Helper variable to make groups variable thread safe. Should be accessed from groupsModificationQueue
    private var _groups: [SafariGroup] = []
    
    // Queue to make groups thread safe
    private let groupsModificationQueue = DispatchQueue(label: "AdGuardSDK.FiltersService.groupsModificationQueue", qos: .utility)
    
    /* Services */
    private let configuration: ConfigurationProtocol
    private let filterFilesStorage: FilterFilesStorageProtocol
    private let metaStorage: MetaStorageProtocol
    private let userDefaultsStorage: UserDefaultsStorageProtocol
    private let metaParser: CustomFilterMetaParserProtocol
    private let httpRequestService: HttpRequestServiceProtocol
    
    // MARK: - Initialization
    
    init(
        configuration: ConfigurationProtocol,
        filterFilesStorage: FilterFilesStorageProtocol,
        metaStorage: MetaStorageProtocol,
        userDefaultsStorage: UserDefaultsStorageProtocol,
        metaParser: CustomFilterMetaParserProtocol = CustomFilterMetaParser(),
        httpRequestService: HttpRequestServiceProtocol
    ) throws {
        self.configuration = configuration
        self.filterFilesStorage = filterFilesStorage
        self.metaStorage = metaStorage
        self.userDefaultsStorage = userDefaultsStorage
        self.metaParser = metaParser
        self.httpRequestService = httpRequestService
        self._groups = try getAllLocalizedGroups()
    }
    
    // MARK: - Public methods
    
    func updateAllMeta(forcibly: Bool, onFiltersUpdated: @escaping (_ error: Error?) -> Void) {
        var resultError: Error?
        let comletionGroup = DispatchGroup()
        
        groupsModificationQueue.async(group: comletionGroup) { [weak self] in
            guard let self = self else {
                resultError = FilterServiceError.unknownError
                return
            }
            
            // Check update conditions
            let now = Date().timeIntervalSince(self.userDefaultsStorage.lastFiltersUpdateCheckDate)
            if now < Self.updatePeriod && !forcibly {
                resultError = FilterServiceError.updatePeriodError(lastUpdateTime: Int(now / 3600))
                return
            }
            
            // Notify that filters started to update
            NotificationCenter.default.filtersUpdateStarted()
            
            let group = DispatchGroup()
            
            // Update filters file content
            group.enter()
            self.updateFiltersFileContent {
                if let error = $0 {
                    resultError = error
                }
                group.leave()
            }
            
            // Update filters metadata
            group.enter()
            self.updateMetadataForFilters {
                if let error = $0 {
                    resultError = error
                }
                group.leave()
            }
            
            // Wait while all updates are done
            group.wait()
            
            // Fill groups with actual objects
            do {
                self._groups = try self.getAllLocalizedGroups()
            } catch {
                resultError = error
                Logger.logError("(FiltersService) - updateAllMeta; Error: \(error)")
            }
            
            // Notify that filters finished updating
            NotificationCenter.default.filtersUpdateFinished()
        }
        
        // Save filters update time if filters were successfully updated
        if resultError == nil {
            userDefaultsStorage.lastFiltersUpdateCheckDate = Date()
        }
        comletionGroup.notify(queue: .main) { onFiltersUpdated(resultError) }
    }
    
    func setGroup(withId id: Int, enabled: Bool) throws {
        try groupsModificationQueue.sync {
            do {
                try metaStorage.setGroup(withId: id, enabled: enabled)
                if let groupIndex = _groups.firstIndex(where: { $0.groupId == id }) {
                    _groups[groupIndex].isEnabled = enabled
                    Logger.logDebug("(FiltersService) - setGroup; Group with id=\(id) was successfully set to enabled=\(enabled)")
                } else {
                    Logger.logDebug("(FiltersService) - setGroup; Group with id=\(id) not exists")
                }
            } catch {
                Logger.logError("(FiltersService) - setGroup; Error setting group with id=\(id) to enabled=\(enabled): \(error)")
                throw FilterServiceError.setGroupError(groupId: id)
            }
        }
    }
    
    func setFilter(withId id: Int, _ groupId: Int, enabled: Bool) throws {
        try groupsModificationQueue.sync {
            do {
                try metaStorage.setFilter(withId: id, enabled: enabled)
                if let groupIndex = _groups.firstIndex(where: { $0.groupType.id == groupId })
                   , let filterIndex = _groups[groupIndex].filters.firstIndex(where: { $0.filterId == id }) {
                    _groups[groupIndex].filters[filterIndex].isEnabled = enabled
                    Logger.logDebug("(FiltersService) - setFilter; Filter id=\(id); group id=\(groupId) was successfully set to enabled=\(enabled)")
                } else {
                    Logger.logDebug("(FiltersService) - setFilter; Filter id=\(id) or group id=\(groupId) not exists")
                }

            } catch {
                Logger.logError("(FiltersService) - setFilter; Error setting filtrer with id=\(id); group id=\(groupId) to enabled=\(enabled): \(error)")
                throw FilterServiceError.setFilterError(filterId: id)
            }
        }
    }
    
    func add(customFilter: ExtendedCustomFilterMetaProtocol, enabled: Bool) throws {
        try groupsModificationQueue.sync {
            guard let filterDownloadPage = customFilter.filterDownloadPage, let subscriptionUrl = URL(string: filterDownloadPage) else {
                throw FilterServiceError.missedFilterDownloadPage(filterName: customFilter.name ?? "nil")
            }
            
            let filterId = metaStorage.nextCustomFilterId
            let customGroup = _groups.first(where: { $0.groupType == .custom })!
            let filterToAdd = ExtendedFiltersMeta.Meta(customFilterMeta: customFilter, filterId: filterId, displayNumber: filterId, group: customGroup)
            try createCustomFilterFile(filterId: filterId, subscriptionUrl: subscriptionUrl)
            try metaStorage.add(filter: filterToAdd, enabled: enabled)
            
            let customGroupIndex = _groups.firstIndex(where: { $0.groupType == .custom })!
            let safariFilter = SafariGroup.Filter(customFilter: customFilter, filterId: filterId, isEnabled: true, group: _groups[customGroupIndex], displayNumber: filterId)
            _groups[customGroupIndex].filters.append(safariFilter)
        }
    }
    
    func deleteCustomFilter(withId id: Int) throws {
        try groupsModificationQueue.sync {
            guard id >= CustomFilterMeta.baseCustomFilterId else {
                throw FilterServiceError.invalidCustomFilterId(filterId: id)
            }
            try metaStorage.deleteFilter(withId: id)
            try filterFilesStorage.deleteFilter(withId: id)
            
            let customGroupIndex = _groups.firstIndex(where: { $0.groupType == .custom })!
            _groups[customGroupIndex].filters.removeAll(where: { $0.filterId == id })
        }
    }
    
    func renameCustomFilter(withId id: Int, to name: String) throws {
        try groupsModificationQueue.sync {
            guard id >= CustomFilterMeta.baseCustomFilterId else {
                throw FilterServiceError.invalidCustomFilterId(filterId: id)
            }
            try metaStorage.renameFilter(withId: id, name: name)
            let customGroupIndex = _groups.firstIndex(where: { $0.groupType == .custom })!
            let filterIndex = _groups[customGroupIndex].filters.firstIndex(where: { $0.filterId == id })!
            let filter = _groups[customGroupIndex].filters[filterIndex]
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
            
            _groups[customGroupIndex].filters[filterIndex] = newFilter
        }
    }
    
    // MARK: - Private methods
    
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
    
    // Updates filters file content
    private func updateFiltersFileContent(onFilesUpdated: @escaping (_ error: Error?) -> Void) {
        var resultError: Error?
        
        let group = DispatchGroup()
        let allFilters = self._groups.flatMap { $0.filters }
        allFilters.forEach { filter in
            group.enter()
            
            // Update filter file
            updateFilterFileContent(filter: filter) { error in
                if let error = error {
                    resultError = error
                    Logger.logError("(FiltersService) - updateFiltersFileContent; Failed to download content of filter with id=\(filter.filterId); Error: \(error)")
                } else {
                    Logger.logDebug("(FiltersService) - updateFiltersFileContent; Successfully downloaded content of filter with id=\(filter.filterId)")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) { onFilesUpdated(resultError) }
    }
    
    /* Downloads filter metadata and metadata localizations and saves it to database */
    private func updateMetadataForFilters(onFiltersMetaUpdated: @escaping (_ error: Error?) -> Void) {
        var resultError: Error?
        let group = DispatchGroup()
        
        group.enter()
        httpRequestService.loadFiltersMetadata(version: configuration.appProductVersion,
                                               id: configuration.appId,
                                               cid: configuration.cid,
                                               lang: configuration.currentLanguage) { [weak self] filtersMeta in
            if let meta = filtersMeta {
                do {
                    try self?.save(filtersMeta: meta)
                } catch {
                    resultError = error
                }
            }
            group.leave()
        }
        
        group.enter()
        httpRequestService.loadFiltersLocalizations { [weak self] filtersMetaLocalizations in
            if let localizations = filtersMetaLocalizations {
                do {
                    try self?.save(localizations: localizations)
                } catch {
                    resultError = error
                }
            }
            group.leave()
        }
        
        group.notify(queue: .main) { onFiltersMetaUpdated(resultError) }
    }
    
    /* Saves filters meta to database */
    private func save(filtersMeta: ExtendedFiltersMeta) throws {
        let groups = filtersMeta.groups
        let filters = filtersMeta.filters
        
        if !groups.isEmpty {
            try metaStorage.updateAll(groups: groups)
        }
        if !filters.isEmpty {
            try metaStorage.updateAll(filters: filters)
        }
        try filters.forEach {
            try metaStorage.updateAll(tags: $0.tags, forFilterWithId: $0.filterId)
            try metaStorage.updateAll(langs: $0.languages, forFilterWithId: $0.filterId)
        }
    }
    
    /* Saves filters localizations to database */
    private func save(localizations: ExtendedFiltersMetaLocalizations) throws {
        
        let groups = localizations.groups
        let groupIds = groups.keys
        
        let filters = localizations.filters
        let filterIds = filters.keys
        
        for groupId in groupIds {
            let localizationsByLangs = groups[groupId] ?? [:]
            let langs = localizationsByLangs.keys
            for lang in langs {
                let localization = localizationsByLangs[lang]!
                try metaStorage.updateLocalizationForGroup(withId: groupId, forLanguage: lang, localization: localization)
            }
        }
        
        for filterId in filterIds {
            let localizationsByLangs = filters[filterId] ?? [:]
            let langs = localizationsByLangs.keys
            for lang in langs {
                let localization = localizationsByLangs[lang]!
                try metaStorage.updateLocalizationForFilter(withId: filterId, forLanguage: lang, localization: localization)
            }
        }
    }
    
    private func createCustomFilterFile(filterId: Int, subscriptionUrl: URL) throws {
        let group = DispatchGroup()
        var resultError: Error?
        group.enter()
        updateCustomFilter(withId: filterId, subscriptionUrl: subscriptionUrl) {
            if let error = $0 {
                resultError = error
            }
            group.leave()
        }
        group.wait()
        if let error = resultError {
            throw error
        }
        
        Logger.logError("(FiltersService) - createCustomFilterFile; updating file for filter with id = \(filterId) succeeded")
    }
    
    private func updateFilterFileContent(filter: SafariFilterProtocol, onFilesUpdated: @escaping (_ error: Error?) -> Void) {
        if filter.group.groupType == .custom {
            guard let filterDownloadPage = filter.filterDownloadPage,
                  let subscriptionUrl = URL(string: filterDownloadPage) else {
                Logger.logError("(FiltersService) - updateCustomFilter; filterDownloadPage is missed for filter with id = \(filter.filterId)")
                onFilesUpdated(FilterServiceError.missedFilterDownloadPage(filterName: "\(filter.name ?? "nil") and filter id = \(filter.filterId))"))
                return
            }
            
            updateCustomFilter(withId: filter.filterId, subscriptionUrl: subscriptionUrl, onFilesUpdated: onFilesUpdated)
        } else {
            filterFilesStorage.updateFilter(withId: filter.filterId, onFilterUpdated: onFilesUpdated)
        }
    }
    
    private func updateCustomFilter(withId filterId: Int, subscriptionUrl: URL, onFilesUpdated: @escaping (_ error: Error?) -> Void) {
        var resultError: Error?
        filterFilesStorage.updateCustomFilter(withId: filterId, subscriptionUrl: subscriptionUrl, onFilterUpdated: {
            if let error = $0 {
                Logger.logError("(FiltersService) - updateCustomFilter; updating file error: \(error) for filter with id = \(filterId)")
                resultError = error
            }
            onFilesUpdated(resultError)
        })
    }
}

// MARK: - Resources + FilterService variables

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
    }
    
    func filtersUpdateFinished() {
        self.post(name: .filtersUpdateFinished, object: self, userInfo: nil)
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
