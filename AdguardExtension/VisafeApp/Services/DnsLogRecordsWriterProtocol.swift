
import Foundation

@objc protocol DnsLogRecordsWriterProtocol: MobileDNSRequestProcessedListenerProtocol {
    var server: String { get set }
}
