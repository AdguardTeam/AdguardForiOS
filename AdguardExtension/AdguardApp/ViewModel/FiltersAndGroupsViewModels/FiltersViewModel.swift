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
    adds select tag to search query or removes it if it is allready added
    */
    func switchTag(name: String)
    
    /**
      delete custom filter and reload safari content blockers
     */
     func deleteCustomFilter(filter: Filter, completion: @escaping (_ success: Bool)->Void)
    
    /**
     enable/disable filter
     */
    func set(filter: Filter, enabled: Bool)
    
    /**
    current filters group
     */
    var group: Group { get }
    
    var customGroup: Bool { get }
    
    /**
     enable/disable group with callback
     */
    func setGroup(enabled: Bool)
    
    /**
     add custom filter to database and reloads safari content blockers
     returns @success result in callback
     */
    func addCustomFilter(filter: AASCustomFilterParserResult, overwriteExisted: Bool, completion: @escaping (_ success: Bool)->Void)
    
    var helper: IFiltersAndGroupsViewModelHelper? { get }
    
    // MARK - callbacks
    var filtersChangedCallback:(()->Void)? { get set }
    var searchChangedCallback:(()->Void)? { get set }
}

// MARK: - FiltersViewModel
class FiltersViewModel: FiltersViewModelProtocol {
    
    var helper: IFiltersAndGroupsViewModelHelper?
    
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
    
    private var allFilters: [Filter] = []
    
    private let filtersService: FiltersServiceProtocol
    
    private var filterMetas: [ASDFilterMetadata] = [ASDFilterMetadata]()
    private var searchFilters: [Filter] = [Filter]()
    
    // MARK: - init
    
    init(filtersService: FiltersServiceProtocol, group: Group, helper: IFiltersAndGroupsViewModelHelper?) {
        
        self.helper = helper
        self.filtersService = filtersService
        self.customGroup = group.groupId == FilterGroupId.custom
        self.group = group
        
        NotificationCenter.default.addObserver(forName: self.filtersService.updateNotification, object: nil, queue: nil) {
            [weak self] (notification) in
            self?.updateFilters()
            self?.filtersChangedCallback?()
        }
        
        updateFilters()
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
        updateFilters()
        completion(true)
    }
    
    func deleteCustomFilter(filter: Filter, completion: @escaping (Bool) -> Void) {
        filtersService.deleteCustomFilter(filter)
        updateFilters()
        completion(true)
    }
    
    func searchFilter(query: String) {
        guard let helper = helper else { return }
        isSearchActive = true
        searchString = query
        
        searchFilters = [Filter]()
        
        if query.count == 0 {
            allFilters.forEach({ $0.searchAttributedString = nil })
            searchFilters = allFilters
            heighlightTags([])
        }
        else {
            let result = helper.searchComponentsInFilters(searchString: searchString, allFilters: allFilters)
            
            searchFilters = result.searchFilters
            let selectedTags = result.selectedTags
            heighlightTags(selectedTags)
        }
        
        filtersChangedCallback?()
    }
    
    func cancelSearch() {
        isSearchActive = false
        allFilters.forEach({ $0.searchAttributedString = nil })
        searchString = ""
        heighlightTags([])
        searchFilters = [Filter]()
        
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
    
    private func heighlightTags(_ tags: Set<String>) {
        helper?.highlightTags(filters: allFilters, tags)
    }
    
    private func updateFilters() {
        guard let helper = helper else { return }
        allFilters = helper.sort(filters: group.filters)
    }
    
}
