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

protocol ApiMethodsProtocol {
    
    /// Loads filters meta data with API call to our server and returns it in completion if request succeedes
    func loadFiltersMetadata(version: String, id: String, cid: String, lang: String, _ completion: @escaping (_ filterMeta: ExtendedFiltersMeta?) -> Void)
    
    /// Loads filters localizations with API call to our server and returns them in completion if request succeedes
    func loadFiltersLocalizations(_ completion: @escaping (_ filterMetaLocalization: ExtendedFiltersMetaLocalizations?) -> Void)
}

/**
 This class is a wrapper for API requests to our server
 It's methods send requests and return objects of different types
 */
final class ApiMethods: ApiMethodsProtocol {
    
    private let requestSender: RequestSenderProtocol
    
    init(requestSender: RequestSenderProtocol = RequestSender()) {
        self.requestSender = requestSender
    }
    
    func loadFiltersMetadata(version: String,
                             id: String,
                             cid: String,
                             lang: String,
                             _ completion: @escaping (_ filterMeta: ExtendedFiltersMeta?) -> Void) {
        
        let config = RequestsFactory.loadFiltersMetadataConfig(version: version, id: id, cid: cid, lang: lang)
        requestSender.send(requestConfig: config) { result in
            switch result {
            case .success(let metadata):
                completion(metadata)
            case .error(_):
                completion(nil)
            }
        }
    }
    
    func loadFiltersLocalizations(_ completion: @escaping (_ filterMetaLocalization: ExtendedFiltersMetaLocalizations?) -> Void) {
        let config = RequestsFactory.loadFiltersLocalizationsConfig()
        requestSender.send(requestConfig: config) { result in
            switch result {
            case .success(let localizations):
                completion(localizations)
            case .error(_):
                completion(nil)
            }
        }
    }
}
