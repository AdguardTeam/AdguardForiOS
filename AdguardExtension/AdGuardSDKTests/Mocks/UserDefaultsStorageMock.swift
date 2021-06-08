import Foundation

class UserDefaultsStorageMock: UserDefaultsStorageProtocol {
    var storage: UserDefaults = UserDefaults(suiteName: "mockUserDefaults")!
}
