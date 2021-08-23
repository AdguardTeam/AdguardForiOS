
import Foundation

protocol ConfigurationServiceProtocol: AnyObject {
    var darkTheme: Bool { get }
    var userThemeMode: ThemeMode { get set }
    var systemAppearenceIsDark: Bool { get set }
    var proStatus : Bool { get }
    var purchasedThroughLogin: Bool { get }
    var advancedMode: Bool { get  set }
    var showStatusBar: Bool { get set }
    var allContentBlockersEnabled: Bool { get }
    var someContentBlockersEnabled: Bool { get }
    
    func checkContentBlockerEnabled()
}
