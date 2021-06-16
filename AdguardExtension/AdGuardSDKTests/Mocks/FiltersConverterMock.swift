import Foundation

final class FiltersConverterMock: FiltersConverterProtocol {
    
    var resultFilters: [SafariFilter]?

    var passedFilters: [FilterFileContent]?
    var passedBlocklistRules: [String]?
    var passedAllowlistRules: [String]?
    var passedInvertedAllowlistRulesString: String?
    
    func convert(filters: [FilterFileContent], blocklistRules: [String]?, allowlistRules: [String]?, invertedAllowlistRulesString: String?) -> [SafariFilter]? {
        passedFilters = filters
        passedBlocklistRules = blocklistRules
        passedAllowlistRules = allowlistRules
        passedInvertedAllowlistRulesString = invertedAllowlistRulesString
        return resultFilters
    }
}
