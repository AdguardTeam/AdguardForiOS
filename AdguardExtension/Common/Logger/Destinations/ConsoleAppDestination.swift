import Foundation
import SwiftyBeaver
import os.log

/// Send log messages to debug console and Console.app
class ConsoleAppDestination : BaseDestination {

    override public var defaultHashValue: Int { return 3 } // We use 3 because we want that 🐣

    private var nativeLoggerWrapper: NativeLoggerWrapper = ConsoleAppDestination.createNativeLoggerWrapper()

    override public func send(
        _ level: SwiftyBeaver.Level,
        msg: String,
        thread: String,
        file: String,
        function: String,
        line: Int,
        context: Any? = nil
    ) -> String? {
        guard let formattedString = super.send(level, msg: msg, thread: thread, file: file, function: function, line: line, context: context) else {
            return nil
        }

        if level.rawValue >= self.minLevel.rawValue {
            let label = context as? String ?? "unknown label"
            nativeLoggerWrapper.send(formattedString, convertToCommonLogLevel(level))
        }

        return formattedString
    }

    private func convertToCommonLogLevel(_ logLevel: SwiftyBeaver.Level) -> LogLevel {
        switch (logLevel) {
            case .info: return .info
            case .warning: return .warn
            case .error: return .error
            case .debug: return .debug
            case .verbose: return .debug
        }
    }

    private static func createNativeLoggerWrapper() -> NativeLoggerWrapper {
        let subsystem = Bundle.main.bundleIdentifier ?? "com.AdGuard.DefaultIdentifier"
        if #available(iOS 14.0, *) {
            return NativeLoggerWrapperSystemLoggerImpl(subsystem: subsystem)
        } else {
            return NativeLoggerWrapperOsLogImpl(subsystem: subsystem)
        }
    }
}
