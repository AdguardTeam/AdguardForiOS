
import Foundation

@objc public protocol DnsBackgroundFetchUpdateProtocol {
    @objc optional func updateFilters(onFiltersUpdate: (() -> ())?)
}
