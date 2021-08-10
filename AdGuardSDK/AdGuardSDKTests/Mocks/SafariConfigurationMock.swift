import Foundation

final class SafariConfigurationMock: SafariConfigurationProtocol {
    var currentLanguage: String = "en"
    
    var proStatus: Bool = false
    
    var safariProtectionEnabled: Bool = false
    
    var blocklistIsEnabled: Bool = false
    
    var allowlistIsEnbaled: Bool = false
    
    var allowlistIsInverted: Bool = false
    
    var updateOverWifiOnly: Bool = false
    
    var appProductVersion: String = ""
    
    var appBundleId: String = ""
    
    var appId: String = ""
    
    var cid: String = ""
    
    var copy: SafariConfigurationMock { return SafariConfigurationMock() }
}
