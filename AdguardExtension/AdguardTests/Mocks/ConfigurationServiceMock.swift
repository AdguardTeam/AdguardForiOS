
import Foundation

class ConfigurationServiceMock: NSObject, ConfigurationServiceProtocol{
    
    var userThemeMode: AEThemeMode = AELightThemeMode
    var systemAppearenceIsDark = true
    var purchasedThroughLogin = true
    var darkTheme = false
    var proStatus = true
}
