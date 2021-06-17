import Foundation

protocol ContentBlockerJsonProviderProtocol {
    func getJsonUrl(for cbType: ContentBlockerType) throws -> URL
}

final class ContentBlockerJsonProvider: ContentBlockerJsonProviderProtocol {
    
    private let jsonStorage: ContentBlockersInfoStorage
    private let configuration: ConfigurationProtocol
    
    init(jsonStorage: ContentBlockersInfoStorage, configuration: ConfigurationProtocol) {
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
