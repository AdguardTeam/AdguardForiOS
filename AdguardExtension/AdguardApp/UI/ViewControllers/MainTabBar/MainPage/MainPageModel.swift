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
import SafariAdGuardSDK

protocol MainPageModelDelegate: AnyObject {
    func updateStarted()
    func updateFinished(message: String?)
    func updateFailed(error: String)
}

protocol MainPageModelProtocol: AnyObject {
    func updateFilters()
    var delegate: MainPageModelDelegate? { get set }
}

final class MainPageModel: MainPageModelProtocol {
    
    weak var delegate: MainPageModelDelegate?
    
    // MARK: - private members
    
    private let safariProtection: SafariProtectionProtocol
    private let resources: AESharedResourcesProtocol
    
    // MARK: - init
    
    init(resource: AESharedResourcesProtocol, safariProtection: SafariProtectionProtocol) {
        self.resources = resource
        self.safariProtection = safariProtection
    }
    
    // MARK: - public methods
    
    /**
     updates filters. calls callback during updating process
     */
    func updateFilters() {
        delegate?.updateStarted()
        
        var message: String?
        safariProtection.updateFiltersMetaAndLocalizations(true) { [weak delegate] result in
            switch result {
            case .error(_):
                delegate?.updateFailed(error: String.localizedString("filter_updates_error"))
                return
            case .success(let updateResult):
                let filtersCount = updateResult.updatedFilterIds.count
                if filtersCount > 0 {
                    let format = String.localizedString("filters_updated_format")
                    message = String(format: format, filtersCount)
                } else {
                    message = String.localizedString("filters_noUpdates")
                }
            }
        } onCbReloaded: { [weak delegate] _ in
            delegate?.updateFinished(message: message)
        }
    }
}
