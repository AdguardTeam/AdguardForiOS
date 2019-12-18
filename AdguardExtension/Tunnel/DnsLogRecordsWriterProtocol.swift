
import Foundation

@objc protocol DnsLogRecordsWriterProtocol {
    var server: String { get set }
    var userFilterId: NSNumber? { get set }
    var otherFilterIds: [NSNumber]? { get set }
    func handleEvent(_ event: AGDnsRequestProcessedEvent)
}
