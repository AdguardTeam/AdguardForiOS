import Foundation

public protocol ContentBlockerJsonProviderProtocol {
    /**
     Returns URL of JSON file
     - Parameter safariProtectionIsEnabled: Current state of Safari protection
     - throws: Can throw an error if error occured while getting JSON file
     */
    func getJsonUrl(_ safariProtectionIsEnabled: Bool) throws -> URL
}


/// This class should be used in Content Blocker's extensions to get appropriate JSON
public final class ContentBlockerJsonProvider: ContentBlockerJsonProviderProtocol {
    
    private let userDefaults: UserDefaultsStorageProtocol
    private let jsonStorageUrl: URL
    private let type: ContentBlockerType
    
    public init(cbBundleId: String, mainAppBundleId: String, jsonStorageUrl: URL, userDefaults: UserDefaults) {
        self.userDefaults = UserDefaultsStorage(storage: userDefaults)
        self.jsonStorageUrl = jsonStorageUrl
        self.type = Self.typeForBundleId(cbBundleId, mainAppBundleId: mainAppBundleId)
    }
    
    public func getJsonUrl(_ safariProtectionIsEnabled: Bool) throws -> URL {
        let jsonStorage = try ContentBlockersInfoStorage(jsonStorageUrl: jsonStorageUrl, userDefaultsStorage: userDefaults)
        let emptyJsonUrl = try jsonStorage.getEmptyRuleJsonUrl()
        
        guard safariProtectionIsEnabled else {
            Logger.logInfo("(ContentBlockerJsonProvider) - getJsonUrl; Safari protection is disabled")
            return emptyJsonUrl
        }
        
        let cbInfo = jsonStorage.getInfo(for: type)
        return cbInfo?.jsonUrl ?? emptyJsonUrl
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
