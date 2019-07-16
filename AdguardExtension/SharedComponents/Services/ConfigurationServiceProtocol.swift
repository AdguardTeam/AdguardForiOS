
import Foundation

@objc
protocol ConfigurationServiceProtocol : NSObjectProtocol {
    var darkTheme: Bool { get }
    var userThemeMode: AEThemeMode { get }
    var systemAppearenceIsDark: Bool { get }
    var proStatus : Bool { get }
    var purchasedThroughLogin: Bool { get }
}
