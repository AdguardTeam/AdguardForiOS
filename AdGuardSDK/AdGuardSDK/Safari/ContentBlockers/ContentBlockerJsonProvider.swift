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

    public var jsonUrl: URL? { jsonStorage.urlForJson(withType: type) }

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
