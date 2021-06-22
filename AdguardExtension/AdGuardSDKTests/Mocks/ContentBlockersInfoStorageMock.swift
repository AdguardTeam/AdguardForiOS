import Foundation

final class ContentBlockersInfoStorageMock: ContentBlockersInfoStorageProtocol {
    
    var allCbInfo: [ContentBlockerType : ConverterResult] = [:]
    
    var saveCbInfoCalled = false
    var saveCbInfoError: Error?
    func save(cbInfo: SafariFilter) throws {
        saveCbInfoCalled = true
        if let error = saveCbInfoError {
            throw error
        }
    }
    
    var saveCbInfosCalled = false
    var saveCbInfosError: Error?
    func save(cbInfos: [SafariFilter]) throws {
        saveCbInfosCalled = true
        if let error = saveCbInfosError {
            throw error
        }
    }
    
    var getInfoCalled = false
    var getInfoResult: ConverterResult?
    func getInfo(for cbType: ContentBlockerType) -> ConverterResult? {
        getInfoCalled = true
        return getInfoResult
    }
    
    var getEmptyRuleJsonUrlCalled = false
    var getEmptyRuleJsonUrlResult: Result<URL> = .error(NSError(domain: "test", code: 1, userInfo: nil))
    func getEmptyRuleJsonUrl() throws -> URL {
        getEmptyRuleJsonUrlCalled = true
        switch getEmptyRuleJsonUrlResult {
        case .success(let url): return url
        case .error(let error): throw error
        }
    }
    
    func reset() throws {
        
    }
}
