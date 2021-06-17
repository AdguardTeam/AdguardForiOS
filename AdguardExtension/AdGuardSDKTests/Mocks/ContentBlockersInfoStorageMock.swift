import Foundation

final class ContentBlockersInfoStorageMock: ContentBlockersInfoStorageProtocol {
    
    var allCbInfo: [ContentBlockerType : ContentBlockersInfoStorage.ConverterResult] = [:]
    
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
    var getInfoResult: ContentBlockersInfoStorage.ConverterResult?
    func getInfo(for cbType: ContentBlockerType) -> ContentBlockersInfoStorage.ConverterResult? {
        getInfoCalled = true
        return getInfoResult
    }
}
