
import Foundation


class SafariServiceMock: NSObject, SafariServiceProtocol {
    
    var jsons = [Int: Data]()
    
    func invalidateBlockingJsons(completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
    
    func save(json: Data, type: Int) {
        jsons[type] = json
    }
    
    func readJson(forType type: Int) -> Data {
        return jsons[type] ?? Data()
    }
    
    func allBlockingContentRules() -> [String : Data] {
        return [:]
    }
    
    func checkStatus(completion: @escaping (Bool) -> Void) {
        
    }
}
