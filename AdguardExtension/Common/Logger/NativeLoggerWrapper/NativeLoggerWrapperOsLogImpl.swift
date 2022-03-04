import Foundation
import os.log

// This entity is wrapper for the Apple logger system `os_log`
// Since iOS 14.0 this entity would not be used
@available(iOS, obsoleted: 14, message: "We should use the `ComLog_NativeLoggerWrapperSystemLoggerImpl` class instead")
class ComLog_NativeLoggerWrapperOsLogImpl: ComLog_NativeLoggerWrapper {

    private static let messageTemplate: StaticString = "%{public}@"

    private let osLog: OSLog

    init(subsystem: String) {
        self.osLog = OSLog(subsystem: subsystem, category: "General")
    }

    func send(_ message: String, _ logLevel: ComLog_LogLevel) {
        if #available(iOS 12.0, *) {
            os_log(logLevel.getOsLogLevel(), ComLog_NativeLoggerWrapperOsLogImpl.messageTemplate, message)
        } else {
            os_log(ComLog_NativeLoggerWrapperOsLogImpl.messageTemplate, log: osLog, type: logLevel.getOsLogLevel(), message)
        }
    }
}
