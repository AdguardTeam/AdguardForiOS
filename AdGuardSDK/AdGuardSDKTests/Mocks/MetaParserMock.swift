import Foundation

final class MetaParserMock: CustomFilterMetaParserProtocol {
    var parseCalled = false
    var parseCalledCount = 0
    var parseResult: Result<ExtendedCustomFilterMetaProtocol> = .error(CommonError.missingData)

    func parse(_ filterFileContentString: String, for parserType: CustomFilterMetaParserType) throws -> ExtendedCustomFilterMetaProtocol {
        parseCalled = true
        parseCalledCount += 1
        switch parseResult {
        case .success(let result): return result
        case .error(let error): throw error
        }
    }

    var parseWithFilterDownloadPageCalledCount = 0
    var parseWithFilterDownloadPageResult: Result<ExtendedCustomFilterMetaProtocol> = .error(CommonError.missingData)
    func parse(_ filterFileContentString: String, for parserType: CustomFilterMetaParserType, filterDownloadPage: String?) throws -> ExtendedCustomFilterMetaProtocol {
        parseWithFilterDownloadPageCalledCount += 1
        switch parseWithFilterDownloadPageResult {
        case .success(let result): return result
        case .error(let error): throw error
        }
    }
}
