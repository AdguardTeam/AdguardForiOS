import Foundation

final class DnsConfigurationMock: DnsConfigurationProtocol {
    var copy: DnsConfigurationMock { DnsConfigurationMock() }
    
    var blocklistIsEnabled: Bool = false
    
    var allowlistIsEnabled: Bool = false
    
    var dnsFilteringIsEnabled: Bool = false
    
    var dnsImplementation: DnsImplementation = .adguard
    
    var currentLanguage: String = ""
    
    var proStatus: Bool = false
}
