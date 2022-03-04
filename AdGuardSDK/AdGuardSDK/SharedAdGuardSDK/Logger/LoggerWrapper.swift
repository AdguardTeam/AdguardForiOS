import Foundation
import SwiftyBeaver

/// Logger with specified label
public final class ComLog_LoggerWrapper {

    let label: String

    init(_ label: String) {
        self.label = label
    }

    public func info(_ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line, customLabel: String? = nil) {
        guard let message = message else { return }

        SwiftyBeaver.info(message, file, function, line: line, context: label)
    }

    public func debug(_ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line, customLabel: String? = nil) {
        guard let message = message else { return }

        SwiftyBeaver.debug(message, file, function, line: line, context: label)
    }

    public func warn(_ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line, customLabel: String? = nil) {
        guard let message = message else { return }

        SwiftyBeaver.warning(message, file, function, line: line, context: label)
    }

    public func error(_ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line, customLabel: String? = nil) {
        guard let message = message else { return }

        SwiftyBeaver.error(message, file, function, line: line, context: label)
    }



    // Static functions to call them when a logger shouldn't be created

    public static func info(_ label: String, _ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        guard let message = message else { return }

        SwiftyBeaver.info(message, file, function, line: line, context: label)
    }

    public static func debug(_ label: String, _ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        guard let message = message else { return }

        SwiftyBeaver.debug(message, file, function, line: line, context: label)
    }

    public static func warn(_ label: String, _ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        guard let message = message else { return }

        SwiftyBeaver.warning(message, file, function, line: line, context: label)
    }

    public static func error(_ label: String, _ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        guard let message = message else { return }

        SwiftyBeaver.error(message, file, function, line: line, context: label)
    }
}
