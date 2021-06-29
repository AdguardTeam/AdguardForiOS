import Foundation

final class ContentBlockerServiceMock: ContentBlockerServiceProtocol {
    var allContentBlockersStates: [ContentBlockerType : Bool] = [:]
    
    var updateContentBlockersCalledCount = 0
    var updateContentBlockersError: Error?
    func updateContentBlockers(onContentBlockersUpdated: @escaping (Error?) -> Void) {
        updateContentBlockersCalledCount += 1
        DispatchQueue.global().async {
            onContentBlockersUpdated(self.updateContentBlockersError)
        }
    }
    
    var getStateCalledCount = 0
    var getStateResult = false
    func getState(for cbType: ContentBlockerType) -> Bool {
        getStateCalledCount += 1
        return getStateResult
    }
}
