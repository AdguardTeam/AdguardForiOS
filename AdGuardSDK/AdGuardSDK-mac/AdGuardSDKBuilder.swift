import Foundation
import SQLite

public protocol AdGuardSDKBuilderProtocol {
    /** load metadata and all filters synchronously and store them in urls sent to constructor */
    func loadAll()->Bool
}

public class AdGuardSDKBuilder: AdGuardSDKBuilderProtocol {

    let filtersService: FiltersServiceProtocol
    public init (filtersStorageUrl: URL, dbUrl: URL) {
        let configuration = Configuration(currentLanguage: "en", proStatus: false, safariProtectionEnabled: true, blocklistIsEnabled: true, allowlistIsEnbaled: true, allowlistIsInverted: false, updateOverWifiOnly: false, appBundleId: Bundle.main.bundleIdentifier ?? "", appProductVersion: "", appId: "builder", cid: "")
        
        let filtersStorage = try! FilterFilesStorage(filterFilesDirectoryUrl: filtersStorageUrl)
        
        let dbManager = BulderDbManager(dbContainerFolderUrl: dbUrl)
        let metaStorage = MetaStorage(productionDbManager: dbManager)
        
        let defaults = UserDefaultsStorage(storage: UserDefaults())
        
        let api = ApiMethods()
        
        filtersService = try! FiltersService(configuration: configuration, filterFilesStorage: filtersStorage, metaStorage: metaStorage, userDefaultsStorage: defaults, apiMethods: api)
    }
    
    public func loadAll() -> Bool {
        
        var result = false
        let group = DispatchGroup()
        group.enter()
        filtersService.updateAllMeta(forcibly: true) { updateResult in
            
            switch (updateResult) {
            case .success(_):
                result = true
            
            case .error(_):
                result = false
            }
            
            group.leave()
        }
        
        group.wait()
        
        return result
    }
}

class BulderDbManager: ProductionDatabaseManagerProtocol {
    
    let filtersDb: Connection
    
    init(dbContainerFolderUrl: URL) {
        let dbPath = dbContainerFolderUrl.appendingPathComponent("default.db").absoluteString
        try? FileManager.default.removeItem(atPath: dbPath)
        filtersDb = try! Connection(dbPath)
        
        let schemaUrl = Bundle(for: type(of: self)).url(forResource: "schema", withExtension: "sql")!
        let createQuery = try! String(contentsOf: schemaUrl)
        try! filtersDb.execute(createQuery)
    }
    
    func updateDatabaseIfNeeded() throws {
    }
    
    func reset() throws {
    }
}
