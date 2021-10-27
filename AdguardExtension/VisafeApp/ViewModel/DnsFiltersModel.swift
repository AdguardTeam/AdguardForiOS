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
    var enabledRulesCount: Int { get }
    var isSearchActive: Bool { get set }
    
    /* this methods must be called on main queue */
    func setFilter(index: Int, enabled: Bool)
    func addFilter(_ filter: DnsFilter, data: Data?) -> Bool
    func searchFilter(by string: String?)
    
    /* completion ewill be called on main queue */
    func updateFilters(completion: @escaping (Bool)->())
    func refreshFilters()
}

protocol DnsFiltersChangedProtocol: class {
    /** must be called on main queue */
    func filtersChanged()
}

class DnsFiltersModel: DnsFiltersModelProtocol {
    
    weak var delegate: DnsFiltersChangedProtocol?
    
    private let filtersService: DnsFiltersServiceProtocol
    private let networking: ACNNetworkingProtocol
    
    var filters: [DnsFilter] {
        get {
            return isSearchActive ? searchFilters : allFilters
        }
    }
    
    var enabledRulesCount: Int { filtersService.enabledRulesCount }
    
    private var allFilters: [DnsFilter] = []
    private var searchFilters: [DnsFilter] = []
    
    var isSearchActive: Bool = false
    
    init(filtersService: DnsFiltersServiceProtocol, networking: ACNNetworking) {
        self.filtersService = filtersService;
        self.networking = networking
        
        refreshFilters()
    }
    
    //MARK: - Public methods
    
    func addFilter(_ filter: DnsFilter, data: Data?) -> Bool {
        // Check if there are no identical filters
        for filt in allFilters{
            if filter == filt {
                return true
            }
        }
        
        allFilters.append(filter)
        filtersService.addFilter(filter, data: data)
        delegate?.filtersChanged()
        return false
    }
    
    func setFilter(index: Int, enabled: Bool) {
        let filter = filters[index]
        filtersService.setFilter(filterId: filter.id, enabled: enabled)
    }
    
    func refreshFilters() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.allFilters = self.filtersService.filters
            self.delegate?.filtersChanged()
        }
    }
    
    func updateFilters(completion: @escaping (Bool)->()){
        if filtersService.filtersAreUpdating {
            completion(false)
            return
        }
        
        filtersService.updateFilters(networking: networking) {[weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.filtersService.readFiltersMeta()
                self?.allFilters = self?.filtersService.filters ?? []
                completion(true)
            }
        }
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
