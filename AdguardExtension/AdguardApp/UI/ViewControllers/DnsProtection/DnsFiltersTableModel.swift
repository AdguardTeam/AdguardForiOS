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
import DnsAdGuardSDK

final class DnsFiltersTableModel {
    
    // MARK: - Public variables
    
    var searchString: String? {
        didSet {
            
        }
    }
    
    var isSearching: Bool { searchString != nil && !searchString!.isEmpty }
    
    private(set) var cellModels: [FilterCellModel] = []
    
    // MARK: - Private variables
    
    private let dnsProtection: DnsProtectionProtocol
    
    // MARK: - Initialization
    
    init(dnsProtection: DnsProtectionProtocol) {
        self.dnsProtection = dnsProtection
    }
    
    // MARK: - Public methods
    
    
    // MARK: - Private methods
}

// MARK: - DnsFiltersTableModel + NewCustomFilterDetailsControllerDelegate

extension DnsFiltersTableModel: NewCustomFilterDetailsControllerDelegate {
    func addCustomFilter(_ meta: ExtendedCustomFilterMetaProtocol, _ onFilterAdded: @escaping (Error?) -> Void) {
        
    }
    
    func renameFilter(withId filterId: Int, to newName: String) throws -> FilterDetailsProtocol {
        throw CommonError.missingData
    }
}
