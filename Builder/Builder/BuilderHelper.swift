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

@objc
@objcMembers
class BuilderHelper: NSObject {
    
    let directory: String
    init (directory: String) {
        self.directory = directory
    }
    
    private let networking = HttpRequestService()
    func loadFiltersMetadata(completion: @escaping (ABECFilterClientMetadata?)->Void) {
        networking.loadFiltersMetadata(completion: completion)
    }
    
    func loadFiltersLocalizations(completion: @escaping (ABECFilterClientLocalization?)->Void) {
        networking.loadFiltersLocalizations(completion: completion)
    }
    
    func downloadFilterSync(identifier: Int)->Error? {
        let group = DispatchGroup()
        group.enter()
        let storage = FiltersStorage(filtersDirectory: directory)
        var resultError: Error? = nil
        storage.updateFilter(identifier: identifier) { error in
            resultError = error
            group.leave()
        }
        group.wait()
        return resultError
    }
}
