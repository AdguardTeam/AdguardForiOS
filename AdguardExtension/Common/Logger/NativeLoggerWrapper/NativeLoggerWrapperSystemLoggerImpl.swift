import Foundation
import os.log

/// This object is wrapper for the Apple logger system `Logger`
/// From iOS 14.0 Apple introduce improved API for OSLog framework; See [Logger](https://developer.apple.com/documentation/os/logger)
@available(iOS 14.0, *)
class ComLog_NativeLoggerWrapperSystemLoggerImpl: ComLog_NativeLoggerWrapper {

    private let logger: Logger

    init(subsystem: String/*, label: String*/) {
        self.logger = Logger(subsystem: subsystem, category: "General")
    }

    func send(_ message: String, _ logLevel: ComLog_LogLevel) {
        logger.log(level: logLevel.getOsLogLevel(), "\(message)")
    }
}
