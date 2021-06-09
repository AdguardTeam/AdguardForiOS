import Foundation
import SQLite

enum FilterMetaStorageMockError: Error {
    case updateAllGroupsError
    case updateAllFiltersError
    case updateAllTagsError
    case updateAllLangsError
    case getAllLocalizedGroupsError
    case getAllLocalizaedFiltersError
    case updateLocalizationForGroupErorr
    case updateLocalizationForFilterError
    case setGropuError
    case setFilterError
    case addError
    case deleteError
    case renameError
    case error
}

class FiltersMetaStorageMock: FiltersMetaStorageProtocol {
    var constantGroupsTable = [
        FilterGroupsTable(groupId: 1, name: "Ad Blocking", displayNumber: 1, isEnabled: false),
        FilterGroupsTable(groupId: 2, name: "Privacy", displayNumber: 2, isEnabled: false),
        FilterGroupsTable(groupId: 3, name: "Social Widgets", displayNumber: 3, isEnabled: false),
        FilterGroupsTable(groupId: 4, name: "Annoyances", displayNumber: 4, isEnabled: false),
        FilterGroupsTable(groupId: 5, name: "Security", displayNumber: 5, isEnabled: false),
        FilterGroupsTable(groupId: 6, name: "Other", displayNumber: 6, isEnabled: false),
        FilterGroupsTable(groupId: 7, name: "Language-specific", displayNumber: 7, isEnabled: false),
        FilterGroupsTable(groupId: 101, name: "Custom", displayNumber: 0, isEnabled: false)]
    
    var filtersDownloadPage: [String?] = [
        "https://filters.adtidy.org/ios/filters/1_optimized.txt",
        "https://filters.adtidy.org/ios/filters/2_optimized.txt",
        "https://filters.adtidy.org/ios/filters/3_optimized.txt",
        "https://filters.adtidy.org/ios/filters/4_optimized.txt",
        "https://filters.adtidy.org/ios/filters/5_optimized.txt",
        "https://filters.adtidy.org/ios/filters/6_optimized.txt",
        "https://filters.adtidy.org/ios/filters/7_optimized.txt",
        "https://filters.adtidy.org/ios/filters/8_optimized.txt"
    ]
    
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
    
    var updateAllGroupsResult: Result<FilterMetaStorageMockError?> = .success(nil)
    var updateAllFiltersResult: Result<FilterMetaStorageMockError?> = .success(nil)
    var updateAllTagsResult: Result<FilterMetaStorageMockError?> = .success(nil)
    var updateAllLangsResult: Result<FilterMetaStorageMockError?> = .success(nil)
    
    var getAllLocalizedGroupsResult: Result<[FilterGroupsTable]> = .success([])
    var getAllLocalizaedFiltersResult: Result<[FiltersTable]> = .success([])
    
    var updateLocalizationForGroupResult: Result<FilterMetaStorageMockError?> = .success(nil)
    var updateLocalizationForFilterResult: Result<FilterMetaStorageMockError?> = .success(nil)
    
    var setGroupResult: Result<FilterMetaStorageMockError?> = .success(nil)
    var setFilterResult: Result<FilterMetaStorageMockError?> = .success(nil)
    
    var addResult: Result<FilterMetaStorageMockError?> = .success(nil)
    
    var deleteResult: Result<FilterMetaStorageMockError?> = .success(nil)
    
    var renameResult: Result<FilterMetaStorageMockError?> = .success(nil)
    
    init() {
        getAllLocalizedGroupsResult = .success(constantGroupsTable)
        getAllLocalizaedFiltersResult = .success(generateLocalizationForFilters())
    }
    
    func setResultsToDefault() {
        updateAllGroupsResult = .success(nil)
        updateAllFiltersResult = .success(nil)
        updateAllTagsResult = .success(nil)
        updateAllLangsResult = .success(nil)
        
        getAllLocalizedGroupsResult = .success(constantGroupsTable)
        getAllLocalizaedFiltersResult = .success(generateLocalizationForFilters())

        updateLocalizationForGroupResult = .success(nil)
        updateLocalizationForFilterResult = .success(nil)
        
        setGroupResult = .success(nil)
        setFilterResult = .success(nil)
        
        addResult = .success(nil)
        
        deleteResult = .success(nil)
        
        renameResult = .success(nil)
    }
    
    // MARK: - FiltersMetaStorageProtocol + Filters methods

    func getLocalizedFiltersForGroup(withId id: Int, forLanguage lang: String) throws -> [FiltersTable] {
        switch getAllLocalizaedFiltersResult {
        case .success(let filters): return filters
        case .error(let error): throw error
        }
    }
    
    func setFilter(withId id: Int, enabled: Bool) throws {
        switch setFilterResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func updateAll(filters: [ExtendedFilterMetaProtocol]) throws {
        switch updateAllFiltersResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func update(filter: ExtendedFilterMetaProtocol) throws {
        switch updateAllFiltersResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func add(filter: ExtendedFilterMetaProtocol, enabled: Bool) throws {
        switch addResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func deleteFilter(withId id: Int) throws {
        switch deleteResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func deleteFilters(withIds ids: [Int]) throws {
        switch deleteResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func renameFilter(withId id: Int, name: String) throws {
        switch renameResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    // MARK: - FiltersMetaStorageProtocol + Groups methods
    func getAllLocalizedGroups(forLanguage lang: String) throws -> [FilterGroupsTable] {
        switch getAllLocalizedGroupsResult {
        case .success(let groups): return groups
        case .error(let error): throw error
        }
    }
    
    func setGroup(withId id: Int, enabled: Bool) throws {
        switch setGroupResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func updateAll(groups: [GroupMetaProtocol]) throws {
        switch updateAllGroupsResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func update(group: GroupMetaProtocol) throws {
        switch updateAllGroupsResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    // MARK: - FiltersMetaStorageProtocol + Tags methods
    func getAllTags() throws -> [FilterTagsTable] {
        return []
    }
    
    func getTagsForFilter(withId id: Int) throws -> [FilterTagsTable] {
        return []
    }
    
    func updateAll(tags: [ExtendedFiltersMeta.Tag], forFilterWithId id: Int) throws {
        switch updateAllTagsResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func update(tag: ExtendedFiltersMeta.Tag, forFilterWithId id: Int) throws {
        switch updateAllTagsResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func deleteTagsForFilters(withIds ids: [Int]) throws {
        
    }
    
    
    // MARK: - FiltersMetaStorageProtocol + Langs methods
    func getLangsForFilter(withId id: Int) throws -> [String] {
        return []
    }
    
    func updateAll(langs: [String], forFilterWithId id: Int) throws {
        switch updateAllLangsResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func update(lang: String, forFilterWithId id: Int) throws {
        switch updateAllLangsResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func deleteLangsForFilters(withIds ids: [Int]) throws {
        
    }
    
    // MARK: - FiltersMetaStorageProtocol + Group localizations methods
    func getLocalizationForGroup(withId id: Int, forLanguage lang: String) -> FilterGroupLocalizationsTable? {
        return nil
    }

    func updateLocalizationForGroup(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.GroupLocalization) throws {
        switch updateLocalizationForGroupResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    // MARK: - FiltersMetaStorageProtocol + Filters localizations methods
    func getLocalizationForFilter(withId id: Int, forLanguage lang: String) throws -> FilterLocalizationsTable? {
        return nil
    }
    
    func updateLocalizationForFilter(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.FilterLocalization) throws {
        switch updateLocalizationForFilterResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
    
    func deleteAllLocalizationForFilters(withIds ids: [Int]) throws {
        
    }
    
    func deleteAllLocalizationForFilter(withId id: Int) throws {
        
    }
    
    
    
    //MARK: - public method
    func generateLocalizationForFilters() -> [FiltersTable] {
        var result = [FiltersTable]()
        var groupId = 0
        for var filterId in 0..<8 {
            groupId += 1
            let downloadPage = filtersDownloadPage[filterId]
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
