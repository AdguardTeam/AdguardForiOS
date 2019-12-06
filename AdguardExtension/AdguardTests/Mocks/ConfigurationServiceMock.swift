
import Foundation

class ConfigurationServiceMock: NSObject, ConfigurationServiceProtocol{
    
    var developerMode: Bool = true
    var userThemeMode: AEThemeMode = AELightThemeMode
    var systemAppearenceIsDark = true
    var purchasedThroughLogin = true
    var darkTheme = false
    var proStatus = true
}
