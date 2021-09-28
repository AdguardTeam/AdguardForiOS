import Foundation

final class ContentBlockersInfoStorageMock: ContentBlockersInfoStorageProtocol {

    var advancedRulesFileUrl: URL = URL(string: "/User/folder/file.txt")!

    var advancedRulesCount: Int = 0

    var invokedAllConverterResultsGetterCount = 0
    var stubbedAllConverterResults: [ConverterResult] = []
    var allConverterResults: [ConverterResult] {
        invokedAllConverterResultsGetterCount += 1
        return stubbedAllConverterResults
    }

    var invokedSaveCount = 0
    var invokedSaveParameter = [FiltersConverterResult]()
    var stubbedSaveError: Error?
    func save(converterResults: [FiltersConverterResult]) throws {
        invokedSaveCount += 1
        invokedSaveParameter = converterResults
        if let error = stubbedSaveError {
            throw error
        }
    }

    var invokedGetConverterResultCount = 0
    var invokedGetConverterResultParameter: ContentBlockerType?
    var stubbedGetConverterResultResult: ConverterResult!
    func getConverterResult(for cbType: ContentBlockerType) -> ConverterResult? {
        invokedGetConverterResultCount += 1
        invokedGetConverterResultParameter = cbType
        return stubbedGetConverterResultResult
    }

    var invokedResetCount = 0
    var stubbedResetError: Error?
    func reset() throws {
        invokedResetCount += 1
        if let error = stubbedResetError {
            throw error
        }
    }
}
