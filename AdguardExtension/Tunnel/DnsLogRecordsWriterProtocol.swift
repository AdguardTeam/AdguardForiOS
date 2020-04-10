
import Foundation

@objc protocol DnsLogRecordsWriterProtocol {
    var dnsProxyService: DnsProxyServiceProtocol? { get set }
    var server: String { get set }
    var userFilterId: NSNumber? { get set }
    var whitelistFilterId: NSNumber? {get set }
    var otherFilterIds: [NSNumber]? { get set }
    func handleEvent(_ event: AGDnsRequestProcessedEvent)
}
