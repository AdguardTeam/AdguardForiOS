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

protocol FiltersAndGroupsViewModelProtocol {
    
    /* Indicates whether you need to work only with single group, otherwise it is nil */
    var currentGroup: Group? { get set }
    
    /* Returns array of groups to display */
    var groups: [Group]? { get }
    
    /* contains search query string */
    var searchString: String { get }
    
    /* filters array of groups by query */
    func searchFilter(query: String)
    
    /* cancels search */
    func cancelSearch()
    
    /* Indicates whether search is active */
    var isSearchActive: Bool { get }
    
    /* adds select tag to search query or removes it if it is allready added */
    func switchTag(name: String)
    
    /* enable/disable filter */
    func set(filter: Filter, enabled: Bool)
    
    /* enable/disable group */
    func set(group: Group, enabled: Bool)
    
    /* loads filters list */
    func load(_ completion: @escaping ()->Void)
    
    /* sets groups change observer */
    func bind(groupChanged: @escaping (_ index: Int)->Void)
    
    func updateCurrentGroup()
    
    func updateAllGroups()
    
    /* adds custom filter to database and reloads safari content blockers
    returns @success result in callback */
    func addCustomFilter(filter: AASCustomFilterParserResult, overwriteExisted: Bool, completion: @escaping (Bool) -> Void)
    
    // MARK - callbacks
    var filtersChangedCallback:(()->Void)? { get set }
    var searchChangedCallback:(()->Void)? { get set }
}

final class FiltersAndGroupsViewModel: NSObject, FiltersAndGroupsViewModelProtocol {

    // MARK: - Public properties
    
    var currentGroup: Group?
    
    var groups: [Group]? {
        get {
            return isSearchActive ? searchGroups : allGroups
        }
    }
    
    var searchString: String = ""
    
    var isSearchActive: Bool = false
    
    
    // MARK: - Private properties
    
    private var searchGroups: [Group] = []
    private var allGroups: [Group] = []
    
    private var groupsObserver: ((_ index: Int)->Void)?
    private var filtersService: FiltersServiceProtocol
    
    
    // MARK: - Callbacks
    
    var filtersChangedCallback: (() -> Void)?
    
    var searchChangedCallback: (() -> Void)?
    
    
    // MARK: - initializers
    
    init(filtersService: FiltersServiceProtocol) {
        self.filtersService = filtersService
        super.init()
        
        updateAllGroups()
        NotificationCenter.default.addObserver(forName: self.filtersService.updateNotification, object: nil, queue: nil) {
            [weak self] (notification) in
            self?.groupsObserver?(0)
        }
    }
    
    // MARK: - Public methods

    func searchFilter(query: String) {
        isSearchActive = true
        searchString = query
        
        searchGroups = [Group]()
        let groupsToSearchIn: [Group] = (currentGroup != nil) ? [currentGroup!] : allGroups
        
        if query.count == 0 {
            groupsToSearchIn.forEach({ $0.filters.forEach({ $0.searchAttributedString = nil }) })
            searchGroups = groupsToSearchIn
            highlightTags([])
        } else {
            
            let components = searchString.lowercased().split(separator: " ")
            
            let searchSet = Set(components.map({ String($0) }))
            let searchStrings = Array(searchSet)
            
            for group in groupsToSearchIn{
                
                var foundFiltersSet = Set<Filter>()
                
                let filters = group.filters
                
                for filter in filters{
                    filter.searchAttributedString = filter.name?.highlight(search: searchStrings)
                    
                    let tags = filter.tags?.map({$0.name}) ?? []
                    let langs = filter.langs?.map({$0.name}) ?? []
                    
                    let tagsSet = Set(tags)
                    let langsSet = Set(langs)
                    
                    let langsAndTagsUnion = tagsSet.union(langsSet)
                    let selectedTagsForFilterSet = searchSet.intersection(langsAndTagsUnion)
                    
                    highlight(filter: filter, tags: selectedTagsForFilterSet)
                    
                    let filterNameSatisfies = checkFilter(filter: filter, components: components)
                    
                    if !selectedTagsForFilterSet.isEmpty || filterNameSatisfies {
                        foundFiltersSet.insert(filter)
                    }
                }
                let foundFilters = Array(foundFiltersSet)
                if foundFilters.count > 0 {
                    guard let searchGroup = group.copy() as? Group else { return }
                    searchGroup.filters = foundFilters
                    searchGroups.append(searchGroup)
                }
            }
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
        } else {
            newSearchString = name + " " + searchString
        }
        
        searchFilter(query: newSearchString)
        searchChangedCallback?()
    }
    
    func set(filter: Filter, enabled: Bool) {
        filtersService.setFilter(filter, enabled: enabled)
    }
    
    func set(group: Group, enabled: Bool) {
        filtersService.setGroup(group, enabled: enabled)
        filtersChangedCallback?()
    }

    func load(_ completion: @escaping () -> Void) {
        filtersService.load(refresh: false, completion)
    }

    func bind(groupChanged: @escaping (Int) -> Void) {
        groupsObserver = groupChanged
    }
    
    func addCustomFilter(filter: AASCustomFilterParserResult, overwriteExisted: Bool, completion: @escaping (Bool) -> Void) {
        filtersService.addCustomFilter(filter, overwriteExisted: overwriteExisted)
        updateAllGroups()
        completion(true)
        filtersChangedCallback?()
    }
    
    func updateCurrentGroup(){
        if currentGroup != nil {
            let groups = filtersService.groups
            let id = currentGroup?.groupId
            for group in groups {
                if group.groupId == id {
                    currentGroup = group
                }
            }
        }
    }
    
    func updateAllGroups(){
        let groups = filtersService.groups
        let sortedGroups = groups.sorted(by: { $0.groupId < $1.groupId })
        for group in sortedGroups {
            let filters = group.filters
            group.filters = filters.sorted { (filter1, filter2) -> Bool in
            
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
        }
        self.allGroups = sortedGroups
    }
    
    
    // MARK: - Private methods
    private func highlight(filter: Filter, tags: Set<String>){
        for i in 0..<(filter.tags?.count ?? 0) {
            filter.tags![i].heighlighted = !(tags.count == 0 || tags.contains(filter.tags![i].name))
        }
        for i in 0..<(filter.langs?.count ?? 0) {
            filter.langs![i].heighlighted = !(tags.count == 0 || tags.contains(filter.langs![i].name))
        }
    }
    
    private func highlightTags(_ tags: Set<String>){
        for group in allGroups{
            let filters = group.filters
            for filter in filters {
                for i in 0..<(filter.tags?.count ?? 0) {
                    filter.tags![i].heighlighted = !(tags.count == 0 || tags.contains(filter.tags![i].name))
                }
                
                for i in 0..<(filter.langs?.count ?? 0) {
                    filter.langs![i].heighlighted = !(tags.count == 0 || tags.contains(filter.langs![i].name))
                }
            }
        }
    }
    
    private func checkFilter(filter: Filter?, components: [Substring]) -> Bool {
        let name = filter?.name
        for component in components {
            let range = name?.range(of: component, options: .caseInsensitive)
            if range != nil {
                return true
            }
        }
        return false
    }
}
