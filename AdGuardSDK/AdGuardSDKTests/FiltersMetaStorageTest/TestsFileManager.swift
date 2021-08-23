import Foundation

final class TestsFileManager {
    static let rootDirectory = Bundle(for: TestsFileManager.self).resourceURL!
    static let workingUrl = Bundle(for: TestsFileManager.self).resourceURL!.appendingPathComponent("testFolder")
    
    static let defaultDbFileRootUrl = rootDirectory.appendingPathComponent(defaultDbFileName)
    static let adguardDbFileRootUrl = rootDirectory.appendingPathComponent(adguardDbFileName)
    static let defaultDbArchiveRootUrl = rootDirectory.appendingPathComponent(defaultDbArchiveFileName)
    static let adguardDbFileWorkingUrl = workingUrl.appendingPathComponent(adguardDbFileName)
    static let defaultDbFileWorkingUrl = workingUrl.appendingPathComponent(defaultDbFileName)
    
    static let defaultDbFileName = Constants.Files.defaultDb
    static let defaultDbArchiveFileName = "\(Constants.Files.defaultDb).zip"
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
}
