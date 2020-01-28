
import Foundation

class ConfigurationServiceMock: NSObject, ConfigurationServiceProtocol{
    var developerMode: Bool = true
    var userThemeMode: AEThemeMode = AELightThemeMode
    var showStatusBar: Bool = true
    var systemAppearenceIsDark = true
    var purchasedThroughLogin = true
    var darkTheme = false
    var proStatus = true
    var allContentBlockersEnabled: Bool = true
}
