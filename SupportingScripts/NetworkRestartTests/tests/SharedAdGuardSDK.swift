// GPL-3.0-or-later. Test-only logging and result types.
@_exported import Foundation
public enum Logger {
    public static func logInfo(_ text: String) {}
    public static func logError(_ text: String) {}
    public static func logDebug(_ text: String) {}
}
public enum CommonError: Error { case missingSelf }
public enum Result<T> { case success(T), error(Error) }
