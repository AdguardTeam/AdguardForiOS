import Foundation
import SwiftyBeaver

/// Represent AdGuard VPN log level mode
/// - defaultMode will include all log levels (debug -> info -> warning -> error)
/// - extendedMode will exclude debug log level (info -> warning -> error)
enum ComLog_LogLevelMode: Int, CaseIterable {
    case defaultMode = 0
    case extendedMode
}
