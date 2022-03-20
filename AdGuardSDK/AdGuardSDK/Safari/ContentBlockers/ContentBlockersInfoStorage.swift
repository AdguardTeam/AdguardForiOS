//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import SharedAdGuardSDK
import ContentBlockerConverter

// MARK: - ContentBlockerType

public enum ContentBlockerType: Int, CaseIterable, Codable {
    case general
    case privacy
    case custom
    case socialWidgetsAndAnnoyances
    case other
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
    public let type: ContentBlockerType // Content blocker type the result is related with
    public let totalRules: Int // Total valis rules number, because some rules that we pass can be invalid
    public let totalConverted: Int // The result number of rules with Content blockers limit of 'contentBlockerRulesLimit' rules
    public let overlimit: Bool // Is true if totalRules is greater than 'contentBlockerRulesLimit' rules
    public let errorsCount: Int // Number of errors handled
    public let advancedBlockingConvertedCount: Int // Number of entries in advanced blocking part
    public let message: String // Result message

    init(result: FiltersConverterResult) {
        self.type = result.type
        self.totalRules = result.totalRules
        self.totalConverted = result.totalConverted
        self.overlimit = result.overlimit
        self.errorsCount = result.errorsCount
        self.advancedBlockingConvertedCount = result.advancedBlockingConvertedCount
        self.message = result.message
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

    /// returns url to content blocker json for specified content blocker type
    func getJsonUrl(for cbType: ContentBlockerType) -> URL
}

private let LOG = LoggerFactory.getLoggerWrapper(ContentBlockersInfoStorage.self)

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

        LOG.info("Trying to save \(converterResults.count) jsons")

        let result: [ConverterResult] = try converterResults.map {
            let urlToSave = getJsonUrl(for: $0.type)
            try $0.jsonString.write(to: urlToSave, atomically: true, encoding: .utf8)
            return ConverterResult(result: $0)
        }
        userDefaultsStorage.allCbInfo = result
        try saveAdvancedRules(from: converterResults)
    }

    func getConverterResult(for cbType: ContentBlockerType) -> ConverterResult? {
        LOG.info("Result request for \(cbType)")
        let allResults = userDefaultsStorage.allCbInfo
        return allResults.first(where: { $0.type == cbType })
    }

    func reset() throws {
        LOG.info("Reset start")

        // Remove all converted JSON fils
        try fileManager.removeItem(at: jsonStorageUrl)

        // Create directory
        try fileManager.createDirectory(at: jsonStorageUrl, withIntermediateDirectories: true, attributes: nil)

        // Clear user defaults
        userDefaultsStorage.allCbInfo = []

        LOG.info("Successfully deleted directory with CBs JSONs")
    }

    func getJsonUrl(for cbType: ContentBlockerType) -> URL {
        return jsonStorageUrl.appendingPathComponent(cbType.fileName)
    }

    // MARK: - Private methods

    private func saveAdvancedRules(from results: [FiltersConverterResult]) throws {
        LOG.info("saveAdvancedRules; start")

        // Remove duplicates from the rules.
        // Note that we persist the rules order (it is very important for interpreting them in the Web Extension).
        var uniqueRules: Set<String> = []
        var rules: [String] = []
        for result in results {
            let content = (result.advancedBlockingText ?? "") as NSString
            content.enumerateLines { line, _ in
                if !uniqueRules.contains(line) {
                    rules.append(line)
                    uniqueRules.insert(line)
                }
            }
        }

        // String from unique rules
        let uniqueRulesText = rules.joined(separator: "\n")

        try uniqueRulesText.write(to: advancedRulesFileUrl, atomically: true, encoding: .utf8)
        userDefaultsStorage.advancedRulesCount = rules.count
        LOG.info("Finished saving \(rules.count) rules")
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
                storage.set(Data(), forKey: allCbInfoKey)
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
