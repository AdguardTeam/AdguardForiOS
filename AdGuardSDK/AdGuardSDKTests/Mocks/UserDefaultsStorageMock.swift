import Foundation

class UserDefaultsStorageMock: UserDefaultsStorageProtocol {
    let storage: UserDefaults
    
    init() {
        self.storage = UserDefaults(suiteName: "mockUserDefaults")!
        self.storage.removePersistentDomain(forName: "mockUserDefaults")
    }
}
