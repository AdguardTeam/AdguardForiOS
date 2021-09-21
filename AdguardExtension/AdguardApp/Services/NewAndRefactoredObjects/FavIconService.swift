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

import UIKit

protocol FavIconServiceProtocol {
    /// Returns URL of the icon for the specified `domain`
    func iconUrl(for domain: String) -> URL?
    
    /// Returns UIImage of the icon for the specified `domain` in `onImageObtained` closure
    func image(for domain: String, _ onImageObtained: @escaping (_ image: UIImage?) -> Void)
}

/// This object is responsible for providing fav icons
/// It uses our internal service for obtaining icons
struct FavIconService: FavIconServiceProtocol {
    
    private let urlBase = "https://icons.adguard.org/icon?domain="
    
    func iconUrl(for domain: String) -> URL? {
        let url = urlBase + domain
        return URL(string: url)
    }
    
    func image(for domain: String, _ onImageObtained: @escaping (_ image: UIImage?) -> Void) {
        let completionQueue = DispatchQueue.main
        guard let url = iconUrl(for: domain) else {
            completionQueue.async { onImageObtained(nil) }
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completionQueue.async { onImageObtained(nil) }
                return
            }
            
            completionQueue.async { onImageObtained(image) }
        }
        dataTask.resume()
    }
}
