import Foundation
import SQLite

class FiltersMetaStorageMock: FiltersMetaStorageProtocol {
    
    var nextCustomFilterId: Int {
        100000
    }
    
    static var defaultDbLanguage: String = "en"

    var filtersDb: Connection = try! Connection()

    func getAllLocalizedGroups(forLanguage lang: String) throws -> [FilterGroupsTable] {
        return [
            FilterGroupsTable(groupId: 1, name: "Ad Blocking", displayNumber: 1, isEnabled: false),
            FilterGroupsTable(groupId: 2, name: "Privacy", displayNumber: 2, isEnabled: false),
            FilterGroupsTable(groupId: 3, name: "Social Widgets", displayNumber: 3, isEnabled: false),
            FilterGroupsTable(groupId: 4, name: "Annoyances", displayNumber: 4, isEnabled: false),
            FilterGroupsTable(groupId: 5, name: "Security", displayNumber: 5, isEnabled: false),
            FilterGroupsTable(groupId: 6, name: "Other", displayNumber: 6, isEnabled: false),
            FilterGroupsTable(groupId: 7, name: "Language-specific", displayNumber: 7, isEnabled: false),
            FilterGroupsTable(groupId: 101, name: "Custom", displayNumber: 0, isEnabled: false)]
    }
    
    func getLocalizedFiltersForGroup(withId id: Int, forLanguage lang: String) throws -> [FiltersTable] {
        var result = [FiltersTable]()
        var groupId = 0
        for var filterId in 0..<8 {
            groupId += 1
            if filterId == 8 {
                filterId = 100001
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
                                        subscriptionUrl: ""))
        }
        return result
    }
    
    func updateLocalizationForFilter(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.FilterLocalization) throws {
        
    }
    
    func updateLocalizationForGroup(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.GroupLocalization) throws {
        
    }
    
    func setFilter(withId id: Int, enabled: Bool) throws {
        
    }
    
    func updateAll(filters: [ExtendedFilterMetaProtocol]) throws {
        
    }
    
    func update(filter: ExtendedFilterMetaProtocol) throws {
        
    }
    
    func add(filter: ExtendedFilterMetaProtocol, enabled: Bool) throws {
        
    }
    
    func deleteFilter(withId id: Int) throws {
        
    }
    
    func deleteFilters(withIds ids: [Int]) throws {
        
    }
    
    func renameFilter(withId id: Int, name: String) throws {
        
    }
    
    func setGroup(withId id: Int, enabled: Bool) throws {
        
    }
    
    func updateAll(groups: [GroupMetaProtocol]) throws {
        
    }
    
    func update(group: GroupMetaProtocol) throws {
        
    }
    
    func getAllTags() throws -> [FilterTagsTable] {
        return []
    }
    
    func getTagsForFilter(withId id: Int) throws -> [FilterTagsTable] {
        return []
    }
    
    func updateAll(tags: [ExtendedFiltersMeta.Tag], forFilterWithId id: Int) throws {
        
    }
    
    func update(tag: ExtendedFiltersMeta.Tag, forFilterWithId id: Int) throws {
        
    }
    
    func deleteTagsForFilters(withIds ids: [Int]) throws {
        
    }
    
    func getLangsForFilter(withId id: Int) throws -> [String] {
        return []
    }
    
    func updateAll(langs: [String], forFilterWithId id: Int) throws {
        
    }
    
    func update(lang: String, forFilterWithId id: Int) throws {
        
    }
    
    func deleteLangsForFilters(withIds ids: [Int]) throws {
        
    }
    
    func getLocalizationForFilter(withId id: Int, forLanguage lang: String) throws -> FilterLocalizationsTable? {
        return nil
    }
    
    func updateLocalizatonForFilter(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.FilterLocalization) throws {
        
    }
    
    func deleteAllLocalizationForFilters(withIds ids: [Int]) throws {
        
    }
    
    func deleteAllLocalizationForFilter(withId id: Int) throws {
        
    }
}
