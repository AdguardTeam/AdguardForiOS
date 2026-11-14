// GPL-3.0-or-later. Isolated test collaborators, never packaged in the application.
@_exported import Foundation
// Match the real Objective-C framework's transitive legacy NWPath exposure.
@_exported import NetworkExtension
public enum AGDnsLogLevel { case AGDLLDebug, AGDLLInfo, AGDLLErr, AGDLLWarn }
public enum AGDnsLogger {
    public static func setLevel(_ level: AGDnsLogLevel) {}
    public static func setCallback(_ callback: @escaping (AGDnsLogLevel, UnsafePointer<CChar>?, Int) -> Void) {}
}
public final class AGDnsUpstream {
    public init() {}
    public var address = ""
    public var bootstrap: [String] = []
    public var serverIp = Data()
    public var id = 0
    public var outboundInterfaceName: String?
}
public enum AGDnsUtils {
    public static func test(_ upstream: AGDnsUpstream, timeoutMs: UInt, ipv6Available: Bool, offline: Bool) -> Error? { nil }
}
public enum AGDnsProxyConfig { public static let defaultTimeoutMs = 1000 }
public final class AGDnsStamp {
    public init?(string: String, error: inout NSError?) { return nil }
}
