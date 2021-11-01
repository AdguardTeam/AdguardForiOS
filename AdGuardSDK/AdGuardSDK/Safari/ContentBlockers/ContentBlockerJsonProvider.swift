///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import SharedAdGuardSDK

public protocol ContentBlockerJsonProviderProtocol {
    /**
     Returns URL of JSON file
     - Parameter safariProtectionIsEnabled: Current state of Safari protection
     - throws: Can throw an error if error occured while getting JSON file
     */
    var jsonUrl: URL? { get }
}


/// This class should be used in Content Blocker's extensions to get appropriate JSON
public final class ContentBlockerJsonProvider: ContentBlockerJsonProviderProtocol {

    public var jsonUrl: URL? { jsonStorage.getConverterResult(for: type)?.jsonUrl }

    private let jsonStorage: ContentBlockersInfoStorageProtocol
    private let type: ContentBlockerType

    public init(cbBundleId: String, mainAppBundleId: String, jsonStorageUrl: URL, userDefaults: UserDefaults) throws {
        let userDefaultsStorage = UserDefaultsStorage(storage: userDefaults)
        self.jsonStorage = try ContentBlockersInfoStorage(jsonStorageUrl: jsonStorageUrl, userDefaultsStorage: userDefaultsStorage)
        self.type = Self.typeForBundleId(cbBundleId, mainAppBundleId: mainAppBundleId)
    }

    /// Initializer for tests
    init(jsonStorage: ContentBlockersInfoStorageProtocol, type: ContentBlockerType) {
        self.jsonStorage = jsonStorage
        self.type = type
    }

    private static func typeForBundleId(_ cbBundleId: String, mainAppBundleId: String)->ContentBlockerType {
        for type in ContentBlockerType.allCases {
            if type.contentBlockerBundleId(mainAppBundleId) == cbBundleId {
                return type
            }
        }
        return .general
    }
}
