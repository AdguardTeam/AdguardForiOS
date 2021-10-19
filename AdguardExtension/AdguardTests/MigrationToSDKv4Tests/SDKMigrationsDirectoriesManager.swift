import Foundation

/// This object is a helper for SDK migrations test
/// It is responsible for managing test directories
final class SDKMigrationsDirectoriesManager {
    static let rootUrl = Bundle(for: SDKMigrationsDirectoriesManager.self).resourceURL!.appendingPathComponent("SDK_tests_folder", isDirectory: true)
    static let subfolderUrl = rootUrl.appendingPathComponent("test_subfolder")

    static func createFolders() {
        try! FileManager.default.createDirectory(at: rootUrl, withIntermediateDirectories: true, attributes: nil)
        try! FileManager.default.createDirectory(at: subfolderUrl, withIntermediateDirectories: true, attributes: nil)
    }

    static func clear() {
        if FileManager.default.fileExists(atPath: rootUrl.path) {
            try! FileManager.default.removeItem(at: rootUrl)
        }
    }
}
