import XCTest

class CustomFilterMetaParserTest: XCTestCase {

    let parser: CustomFilterMetaParserProtocol = CustomFilterMetaParser()

    // MARK: - Safari filters test

    func testEasyListFilter() {
        let fileContent = getStringFromFile("EasyListTest")
        let result = try! parser.parse(fileContent, for: .safari, filterDownloadPage: nil)

        XCTAssertEqual(result.name, "EasyList")
        XCTAssertNil(result.description)
        XCTAssertEqual(result.version, "202105121116")
        XCTAssertNotNil(result.lastUpdateDate)
        XCTAssertEqual(result.homePage, "https://easylist.to/")
        XCTAssertEqual(result.licensePage, "https://easylist.to/pages/licence.html")
        XCTAssertNil(result.issuesReportPage)
        XCTAssertNil(result.communityPage)
        XCTAssertNil(result.filterDownloadPage)
        XCTAssertEqual(result.rulesCount, 48)
    }

    func testEasyListFilterWithPassedUrl() {
        let url = "https://domain.com"
        let fileContent = getStringFromFile("EasyListTest")
        let result = try! parser.parse(fileContent, for: .safari, filterDownloadPage: url)

        XCTAssertEqual(result.name, "EasyList")
        XCTAssertNil(result.description)
        XCTAssertEqual(result.version, "202105121116")
        XCTAssertNotNil(result.lastUpdateDate)
        XCTAssertEqual(result.homePage, "https://easylist.to/")
        XCTAssertEqual(result.licensePage, "https://easylist.to/pages/licence.html")
        XCTAssertNil(result.issuesReportPage)
        XCTAssertNil(result.communityPage)
        XCTAssertEqual(result.filterDownloadPage, url)
        XCTAssertEqual(result.rulesCount, 48)
    }

    func testAdblockIcelandicFilter() {
        let fileContent = getStringFromFile("AdblockIcelandicFilterTest")
        let result = try! parser.parse(fileContent, for: .safari, filterDownloadPage: nil)

        XCTAssertNil(result.name)
        XCTAssertNil(result.description)
        XCTAssertNil(result.version)
        XCTAssertNil(result.lastUpdateDate)
        XCTAssertNil(result.homePage)
        XCTAssertNil(result.licensePage)
        XCTAssertNil(result.issuesReportPage)
        XCTAssertNil(result.communityPage)
        XCTAssertNil(result.filterDownloadPage)
        XCTAssertEqual(result.rulesCount, 188)
    }

    func testAdGuardBaseFilter() {
        let fileContent = getStringFromFile("AdGuardBaseFilterTest")
        let result = try! parser.parse(fileContent, for: .safari, filterDownloadPage: nil)

        XCTAssertEqual(result.name, "AdGuard Base filter")
        XCTAssertEqual(result.description, "EasyList + AdGuard English filter. This filter is necessary for quality ad blocking.")
        XCTAssertEqual(result.version, "2.1.75.96")
        XCTAssertNotNil(result.lastUpdateDate)
        XCTAssertEqual(result.homePage, "https://github.com/AdguardTeam/AdGuardFilters")
        XCTAssertEqual(result.licensePage, "https://github.com/AdguardTeam/AdguardFilters/blob/master/LICENSE")
        XCTAssertNil(result.issuesReportPage)
        XCTAssertNil(result.communityPage)
        XCTAssertNil(result.filterDownloadPage)
        XCTAssertEqual(result.rulesCount, 38)
    }

    func testEmptyFileContent() {
        XCTAssertThrowsError(try parser.parse("", for: .safari, filterDownloadPage: nil)) { error in
            XCTAssertEqual(error as! CustomFilterMetaParserError, CustomFilterMetaParserError.invalidFileContent)
        }
    }

    func testInvalidFileContent() {
        let htmlContent = """
                        <!DOCTYPE html>
                        <html>
                        <body>
                        <h1>Header</h1>
                        </body>
                        </html>
                        """
        XCTAssertThrowsError(try parser.parse(htmlContent, for: .safari, filterDownloadPage: nil)) { error in
            XCTAssertEqual(error as! CustomFilterMetaParserError, CustomFilterMetaParserError.invalidFileContent)
        }
    }

    // MARK: - DNS filters test

    func testAdGuardSDNSFilter() {
        let fileContent = getStringFromFile("AdGuardSDNSFilterTest")
        let result = try! parser.parse(fileContent, for: .system, filterDownloadPage: nil)

        XCTAssertEqual(result.name, "AdGuard DNS filter")
        XCTAssertEqual(result.description, "Filter composed of several other filters (AdGuard Base filter, Social media filter, Tracking Protection filter, Mobile ads filter, EasyList, EasyPrivacy, etc) and simplified specifically to be better compatible with DNS-level ad blocking.")
        XCTAssertNil(result.version)
        XCTAssertNotNil(result.lastUpdateDate)
        XCTAssertEqual(result.homePage, "https://github.com/AdguardTeam/AdguardSDNSFilter")
        XCTAssertEqual(result.licensePage, "https://github.com/AdguardTeam/AdguardSDNSFilter/blob/master/LICENSE")
        XCTAssertNil(result.issuesReportPage)
        XCTAssertNil(result.communityPage)
        XCTAssertNil(result.filterDownloadPage)
        XCTAssertEqual(result.rulesCount, 7)
    }

    // MARK: - Helper methods

    private func getStringFromFile(_ fileName: String) -> String {
        let path = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "txt")!
        let content = try! String(contentsOf: path)
        return content
    }
}
