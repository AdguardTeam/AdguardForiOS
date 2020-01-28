
import Foundation

@objc
protocol ConfigurationServiceProtocol : NSObjectProtocol {
    var darkTheme: Bool { get }
    var userThemeMode: AEThemeMode { get }
    var systemAppearenceIsDark: Bool { get }
    var proStatus : Bool { get }
    var purchasedThroughLogin: Bool { get }
    var developerMode: Bool { get  set }
    var showStatusBar: Bool { get set }
    var allContentBlockersEnabled: Bool { get }
}
