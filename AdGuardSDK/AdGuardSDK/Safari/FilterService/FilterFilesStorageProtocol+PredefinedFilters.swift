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
import Zip

public extension FilterFilesStorageProtocol {
    /**
     Unzips `filters.zip` archive and saves all filters from it.
     - Throws an error if there are any other files except `filters.zip`
     */
    func unzipPredefinedFiltersIfNeeded() throws {
        let fm = FileManager.default
        let filtersZipUrl = filterFilesDirectoryUrl.appendingPathComponent(Constants.Files.filtersZipFileName)
        let filtersUrls = try fm.contentsOfDirectory(at: filterFilesDirectoryUrl, includingPropertiesForKeys: nil, options: [])
        // There must be only filters.zip file
        guard filtersUrls.count == 1 else {
            return
        }
        try Zip.unzipFile(filtersZipUrl, destination: filterFilesDirectoryUrl, overwrite: true, password: nil)
    }
}
