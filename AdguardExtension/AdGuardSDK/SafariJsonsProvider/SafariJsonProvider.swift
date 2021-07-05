import Foundation

/**
 this is public class that can be used in Content Blocker's extensions to get appropriate JSON
 */
public protocol SafariJsonProviderProtocol {
    
    // returns url for json file
    func jsonUrl()->URL?
}

public class SafariJsonProvider: SafariJsonProviderProtocol {
    
    private let type: ContentBlockerType
    private let storageUrl: URL
    private let userDefaults: UserDefaults
    private let configuration: SafariConfigurationProtocol
    
    // - bundleId extension bundle identifier
    public init(bundleId: String, mainAppBundleId: String, jsonStorageUrl: URL, userDefaults: UserDefaults, configuration: SafariConfigurationProtocol) {
        self.type = ContentBlockerType.typeForBundleId(bundleId, mainAppBundleId: mainAppBundleId)
        self.storageUrl = jsonStorageUrl
        self.userDefaults = userDefaults
        self.configuration = configuration
    }
    
    public func jsonUrl()->URL? {
        let defaultsStorage = UserDefaultsStorage(storage: userDefaults)
        guard let storage =  try? ContentBlockersInfoStorage(jsonStorageUrl: storageUrl, userDefaultsStorage: defaultsStorage) else {
            Logger.logError("SafariJsonProvider can not instantiate ContentBlockersInfoStorage. storageUrl = \(storageUrl)")
            return nil
        }
        
        let provider = ContentBlockerJsonProvider(jsonStorage: storage, configuration:configuration)
        
        if let url = try? provider.getJsonUrl(for: type) {
            return url
        }
        else {
            Logger.logError("SafariJsonProvider can not get json url for content blocker: \(type)")
            return nil
        }
    }
}
