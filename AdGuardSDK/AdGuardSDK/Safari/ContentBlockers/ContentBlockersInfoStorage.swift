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
import SharedAdGuardSDK
import ContentBlockerConverter

// MARK: - ContentBlockerType

public enum ContentBlockerType: Int, CaseIterable, Codable {
    case general
    case privacy
    case socialWidgetsAndAnnoyances
    case other
    case custom
    case security

    var affinity: Affinity {
        switch self {
        case .general: return .general
        case .privacy: return .privacy
        case .socialWidgetsAndAnnoyances: return .socialWidgetsAndAnnoyances
        case .other: return .other
        case .custom: return .custom
        case .security: return .security
        }
    }
}

// MARK: - ConverterResult

/**
 This struct is used to represent the convertation result of Converter lib.
 It is practically the same as **FiltersConverterResult** but instead of storing JSON file string it stores JSON file URL.
 It is more convenient to use URLs because Content Blockers are waiting JSON URL with converted rules.
 */
public struct ConverterResult: Codable, Equatable {
    public let result: FiltersConverterResult // Converter result obtained from ConverterLib
    public let jsonUrl: URL // URL where JSON with converted rules is stored

    init(result: FiltersConverterResult, jsonUrl: URL) {
        self.result = result
        self.jsonUrl = jsonUrl
    }
}

// MARK: - ContentBlockersInfoStorage

protocol ContentBlockersInfoStorageProtocol: ResetableSyncProtocol {
    /* Number of advanced rules that will be passed to Safari Web Extension */
    var advancedRulesCount: Int { get }

    /* We save advanced rules to the file and pass them to Safari Web Extension */
    var advancedRulesFileUrl: URL { get }

    /* Returns all content blocker conversion results and JSONs urls */
    var allConverterResults: [ConverterResult] { get }

    /* Saves filters convertion info and JSON files to storage */
    func save(converterResults: [FiltersConverterResult]) throws

    /* Loads filters convertion result and JSON file url for specified content blocker type */
    func getConverterResult(for cbType: ContentBlockerType) -> ConverterResult?
}

/* This class is responsible for managing JSON files for every content blocker */
final class ContentBlockersInfoStorage: ContentBlockersInfoStorageProtocol {

    // MARK: - Public properties

    var advancedRulesCount: Int { userDefaultsStorage.advancedRulesCount }

    var advancedRulesFileUrl: URL { jsonStorageUrl.appendingPathComponent(Constants.Files.advancedRulesFileName) }

    var allConverterResults: [ConverterResult] { userDefaultsStorage.allCbInfo }

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

    func save(converterResults: [FiltersConverterResult]) throws {
        guard converterResults.count == ContentBlockerType.allCases.count else {
            throw CommonError.error(message: "Received \(converterResults.count) results, but expecting \(ContentBlockerType.allCases.count)")
        }

        Logger.logInfo("(ContentBlockersJSONStorage) - save cbJsons; Trying to save \(converterResults.count) jsons")

        let result: [ConverterResult] = try converterResults.map {
            let urlToSave = urlForJson(withType: $0.type)
            try $0.jsonString.write(to: urlToSave, atomically: true, encoding: .utf8)
            return ConverterResult(result: $0, jsonUrl: urlToSave)
        }
        userDefaultsStorage.allCbInfo = result
        try saveAdvancedRules(from: converterResults)
    }

    func getConverterResult(for cbType: ContentBlockerType) -> ConverterResult? {
        Logger.logInfo("(ContentBlockersJSONStorage) - getConverterResult; Result request for \(cbType)")
        let allResults = userDefaultsStorage.allCbInfo
        return allResults.first(where: { $0.result.type == cbType })
    }

    func reset() throws {
        Logger.logInfo("(ContentBlockersJSONStorage) - reset start")

        // Remove all converted JSON fils
        try fileManager.removeItem(at: jsonStorageUrl)

        // Create directory
        try fileManager.createDirectory(at: jsonStorageUrl, withIntermediateDirectories: true, attributes: nil)

        // Clear user defaults
        userDefaultsStorage.allCbInfo = []

        Logger.logInfo("(ContentBlockersJSONStorage) - reset; Successfully deleted directory with CBs JSONs")
    }

    // MARK: - Private methods

    private func urlForJson(withType cbType: ContentBlockerType) -> URL {
        return jsonStorageUrl.appendingPathComponent(cbType.fileName)
    }

    private func saveAdvancedRules(from results: [FiltersConverterResult]) throws {
        // Advanced rules from every Content Blocker in one string
        let bigRule = results.reduce("", { $0 + "\n" + ($1.advancedBlockingText ?? "") })

        // Unique rules from all rules
        let rules = Set(bigRule.split(separator: "\n"))

        // String from unique rules
        let uniqueRulesText = rules.joined(separator: "\n")

        try uniqueRulesText.write(to: advancedRulesFileUrl, atomically: true, encoding: .utf8)
        userDefaultsStorage.advancedRulesCount = rules.count
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
    private var advancedRulesCountKey: String { "AdGuardSDK.advancedRulesCountKey" }

    var allCbInfo: [ConverterResult] {
        get {
            if let savedCbData = storage.data(forKey: allCbInfoKey) {
                let decoder = JSONDecoder()
                let cbInfo = try? decoder.decode([ConverterResult].self, from: savedCbData)
                return cbInfo ?? []
            }
            return []
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

    var advancedRulesCount: Int {
        get {
            return storage.integer(forKey: advancedRulesCountKey)
        }
        set {
            storage.set(newValue, forKey: advancedRulesCountKey)
        }
    }
}
