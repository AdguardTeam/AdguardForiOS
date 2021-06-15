import Foundation

class ConfigurationMock: ConfigurationProtocol {
    var currentLanguage: String = "en"
    
    var proStatus: Bool = false
    
    var blocklistIsEnabled: Bool = false
    
    var allowlistIsEnbaled: Bool = false
    
    var allowlistIsInverted: Bool = false
    
    var appProductVersion: String = ""
    
    var appId: String = ""
    
    var cid: String = ""
}
