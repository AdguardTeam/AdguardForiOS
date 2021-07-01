import Foundation

protocol ContentBlockerJsonProviderProtocol {
    /**
     Returns URL of JSON file for specified Content Blocker
     - Parameter cbType: Type of content blocker for which the URL should be returned
     - throws: Can throw an error if error occured while getting JSON file
     */
    func getJsonUrl(for cbType: ContentBlockerType) throws -> URL
}

/**
 This class should be used in Content Blocker's extensions to get appropriate JSON
 */
final class ContentBlockerJsonProvider: ContentBlockerJsonProviderProtocol {
    
    private let jsonStorage: ContentBlockersInfoStorageProtocol
    private let configuration: ConfigurationProtocol
    
    init(jsonStorage: ContentBlockersInfoStorageProtocol, configuration: ConfigurationProtocol) {
        self.jsonStorage = jsonStorage
        self.configuration = configuration
    }
    
    func getJsonUrl(for cbType: ContentBlockerType) throws -> URL {
        let emptyJsonUrl = try jsonStorage.getEmptyRuleJsonUrl()
        
        guard configuration.safariProtectionEnabled else {
            Logger.logInfo("(ContentBlockerJsonProvider) - getJsonUrl; ")
            return emptyJsonUrl
        }
        
        let cbInfo = jsonStorage.getInfo(for: cbType)
        return cbInfo?.jsonUrl ?? emptyJsonUrl
    }
}
