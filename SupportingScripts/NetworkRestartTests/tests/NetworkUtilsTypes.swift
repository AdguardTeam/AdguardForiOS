// GPL-3.0-or-later. Dependency stand-ins for type-checking the real monitor adapter.
import Foundation
import AGDnsProxy
public enum DnsProtocol { case dns, doh, dot, doq }
public enum DnsImplementation { case adGuard }
public enum CustomDnsProvidersStorageError: Error { case invalidUpstream(upstream: String) }
enum UrlUtils {
    static func isIpv4(_ value: String) -> Bool { false }
    static func isIpv6(_ value: String) -> Bool { false }
}
extension AGDnsStamp { var dnsProtocol: DnsProtocol { .dns } }
