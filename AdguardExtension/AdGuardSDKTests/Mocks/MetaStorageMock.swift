import Foundation
@_implementationOnly import SQLite

enum MetaStorageMockError: Error {
    case updateAllGroupsError
    case updateAllFiltersError
    case updateAllTagsError
    case updateAllLangsError
    case getAllLocalizedGroupsError
    case getAllLocalizaedFiltersError
    case updateLocalizationForGroupErorr
    case updateLocalizationForFilterError
    case setGroupError
    case setFilterError
    case addError
    case deleteError
    case renameError
    case resetError
    case error
}

class MetaStorageMock: MetaStorageProtocol {
    var groupsTableMock = [
        FilterGroupsTable(groupId: SafariGroup.GroupType.ads.id, name: "Ad Blocking", displayNumber: 1, isEnabled: false),
        FilterGroupsTable(groupId: SafariGroup.GroupType.privacy.id, name: "Privacy", displayNumber: 2, isEnabled: false),
        FilterGroupsTable(groupId: SafariGroup.GroupType.socialWidgets.id, name: "Social Widgets", displayNumber: 3, isEnabled: false),
        FilterGroupsTable(groupId: SafariGroup.GroupType.annoyances.id, name: "Annoyances", displayNumber: 4, isEnabled: false),
        FilterGroupsTable(groupId: SafariGroup.GroupType.security.id, name: "Security", displayNumber: 5, isEnabled: false),
        FilterGroupsTable(groupId: SafariGroup.GroupType.other.id, name: "Other", displayNumber: 6, isEnabled: false),
        FilterGroupsTable(groupId: SafariGroup.GroupType.languageSpecific.id, name: "Language-specific", displayNumber: 7, isEnabled: false),
        FilterGroupsTable(groupId: SafariGroup.GroupType.custom.id, name: "Custom", displayNumber: 8, isEnabled: false)
    ]
    
    func someMethod() -> Int {
        return DispatchQueue.global().sync {
            return 0
        }
    }
    
    var filtersTableMock: [FiltersTable] {
        let filtersIdsByGroup = [
            SafariGroup.GroupType.ads.id: [1, 2, 3, 4, 5, 6],
            SafariGroup.GroupType.privacy.id: [7, 8, 9, 10],
            SafariGroup.GroupType.socialWidgets.id: [11, 12, 13],
            SafariGroup.GroupType.annoyances.id: [14, 15, 16, 17],
            SafariGroup.GroupType.security.id: [18, 19, 20],
            SafariGroup.GroupType.other.id: [21, 22, 23, 24, 25],
            SafariGroup.GroupType.languageSpecific.id: [26, 27, 28],
            SafariGroup.GroupType.custom.id: [29, 30]
        ]
        
        return filtersIdsByGroup.flatMap { groupId, filtersIds in
            return filtersIds.map {
                let filterId = groupId == SafariGroup.GroupType.custom.id ? CustomFilterMeta.baseCustomFilterId + $0 : $0
                return FiltersTable(filterId: filterId,
                                    groupId: groupId,
                                    isEnabled: false,
                                    version: "1.1.1",
                                    lastUpdateTime: Date(),
                                    lastCheckTime: Date(),
                                    editable: false,
                                    displayNumber: filterId,
                                    name: "filter_\(filterId)",
                                    description: "description_\(filterId)",
                                    homePage: "some.home.page_\(filterId)",
                                    removable: false,
                                    expires: 100,
                                    subscriptionUrl: "some.download.page_\(filterId)")
            }
        }
    }
    
    var nextCustomFilterId: Int {
        filtersTableMock.reduce(0) { result, filter in
            max(result, filter.filterId)
        } + 1
    }
    
    static var defaultDbLanguage: String = "en"

    var filtersDb: Connection = try! Connection()

    init() {
        getAllLocalizedGroupsResult = .success(groupsTableMock)
    }
    
    // MARK: - FiltersMetaStorageProtocol + Filters methods

    var getLocalizedFiltersForGroupCalledCount = 0
    var getAllLocalizaedFiltersResult: Result<[FiltersTable]>?
    func getLocalizedFiltersForGroup(withId id: Int, forLanguage lang: String) throws -> [FiltersTable] {
        getLocalizedFiltersForGroupCalledCount += 1
        
        guard let result = getAllLocalizaedFiltersResult else {
            return filtersTableMock.filter { $0.groupId == id }
        }
        
        switch result {
        case .success(let filters): return filters
        case .error(let error): throw error
        }
    }
    
    var setFilterCalledCount = 0
    var setFilterResultError: Error?
    func setFilter(withId id: Int, enabled: Bool) throws {
        setFilterCalledCount += 1
        if let error = setFilterResultError {
            throw error
        }
    }
    
    var updateFilterCalledCount = 0
    var updateFilterResult: Result<Bool> = .success(true)
    func update(filter: ExtendedFilterMetaProtocol) throws -> Bool {
        updateFilterCalledCount += 1
        switch updateFilterResult {
        case .success(let wasUpdated): return wasUpdated
        case .error(let error): throw error
        }
    }
    
    var updateFiltersCalledCount = 0
    var updateFiltersResult: Result<[Int]> = .success([])
    func update(filters: [ExtendedFilterMetaProtocol]) throws -> [Int] {
        updateFiltersCalledCount += 1
        switch updateFiltersResult {
        case .success(let updatedFiltersIds): return updatedFiltersIds
        case .error(let error): throw error
        }
    }
    
    var addFilterCalledCount = 0
    var addResultError: Error?
    func add(filter: ExtendedFilterMetaProtocol, enabled: Bool) throws {
        addFilterCalledCount += 1
        if let error = addResultError {
            throw error
        }
    }
    
    var deleteFilterCalledCount = 0
    var deleteFilterResultError: Error?
    func deleteFilter(withId id: Int) throws {
        deleteFilterCalledCount += 1
        if let error = deleteFilterResultError {
            throw error
        }
    }
    
    var deleteFiltersCalledCount = 0
    var deleteFiltersResultError: Error?
    func deleteFilters(withIds ids: [Int]) throws {
        deleteFiltersCalledCount += 1
        if let error = deleteFiltersResultError {
            throw error
        }
    }
    
    var renameFilterCalledCount = 0
    var renameResultError: Error?
    func renameFilter(withId id: Int, name: String) throws {
        renameFilterCalledCount += 1
        if let error = renameResultError {
            throw error
        }
    }
    
    // MARK: - FiltersMetaStorageProtocol + Groups methods
    var getAllLocalizedGroupsCalledCount = 0
    var getAllLocalizedGroupsResult: Result<[FilterGroupsTable]> = .success([])
    func getAllLocalizedGroups(forLanguage lang: String) throws -> [FilterGroupsTable] {
        getAllLocalizedGroupsCalledCount += 1
        switch getAllLocalizedGroupsResult {
        case .success(let groups): return groups
        case .error(let error): throw error
        }
    }
    
    var setGroupCalledCount = 0
    var setGroupResultError: Error?
    func setGroup(withId id: Int, enabled: Bool) throws {
        setGroupCalledCount += 1
        if let error = setGroupResultError {
            throw error
        }
    }
    
    var updateGroupCalledCount = 0
    var updateGroupResultError: Error?
    func update(group: GroupMetaProtocol) throws {
        updateGroupCalledCount += 1
        if let error = updateGroupResultError {
            throw error
        }
    }
    
    var updateGroupsCalledCount = 0
    var updateGroupsResultError: Error?
    func update(groups: [GroupMetaProtocol]) throws {
        updateGroupsCalledCount += 1
        if let error = updateGroupsResultError {
            throw error
        }
    }
    
    // MARK: - FiltersMetaStorageProtocol + Tags methods
        
    var getAllTagsCalledCount = 0
    func getAllTags() throws -> [FilterTagsTable] {
        getAllTagsCalledCount += 1
        return []
    }
    
    var getTagsForFilterCalledCount = 0
    func getTagsForFilter(withId id: Int) throws -> [FilterTagsTable] {
        getTagsForFilterCalledCount += 1
        return []
    }
    
    var updateAllTagsCalledCount = 0
    var updateAllTagsResultError: Error?
    func updateAll(tags: [ExtendedFiltersMeta.Tag], forFilterWithId id: Int) throws {
        updateAllTagsCalledCount += 1
        if let error = updateAllTagsResultError {
            throw error
        }
    }
    
    var updateTagCalledCount = 0
    var updateTagResultError: Error?
    func update(tag: ExtendedFiltersMeta.Tag, forFilterWithId id: Int) throws {
        updateTagCalledCount += 1
        if let error = updateTagResultError {
            throw error
        }
    }
    
    var deleteTagsForFiltersCalledCount = 0
    func deleteTagsForFilters(withIds ids: [Int]) throws {
        deleteTagsForFiltersCalledCount += 1
    }
    
    
    // MARK: - FiltersMetaStorageProtocol + Langs methods
    
    var getLangsForFilterCalledCount = 0
    func getLangsForFilter(withId id: Int) throws -> [String] {
        getLangsForFilterCalledCount += 1
        return []
    }
    
    var updateAllLangsCalledCount = 0
    var updateAllLangsResultError: Error?
    func updateAll(langs: [String], forFilterWithId id: Int) throws {
        updateAllLangsCalledCount += 1
        if let error = updateAllLangsResultError {
            throw error
        }
    }
    
    var updateLangCalledCount = 0
    var updateLangResultError: Error?
    func update(lang: String, forFilterWithId id: Int) throws {
        updateLangCalledCount += 1
        if let error = updateLangResultError {
            throw error
        }
    }
    
    var deleteLangsForFiltersCalledCount = 0
    func deleteLangsForFilters(withIds ids: [Int]) throws {
        deleteLangsForFiltersCalledCount += 1
    }
    
    // MARK: - FiltersMetaStorageProtocol + Group localizations methods
    
    var getLocalizationForGroupCalledCount = 0
    func getLocalizationForGroup(withId id: Int, forLanguage lang: String) -> FilterGroupLocalizationsTable? {
        getLocalizationForGroupCalledCount += 1
        return nil
    }

    var updateLocalizationForGroupCalledCount = 0
    var updateLocalizationForGroupResultError: Error?
    func updateLocalizationForGroup(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.GroupLocalization) throws {
        updateLocalizationForGroupCalledCount += 1
        if let error = updateLocalizationForGroupResultError {
            throw error
        }
    }
    
    // MARK: - FiltersMetaStorageProtocol + Filters localizations methods
    
    var getLocalizationForFilterCalledCount = 0
    func getLocalizationForFilter(withId id: Int, forLanguage lang: String) throws -> FilterLocalizationsTable? {
        getLocalizationForFilterCalledCount += 1
        return nil
    }
    
    var updateLocalizationForFilterCalledCount = 0
    var updateLocalizationForFilterResultError: Error?
    func updateLocalizationForFilter(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.FilterLocalization) throws {
        updateLocalizationForFilterCalledCount += 1
        if let error = updateLocalizationForFilterResultError {
            throw error
        }
    }
    
    var deleteAllLocalizationForFiltersCalledCount = 0
    func deleteAllLocalizationForFilters(withIds ids: [Int]) throws {
        deleteAllLocalizationForFiltersCalledCount += 1
    }
    
    var deleteAllLocalizationForFilterCalledCount = 0
    func deleteAllLocalizationForFilter(withId id: Int) throws {
        deleteAllLocalizationForFilterCalledCount += 1
    }
    
    var resetCalledCount = 0
    var resetError: Error?
    func reset() throws {
        resetCalledCount += 1
        if let error = resetError {
            throw error
        }
    }
}
