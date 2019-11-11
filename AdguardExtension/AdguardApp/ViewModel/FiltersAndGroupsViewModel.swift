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

protocol FiltersAndGroupsViewModelProtocol: class {
    
    /* Indicates whether you need to work only with single group, otherwise it is nil */
    var currentGroup: Group? { get set }
    
    /* Returns array of groups to display */
    var groups: [Group]? { get }
    
    var constantAllGroups: [Group] { get }
    
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
    func set(groupId: Int, enabled: Bool)
    
    /* loads filters list */
    func load(_ completion: @escaping ()->Void)
    
    /* refresh filters list*/
    func refresh(_ complition: @escaping()->Void)
    
    /* sets groups change observer */
    func bind(groupChanged: @escaping (_ index: Int)->Void)
    
    func updateCurrentGroup()
    
    func updateAllGroups()
    
    /* adds custom filter to database and reloads safari content blockers
    returns @success result in callback */
    func addCustomFilter(filter: AASCustomFilterParserResult, completion: @escaping (Bool) -> Void)
    
    // MARK - callbacks methods
    func add(_ callback: @escaping ()->(), with key: String)
    func removeCallback(with key: String)
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
    var constantAllGroups: [Group] = []
    
    private var groupsObserver: ((_ index: Int)->Void)?
    private var filtersService: FiltersServiceProtocol
    private var configurationService: ConfigurationService
    
    
    // MARK: - Callbacks
    
    private var callbacksByKey: [ String : ()->() ] = [:]
    var searchChangedCallback: (() -> Void)?
    
    var notificationToken: NotificationToken?
    
    // MARK: - initializers
    
    init(filtersService: FiltersServiceProtocol, configurationService: ConfigurationService) {
        self.configurationService = configurationService
        self.filtersService = filtersService
        super.init()
        
        updateAllGroups()
        notificationToken = NotificationCenter.default.observe(name: self.filtersService.updateNotification, object: nil, queue: nil) {
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
                    
                    // Adding "#" symbol to satisfy search string
                    let tags = filter.tags?.map({"#" + $0.name}) ?? []
                    let langs = filter.langs?.map({"#" + $0.name}) ?? []
                    
                    let tagsSet = Set(tags)
                    let langsSet = Set(langs)
                    
                    let langsAndTagsUnion = tagsSet.union(langsSet)
                    let selectedTagsForFilterSet = searchSet.intersection(langsAndTagsUnion)
                    
                    // Remove "#" for tags, because filter names do not contain "#" symbol
                    var untaggedTags: Set<String> = []
                    
                    for tag in selectedTagsForFilterSet {
                        untaggedTags.insert(String(tag.dropFirst()))
                    }
                    
                    highlight(filter: filter, tags: untaggedTags)
                    
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
        callAllCallbacks()
    }
    
    func cancelSearch() {
        isSearchActive = false
        allGroups.forEach({ $0.filters.forEach({ $0.searchAttributedString = nil }) })
        searchString = ""
        highlightTags([])
        searchGroups = [Group]()
            
        callAllCallbacks()
    }
    
    func switchTag(name: String) {
        
        isSearchActive = true
        var newSearchString = ""
        let pattern = "(^|\\s)(\(name))\\s?"
        
        if searchString.range(of: pattern, options: .regularExpression) != nil {
            newSearchString = searchString.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
            newSearchString = newSearchString.trimmingCharacters(in: .whitespaces)
        } else {
            // "#" symbol added only when we tap on tag-buttons
            newSearchString = "#" + name + " " + searchString
        }
        
        searchFilter(query: newSearchString)
        searchChangedCallback?()
    }
    
    func set(filter: Filter, enabled: Bool) {
        filtersService.setFilter(filter, enabled: enabled)
    }
    
    func set(groupId: Int, enabled: Bool) {
        filtersService.setGroup(groupId, enabled: enabled)
        guard let group = getGroupFromSearchGroups(by: groupId) else { return }
        group.enabled = enabled
    }

    func load(_ completion: @escaping () -> Void) {
        filtersService.load(refresh: false, completion)
    }
    
    func refresh(_ complition: @escaping () -> Void) {
        filtersService.load(refresh: true) { [weak self] in
            self?.updateAllGroups()
            self?.updateCurrentGroup()
            complition()
        }
    }

    func bind(groupChanged: @escaping (Int) -> Void) {
        groupsObserver = groupChanged
    }
    
    func addCustomFilter(filter: AASCustomFilterParserResult, completion: @escaping (Bool) -> Void) {
        filtersService.addCustomFilter(filter)
        updateAllGroups()
        completion(true)
        callAllCallbacks()
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
        constantAllGroups = filtersService.groups
        let proStatus = configurationService.proStatus
        let groups = filtersService.groups.filter { (group) -> Bool in
            if proStatus {
                return true
            }
            return !group.proOnly
        }
        
        let sortedGroups = groups.sorted(by: { $0.groupId < $1.groupId })
        for group in sortedGroups {
            sortFilters(in: group)
        }
        allGroups = sortedGroups
    }
    
    func add(_ callback: @escaping () -> (), with key: String) {
        callbacksByKey[key] = callback
    }
    
    func removeCallback( with key: String) {
        callbacksByKey.removeValue(forKey: key)
    }
    
    
    // MARK: - Private methods
    
    private func callAllCallbacks(){
        callbacksByKey.forEach({ $0.value() })
    }
    
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
    
    private func sortFilters(in group: Group){
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
    
    private func getGroupFromSearchGroups(by groupId: Int) -> Group? {
        return searchGroups.first {$0.groupId == groupId }
    }
}
