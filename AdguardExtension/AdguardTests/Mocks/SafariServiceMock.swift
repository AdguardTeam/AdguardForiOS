
import Foundation


class SafariServiceMock: NSObject, SafariServiceProtocol {
    
    func checkStatus(completion: @escaping ([NSNumber : Bool]) -> Void) {
    }
    
    func getContentBlockerEnabled(type: ContentBlockerType) -> Bool {
        return true
    }
    
    var jsons = [Int: Data]()
    
    func invalidateBlockingJsons(completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
    
    func save(json: Data, type: Int) {
        jsons[type] = json
    }
    
    func readJson(forType type: Int) -> Data? {
        return jsons[type]
    }
    
    func allBlockingContentRules() -> [String : Data] {
        return [:]
    }
}
