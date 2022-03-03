import os.log
import SwiftyBeaver

extension ComLog_LogLevel {

    func getOsLogLevel() -> OSLogType {
        // Well, we convert our log level to the "OSLogType" log level to communicate with
        // Apple native application "Console.app".
        // Cupertino guys as always think different and use usual log levels differently from other entire world.
        // So, the error for the "Console.app" is just a message with ⚠️ level.
        // The the fault for the "Console.app" is a message with ⛔️ level.
        //
        // Let's make friends 🐸 and 🐍 and provide the correct OSLogType by our log level value.
        switch (self) {
            case .info: return .info
            case .warn: return .error
            case .error: return .fault
            case .debug: return .debug
        }
    }

    func getSwiftyBeaverLogLevel() -> SwiftyBeaver.Level {
        switch (self) {
            case .info: return .info        // Will be printed info, warnings and errors
            case .warn: return .warning     // Will be printed warnings and errors only
            case .error: return .error      // Will be printed errors only
            case .debug: return .debug      // Will be printed info, warnings, errors and debug
        }
    }
}
