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
    var constantGroupsTable = [
        FilterGroupsTable(groupId: 1, name: "Ad Blocking", displayNumber: 1, isEnabled: false),
        FilterGroupsTable(groupId: 2, name: "Privacy", displayNumber: 2, isEnabled: false),
        FilterGroupsTable(groupId: 3, name: "Social Widgets", displayNumber: 3, isEnabled: false),
        FilterGroupsTable(groupId: 4, name: "Annoyances", displayNumber: 4, isEnabled: false),
        FilterGroupsTable(groupId: 5, name: "Security", displayNumber: 5, isEnabled: false),
        FilterGroupsTable(groupId: 6, name: "Other", displayNumber: 6, isEnabled: false),
        FilterGroupsTable(groupId: 7, name: "Language-specific", displayNumber: 7, isEnabled: false),
        FilterGroupsTable(groupId: 101, name: "Custom", displayNumber: 0, isEnabled: false)]
    
    lazy var filtersTable: [FiltersTable] = {
        generateLocalizationForFilters()
    }()
    
    var nextCustomFilterId: Int {
        filtersTable.reduce(0) { result, filter in
            max(result, filter.filterId)
        } + 1
    }
    
    static var defaultDbLanguage: String = "en"

    var filtersDb: Connection = try! Connection()
    
    //MARK: - Mock results
    
    var updateAllGroupsResult: Result<MetaStorageMockError?> = .success(nil)
    var updateAllFiltersResult: Result<MetaStorageMockError?> = .success(nil)
    var updateAllTagsResult: Result<MetaStorageMockError?> = .success(nil)
    var updateAllLangsResult: Result<MetaStorageMockError?> = .success(nil)
    
    var getAllLocalizedGroupsResult: Result<[FilterGroupsTable]> = .success([])
    var getAllLocalizaedFiltersResult: Result<[FiltersTable]> = .success([])
    
    var updateLocalizationForGroupResult: Result<MetaStorageMockError?> = .success(nil)
    var updateLocalizationForFilterResult: Result<MetaStorageMockError?> = .success(nil)
    
    var setGroupResult: Result<MetaStorageMockError?> = .success(nil)
    var setFilterResult: Result<MetaStorageMockError?> = .success(nil)
    
    var addResult: Result<MetaStorageMockError?> = .success(nil)
    
    var deleteResult: Result<MetaStorageMockError?> = .success(nil)
    
    var renameResult: Result<MetaStorageMockError?> = .success(nil)
    
    var getLocalizedFiltersForGroupCalled = false
    var setFilterCalled = false
    var updateAllFiltersCalled = false
    var updateFilterCalled = false
    var addFilterCalled = false
    var deleteFilterCalled = false
    var deleteFiltersCalled = false
    var renameFilterCalled = false
    var getAllLocalizedGroupsCalled = false
    var setGroupCalled = false
    var updateAllGroupsCalled = false
    var updateGroupCalled = false
    var getAllTagsCalled = false
    var getTagsForFilterCalled = false
    var updateAllTagsCalled = false
    var updateTagCalled = false
    var deleteTagsForFiltersCalled = false
    var getLangsForFilterCalled = false
    var updateAllLangsCalled = false
    var updateLangCalled = false
    var deleteLangsForFiltersCalled = false
    var getLocalizationForGroupCalled = false
    var updateLocalizationForGroupCalled = false
    var updateLocalizationForFilterCalled = false
    var getLocalizationForFilterCalled = false
    var deleteAllLocalizationForFiltersCalled = false
    var deleteAllLocalizationForFilterCalled = false
    
    init() {
        getAllLocalizedGroupsResult = .success(constantGroupsTable)
        getAllLocalizaedFiltersResult = .success(generateLocalizationForFilters())
    }
    
    // MARK: - FiltersMetaStorageProtocol + Filters methods

    func getLocalizedFiltersForGroup(withId id: Int, forLanguage lang: String) throws -> [FiltersTable] {
        getLocalizedFiltersForGroupCalled = true
        switch getAllLocalizaedFiltersResult {
        case .success(let filters): return filters
        case .error(let error): throw error
        }
    }
    
    func setFilter(withId id: Int, enabled: Bool) throws {
        setFilterCalled = true
        switch setFilterResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func updateAll(filters: [ExtendedFilterMetaProtocol]) throws {
        updateAllFiltersCalled = true
        switch updateAllFiltersResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func update(filter: ExtendedFilterMetaProtocol) throws {
        updateFilterCalled = true
        switch updateAllFiltersResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func add(filter: ExtendedFilterMetaProtocol, enabled: Bool) throws {
        addFilterCalled = true
        switch addResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func deleteFilter(withId id: Int) throws {
        deleteFilterCalled = true
        switch deleteResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func deleteFilters(withIds ids: [Int]) throws {
        deleteFiltersCalled = true
        switch deleteResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func renameFilter(withId id: Int, name: String) throws {
        renameFilterCalled = true
        switch renameResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    // MARK: - FiltersMetaStorageProtocol + Groups methods
    func getAllLocalizedGroups(forLanguage lang: String) throws -> [FilterGroupsTable] {
        getAllLocalizedGroupsCalled = true
        switch getAllLocalizedGroupsResult {
        case .success(let groups): return groups
        case .error(let error): throw error
        }
    }
    
    func setGroup(withId id: Int, enabled: Bool) throws {
        setGroupCalled = true
        switch setGroupResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func updateAll(groups: [GroupMetaProtocol]) throws {
        updateAllGroupsCalled = true
        switch updateAllGroupsResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func update(group: GroupMetaProtocol) throws {
        updateGroupCalled = true
        switch updateAllGroupsResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    // MARK: - FiltersMetaStorageProtocol + Tags methods
    func getAllTags() throws -> [FilterTagsTable] {
        getAllTagsCalled = true
        return []
    }
    
    func getTagsForFilter(withId id: Int) throws -> [FilterTagsTable] {
        getTagsForFilterCalled = true
        return []
    }
    
    func updateAll(tags: [ExtendedFiltersMeta.Tag], forFilterWithId id: Int) throws {
        updateAllTagsCalled = true
        switch updateAllTagsResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func update(tag: ExtendedFiltersMeta.Tag, forFilterWithId id: Int) throws {
        updateTagCalled = true
        switch updateAllTagsResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func deleteTagsForFilters(withIds ids: [Int]) throws {
        deleteTagsForFiltersCalled = true
    }
    
    
    // MARK: - FiltersMetaStorageProtocol + Langs methods
    func getLangsForFilter(withId id: Int) throws -> [String] {
        getLangsForFilterCalled = true
        return []
    }
    
    func updateAll(langs: [String], forFilterWithId id: Int) throws {
        updateAllLangsCalled = true
        switch updateAllLangsResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func update(lang: String, forFilterWithId id: Int) throws {
        updateLangCalled = true
        switch updateAllLangsResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func deleteLangsForFilters(withIds ids: [Int]) throws {
        deleteLangsForFiltersCalled = true
    }
    
    // MARK: - FiltersMetaStorageProtocol + Group localizations methods
    func getLocalizationForGroup(withId id: Int, forLanguage lang: String) -> FilterGroupLocalizationsTable? {
        getLocalizationForGroupCalled = true
        return nil
    }

    func updateLocalizationForGroup(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.GroupLocalization) throws {
        updateLocalizationForGroupCalled = true
        switch updateLocalizationForGroupResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    // MARK: - FiltersMetaStorageProtocol + Filters localizations methods
    func getLocalizationForFilter(withId id: Int, forLanguage lang: String) throws -> FilterLocalizationsTable? {
        getLocalizationForFilterCalled = true
        return nil
    }
    
    func updateLocalizationForFilter(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.FilterLocalization) throws {
        updateLocalizationForFilterCalled = true
        switch updateLocalizationForFilterResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func deleteAllLocalizationForFilters(withIds ids: [Int]) throws {
        deleteAllLocalizationForFiltersCalled = true
    }
    
    func deleteAllLocalizationForFilter(withId id: Int) throws {
        deleteAllLocalizationForFiltersCalled = true
    }
    
    
    
    //MARK: - public method
    func generateLocalizationForFilters() -> [FiltersTable] {
        var result = [FiltersTable]()
        var groupId = 0
        for var filterId in 0..<8 {
            groupId += 1
            let downloadPage = "https://filters.adtidy.org/ios/filters/\(filterId)_optimized.txt"
            if groupId > 7 {
                filterId = 99999 + filterId + 1
                groupId = 101
            }
            result.append(FiltersTable(filterId: filterId,
                                       groupId: groupId,
                                       isEnabled: false,
                                       version: "",
                                       lastUpdateTime: Date(),
                                       lastCheckTime: Date(),
                                       editable: false,
                                       displayNumber: 0,
                                       name: "",
                                       description: "",
                                       homePage: "",
                                       removable: false,
                                       expires: 0,
                                       subscriptionUrl: downloadPage))
        }
        return result
    }
}
