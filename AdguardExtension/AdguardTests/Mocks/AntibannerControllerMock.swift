
import Foundation

class AntibannerControllerMock: AntibannerControllerProtocol {
    
    let antibanner: AESAntibannerProtocol
    
    init(_ antibanner: AESAntibannerProtocol) {
        self.antibanner = antibanner
    }
    
    func start() {
    }
    
    func onReady(_ block: @escaping (AESAntibannerProtocol) -> Void) {
        block(antibanner)
    }
    
    func reset() {}
}
