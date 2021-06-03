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
     - Parameter onFiltersUpdated: closure to handle update result **filtersWereUpdated** is true if some filters were updated
     */
    func updateAllMeta(forcibly: Bool, onFiltersUpdated: @escaping (_ filtersWereUpdated: Bool) -> Void)
}

final class FiltersServiceNew: FiltersServiceNewProtocol {
    
    // MARK: - Public properties
    
    var groups: [SafariGroup] { groupsModificationQueue.sync { _groups } }
    
    // MARK: - Private properties
    
    // Filters update period; We should check filters updates once per 6 hours
    private static let updatePeriod: TimeInterval = 3600 * 6
    
    // Helper variable to make groups variable thread safe
    private var _groups: [SafariGroup] = []
    
    // Queue to make groups thread safe
    private let groupsModificationQueue = DispatchQueue(label: "AdGuardSDK.FiltersService.groupsModificationQueue", qos: .utility)
    
    /* Services */
    private let configuration: ConfigurationProtocol
    private let filterFilesStorage: FilterFilesStorageProtocol
    private let filtersMetaStorage: FiltersMetaStorageProtocol
    private let userDefaultsStorage: UserDefaultsStorageProtocol
    private let metaParser: CustomFilterMetaParserProtocol
    private let httpRequestService: HttpRequestServiceProtocol
    
    // MARK: - Initialization
    
    init(
        configuration: ConfigurationProtocol,
        filterFilesStorage: FilterFilesStorageProtocol,
        filtersMetaStorage: FiltersMetaStorageProtocol,
        userDefaultsStorage: UserDefaultsStorageProtocol,
        metaParser: CustomFilterMetaParserProtocol = CustomFilterMetaParser(),
        httpRequestService: HttpRequestServiceProtocol
    ) throws {
        self.configuration = configuration
        self.filterFilesStorage = filterFilesStorage
        self.filtersMetaStorage = filtersMetaStorage
        self.userDefaultsStorage = userDefaultsStorage
        self.metaParser = metaParser
        self.httpRequestService = httpRequestService
        self._groups = try getAllLocalizedGroups()
    }
    
    // MARK: - Public methods
    
    func updateAllMeta(forcibly: Bool, onFiltersUpdated: @escaping (_ filtersWereUpdated: Bool) -> Void) {
        groupsModificationQueue.async { [weak self] in
            guard let self = self else {
                onFiltersUpdated(false)
                return
            }
            
            // Check update conditions
            let now = Date()
            if now.timeIntervalSince(self.userDefaultsStorage.lastFiltersUpdateCheckDate) < Self.updatePeriod && !forcibly {
                onFiltersUpdated(false)
                return
            }
            
            // Notify that filters started to update
            NotificationCenter.default.filtersUpdateStarted()
            
            // Update filters file content and filters meta
            let group = DispatchGroup()
            let allFilters = self._groups.flatMap { $0.filters }
            allFilters.forEach { filter in
                group.enter()
                
                // Update filter file
                self.filterFilesStorage.updateFilter(withId: filter.filterId) { error in
                    if let error = error {
                        Logger.logError("(FiltersService) - updateAllFilters; Failed to download content of filter with id=\(filter.filterId); Error: \(error)")
                    } else {
                        Logger.logDebug("(FiltersService) - updateAllFilters; Successfully downloaded content of filter with id=\(filter.filterId)")
                    }
                    group.leave()
                }
            }
            
            // Update filters metadata
            group.enter()
            self.updateMetadataForFilters() {
                group.leave()
            }
            
            // Wait while all updates are done
            group.wait()
            
            // Notify that filters finished updating
            NotificationCenter.default.filtersUpdateFinished()
        }
    }
    
    // MARK: - Private methods
    
    /* Returns all groups froma database with filters and localizations */
    private func getAllLocalizedGroups() throws -> [SafariGroup] {
        let localizedGroupsMeta = try filtersMetaStorage.getAllLocalizedGroups(forLanguage: configuration.currentLanguage)
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
        let localizedFiltersMeta = try filtersMetaStorage.getLocalizedFiltersForGroup(withId: group.groupType.rawValue, forLanguage: configuration.currentLanguage)
        return try localizedFiltersMeta.map { dbFilter in
            // TODO: - Maybe we should store filter meta in database
            let meta = getMetaForFilter(withId: dbFilter.filterId)
            let languages = try filtersMetaStorage.getLangsForFilter(withId: dbFilter.filterId)
            let tags = try filtersMetaStorage.getTagsForFilter(withId: dbFilter.filterId)
            return SafariGroup.Filter(dbFilter: dbFilter,
                                      group: group,
                                      rulesCount: meta?.rulesCount,
                                      languages: languages,
                                      tags: tags,
                                      filterDownloadPage: meta?.filterDownloadPage)
        }
    }
    
    /* Gets filter file content, parses it's meta and returns it */
    private func getMetaForFilter(withId id: Int) -> ExtendedCustomFilterMetaProtocol? {
        guard let filterContent = filterFilesStorage.getFilterContentForFilter(withId: id) else {
            Logger.logError("(FiltersServiceNew) - getRulesCountForFilter; received nil for filter with id=\(id)")
            return nil
        }
        
        do {
            return try metaParser.parse(filterContent, for: .safari)
        } catch {
            Logger.logError("(FiltersServiceNew) - getRulesCountForFilter; received error for filter with id=\(id); error: \(error)")
            return nil
        }
    }
    
    /* Downloads filter metadata and metadata localizations and saves it to database */
    private func updateMetadataForFilters(onFiltersMetaUpdated: @escaping () -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        httpRequestService.loadFiltersMetadata(version: configuration.appProductVersion,
                                               id: configuration.appId,
                                               cid: configuration.cid,
                                               lang: configuration.currentLanguage) { [weak self] filtersMeta in
            if let meta = filtersMeta {
                self?.save(filtersMeta: meta)
            }
            group.leave()
        }
        
        group.enter()
        httpRequestService.loadFiltersLocalizations { [weak self] filtersMetaLocalizations in
            if let localizations = filtersMetaLocalizations {
                self?.save(localizations: localizations)
            }
            group.leave()
        }
        
        group.notify(queue: .main) { onFiltersMetaUpdated() }
    }
    
    /* Saves filters meta to database */
    private func save(filtersMeta: ExtendedFiltersMeta) {
        let groups = filtersMeta.groups
        let filters = filtersMeta.filters
        
        do {
            try filtersMetaStorage.updateAll(groups: groups)
            try filtersMetaStorage.updateAll(filters: filters)
            try filters.forEach {
                try filtersMetaStorage.updateAll(tags: $0.tags, forFilterWithId: $0.filterId)
                try filtersMetaStorage.updateAll(langs: $0.languages, forFilterWithId: $0.filterId)
            }
        } catch {
            Logger.logError("(FiltersService) - save filtersMeta; Error saving to database: \(error)")
        }
    }
    
    /* Saves filters localizations to database */
    private func save(localizations: ExtendedFiltersMetaLocalizations) {
        
        let groups = localizations.groups
        let groupIds = groups.keys
        
        let filters = localizations.filters
        let filterIds = filters.keys
        
        do {
            for groupId in groupIds {
                let localizationsByLangs = groups[groupId] ?? [:]
                let langs = localizationsByLangs.keys
                for lang in langs {
                    let localization = localizationsByLangs[lang]!
                    try filtersMetaStorage.updateLocalizationForGroup(withId: groupId, forLanguage: lang, localization: localization)
                }
            }
            
            for filterId in filterIds {
                let localizationsByLangs = filters[filterId] ?? [:]
                let langs = localizationsByLangs.keys
                for lang in langs {
                    let localization = localizationsByLangs[lang]!
                    try filtersMetaStorage.updateLocalizatonForFilter(withId: filterId, forLanguage: lang, localization: localization)
                }
            }
        } catch {
            Logger.logError("(FiltersService) - save localizations; Error saving to database: \(error)")
        }
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
