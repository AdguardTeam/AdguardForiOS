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

protocol IFiltersAndGroupsViewModelHelper: class {
    /* Highlight tags in FiltersController and SearchController */
    func highlightTags( filters: [Filter], _ tags: Set<String>)
    
    /* Sorts filters */
    func sort(filters: [Filter]) -> [Filter]
    
    /* Switches tag */
    func switchTagString(name: String, searchString: String) -> String
    
    /* Searches components in filters */
    func searchComponentsInFilters(searchString: String, allFilters: [Filter]) -> (searchFilters: [Filter], selectedTags: Set<String>)
    
    /* Searches components in groups */
    func searchComponentsInGroupsAndFilters(searchString: String, allGroups: [Group]) -> (searchGroups: [Group], selectedTags: Set<String>)
}

class FiltersAndGroupsViewModelHelper: IFiltersAndGroupsViewModelHelper {
    
    func highlightTags( filters: [Filter], _ tags: Set<String>){
        
        for filter in filters {
            for i in 0..<(filter.tags?.count ?? 0) {
                filter.tags![i].heighlighted = !(tags.count == 0 || tags.contains(filter.tags![i].name))
            }
            
            for i in 0..<(filter.langs?.count ?? 0) {
                filter.langs![i].heighlighted = !(tags.count == 0 || tags.contains(filter.langs![i].name))
            }
        }
    }
    
    func sort(filters: [Filter]) -> [Filter] {
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
    
    func switchTagString(name: String, searchString: String) -> String{
        var newSearchString = ""
            
        let pattern = "(^|\\s)(\(name))\\s?"
        if searchString.range(of: pattern, options: .regularExpression) != nil {
            newSearchString = searchString.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
            newSearchString = newSearchString.trimmingCharacters(in: .whitespaces)
        }
        else {
            newSearchString = name + " " + searchString
        }
        return newSearchString
    }
    
    func searchComponentsInFilters(searchString: String, allFilters: [Filter]) -> (searchFilters: [Filter], selectedTags: Set<String>){
        let components = searchString.lowercased().split(separator: " ")
            
        var searchTextFiltersSet: Set<Filter> = Set<Filter>()
        var searchTaggedFiltersSet: Set<Filter> = Set<Filter>()
        
        var selectedTags: Set<String> = Set()
        
        var hasNotagText = false
        
        var searchStrings: [String?] = []
        
        for component in components {

            var componentIsTag = false
            searchStrings.append(String(component))
            
            allFilters.forEach { (filter) in
                    
                filter.searchAttributedString = filter.name?.highlight(search: searchStrings)
                    
                var tagFound = false
                
                let tags = filter.tags?.map({$0.name}) ?? []
                let langs = filter.langs?.map({$0.name}) ?? []
                
                findTagOrLangByName(componentNames: tags, component: String(component), filter: filter, tagFound: &tagFound, searchTaggedFiltersSet: &searchTaggedFiltersSet, selectedTags: &selectedTags)
                findTagOrLangByName(componentNames: langs, component: String(component), filter: filter, tagFound: &tagFound, searchTaggedFiltersSet: &searchTaggedFiltersSet, selectedTags: &selectedTags)
                
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
        
        let searchFilters = Array(searchFiltersSet)
        
        return (searchFilters: searchFilters, selectedTags: selectedTags)
    }
    
    func searchComponentsInGroupsAndFilters(searchString: String, allGroups: [Group]) -> (searchGroups: [Group], selectedTags: Set<String>){
        let components = searchString.lowercased().split(separator: " ")
        var selectedTags: Set<String> = Set()
        var searchGroups: [Group] = []
        for group in allGroups {
            
            var searchTextFiltersSet: Set<Filter> = Set<Filter>()
            var searchTaggedFiltersSet: Set<Filter> = Set<Filter>()
            
            var hasNotagText = false
            
            var searchStrings: [String?] = []
            
            for component in components {
                
                searchStrings.append(String(component))
                var componentIsTag = false
                
                group.filters.forEach { (filter) in
                    
                    filter.searchAttributedString = filter.name?.highlight(search: searchStrings)
                    
                    var tagFound = false
                    
                    let tags = filter.tags?.map({$0.name}) ?? []
                    let langs = filter.langs?.map({$0.name}) ?? []
                    
                    findTagOrLangByName(componentNames: tags, component: String(component), filter: filter, tagFound: &tagFound, searchTaggedFiltersSet: &searchTaggedFiltersSet, selectedTags: &selectedTags)
                    findTagOrLangByName(componentNames: langs, component: String(component), filter: filter, tagFound: &tagFound, searchTaggedFiltersSet: &searchTaggedFiltersSet, selectedTags: &selectedTags)
                                        
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
        return (searchGroups,selectedTags)
    }
    
    private func findTagOrLangByName(componentNames: [String], component: String, filter: Filter, tagFound: inout Bool, searchTaggedFiltersSet: inout Set<Filter>, selectedTags: inout Set<String>){
        for componentName in componentNames{
            if componentName == component {
                searchTaggedFiltersSet.insert(filter)
                selectedTags.insert(componentName)
                tagFound = true
            }
        }
    }
}
