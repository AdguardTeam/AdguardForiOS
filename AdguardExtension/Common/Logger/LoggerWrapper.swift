import Foundation
import SwiftyBeaver

/// Logger with specified label
final class ComLog_LoggerWrapper {

    let label: String

    init(_ label: String) {
        self.label = label
    }

    func info(_ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line, customLabel: String? = nil) {
        guard let message = message else { return }

        SwiftyBeaver.info(message, file, function, line: line, context: label)
    }

    func debug(_ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line, customLabel: String? = nil) {
        guard let message = message else { return }

        SwiftyBeaver.debug(message, file, function, line: line, context: label)
    }

    func warn(_ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line, customLabel: String? = nil) {
        guard let message = message else { return }

        SwiftyBeaver.warning(message, file, function, line: line, context: label)
    }

    func error(_ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line, customLabel: String? = nil) {
        guard let message = message else { return }

        SwiftyBeaver.error(message, file, function, line: line, context: label)
    }



    // Static functions to call them when a logger shouldn't be created

    static func info(_ label: String, _ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        guard let message = message else { return }

        SwiftyBeaver.info(message, file, function, line: line, context: label)
    }

    static func debug(_ label: String, _ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        guard let message = message else { return }

        SwiftyBeaver.debug(message, file, function, line: line, context: label)
    }

    static func warn(_ label: String, _ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        guard let message = message else { return }

        SwiftyBeaver.warning(message, file, function, line: line, context: label)
    }

    static func error(_ label: String, _ message: String?, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        guard let message = message else { return }

        SwiftyBeaver.error(message, file, function, line: line, context: label)
    }
}
