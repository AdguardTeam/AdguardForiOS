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

extension HttpRequestServiceProtocol {
    func loadFiltersMetadata(version: String, id: String, cid: String, lang: String, completion: @escaping (_ filterMeta: ExtendedFiltersMeta?) -> Void) {
        let config = RequestFactory.loadFiltersMetadataConfig(version: version, id: id, cid: cid, lang: lang)
        requestSender.send(requestConfig: config) { result in
            switch result {
            case .success(let metadata):
                completion(metadata)
            case .error:
                completion(nil)
            }
        }
    }
    
    func loadFiltersLocalizations(completion: @escaping (_ filterMetaLocalization: ExtendedFiltersMetaLocalizations?) -> Void) {
        let config = RequestFactory.loadFiltersLocalizationsConfig()
        requestSender.send(requestConfig: config) { result in
            switch result {
            case .success(let localizations):
                completion(localizations)
            case .error:
                completion(nil)
            }
        }
    }
}
