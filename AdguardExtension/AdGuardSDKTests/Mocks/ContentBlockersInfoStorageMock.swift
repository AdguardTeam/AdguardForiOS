import Foundation

final class ContentBlockersInfoStorageMock: ContentBlockersInfoStorageProtocol {
    
    var allCbInfo: [ContentBlockerType : ConverterResult] = [:]
    
    var saveCbInfoCalledCount = 0
    var saveCbInfoError: Error?
    func save(cbInfo: FiltersConverter.Result) throws {
        saveCbInfoCalledCount += 1
        if let error = saveCbInfoError {
            throw error
        }
    }
    
    var saveCbInfosCalledCount = 0
    var saveCbInfosError: Error?
    func save(cbInfos: [FiltersConverter.Result]) throws {
        saveCbInfosCalledCount += 1
        if let error = saveCbInfosError {
            throw error
        }
    }
    
    var getInfoCalledCount = 0
    var getInfoResult: ConverterResult?
    func getInfo(for cbType: ContentBlockerType) -> ConverterResult? {
        getInfoCalledCount += 1
        return getInfoResult
    }
    
    var getEmptyRuleJsonUrlCalledCount = 0
    var getEmptyRuleJsonUrlResult: Result<URL> = .error(NSError(domain: "test", code: 1, userInfo: nil))
    func getEmptyRuleJsonUrl() throws -> URL {
        getEmptyRuleJsonUrlCalledCount += 1
        switch getEmptyRuleJsonUrlResult {
        case .success(let url): return url
        case .error(let error): throw error
        }
    }
    
    var resetCalledCount = 0
    var resetError: Error?
    func reset() throws {
        resetCalledCount += 1
        if let error = resetError {
            throw error
        }
    }
}
