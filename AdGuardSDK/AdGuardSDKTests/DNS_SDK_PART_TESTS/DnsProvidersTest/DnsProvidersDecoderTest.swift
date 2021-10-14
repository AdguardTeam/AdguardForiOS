import XCTest

class DnsProvidersDecoderTest: XCTestCase {

    func testProvidersDecodedProperly() {
        let decoder = try! PredefinedDnsProvidersDecoder(currentLocale: Locale(identifier: "en"), bundle: Bundle(for: type(of: self)))
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
        let enProviders = (try! PredefinedDnsProvidersDecoder(currentLocale: Locale(identifier: "en"), bundle: bundle)).providers
        let deProviders = (try! PredefinedDnsProvidersDecoder(currentLocale: Locale(identifier: "de"), bundle: bundle)).providers
        let zhProviders = (try! PredefinedDnsProvidersDecoder(currentLocale: Locale(identifier: "zh-Hant_TW"), bundle: bundle)).providers

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

    func testProvidersLocalizedWithWrongLocale() {
        let bundle = Bundle(for: type(of: self))
        let enProviders = (try! PredefinedDnsProvidersDecoder(currentLocale: Locale(identifier: "en"), bundle: bundle)).providers
        let fooProviders = (try! PredefinedDnsProvidersDecoder(currentLocale: Locale(identifier: "FooBar"), bundle: bundle)).providers

        for i in 0..<enProviders.count {
            let enProvider = enProviders[i]
            let fooProvider = fooProviders[i]

            XCTAssertEqual(enProvider.providerDescription, fooProvider.providerDescription)

            let allEnFeatures = enProvider.servers.flatMap { $0.features }
            let allFooFeatures = fooProvider.servers.flatMap { $0.features }

            for j in 0..<allEnFeatures.count {
                let enFeature = allEnFeatures[j]
                let fooFeature = allFooFeatures[j]

                XCTAssertEqual(enFeature.name, fooFeature.name)
            }
        }
    }

    func testProvidersLocalizedWithSimilarLanguages() {
        let bundle = Bundle(for: type(of: self))
        let enProviders = (try! PredefinedDnsProvidersDecoder(currentLocale: Locale(identifier: "en"), bundle: bundle)).providers
        let srProviders = (try! PredefinedDnsProvidersDecoder(currentLocale: Locale(identifier: "sr"), bundle: bundle)).providers
        let srcsProviders = (try! PredefinedDnsProvidersDecoder(currentLocale: Locale(identifier: "sr-CS"), bundle: bundle)).providers

        for i in 0..<enProviders.count {
            let enProvider = enProviders[i]
            let srProvider = srProviders[i]
            let srCSProvider = srcsProviders[i]

            XCTAssertNotEqual(enProvider.providerDescription, srProvider.providerDescription)
            XCTAssertNotEqual(enProvider.providerDescription, srCSProvider.providerDescription)
            XCTAssertEqual(srProvider.providerDescription, srCSProvider.providerDescription)

            let allEnFeatures = enProvider.servers.flatMap { $0.features }
            let allsrFeatures = srProvider.servers.flatMap { $0.features }
            let allsrcsFeatures = srCSProvider.servers.flatMap { $0.features }

            for j in 0..<allEnFeatures.count {
                let enFeature = allEnFeatures[j]
                let srFeature = allsrFeatures[j]
                let srcsFeature = allsrcsFeatures[j]

                XCTAssertNotEqual(enFeature.name, srFeature.name)
                XCTAssertNotEqual(enFeature.name, srFeature.name)
                XCTAssertEqual(srFeature.name, srcsFeature.name)
            }
        }
    }

    func testProvidersLocalizedChenese() {
        let bundle = Bundle(for: type(of: self))
        let zhProviders = (try! PredefinedDnsProvidersDecoder(currentLocale: Locale(identifier: "zh"), bundle: bundle)).providers
        let zhHantProviders = (try! PredefinedDnsProvidersDecoder(currentLocale: Locale(identifier: "zh-Hant"), bundle: bundle)).providers
        let zhHansProviders = (try! PredefinedDnsProvidersDecoder(currentLocale: Locale(identifier: "zh-Hans"), bundle: bundle)).providers

        for i in 0..<zhProviders.count {
            let zhProvider = zhProviders[i]
            let zhHantProvider = zhHantProviders[i]
            let zhHansProvider = zhHansProviders[i]

            XCTAssertNotEqual(zhProvider.providerDescription, zhHantProvider.providerDescription)
            XCTAssertEqual(zhProvider.providerDescription, zhHansProvider.providerDescription)
            XCTAssertNotEqual(zhHantProvider.providerDescription, zhHansProvider.providerDescription)
        }
    }
}
