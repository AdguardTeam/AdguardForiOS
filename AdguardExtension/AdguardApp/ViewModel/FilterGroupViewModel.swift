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

/** FilterGroupViewModel
    Model for GroupsController
 */
protocol FilterGroupViewModelProtocol {
    
    var groups: [Group]? { get }
    
    /** contains search query string */
    var searchString: String { get }
    
    /**
     filters array of groups by query
     */
    func searchFilter(query: String)
    func cancelSearch()
    var isSearchActive: Bool { get }
    
    /**
     adds select tag to search query or removes it if allready added
    */
    func switchTag(name: String)
    
    /**
     loads filters list
    */
    func load(_ completion: @escaping ()->Void)
    
    /**
     enable/disable group
    */
    func set(group: Group, enabled: Bool, completion: @escaping (_ success: Bool)->Void)
    
    /**
     enable/disable filter
    */
    func setFilter(filter: Filter, enabled: Bool)
    /**
     sets groups change observer
    */
    func bind(groupChanged: @escaping (_ index: Int)->Void)
    
    /* delete custom filter and reload safari content blockers */
    func deleteCustomFilter(filter: Filter, completion: @escaping (_ success: Bool)->Void)
    
    // MARK - callbacks
    var filtersChangedCallback:(()->Void)? { get set }
    var searchChangedCallback:(()->Void)? { get set }
}

class FilterGroupViewModel: NSObject, FilterGroupViewModelProtocol {
    
    var searchString: String = ""
    
    var filtersChangedCallback: (() -> Void)?
    var searchChangedCallback: (() -> Void)?
    var isSearchActive = false
    
    var groups: [Group]? {
        get {
            return isSearchActive ? searchGroups : allGroups
        }
    }
    
    private var searchGroups: [Group] = []
    private var allGroups: [Group] = []
    
    // MARK: - private properties
    private var groupsObserver: ((_ index: Int)->Void)?
    private var filtersService: FiltersServiceProtocol
    
    // MARK: - initializers
    init(filtersService: FiltersServiceProtocol) {
        self.filtersService = filtersService
        super.init()
        
        setAllGroups()
        NotificationCenter.default.addObserver(forName: self.filtersService.updateNotification, object: nil, queue: nil) {
            [weak self] (notification) in
            self?.groupsObserver?(0)
        }
    }
    
    // MARK: - public methods
    
    func bind(groupChanged: @escaping (Int) -> Void) {
        groupsObserver = groupChanged
    }
    
    func load(_ completion: @escaping () -> Void){
        filtersService.load(refresh: false, completion)
    }
    
    func set(group: Group, enabled: Bool, completion: @escaping (_ success: Bool)->Void) {
        filtersService.setGroup(group, enabled: enabled)
    }
    
    func setFilter(filter: Filter, enabled: Bool){
        filtersService.setFilter(filter, enabled: enabled)
    }
    
    func searchFilter(query: String) {
        isSearchActive = true
        searchString = query
        
        searchGroups = [Group]()
        
        
        if query.count == 0 {
            allGroups.forEach({ $0.filters.forEach({ $0.searchAttributedString = nil }) })
            searchGroups = allGroups
            highlightTags([])
        } else {
            
            let components = searchString.lowercased().split(separator: " ")
            var selectedTags: Set<String> = Set()
            
            for group in allGroups {
                
                var searchTextFiltersSet: Set<Filter> = Set<Filter>()
                var searchTaggedFiltersSet: Set<Filter> = Set<Filter>()
                
                var hasNotagText = false
                
                for component in components {
                    
                    var componentIsTag = false
                    
                    group.filters.forEach { (filter) in
                        
                        filter.searchAttributedString = filter.name?.highlight(search: query.lowercased())
                        
                        var tagFound = false
                        for tag in filter.tags!{
                            if tag.name == component {
                                searchTaggedFiltersSet.insert(filter)
                                selectedTags.insert(tag.name)
                                tagFound = true
                            }
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
                
                
                
                let foundFilters = Array(searchFiltersSet)
                
                if foundFilters.count > 0{
                    guard let searchGroup = group.copy() as? Group else { continue }
                    searchGroup.filters = foundFilters
                    searchGroups.append(searchGroup)
                }
                
            }
            highlightTags(selectedTags)
        }
                
        filtersChangedCallback?()
    }
    
    func cancelSearch() {
        isSearchActive = false
        allGroups.forEach({ $0.filters.forEach({ $0.searchAttributedString = nil }) })
        searchString = ""
        highlightTags([])
        searchGroups = [Group]()
            
        filtersChangedCallback?()
    }
    
    func switchTag(name: String) {
        isSearchActive = true
            
        var newSearchString = ""
            
        let pattern = "(^|\\s)(\(name))\\s?"
        if searchString.range(of: pattern, options: .regularExpression) != nil {
            newSearchString = searchString.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
            newSearchString = newSearchString.trimmingCharacters(in: .whitespaces)
        }
        else {
            newSearchString = name + " " + searchString
        }
        
        searchFilter(query: newSearchString)
        
        searchChangedCallback?()
    }
    
    // MARK: - private methods
    private func setAllGroups(){
        let groups = filtersService.groups
        let sortedGroups = groups.sorted(by: { $0.groupId < $1.groupId })
        sortedGroups.forEach({ $0.filters = sort(filters: $0.filters) })
        self.allGroups = sortedGroups
    }
    
    private func highlightTags(_ tags: Set<String>){
        for group in allGroups{
            for filter in group.filters {
                for i in 0..<filter.tags!.count {
                    filter.tags![i].heighlighted = !(tags.count == 0 || tags.contains(filter.tags![i].name))
                }
                
                for i in 0..<filter.langs!.count {
                    filter.langs![i].heighlighted = !(tags.count == 0 || tags.contains(filter.langs![i].name))
                }
            }
        }
        
    }

    // MARK: - Sort Filters
    private func sort(filters: [Filter]) -> [Filter] {
        let sortedFilters = filters.sorted { (filter1, filter2) -> Bool in
                    
            let enabled1 = filter1.enabled
            let enabled2 = filter2.enabled
                    
            switch (enabled1, enabled2) {
            case (true, false):
                return true
            case (false, true):
                return false
            default:
                break
            }
                    
            if filter1.displayNumber != filter2.displayNumber {
                return filter1.displayNumber ?? 0 < filter2.displayNumber ?? 0
            }
            else {
                return filter1.name ?? "" < filter2.name ?? ""
            }
        }
        return sortedFilters
    }
    
    func deleteCustomFilter(filter: Filter, completion: @escaping (Bool) -> Void) {
        filtersService.deleteCustomFilter(filter)
        setAllGroups()
        completion(true)
    }
    
}
