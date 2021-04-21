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

protocol MainPageModelDelegate: class {
    func updateStarted()
    func updateFinished(message: String?)
    func updateFailed(error: String)
}

protocol MainPageModelProtocol: class {
    func updateFilters()
    var delegate: MainPageModelDelegate? { get set }
}

class MainPageModel: MainPageModelProtocol {
    
    weak var delegate: MainPageModelDelegate?
    
    // MARK: - private members
    
    private let filtersService: FiltersServiceProtocol
    
    // MARK: - init
    
    init(filtersService: FiltersServiceProtocol) {
        self.filtersService = filtersService
    }
    
    // MARK: - public methods
    
    /**
     updates filters. calls callback during updating process
     */
    func updateFilters() {
        delegate?.updateStarted()
        filtersService.load(refresh: true) { [weak delegate] filtersCount, error in
            
            if error != nil {
                delegate?.updateFailed(error: String.localizedString("filter_updates_error"))
                return
            }
            
            let message: String?
            if filtersCount > 0 {
                let format = ACLocalizedString("filters_updated_format", nil);
                message = String(format: format, filtersCount)
            } else {
                message = ACLocalizedString("filters_noUpdates", nil);
            }
            
            delegate?.updateFinished(message: message)
        }
    }
}
