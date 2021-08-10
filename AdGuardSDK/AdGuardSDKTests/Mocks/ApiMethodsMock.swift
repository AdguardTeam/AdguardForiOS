import Foundation

class SafariProtectionApiMethodsMock: SafariProtectionApiMethodsProtocol {
    
    var loadFiltersMetadataCalledCount = 0
    var loadFiltersMetadataResult: ExtendedFiltersMeta?
    func loadFiltersMetadata(version: String, id: String, cid: String, lang: String, _ completion: @escaping (ExtendedFiltersMeta?) -> Void) {
        loadFiltersMetadataCalledCount += 1
        completion(loadFiltersMetadataResult)
    }
    
    var loadFiltersLocalizationsCalledCount = 0
    var loadFiltersLocalizationsResult: ExtendedFiltersMetaLocalizations?
    func loadFiltersLocalizations(_ completion: @escaping (ExtendedFiltersMetaLocalizations?) -> Void) {
        loadFiltersLocalizationsCalledCount += 1
        completion(loadFiltersLocalizationsResult)
    }
}
