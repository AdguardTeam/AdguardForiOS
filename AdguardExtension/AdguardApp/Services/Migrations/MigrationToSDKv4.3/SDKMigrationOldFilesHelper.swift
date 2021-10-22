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

/// This object is a helper for `MigrationService`
/// It is responsible for removing unused files and replace used ones
/// We've started to use AdGuard SDK in v4.3
protocol SDKMigrationOldFilesHelperProtocol {
    /// Removes files that aren't used anymore
    func removeOldUnusedFiles()

    /// Replaces content blocker JSON files to new folder
    func replaceCbJsonFiles()
}

/// Implementation of `SDKMigrationOldFilesHelperProtocol`
final class SDKMigrationOldFilesHelper: SDKMigrationOldFilesHelperProtocol {

    private let oldFilesContainerUrl: URL
    private let cbJsonFolderUrl: URL

    init(oldFilesContainerUrl: URL, cbJsonFolderUrl: URL) {
        self.oldFilesContainerUrl = oldFilesContainerUrl
        self.cbJsonFolderUrl = cbJsonFolderUrl
    }

    func removeOldUnusedFiles() {
        let unusedFileNames = [
            "metadata-cache.data",
            "lastupdate-filter-ids.data",
            "i18-cache.data",
            "defaultdb-marker.data",
            "lastupdate-filters-v2.data"
        ]

        unusedFileNames.forEach {
            let url = oldFilesContainerUrl.appendingPathComponent($0)
            try? FileManager.default.removeItem(at: url)
        }
    }

    func replaceCbJsonFiles() {
        let jsonFileNames = [
            "cb_general.json",
            "cb_privacy.json",
            "cb_annoyances.json",
            "cb_other.json",
            "cb_custom.json",
            "cb_security.json"
        ]

        jsonFileNames.forEach {
            let oldCbJsonFileUrl = oldFilesContainerUrl.appendingPathComponent($0)
            let newCbJsonFileUrl = cbJsonFolderUrl.appendingPathComponent($0)

            guard FileManager.default.fileExists(atPath: oldCbJsonFileUrl.path) else {
                return
            }

            if !FileManager.default.fileExists(atPath: newCbJsonFileUrl.path) {
                try? FileManager.default.moveItem(at: oldCbJsonFileUrl, to: newCbJsonFileUrl)
            }
        }
    }
}
