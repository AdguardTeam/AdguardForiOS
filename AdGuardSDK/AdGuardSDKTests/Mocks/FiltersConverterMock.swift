import Foundation

final class FiltersConverterMock: FiltersConverterProtocol {

    var resultFilters: [FiltersConverterResult] = []
    var convertCalledCount = 0
    var passedFilters: [FilterFileContent]?
    var passedBlocklistRules: [String]?
    var passedAllowlistRules: [String]?
    var passedInvertedAllowlistRules: [String]?
    func convert(filters: [FilterFileContent], blocklistRules: [String]?, allowlistRules: [String]?, invertedAllowlistRules: [String]?) -> [FiltersConverterResult] {
        convertCalledCount += 1
        passedFilters = filters
        passedBlocklistRules = blocklistRules
        passedAllowlistRules = allowlistRules
        passedInvertedAllowlistRules = invertedAllowlistRules
        return resultFilters
    }
}
