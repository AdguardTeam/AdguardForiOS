import Foundation

final class TestsFileManager {
    static let rootDirectory = Bundle(for: TestsFileManager.self).resourceURL!
    static let workingUrl = Bundle(for: TestsFileManager.self).resourceURL!.appendingPathComponent("testFolder")
    
    static let defaultDbFileRootUrl = rootDirectory.appendingPathComponent(defaultDbFileName)
    static let adguardDbFileRootUrl = rootDirectory.appendingPathComponent(adguardDbFileName)
    static let defaultDbArchiveRootUrl = rootDirectory.appendingPathComponent(defaultDbArchiveFileName)
    static let adguardDbFileWorkingUrl = workingUrl.appendingPathComponent(adguardDbFileName)
    static let defaultDbFileWorkingUrl = workingUrl.appendingPathComponent(defaultDbFileName)
    
    static let defaultDbFileName = Constants.Files.defaultDbFileName
    static let defaultDbArchiveFileName = "\(Constants.Files.defaultDbFileName).zip"
    static let adguardDbFileName = "adguard.db"
    
    static func deleteTestFolder() {
        do {
            try FileManager.default.removeItem(atPath: workingUrl.path)
        } catch {}
    }
    
    static func clearRootDirectory() {
        let fileManager = FileManager.default
        
        do {
            if fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path) {
                try fileManager.removeItem(at: rootDirectory.appendingPathComponent(defaultDbFileName))
            }
            
            if fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(adguardDbFileName).path) {
                try fileManager.removeItem(at: rootDirectory.appendingPathComponent(adguardDbFileName))
            }
        } catch {}
    }
    
    static func putDbFileToDirectory(_ bundle: Bundle) {
        let dbFileUrl = bundle.url(forResource: "default.db", withExtension: "zip")!
        try! FileManager.default.createDirectory(at: TestsFileManager.workingUrl, withIntermediateDirectories: false, attributes: nil)
        try! FileManager.default.copyItem(at: dbFileUrl, to: TestsFileManager.workingUrl.appendingPathComponent(defaultDbArchiveFileName))
    }
}
