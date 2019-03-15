
import Foundation

@objc
protocol ConfigurationServiceProtocol : NSObjectProtocol {
    var darkTheme: Bool { get }
    var proStatus : Bool { get }
}
