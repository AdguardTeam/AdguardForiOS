
import Foundation
import SafariServices

class SafariManagerMock: SFContentBlockerManagerProtocol {
    
    var maximumCount = 0
    var currentCount = 0
    var sleepTime = 0.5 //seconds
    
    var errors: [String: [Bool]] = [String: [Bool]]()
    
    let errorsQueue = DispatchQueue(label: "errors queue")
    
    func reloadContentBlocker(withIdentifier identifier: String, completionHandler: ((Error?) -> Void)?) {
        DispatchQueue(label: "reload").async {
            self.currentCount = self.currentCount + 1
            self.maximumCount = max(self.maximumCount, self.currentCount)
            DispatchQueue(label: "completion").asyncAfter(deadline: .now() + self.sleepTime) {
                self.currentCount = self.currentCount - 1
                
                var error: Error?
                
                self.errorsQueue.sync {
                    if var errorsByIdentifier = self.errors[identifier] {
                        if errorsByIdentifier.count > 0 {
                            
                            error = errorsByIdentifier.first! ? NSError(domain: "", code: 0, userInfo: nil) : nil
                            errorsByIdentifier.remove(at: 0)
                            self.errors[identifier] = errorsByIdentifier
                        }
                    }
                }
                
                completionHandler?(error)
            }
        }
    }
    
    func getStateOfContentBlocker(withIdentifier identifier: String, completionHandler: @escaping (SFContentBlockerState?, Error?) -> Void) {
        DispatchQueue(label: "state").async {
            completionHandler(SFContentBlockerState(), nil)
        }
    }
}

class SafariServiceMock: NSObject, SafariServiceProtocol {
    
    var contentBlockerManager: SFContentBlockerManagerProtocol = SafariManagerMock()
    
    var errors: [ContentBlockerType: Bool] = [ContentBlockerType: Bool]()
    
    func invalidateBlockingJson(type: ContentBlockerType, completion: @escaping (Error?) -> Void) {
        DispatchQueue(label: "safari mock invalidate").asyncAfter(deadline: .now() + 0.5) {
            completion((self.errors[type] ?? false) ? NSError(domain: "", code: 0, userInfo: nil):nil)
        }
    }
    
    func checkStatus(completion: @escaping ([ContentBlockerType : Bool]) -> Void) {
    }
    
    func getContentBlockerEnabled(type: ContentBlockerType) -> Bool {
        return true
    }
    
    var jsons = [ContentBlockerType: Data]()
    
    func invalidateBlockingJsons(completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
    
    let saveQueue = DispatchQueue(label: "save_queue")
    
    func save(json: Data, type: ContentBlockerType) {
        saveQueue.sync {
            jsons[type] = json
        }
    }
    
    func readJson(forType type: ContentBlockerType) -> Data? {
        return jsons[type]
    }
    
    func allBlockingContentRules() -> [String : Data] {
        return [:]
    }
}
