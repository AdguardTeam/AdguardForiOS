import Foundation
import SwiftyBeaver
import AGDnsProxy

/// Manager that create os and file log destinations. Creates and stores labeled loggers
final class ComLog_LoggerManagerImpl: ComLog_LoggerManager {

    var rootLogDirectory: URL

    private var osLogDestination: BaseDestination!
    private var fileLogDestination: BaseDestination!

    init(url: URL) {
        rootLogDirectory = url

        defer {
            osLogDestination = createOSLogDestination()
            fileLogDestination = createFileLogDestination()
            SwiftyBeaver.addDestination(osLogDestination)
            SwiftyBeaver.addDestination(fileLogDestination)
            configure(.info)
        }
    }

    func configure(_ logLevel: ComLog_LogLevel) {
        let swiftyBeaverLogLevel = logLevel.getSwiftyBeaverLogLevel()
        osLogDestination.minLevel = swiftyBeaverLogLevel
        fileLogDestination.minLevel = swiftyBeaverLogLevel
        AGLogger.setLevel(convertToVpnLibLogLevel(logLevel))
    }

    private func convertToVpnLibLogLevel(_ level: ComLog_LogLevel) -> AGLogLevel {
        switch (level) {
            case .info: return .AGLL_INFO
            case .warn: return .AGLL_WARN
            case .error: return .AGLL_ERR
            case .debug: return .AGLL_TRACE
        }
    }

    private  func createOSLogDestination() -> BaseDestination  {
        let osLogDestination = ComLog_ConsoleAppDestination()
        osLogDestination.format = "[$T] $L $X - $M"
        osLogDestination.asynchronously = true
        return osLogDestination
    }

    private func createFileLogDestination() -> BaseDestination {
        let logDirNameByProcessName = Bundle.main.bundleIdentifier ?? "UnknownProcess"
        let specificLogDirectory = rootLogDirectory.appendingPathComponent(logDirNameByProcessName)
        let logFileUrl = specificLogDirectory.appendingPathComponent("Log", isDirectory: false)

        createLogDirectoryIfNeeded(specificLogDirectory)
        let fileDestination = FileDestination(logFileURL: logFileUrl)
        fileDestination.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d [$T] $L $X - $M"
        fileDestination.asynchronously = true
        fileDestination.logFileMaxSize = 1024 * 1024 * 20 // We think 20MB should be enough for the one log file
        fileDestination.logFileAmount = 10 // We also think only 20 files we want to have

        return fileDestination
    }

    private  func createLogDirectoryIfNeeded(_ url: URL) {
        if FileManager.default.fileExists(atPath: url.path) { return }

        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        } catch {
            print("Log directory creation error: \(error)") // TODO improve it at the future
        }
    }
}
