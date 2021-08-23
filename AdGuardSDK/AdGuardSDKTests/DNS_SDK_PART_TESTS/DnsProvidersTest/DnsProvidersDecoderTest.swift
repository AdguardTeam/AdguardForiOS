import XCTest

class DnsProvidersDecoderTest: XCTestCase {
    
    func testProvidersDecodedProperly() {
        let decoder = try! PredefinedDnsProvidersDecoder(currentLanguage: "en", bundle: Bundle(for: type(of: self)))
        let providers = decoder.providers
        
        XCTAssertEqual(providers.count, 11)
        XCTAssertEqual(providers.flatMap { $0.servers }.count, 36)
        providers.forEach {
            if $0.providerId == PredefinedDnsProvider.systemDefaultProviderId {
                XCTAssertNil($0.logo)
            } else {
                XCTAssertNotNil($0.logo)
            }
            XCTAssert($0.providerId >= PredefinedDnsProvider.systemDefaultProviderId)
            XCTAssert($0.servers.count > 0)
            $0.servers.forEach { server in
                if server.providerId == PredefinedDnsProvider.systemDefaultProviderId {
                    XCTAssert(server.features.isEmpty)
                    XCTAssert(server.upstreams.isEmpty)
                } else {
                    XCTAssert(server.upstreams.count > 0)
                }
            }
        }
    }
    
    func testProvidersLocalized() {
        let bundle = Bundle(for: type(of: self))
        let enProviders = (try! PredefinedDnsProvidersDecoder(currentLanguage: "en", bundle: bundle)).providers
        let deProviders = (try! PredefinedDnsProvidersDecoder(currentLanguage: "de", bundle: bundle)).providers
        let zhProviders = (try! PredefinedDnsProvidersDecoder(currentLanguage: "zh-Hans", bundle: bundle)).providers
        
        for i in 0..<enProviders.count {
            let enProvider = enProviders[i]
            let deProvider = deProviders[i]
            let zhProvider = zhProviders[i]
            
            XCTAssertNotEqual(enProvider.providerDescription, deProvider.providerDescription)
            XCTAssertNotEqual(enProvider.providerDescription, zhProvider.providerDescription)
            XCTAssertNotEqual(deProvider.providerDescription, zhProvider.providerDescription)
            
            let allEnFeatures = enProvider.servers.flatMap { $0.features }
            let allDeFeatures = deProvider.servers.flatMap { $0.features }
            let allZhFeatures = zhProvider.servers.flatMap { $0.features }
            
            for j in 0..<allEnFeatures.count {
                let enFeature = allEnFeatures[j]
                let deFeature = allDeFeatures[j]
                let zhFeature = allZhFeatures[j]
                
                XCTAssertNotEqual(enFeature.name, deFeature.name)
                XCTAssertNotEqual(enFeature.name, zhFeature.name)
                XCTAssertNotEqual(deFeature.name, zhFeature.name)
            }
        }
    }
}
