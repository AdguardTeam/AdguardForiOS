import Foundation
import os.log

// This entity is wrapper for the Apple logger system `os_log`
// Since iOS 14.0 this entity would not be used
@available(iOS, deprecated: 14, message: "We should use the `ComLog_NativeLoggerWrapperSystemLoggerImpl` class instead")
class NativeLoggerWrapperOsLogImpl: NativeLoggerWrapper {

    private static let messageTemplate: StaticString = "%{public}@"

    private let osLog: OSLog

    init(subsystem: String) {
        self.osLog = OSLog(subsystem: subsystem, category: "General")
    }

    func send(_ message: String, _ logLevel: LogLevel) {
        if #available(iOS 12.0, *) {
            os_log(logLevel.getOsLogLevel(), NativeLoggerWrapperOsLogImpl.messageTemplate, message)
        } else {
            os_log(NativeLoggerWrapperOsLogImpl.messageTemplate, log: osLog, type: logLevel.getOsLogLevel(), message)
        }
    }
}
