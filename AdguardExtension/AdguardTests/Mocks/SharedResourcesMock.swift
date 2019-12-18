
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
    
    func reset() {
        do {
            try FileManager.default.removeItem(at: sharedResuorcesURL())
        }
        catch { (error)
            print(error)
        }
        
        try? FileManager.default.createDirectory(at: sharedResuorcesURL(), withIntermediateDirectories: true, attributes: nil)
    }
    
    func sharedResuorcesURL() -> URL { return URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("resources_mock") }
    
    func sharedAppLogsURL() -> URL { return URL(string: "")!}
    
    func sharedLogsURL() -> URL  { return URL(string: "")!}
    
    func sharedDefaults() -> UserDefaults {
        return userDefaults
    }
    
    func synchronizeSharedDefaults() { }
    
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
    
    
    override init() {
        super.init()
        try? FileManager.default.createDirectory(at: sharedResuorcesURL(), withIntermediateDirectories: true, attributes: nil)
    }
}
