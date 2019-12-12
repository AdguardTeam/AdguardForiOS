
import Foundation

class SharedResourcesMock: NSObject, AESharedResourcesProtocol {
    
    var safariProtectionEnabled: Bool = true
    
    lazy var userDefaults: UserDefaults = {
        let userDefaults = UserDefaults(suiteName: "TestDefaults")
        userDefaults?.removePersistentDomain(forName: "TestDefaults")
        userDefaults?.synchronize()
        return userDefaults!
    } ()
    
    var files = [String: Data]()
    
    func reset() {}
    
    static func sharedResuorcesURL() -> URL { return URL(string: "")!}
    
    static func sharedAppLogsURL() -> URL { return URL(string: "")!}
    
    static func sharedLogsURL() -> URL  { return URL(string: "")!}
    
    func sharedDefaults() -> UserDefaults {
        return userDefaults
    }
    
    static func sharedDefaultsSetTempKey(_ key: String, value: Any) {}
    
    static func sharedDefaultsValue(ofTempKey key: String) -> Any? { return NSObject() }
    
    static func sharedDefaultsRemoveTempKey(_ key: String) { }
    
    static func synchronizeSharedDefaults() { }
    
    func save(_ data: Data, toFileRelativePath relativePath: String) -> Bool {
        files[relativePath] = data
        return true
    }
    
    func loadData(fromFileRelativePath relativePath: String) -> Data? {
        return files[relativePath]
    }
    
    var blockingContentRules: Data!
    
    var whitelistContentBlockingRules: NSMutableArray?
    
    var invertedWhitelistContentBlockingObject: AEInvertedWhitelistDomainsObject?
    
    var lastUpdateFilterMetadata: ABECFilterClientMetadata?
    
    var filtersMetadataCache: ABECFilterClientMetadata?
    
    var i18nCacheForFilterSubscription: ABECFilterClientLocalization?
    
    var lastUpdateFilterIds: [NSNumber]?
    
    var lastUpdateFilters: [NSNumber : ASDFilter]?
    
    var activeDnsServer: DnsServerInfo? = nil
    
    func path(forRelativePath relativePath: String) -> String {
        return "test_domain\(relativePath)"
    }
}
