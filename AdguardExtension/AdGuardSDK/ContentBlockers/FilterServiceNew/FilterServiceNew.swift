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
     Checks update conditions for filters and updates them if needed
     - Parameter forcibly: ignores update conditions and immediately updates filters
     */
    func updateAllFilters(forcibly: Bool)
}

final class FiltersServiceNew: FiltersServiceNewProtocol {
    
    // MARK: - Public properties
    
    var groups: [SafariGroup] { groupsModificationQueue.sync { _groups } }
    
    // MARK: - Private properties
    
    // Helper variable to make groups variable thread safe
    private var _groups: [SafariGroup] = []
    
    // Queue to make groups thread safe
    private let groupsModificationQueue = DispatchQueue(label: "AdGuardSDK.FiltersService.groupsModificationQueue", qos: .utility)
    
    /* Services */
    private let configuration: ConfigurationProtocol
    private let filterFilesStorage: FilterFilesStorageProtocol
    private let filtersMetaStorage: FiltersMetaStorageProtocol
    private let metaParser: CustomFilterMetaParserProtocol
    
    // MARK: - Initialization
    
    init(
        configuration: ConfigurationProtocol,
        filterFilesStorage: FilterFilesStorageProtocol,
        filtersMetaStorage: FiltersMetaStorageProtocol,
        metaParser: CustomFilterMetaParserProtocol = CustomFilterMetaParser()
    ) throws {
        self.configuration = configuration
        self.filterFilesStorage = filterFilesStorage
        self.filtersMetaStorage = filtersMetaStorage
        self.metaParser = metaParser
        self._groups = try getAllLocalizedGroups()
    }
    
    // MARK: - Public methods
    
    func updateAllFilters(forcibly: Bool) {
        groupsModificationQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Notify that filters started to update
            NotificationCenter.default.filtersUpdateStarted()
            
            
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
}

// MARK: - NotificationCenter + FilterService events

fileprivate extension NSNotification.Name {
    static var filtersUpdateStarted: NSNotification.Name { .init(rawValue: "filtersUpdateStarted") }
}

fileprivate extension NotificationCenter {
    func filtersUpdateStarted() {
        self.post(name: .filtersUpdateStarted, object: self, userInfo: nil)
    }
}

public extension NotificationCenter {
    func filtersUpdateStart(handler: @escaping () -> Void, queue: OperationQueue? = .main) -> NotificationToken {
        return self.observe(name: .filtersUpdateStarted, object: nil, queue: queue) { _ in
            handler()
        }
    }
}
