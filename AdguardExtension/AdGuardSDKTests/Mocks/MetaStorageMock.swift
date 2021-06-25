import Foundation
import SQLite

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
        getAllLocalizaedFiltersResult = .success(filtersTableMock)
    }
    
    // MARK: - FiltersMetaStorageProtocol + Filters methods

    var getLocalizedFiltersForGroupCalled = false
    var getAllLocalizaedFiltersResult: Result<[FiltersTable]> = .success([])
    func getLocalizedFiltersForGroup(withId id: Int, forLanguage lang: String) throws -> [FiltersTable] {
        getLocalizedFiltersForGroupCalled = true
        switch getAllLocalizaedFiltersResult {
        case .success(let filters): return filters
        case .error(let error): throw error
        }
    }
    
    var setFilterCalled = false
    var setFilterResultError: Error?
    func setFilter(withId id: Int, enabled: Bool) throws {
        setFilterCalled = true
        if let error = setFilterResultError {
            throw error
        }
    }
    
    var updateFilterCalled = false
    var updateFilterResult: Result<Bool> = .success(true)
    func update(filter: ExtendedFilterMetaProtocol) throws -> Bool {
        updateFilterCalled = true
        switch updateFilterResult {
        case .success(let wasUpdated): return wasUpdated
        case .error(let error): throw error
        }
    }
    
    var updateFiltersCalled = false
    var updateFiltersResult: Result<[Int]> = .success([])
    func update(filters: [ExtendedFilterMetaProtocol]) throws -> [Int] {
        updateFiltersCalled = true
        switch updateFiltersResult {
        case .success(let updatedFiltersIds): return updatedFiltersIds
        case .error(let error): throw error
        }
    }
    
    var addFilterCalled = false
    var addResultError: Error?
    func add(filter: ExtendedFilterMetaProtocol, enabled: Bool) throws {
        addFilterCalled = true
        if let error = addResultError {
            throw error
        }
    }
    
    var deleteFilterCalled = false
    var deleteFilterResultError: Error?
    func deleteFilter(withId id: Int) throws {
        deleteFilterCalled = true
        if let error = deleteFilterResultError {
            throw error
        }
    }
    
    var deleteFiltersCalled = false
    var deleteFiltersResultError: Error?
    func deleteFilters(withIds ids: [Int]) throws {
        deleteFiltersCalled = true
        if let error = deleteFiltersResultError {
            throw error
        }
    }
    
    var renameFilterCalled = false
    var renameResultError: Error?
    func renameFilter(withId id: Int, name: String) throws {
        renameFilterCalled = true
        if let error = renameResultError {
            throw error
        }
    }
    
    // MARK: - FiltersMetaStorageProtocol + Groups methods
    var getAllLocalizedGroupsCalled = false
    var getAllLocalizedGroupsResult: Result<[FilterGroupsTable]> = .success([])
    func getAllLocalizedGroups(forLanguage lang: String) throws -> [FilterGroupsTable] {
        getAllLocalizedGroupsCalled = true
        switch getAllLocalizedGroupsResult {
        case .success(let groups): return groups
        case .error(let error): throw error
        }
    }
    
    var setGroupCalled = false
    var setGroupResultError: Error?
    func setGroup(withId id: Int, enabled: Bool) throws {
        setGroupCalled = true
        if let error = setGroupResultError {
            throw error
        }
    }
    
    var updateGroupCalled = false
    var updateGroupResultError: Error?
    func update(group: GroupMetaProtocol) throws {
        updateGroupCalled = true
        if let error = updateGroupResultError {
            throw error
        }
    }
    
    var updateGroupsCalled = false
    var updateGroupsResultError: Error?
    func update(groups: [GroupMetaProtocol]) throws {
        updateGroupsCalled = true
        if let error = updateGroupsResultError {
            throw error
        }
    }
    
    // MARK: - FiltersMetaStorageProtocol + Tags methods
        
    var getAllTagsCalled = false
    func getAllTags() throws -> [FilterTagsTable] {
        getAllTagsCalled = true
        return []
    }
    
    var getTagsForFilterCalled = false
    func getTagsForFilter(withId id: Int) throws -> [FilterTagsTable] {
        getTagsForFilterCalled = true
        return []
    }
    
    var updateAllTagsCalled = false
    var updateAllTagsResultError: Error?
    func updateAll(tags: [ExtendedFiltersMeta.Tag], forFilterWithId id: Int) throws {
        updateAllTagsCalled = true
        if let error = updateAllTagsResultError {
            throw error
        }
    }
    
    var updateTagCalled = false
    var updateTagResultError: Error?
    func update(tag: ExtendedFiltersMeta.Tag, forFilterWithId id: Int) throws {
        updateTagCalled = true
        if let error = updateTagResultError {
            throw error
        }
    }
    
    var deleteTagsForFiltersCalled = false
    func deleteTagsForFilters(withIds ids: [Int]) throws {
        deleteTagsForFiltersCalled = true
    }
    
    
    // MARK: - FiltersMetaStorageProtocol + Langs methods
    
    var getLangsForFilterCalled = false
    func getLangsForFilter(withId id: Int) throws -> [String] {
        getLangsForFilterCalled = true
        return []
    }
    
    var updateAllLangsCalled = false
    var updateAllLangsResultError: Error?
    func updateAll(langs: [String], forFilterWithId id: Int) throws {
        updateAllLangsCalled = true
        if let error = updateAllLangsResultError {
            throw error
        }
    }
    
    var updateLangCalled = false
    var updateLangResultError: Error?
    func update(lang: String, forFilterWithId id: Int) throws {
        updateLangCalled = true
        if let error = updateLangResultError {
            throw error
        }
    }
    
    var deleteLangsForFiltersCalled = false
    func deleteLangsForFilters(withIds ids: [Int]) throws {
        deleteLangsForFiltersCalled = true
    }
    
    // MARK: - FiltersMetaStorageProtocol + Group localizations methods
    
    var getLocalizationForGroupCalled = false
    func getLocalizationForGroup(withId id: Int, forLanguage lang: String) -> FilterGroupLocalizationsTable? {
        getLocalizationForGroupCalled = true
        return nil
    }

    var updateLocalizationForGroupCalled = false
    var updateLocalizationForGroupResultError: Error?
    func updateLocalizationForGroup(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.GroupLocalization) throws {
        updateLocalizationForGroupCalled = true
        if let error = updateLocalizationForGroupResultError {
            throw error
        }
    }
    
    // MARK: - FiltersMetaStorageProtocol + Filters localizations methods
    
    var getLocalizationForFilterCalled = false
    func getLocalizationForFilter(withId id: Int, forLanguage lang: String) throws -> FilterLocalizationsTable? {
        getLocalizationForFilterCalled = true
        return nil
    }
    
    var updateLocalizationForFilterCalled = false
    var updateLocalizationForFilterResultError: Error?
    func updateLocalizationForFilter(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.FilterLocalization) throws {
        updateLocalizationForFilterCalled = true
        if let error = updateLocalizationForFilterResultError {
            throw error
        }
    }
    
    var deleteAllLocalizationForFiltersCalled = false
    func deleteAllLocalizationForFilters(withIds ids: [Int]) throws {
        deleteAllLocalizationForFiltersCalled = true
    }
    
    var deleteAllLocalizationForFilterCalled = false
    func deleteAllLocalizationForFilter(withId id: Int) throws {
        deleteAllLocalizationForFiltersCalled = true
    }
    
    func reset() throws {
        
    }
}
