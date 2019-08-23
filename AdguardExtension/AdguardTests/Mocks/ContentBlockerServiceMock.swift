
import Foundation

class ContentBlockerServiceMock: NSObject, ContentBlockerServiceProtocol {
    
    func validateRule(_ ruleText: String) -> Bool {
        return true
    }
    
    func reloadJsons(backgroundUpdate: Bool, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            completion(nil)
        }
    }
}
