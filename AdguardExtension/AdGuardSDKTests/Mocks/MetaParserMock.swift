import Foundation

final class MetaParserMock: CustomFilterMetaParserProtocol {
    var parseCalled = false
    var parseResult: Result<ExtendedCustomFilterMetaProtocol> = .error(CommonError.missingData)
    
    func parse(_ filterFileContentString: String, for parserType: CustomFilterMetaParserType) throws -> ExtendedCustomFilterMetaProtocol {
        parseCalled = true
        switch parseResult {
        case .success(let result): return result
        case .error(let error): throw error
        }
    }
}
