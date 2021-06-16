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

protocol ContentBlockersInfoStorageProtocol {
    /* Returns all content blocker conversion results and JSONs urls */
    var allCbInfo: [ContentBlockerType: ContentBlockersInfoStorage.ConverterResult] { get }

    /* Saves filters convertion info and JSON file to storage */
    func save(cbInfo: SafariFilter) throws

    /* Saves filters convertion info and JSON files to storage */
    func save(cbInfos: [SafariFilter]) throws

    /* Loads filters convertion result and JSON file url for specified content blocker type */
    func getInfo(for cbType: ContentBlockerType) -> ContentBlockersInfoStorage.ConverterResult?
}

/* This class is responsible for managing JSON files for every content blocker */
final class ContentBlockersInfoStorage: ContentBlockersInfoStorageProtocol {
        
    // MARK: - ConverterResult
    
    struct ConverterResult: Codable, Equatable {
        let contentBlockerType: ContentBlockerType
        let totalRules: Int
        let totalConverted: Int
        let overlimit: Bool
        let jsonUrl: URL
    }
    
    // MARK: - Public properties
    
    var allCbInfo: [ContentBlockerType: ConverterResult] { userDefaultsStorage.allCbInfo }
    
    // MARK: - Private properties
    
    private let fileManager = FileManager.default
    
    // URL of directory where jsons for each content blocker will be stored
    private let jsonStorageUrl: URL
    private let userDefaultsStorage: UserDefaultsStorageProtocol
    
    // MARK: - Initialization
    
    init(jsonStorageUrl: URL, userDefaultsStorage: UserDefaultsStorageProtocol) throws {
        // We are trying to create directory if passed URL is not a valid directory
        if !jsonStorageUrl.isDirectory {
            try fileManager.createDirectory(at: jsonStorageUrl, withIntermediateDirectories: true, attributes: nil)
        }
        self.jsonStorageUrl = jsonStorageUrl
        self.userDefaultsStorage = userDefaultsStorage
    }
    
    // MARK: - Internal methods
    
    func save(cbInfo: SafariFilter) throws {
        let urlToSave = urlForJson(withType: cbInfo.type)
        try cbInfo.jsonString.write(to: urlToSave, atomically: true, encoding: .utf8)
        
        // Save filters convertion result
        let converterResult = ConverterResult(contentBlockerType: cbInfo.type,
                                              totalRules: cbInfo.totalRules,
                                              totalConverted: cbInfo.totalConverted,
                                              overlimit: cbInfo.overlimit,
                                              jsonUrl: urlToSave)
        userDefaultsStorage.allCbInfo[cbInfo.type] = converterResult
        userDefaultsStorage.allCbInfo = allCbInfo
    }
    
    func save(cbInfos: [SafariFilter]) throws {
        Logger.logInfo("(ContentBlockersJSONStorage) - save cbJsons; Trying to save \(cbInfos.count) jsons")
        try cbInfos.forEach { try save(cbInfo: $0) }
    }
    
    func getInfo(for cbType: ContentBlockerType) -> ConverterResult? {
        return userDefaultsStorage.allCbInfo[cbType]
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

// MARK: - UserDefaultsStorageProtocol + allCbInfo

fileprivate extension UserDefaultsStorageProtocol {
    
    private var allCbInfoKey: String { "AdGuardSDK.allCbInfoKey" }
    
    var allCbInfo: [ContentBlockerType: ContentBlockersInfoStorage.ConverterResult] {
        get {
            if let savedCbData = storage.data(forKey: allCbInfoKey) {
                let decoder = JSONDecoder()
                let cbInfo = try? decoder.decode([ContentBlockerType: ContentBlockersInfoStorage.ConverterResult].self, from: savedCbData)
                return cbInfo ?? [:]
            }
            return [:]
        }
        set {
            let encoder = JSONEncoder()
            if let cbInfoData = try? encoder.encode(newValue) {
                storage.set(cbInfoData, forKey: allCbInfoKey)
            } else {
                storage.set(Date(), forKey: allCbInfoKey)
            }
        }
    }
}
