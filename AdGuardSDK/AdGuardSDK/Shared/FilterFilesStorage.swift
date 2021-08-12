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

protocol CustomFilterFilesStorageProtocol: ResetableSyncProtocol {
    /**
     Updates custom filter file with specified **id** and **subscriptionUrl**
     Filter will be created if it doesn't exist
     - Parameter id: Custom filter unique id
     - Parameter subscriptionUrl: Remote URL where filter is stored; Filter is downloaded by this URL
     - Parameter onFilterUpdated: Error handling closure
     */
    func updateCustomFilter(withId id: Int, subscriptionUrl: URL, onFilterUpdated: @escaping (Error?) -> Void)
    
    /**
     Delete  filter file with specified **id**
     - Parameter id: Filter unique id where
     - Throws: Some Foundation methods can throw while removing file
     */
    func deleteFilter(withId id: Int) throws
    
    /**
     Returns filter file content by **filter id**
     - Parameter id: Filter unique id
     - Returns: Filter file content if filter file exists, nil otherwise
     */
    func getFilterContentForFilter(withId id: Int) -> String?
    
    /**
     Returns filter file URL by **filter id**
     - Parameter id: Filter unique id
     - Returns: Filter file URL
     */
    func getUrlForFilter(withId id: Int) -> URL
}

protocol FilterFilesStorageProtocol: CustomFilterFilesStorageProtocol {
    /**
     Updates filter file with specified **id**
     - Parameter id: Filter unique id
     - Parameter onFilterUpdated: Error handling closure
     */
    func updateFilter(withId id: Int, onFilterUpdated: @escaping (Error?) -> Void)
    
    /**
     Returns filter files content by filters id-s
     - Parameter identifiers: Array of filter id-s whose content should be returned
     - Returns: A dictionary of existing filters files content by filter id-s
     */
    func getFiltersContentForFilters(withIds identifiers: [Int]) -> [Int: String]
    
    /**
     Saves **content** of filter to the file of filter with specified **id**
     - Parameter id: Filter unique id where **filterContent** should be saved
     - Parameter filterContent: String representation of filter file
     - Throws: Some Foundation methods can throw while writing string to file
     */
    func saveFilter(withId id: Int, filterContent: String) throws
    
    /**
     Unzips `filters.zip` archive and saves all filters from it.
     - Throws an error if there are any other files except `filters.zip`
     */
    func unzipPredefinedFiltersIfNeeded() throws
}

/* This class manages filters text files */
final class FilterFilesStorage: FilterFilesStorageProtocol {
    
    // MARK: - Private properties
    
    private let fileManager = FileManager.default
    
    // Concurrent queue for downloading filter files
    private let filtersDownloadQueue = DispatchQueue(label: "AdguardSDK.FilterFilesStorage.filtersDownloadQueue", qos: .background, attributes: .concurrent)
    
    // URL of directory where all filters are stored
    private let filterFilesDirectoryUrl: URL
    
    // MARK: - Initialization
    
    init(filterFilesDirectoryUrl: URL) throws {
        // We are trying to create directory if passed URL is not a valid directory
        if !filterFilesDirectoryUrl.isDirectory {
            try fileManager.createDirectory(at: filterFilesDirectoryUrl, withIntermediateDirectories: true, attributes: nil)
        }
        self.filterFilesDirectoryUrl = filterFilesDirectoryUrl
    }
    
    // MARK: - Public methods
    
    func updateFilter(withId id: Int, onFilterUpdated: @escaping (Error?) -> Void) {
        let filterFileUrl = urlForFilter(withId: id)
        downloadFilter(withUrl: filterFileUrl, filterId: id, onFilterDownloaded: onFilterUpdated)
    }
    
    func updateCustomFilter(withId id: Int, subscriptionUrl: URL, onFilterUpdated: @escaping (Error?) -> Void) {
        downloadFilter(withUrl: subscriptionUrl, filterId: id, onFilterDownloaded: onFilterUpdated)
    }
    
    func getFilterContentForFilter(withId id: Int) -> String? {
        let fileUrl = fileUrlForFilter(withId: id)
        
        guard let content = try? String.init(contentsOf: fileUrl, encoding: .utf8) else {
            Logger.logError("FiltersStorage getFilterContentForFilter error. Can not read filter with url: \(fileUrl)")
            
            // try to get presaved filter file
            if  let presavedFilterFileUrl = defaultFilteUrlForFilter(withId: id),
                let content = try? String.init(contentsOf: presavedFilterFileUrl, encoding: .utf8) {
                Logger.logInfo("FiltersStorage return default filter for filter with id=\(id)")
                return content
            }
            return nil
        }
        return content
    }
    
    func getFiltersContentForFilters(withIds identifiers: [Int]) -> [Int : String] {
        var result: [Int: String] = [:]
        
        for id in identifiers {
            if let content = getFilterContentForFilter(withId: id) {
                result[id] = content
            }
        }
        return result
    }
    
    func saveFilter(withId id: Int, filterContent: String) throws {
        let filterFileUrl = fileUrlForFilter(withId: id)
        try filterContent.write(to: filterFileUrl, atomically: true, encoding: .utf8)
    }
    
    func deleteFilter(withId id: Int) throws {
        let filterFileUrl = fileUrlForFilter(withId: id)
        try fileManager.removeItem(at: filterFileUrl)
    }
    
    func getUrlForFilter(withId id: Int) -> URL {
        return fileUrlForFilter(withId: id)
    }
    
    func reset() throws {
        Logger.logInfo("(FilterFilesStorage) - reset start")
        
        // Delete all custom filters files
        let filtersUrls = try fileManager.contentsOfDirectory(at: filterFilesDirectoryUrl, includingPropertiesForKeys: nil, options: [])
        try filtersUrls.forEach { filterUrl in
            let filterFileExtension = filterUrl.pathExtension
            let filterName = filterUrl.deletingPathExtension().lastPathComponent
            let filterVersion = Int(filterName) ?? 0
            if filterFileExtension == "txt" && filterVersion >= CustomFilterMeta.baseCustomFilterId {
                try fileManager.removeItem(at: filterUrl)
            }
        }
        
        // Restore predefined filters after reset
        try unzipPredefinedFiltersIfNeeded()
        
        Logger.logInfo("(FilterFilesStorage) - reset; Successfully deleted directory with filters")
    }
    
    // TODO: - Write tests
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
    
    // MARK: - Private methods
    
    private func downloadFilter(withUrl url: URL, filterId: Int, onFilterDownloaded: @escaping (Error?) -> Void) {
        let filterFileUrl = fileUrlForFilter(withId: filterId)
        
        filtersDownloadQueue.async {
            do {
                let content = try String(contentsOf: url)
                try content.write(to: filterFileUrl, atomically: true, encoding: .utf8)
                onFilterDownloaded(nil)
            }
            catch {
                Logger.logError("FiltersStorage downloadFilter - download error: \(error)")
                onFilterDownloaded(error)
            }
        }
    }
    
    private func urlForFilter(withId id: Int) -> URL {
        let url = "https://filters.adtidy.org/ios/filters/\(id)_optimized.txt"
        return URL(string: url)!
    }
    
    private func fileUrlForFilter(withId id: Int) -> URL {
        return filterFilesDirectoryUrl.appendingPathComponent("\(id).txt")
    }
    
    private func defaultFilteUrlForFilter(withId id: Int) -> URL? {
        return Bundle.main.url(forResource: "\(id)", withExtension: "txt")
    }
}
