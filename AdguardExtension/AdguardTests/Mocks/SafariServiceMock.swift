
import Foundation


class SafariServiceMock: NSObject, SafariServiceProtocol {
    
    func checkStatus(completion: @escaping ([ContentBlockerType : Bool]) -> Void) {
    }
    
    func getContentBlockerEnabled(type: ContentBlockerType) -> Bool {
        return true
    }
    
    var jsons = [ContentBlockerType: Data]()
    
    func invalidateBlockingJsons(completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
    
    func save(json: Data, type: ContentBlockerType) {
        jsons[type] = json
    }
    
    func readJson(forType type: ContentBlockerType) -> Data? {
        return jsons[type]
    }
    
    func allBlockingContentRules() -> [String : Data] {
        return [:]
    }
}
