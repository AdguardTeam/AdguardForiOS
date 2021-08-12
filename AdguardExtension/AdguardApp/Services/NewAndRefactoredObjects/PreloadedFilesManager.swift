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
import SafariAdGuardSDK

// TODO: - Write tests

protocol PreloadedFilesManagerProtocol {
    /// Moves zip files from Bundle to the shared directory
    func processPreloadedFiles() throws
}

/**
 This object is responsible for managing preloaded files
 
 We have `Builder` project. The aim of this project is to load the newest filters and
 put filters data to DB and files. You can look up `Builder` -> `main.swift` for more information
 
 `Builder` puts all files produced to the App Bundle.
 App Bundle is readonly, so we can't even unarchive files in this directory
 This object will replace saved archives with new ones
 */
struct PreloadedFilesManager: PreloadedFilesManagerProtocol {
    
    private let bundle = Bundle.main
    private let sharedStorageUrls: SharedStorageUrls
    
    /// `URL` where to save preloaded files
    init(sharedStorageUrls: SharedStorageUrls = SharedStorageUrls()) {
        self.sharedStorageUrls = sharedStorageUrls
    }
    
    func processPreloadedFiles() throws {
        guard let dbZipUrlInBundle = Bundle.main.url(forResource: Constants.Files.defaultDbFileName, withExtension: "zip"),
              let filtersZipUrlInBundle = Bundle.main.url(forResource: "filters", withExtension: "zip")
        else {
            throw CommonError.missingFile(filename: Constants.Files.defaultDbZipFileName)
        }
        
        let dbFolderUrl = sharedStorageUrls.dbFolderUrl
        let filtersFolderUrl = sharedStorageUrls.filtersFolderUrl
        let fm = FileManager.default
        
        // Create directories if don't exist
        try fm.createDirectory(at: dbFolderUrl, withIntermediateDirectories: true, attributes: [:])
        try fm.createDirectory(at: filtersFolderUrl, withIntermediateDirectories: true, attributes: [:])
        
        // Copy Zip files from Bundle to shared URL
        let dbZipUrl = dbFolderUrl.appendingPathComponent(Constants.Files.defaultDbZipFileName)
        let filtersZipUrl = filtersFolderUrl.appendingPathComponent(Constants.Files.filtersZipFileName)
        try fm.copyOrReplace(at: dbZipUrlInBundle, to: dbZipUrl)
        try fm.copyOrReplace(at: filtersZipUrlInBundle, to: filtersZipUrl)
    }
}
