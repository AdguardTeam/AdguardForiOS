import Foundation
@_implementationOnly import SQLite

public protocol AdGuardSDKBuilderProtocol {
    /// loads metadata and all filters synchronously and store them in urls sent to constructor
    func loadAll() throws
}

public class AdGuardSDKBuilder: AdGuardSDKBuilderProtocol {

    let filtersService: FiltersServiceForBuilderProtocol
    public init (filtersStorageUrl: URL, dbUrl: URL) {
        let configuration = SafariConfiguration(currentLanguage: "en", proStatus: false, safariProtectionEnabled: true, blocklistIsEnabled: true, allowlistIsEnbaled: true, allowlistIsInverted: false, appBundleId: Bundle.main.bundleIdentifier ?? "", appProductVersion: "", appId: "builder", cid: "")
        
        let filtersStorage = try! FilterFilesStorage(filterFilesDirectoryUrl: filtersStorageUrl)
        
        let dbManager = BuilderDbManager(dbContainerFolderUrl: dbUrl)
        let metaStorage = MetaStorage(productionDbManager: dbManager)
        
        let defaults = UserDefaultsStorage(storage: UserDefaults())
        
        let api = SafariProtectionApiMethods()
        
        filtersService = try! FiltersService(configuration: configuration, filterFilesStorage: filtersStorage, metaStorage: metaStorage, userDefaultsStorage: defaults, apiMethods: api)
    }
    
    public func loadAll() throws {
        try filtersService.downloadAndSaveFiltersMeta()
    }
}

fileprivate final class BuilderDbManager: ProductionDatabaseManagerProtocol {
    
    let filtersDb: Connection
    
    init(dbContainerFolderUrl: URL) {
        let dbPath = dbContainerFolderUrl.appendingPathComponent("default.db").absoluteString
        
        let filePaths = try! FileManager.default.contentsOfDirectory(atPath: dbContainerFolderUrl.path)
        for filePath in filePaths {
            try! FileManager.default.removeItem(atPath: dbContainerFolderUrl.appendingPathComponent(filePath).path)
        }
        
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
