import XCTest
@_implementationOnly import ContentBlockerConverter

final class ContentBlockerConverterMock: ContentBlockerConverterProtocol {
    
    var result: [ContentBlockerType: [String]] = [:]
    
    func convertArray(rules: [String], limit: Int, optimize: Bool, advancedBlocking: Bool, cbType: ContentBlockerType) -> ConversionResult? {
        result[cbType] = rules
        return nil
    }
}

class FiltersConverterTest: XCTestCase {
    
    var converterMock: ContentBlockerConverterMock!
    var converter: FiltersConverterProtocol!
    
    override func setUp() {
        converterMock = ContentBlockerConverterMock()
        converter = FiltersConverter(converter: converterMock)
    }
    
    // MARK: - Parts of different filters to test
    
    let adGuardBaseFilter = FilterFileContent(text: """
                                                    ! Checksum: ZfQYKYYCHnYvVSRxWh6gNw
                                                    ally.sh#@#.adsBox
                                                    ondemandkorea.com#@#.afs_ads
                                                    !#safari_cb_affinity(general,privacy)
                                                    @@||imasdk.googleapis.com/js/sdkloader/ima3.js$domain=ondemandkorea.com
                                                    @@||production-static.ondemandkorea.com/images^
                                                    @@||openx.net/|$domain=ondemandkorea.com
                                                    !#safari_cb_affinity
                                                    """,
                                              group: .ads)
    
    let adGuardExperimentalFilter = FilterFileContent(text: """
                                                            ! Checksum: yzpecJf8/nqMe6xzg+biBA
                                                            ! Title: AdGuard Experimental filter (Optimized)
                                                            /fbevents.js^
                                                            ||chrome.test.filter.com^$third-party
                                                            reddit.com##.
                                                            """,
                                                            group: .other)
    
    let adGuardDutchFilter = FilterFileContent(text: """
                                                    ! Expires: 4 days (update frequency)
                                                    -reclameplaatjes/
                                                    /adbron.
                                                    """,
                                               group: .languageSpecific)
    
    let webAnnoyancesUltralist = FilterFileContent(text: """
                                                        ! Start Web Annoyances Ultralist - Main Filters
                                                        10best.com##.homepage-top-story-callout.columns.large-12
                                                        1688.com###j-identity
                                                        """,
                                                   group: .annoyances)
    
    // MARK: - Tests
    // Just test different filters and rules variations
    
    func testWithAllowlistRules() {
        let filters = [adGuardBaseFilter, adGuardExperimentalFilter]
        let blocklistRules = ["/adtwee/*", "ya.ru", "google.com"]
        let allowlistRules = ["mail.com"]
        
        let _ = converter.convert(filters: filters, blocklistRules: blocklistRules, allowlistRules: allowlistRules, invertedAllowlistRulesString: nil)
        
        for (cbType, rules) in converterMock.result {
            switch cbType {
            case .general:
                XCTAssertEqual(rules.count, 9)
                XCTAssertEqual(rules[0], "ally.sh#@#.adsBox")
                XCTAssertEqual(rules[1], "ondemandkorea.com#@#.afs_ads")
                XCTAssertEqual(rules[2], "@@||imasdk.googleapis.com/js/sdkloader/ima3.js$domain=ondemandkorea.com")
                XCTAssertEqual(rules[3], "@@||production-static.ondemandkorea.com/images^")
                XCTAssertEqual(rules[4], "@@||openx.net/|$domain=ondemandkorea.com")
                XCTAssertEqual(rules[5], "/adtwee/*")
                XCTAssertEqual(rules[6], "ya.ru")
                XCTAssertEqual(rules[7], "google.com")
                XCTAssertEqual(rules[8], "@@||mail.com^$document")
            case .other:
                XCTAssertEqual(rules.count, 7)
                XCTAssertEqual(rules[0], "/fbevents.js^")
                XCTAssertEqual(rules[1], "||chrome.test.filter.com^$third-party")
                XCTAssertEqual(rules[2], "reddit.com##.")
                XCTAssertEqual(rules[3], "/adtwee/*")
                XCTAssertEqual(rules[4], "ya.ru")
                XCTAssertEqual(rules[5], "google.com")
                XCTAssertEqual(rules[6], "@@||mail.com^$document")
            case .privacy:
                XCTAssertEqual(rules.count, 7)
                XCTAssertEqual(rules[0], "@@||imasdk.googleapis.com/js/sdkloader/ima3.js$domain=ondemandkorea.com")
                XCTAssertEqual(rules[1], "@@||production-static.ondemandkorea.com/images^")
                XCTAssertEqual(rules[2], "@@||openx.net/|$domain=ondemandkorea.com")
                XCTAssertEqual(rules[3], "/adtwee/*")
                XCTAssertEqual(rules[4], "ya.ru")
                XCTAssertEqual(rules[5], "google.com")
                XCTAssertEqual(rules[6], "@@||mail.com^$document")
            case .security:
                XCTAssertEqual(rules.count, 4)
                XCTAssertEqual(rules[0], "/adtwee/*")
                XCTAssertEqual(rules[1], "ya.ru")
                XCTAssertEqual(rules[2], "google.com")
                XCTAssertEqual(rules[3], "@@||mail.com^$document")
            case .socialWidgetsAndAnnoyances:
                XCTAssertEqual(rules.count, 4)
                XCTAssertEqual(rules[0], "/adtwee/*")
                XCTAssertEqual(rules[1], "ya.ru")
                XCTAssertEqual(rules[2], "google.com")
                XCTAssertEqual(rules[3], "@@||mail.com^$document")
            case .custom:
                XCTAssertEqual(rules.count, 4)
                XCTAssertEqual(rules[0], "/adtwee/*")
                XCTAssertEqual(rules[1], "ya.ru")
                XCTAssertEqual(rules[2], "google.com")
                XCTAssertEqual(rules[3], "@@||mail.com^$document")
            }
        }
    }
    
    func testWithInvertedAllowlistRules() {
        let filters = [adGuardDutchFilter, webAnnoyancesUltralist]
        let invertedAllowlistRules = "@@||*$document,domain=~ya.ru|~vk.com|~mail.ru"
        let _ = converter.convert(filters: filters, blocklistRules: nil, allowlistRules: nil, invertedAllowlistRulesString: invertedAllowlistRules)
        
        for (cbType, rules) in converterMock.result {
            switch cbType {
            case .general:
                XCTAssertEqual(rules.count, 3)
                XCTAssertEqual(rules[0], "-reclameplaatjes/")
                XCTAssertEqual(rules[1], "/adbron.")
                XCTAssertEqual(rules[2], invertedAllowlistRules)
            case .other:
                XCTAssertEqual(rules.count, 1)
                XCTAssertEqual(rules[0], invertedAllowlistRules)
            case .privacy:
                XCTAssertEqual(rules.count, 1)
                XCTAssertEqual(rules[0], invertedAllowlistRules)
            case .security:
                XCTAssertEqual(rules.count, 1)
                XCTAssertEqual(rules[0], invertedAllowlistRules)
            case .socialWidgetsAndAnnoyances:
                XCTAssertEqual(rules.count, 3)
                XCTAssertEqual(rules[0], "10best.com##.homepage-top-story-callout.columns.large-12")
                XCTAssertEqual(rules[1], "1688.com###j-identity")
                XCTAssertEqual(rules[2], invertedAllowlistRules)
            case .custom:
                XCTAssertEqual(rules.count, 1)
                XCTAssertEqual(rules[0], invertedAllowlistRules)
            }
        }
    }
}
