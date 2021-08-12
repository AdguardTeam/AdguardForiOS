
import Foundation

protocol ConfigurationServiceProtocol {
    var darkTheme: Bool { get }
    var userThemeMode: ThemeMode { get }
    var systemAppearenceIsDark: Bool { get }
    var proStatus : Bool { get }
    var purchasedThroughLogin: Bool { get }
    var advancedMode: Bool { get  set }
    var showStatusBar: Bool { get set }
    var allContentBlockersEnabled: Bool { get }
    var someContentBlockersEnabled: Bool { get }
}
