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

protocol SharedStorageUrlsProtocol {
    var sharedContainerUrl: URL { get }
    var dbFolderUrl: URL { get }
    var filtersFolderUrl: URL { get }
    var cbJsonsFolderUrl: URL { get }
}

/// This object contains all shared folders URLs
struct SharedStorageUrls: SharedStorageUrlsProtocol {
    
    let sharedContainerUrl: URL
    let dbFolderUrl: URL
    let filtersFolderUrl: URL
    let cbJsonsFolderUrl: URL
    
    private static let sharedResourcesGroup = Bundle.main.infoDictionary!["SharedResourcesGroup"] as! String
}

extension SharedStorageUrls {
    init() {
        self.sharedContainerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Self.sharedResourcesGroup)!
        self.dbFolderUrl = sharedContainerUrl.appendingPathComponent("db_files", isDirectory: true)
        self.filtersFolderUrl = sharedContainerUrl.appendingPathComponent("filters", isDirectory: true)
        self.cbJsonsFolderUrl = sharedContainerUrl.appendingPathComponent("cb_jsons", isDirectory: true)
    }
}
