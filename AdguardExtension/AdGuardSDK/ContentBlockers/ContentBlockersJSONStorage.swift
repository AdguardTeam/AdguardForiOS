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

protocol ContentBlockersJSONStorageProtocol {
    /* Returns all content blocker JSONs that was able to get from storage */
    var allJsons: [ContentBlockersJSONStorage.ContentBlockerJSON] { get }
    
    /* Saves JSON file to storage */
    func save(json: ContentBlockersJSONStorage.ContentBlockerJSON) throws
    
    /* Saves JSON files to storage */
    func save(cbJsons: [ContentBlockersJSONStorage.ContentBlockerJSON]) throws
    
    /* Loads JSON file from storage for specified content blocker type */
    func getJson(for cbType: ContentBlockerType) throws -> ContentBlockersJSONStorage.ContentBlockerJSON
}

/* This class is responsible for managing JSON files for every content blocker */
final class ContentBlockersJSONStorage: ContentBlockersJSONStorageProtocol {
    
    // MARK: - ContentBlockerJSON
    
    struct ContentBlockerJSON {
        let json: String
        let contentBlocker: ContentBlockerType
    }
    
    // MARK: - Public properties
    
    var allJsons: [ContentBlockerJSON] { ContentBlockerType.allCases.compactMap { try? getJson(for: $0) } }
    
    // MARK: - Private properties
    
    private let fileManager = FileManager.default
    
    // URL of directory where jsons for each content blocker will be stored
    private let jsonStorageUrl: URL
    
    // MARK: - Initialization
    
    init(jsonStorageUrl: URL) throws {
        // We are trying to create directory if passed URL is not a valid directory
        if !jsonStorageUrl.isDirectory {
            try fileManager.createDirectory(at: jsonStorageUrl, withIntermediateDirectories: true, attributes: nil)
        }
        self.jsonStorageUrl = jsonStorageUrl
    }
    
    // MARK: - Internal methods
    
    func save(json: ContentBlockerJSON) throws {
        let urlToSave = urlForJson(withType: json.contentBlocker)
        try json.json.write(to: urlToSave, atomically: true, encoding: .utf8)
    }
    
    func save(cbJsons: [ContentBlockerJSON]) throws {
        Logger.logInfo("(ContentBlockersJSONStorage) - save cbJsons; Trying to save \(cbJsons.count) jsons")
        try cbJsons.forEach { try save(json: $0) }
    }
    
    func getJson(for cbType: ContentBlockerType) throws -> ContentBlockerJSON {
        let jsonUrl = urlForJson(withType: cbType)
        let jsonString = try String.init(contentsOf: jsonUrl, encoding: .utf8)
        return ContentBlockerJSON(json: jsonString, contentBlocker: cbType)
    }
    
    // MARK: - Private methods
    
    private func urlForJson(withType cbType: ContentBlockerType) -> URL {
        return jsonStorageUrl.appendingPathComponent(cbType.fileName)
    }
}

// MARK: - ContentBlockerType + fileName

fileprivate extension ContentBlockerType {
    var fileName: String {
        switch self {
        case .general: return "cb_general.json"
        case .privacy: return "cb_privacy.json"
        case .socialWidgetsAndAnnoyances: return "cb_annoyances.json"
        case .other: return "cb_other.json"
        case .custom: return "cb_custom.json"
        case .security: return "cb_security.json"
        }
    }
}
