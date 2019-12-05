
import Foundation

@objc protocol DnsLogRecordsWriterProtocol {
    var server: String { get set }
    func handleEvent(_ event: AGDnsRequestProcessedEvent)
}
