import Foundation

class UserDefaultsStorageMock: UserDefaultsStorageProtocol {
    private var lastFiltersUpdateCheckDateKey: String { "AdGuardSDK.lastFiltersUpdateCheckDateKey" }
    var storage: UserDefaults = UserDefaults(suiteName: "mockUserDefaults")!
    
    var lastFiltersUpdateCheckDate: Date {
        get {
            if let date = storage.value(forKey: lastFiltersUpdateCheckDateKey) as? Date {
                return date
            }
            return Date(timeIntervalSince1970: 0.0)
        }
        set {
            storage.setValue(newValue, forKey: lastFiltersUpdateCheckDateKey)
        }
    }
    
    init() {
        storage.removeObject(forKey: lastFiltersUpdateCheckDateKey)
    }
}
