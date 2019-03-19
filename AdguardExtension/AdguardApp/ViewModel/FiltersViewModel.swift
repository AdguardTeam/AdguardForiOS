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

// MARK: - FiltersViewModelProtocol -
/**
 Model for Filters Controller
 */
protocol FiltersViewModelProtocol {

    /**
     array of filters to show. If search is active it returns filtered array
     */
    var filters: [Filter] { get }
    
    /**
    current filters group
     */
    var group: Group { get }
    
    var customGroup: Bool { get }
    
    /**
     enable/disable filter
     */
    func set(filter: Filter, enabled: Bool);
    
    /**
     enable/disable group with callback
     */
    func setGroup(enabled: Bool);
    
    /**
     add custom filter to database and reloads safari content blockers
     returns @success result in callback
     */
    func addCustomFilter(filter: AASCustomFilterParserResult, overwriteExisted: Bool, completion: @escaping (_ success: Bool)->Void)
    
    /**
     delete custom filter and reload safari content blockers
    */
    func deleteCustomFilter(filter: Filter, completion: @escaping (_ success: Bool)->Void)
    
    /**
     contains search query string
    */
    var searchString: String { get }
    
    /**
     filters array of filters by query
     */
    func searchFilter(query: String)
    func cancelSearch()
    var isSearchActive: Bool { get }
    
    /**
     adds select tag to search query or removes it if allready added
    */
    func switchTag(name: String)
    
    // MARK - callbacks
    var filtersChangedCallback:(()->Void)? { get set }
    var searchChangedCallback:(()->Void)? { get set }
}

// MARK: - FiltersViewModel -
class FiltersViewModel: FiltersViewModelProtocol {
    
    var searchString: String = ""
    
    var filtersChangedCallback: (() -> Void)?
    var searchChangedCallback: (() -> Void)?
    var filters: [Filter] {
        get {
             return (isSearchActive ? searchFilters : allFilters)
        }
    }
    
    var group: Group
    var customGroup: Bool = false
    var isSearchActive = false
    
    // MARK: - private properties
    
    private let filtersService: FiltersServiceProtocol
    
    private var filterMetas: [ASDFilterMetadata] = [ASDFilterMetadata]()
    private var allFilters: [Filter] {
        get {
            return group.filters
        }
    }
    private var searchFilters: [Filter] = [Filter]()
    
    // MARK: - init
    
    init(filtersService: FiltersServiceProtocol, group: Group) {
        
        self.filtersService = filtersService
        self.customGroup = group.groupId == FilterGroupId.custom
        self.group = group
    }
    
    // MARK: - public methods
    
    func set(filter: Filter, enabled: Bool) {
        filtersService.setFilter(filter, enabled: enabled)
    }
    
    func setGroup(enabled: Bool) {
        filtersService.setGroup(group, enabled: enabled)
        
        filtersChangedCallback?()
    }
    
    func addCustomFilter(filter: AASCustomFilterParserResult, overwriteExisted: Bool, completion: @escaping (Bool) -> Void) {
        filtersService.addCustomFilter(filter, overwriteExisted: overwriteExisted)
        completion(true)
    }
    
    func deleteCustomFilter(filter: Filter, completion: @escaping (Bool) -> Void) {
        filtersService.deleteCustomFilter(filter)
        completion(true)
    }
    
    func searchFilter(query: String) {
        isSearchActive = true
        searchString = query
        
        searchFilters = [Filter]()
        
        if query.count == 0 {
            searchFilters = allFilters
            heighlightTags([])
        }
        else {
            
            let components = searchString.lowercased().split(separator: " ")
            
            var searchTextFiltersSet: Set<Filter> = Set<Filter>()
            var searchTaggedFiltersSet: Set<Filter> = Set<Filter>()
            
            var selectedTags: Set<String> = Set()
            
            var hasNotagText = false
            
            for component in components {

                var componentIsTag = false
                
                allFilters.forEach { (filter) in

                    var tagFound = false
                    for tag in filter.tags!{
                        if tag.name == component {
                            searchTaggedFiltersSet.insert(filter)
                            selectedTags.insert(tag.name)
                            tagFound = true
                        }
                    }
                    
                    if tagFound {
                        componentIsTag = true
                        return
                    }
                    
                    for lang in filter.langs! {
                        if lang.name == component {
                            searchTaggedFiltersSet.insert(filter)
                            selectedTags.insert(lang.name)
                            tagFound = true
                        }
                    }
                    
                    if tagFound {
                        componentIsTag = true
                        return
                    }
                    
                    let range = filter.name?.range(of: component, options: .caseInsensitive)
                    if range != nil {
                        searchTextFiltersSet.insert(filter)
                    }
                }
                
                if !componentIsTag {
                    hasNotagText = true
                }
            }
            
            var searchFiltersSet: Set<Filter> = Set<Filter>()
            
            if !hasNotagText {
                searchFiltersSet = searchTaggedFiltersSet
            }
            else if searchTaggedFiltersSet.isEmpty {
                searchFiltersSet = searchTextFiltersSet
            }
            else {
                searchFiltersSet = searchTextFiltersSet.intersection(searchTaggedFiltersSet)
            }
            
            searchFilters = Array(searchFiltersSet)
            
            heighlightTags(selectedTags)
        }
        
        filtersChangedCallback?()
    }
    
    func cancelSearch() {
        isSearchActive = false
        searchString = ""
        heighlightTags([])
        searchFilters = [Filter]()
        
        filtersChangedCallback?()
    }
    
    func switchTag(name: String) {
        isSearchActive = true
        
        var newSearchString = ""
        if searchString.contains(name) {
            newSearchString = searchString.replacingOccurrences(of: name, with: "")
            newSearchString = newSearchString.trimmingCharacters(in: .whitespaces)
        }
        else {
            newSearchString = name + " " + searchString
        }
        
        searchFilter(query: newSearchString)
        
        searchChangedCallback?()
    }
    
    // MARK: - private methods
    
    private func heighlightTags(_ tags: Set<String>) {
        for filter in allFilters {
            for i in 0..<filter.tags!.count {
                filter.tags![i].heighlighted = !(tags.count == 0 || tags.contains(filter.tags![i].name))
            }
            
            for i in 0..<filter.langs!.count {
                filter.langs![i].heighlighted = !(tags.count == 0 || tags.contains(filter.langs![i].name))
            }
        }
    }
}
