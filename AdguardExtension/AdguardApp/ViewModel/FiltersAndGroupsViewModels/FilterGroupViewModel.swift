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
     adds select tag to search query or removes it if it is allready added
    */
    func switchTag(name: String)
    
    /* delete custom filter and reload safari content blockers */
    func deleteCustomFilter(filter: Filter, completion: @escaping (_ success: Bool)->Void)
    
    /**
        enable/disable filter
    */
    func set(filter: Filter, enabled: Bool)
    
    /**
     loads filters list
    */
    func load(_ completion: @escaping ()->Void)
    
    /**
     enable/disable group
    */
    func set(group: Group, enabled: Bool, completion: @escaping (_ success: Bool)->Void)
    
    /**
     sets groups change observer
    */
    func bind(groupChanged: @escaping (_ index: Int)->Void)
    
    var helper: IFiltersAndGroupsViewModelHelper? { get }
    
    // MARK - callbacks
    var filtersChangedCallback:(()->Void)? { get set }
    var searchChangedCallback:(()->Void)? { get set }
}

class FilterGroupViewModel: NSObject, FilterGroupViewModelProtocol {
    
    var helper: IFiltersAndGroupsViewModelHelper?
    
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
    init(filtersService: FiltersServiceProtocol, helper: IFiltersAndGroupsViewModelHelper) {
        self.helper = helper
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
    
    func set(filter: Filter, enabled: Bool){
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
            guard let result = helper?.searchComponentsInGroupsAndFilters(searchString: searchString, allGroups: allGroups) else { return }
            
            searchGroups = result.searchGroups
            highlightTags(result.selectedTags)
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
        guard let helper = helper else { return }
        
        isSearchActive = true
            
        let newSearchString = helper.switchTagString(name: name, searchString: searchString)
        
        searchFilter(query: newSearchString)
        
        searchChangedCallback?()
    }
    
    // MARK: - private methods
    private func setAllGroups(){
        guard let helper = helper else { return }
        let groups = filtersService.groups
        let sortedGroups = groups.sorted(by: { $0.groupId < $1.groupId })
        sortedGroups.forEach({ $0.filters = helper.sort(filters: $0.filters) })
        self.allGroups = sortedGroups
    }
    
    private func highlightTags(_ tags: Set<String>){
        for group in allGroups{
            helper?.highlightTags(filters: group.filters, tags)
        }        
    }
    
    func deleteCustomFilter(filter: Filter, completion: @escaping (Bool) -> Void) {
        filtersService.deleteCustomFilter(filter)
        setAllGroups()
        completion(true)
    }
    
}
