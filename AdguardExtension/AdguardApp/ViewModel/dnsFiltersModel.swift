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
    var filters: [DnsFilter] { get }
    func setFilter(index: Int, enabled: Bool)
    func addFilter(_ filter: DnsFilter)
    func deleteFilter(_ filter: DnsFilter)
    
    func updateFilters()
}

class DnsFiltersModel: DnsFiltersModelProtocol {
    
    private var filtersService: DnsFiltersServiceProtocol
    var filters: [DnsFilter] = []
    
    init(filtersService: DnsFiltersServiceProtocol) {
        self.filtersService = filtersService;
        updateFilters()
    }
    
    //MARK: - Public methods
    
    func addFilter(_ filter: DnsFilter) {
        filters.append(filter)
        filtersService.addFilter(filter)
    }
    
    func deleteFilter(_ filter: DnsFilter) {
        filtersService.deleteFilter(filter)
        for (i, fil) in filters.enumerated() {
            if fil.id == filter.id {
                filters.remove(at: i)
                return
            }
        }
    }
    
    func setFilter(index: Int, enabled: Bool) {
        let filter = filters[index]
        filtersService.setFilter(filterId: filter.id, enabled: enabled)
    }
    
    func updateFilters(){
        filters = filtersService.filters
    }
}
