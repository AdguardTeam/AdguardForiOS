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

protocol DnsFiltersModelProtocol {
    var delegate: DnsFiltersChangedProtocol? { get set }
    
    var filters: [DnsFilter] { get }
    var isSearchActive: Bool { get set }
    
    func setFilter(index: Int, enabled: Bool)
    func addFilter(_ filter: DnsFilter, data: Data?)
    func deleteFilter(_ filter: DnsFilter)
    func searchFilter(by string: String?)
    func updateFilters()
}

protocol DnsFiltersChangedProtocol {
    func filtersChanged()
}

class DnsFiltersModel: DnsFiltersModelProtocol {
    
    var delegate: DnsFiltersChangedProtocol?
    
    private var filtersService: DnsFiltersServiceProtocol
    
    var filters: [DnsFilter] {
        get {
            return isSearchActive ? searchFilters : allFilters
        }
    }
    private var allFilters: [DnsFilter] = []
    private var searchFilters: [DnsFilter] = []
    
    var isSearchActive: Bool = false
    
    init(filtersService: DnsFiltersServiceProtocol) {
        self.filtersService = filtersService;
        updateFilters()
    }
    
    //MARK: - Public methods
    
    func addFilter(_ filter: DnsFilter, data: Data?) {
        // Check if there are no identical filters
        for filt in allFilters{
            if filter == filt {
                return
            }
        }
        
        allFilters.append(filter)
        filtersService.addFilter(filter, data: data)
    }
    
    func deleteFilter(_ filter: DnsFilter) {
        filtersService.deleteFilter(filter)
        for (i, fil) in filters.enumerated() {
            if fil.id == filter.id {
                allFilters.remove(at: i)
                return
            }
        }
    }
    
    func setFilter(index: Int, enabled: Bool) {
        let filter = filters[index]
        filtersService.setFilter(filterId: filter.id, enabled: enabled)
    }
    
    func updateFilters(){
        allFilters = filtersService.filters
    }
    
    func searchFilter(by string: String?) {
        searchFilters = []
        allFilters.forEach({ $0.attributedString = nil })
        
        if string == nil || (string?.isEmpty ?? true) {
            searchFilters = allFilters
            delegate?.filtersChanged()
            return
        }
        let components = string!.lowercased().split(separator: " ")
        let searchSet = Set(components.map({ String($0) }))
        let searchStrings = Array(searchSet)
        
        for filter in allFilters {
            if checkFilter(filter: filter, searchString: searchStrings) {
                filter.attributedString = filter.name?.highlight(search: searchStrings)
                searchFilters.append(filter)
            }
        }
        delegate?.filtersChanged()
    }
    
    private func checkFilter(filter: DnsFilter, searchString: [String]) -> Bool{
        let name = filter.name ?? ""
        for string in searchString {
            let range = name.range(of: string, options: .caseInsensitive)
            if range != nil {
                return true
            }
        }
        return false
    }
}
