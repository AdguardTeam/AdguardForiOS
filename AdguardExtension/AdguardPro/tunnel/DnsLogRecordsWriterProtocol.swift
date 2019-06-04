
import Foundation
import Mobile

@objc protocol DnsLogRecordsWriterProtocol: MobileDNSRequestProcessedListenerProtocol {
    var server: String { get set }
}
