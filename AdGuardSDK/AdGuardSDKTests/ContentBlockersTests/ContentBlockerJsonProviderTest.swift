import XCTest

class ContentBlockerJsonProviderTest: XCTestCase {
    var jsonStorage: ContentBlockersInfoStorageMock!
    var jsonProvider: ContentBlockerJsonProviderProtocol!

    override func setUp() {
        jsonStorage = ContentBlockersInfoStorageMock()
        jsonProvider = ContentBlockerJsonProvider(jsonStorage: jsonStorage, type: .privacy)
    }

    func testJsonUrl() {
        let someUrl = TestsFileManager.workingUrl
        jsonStorage.stubbedGetConverterResultResult = ConverterResult(result: FiltersConverterResult(type: .general, jsonString: "jsonString", totalRules: 100, totalConverted: 20, overlimit: false, errorsCount: 2, advancedBlockingConvertedCount: 20, advancedBlockingJson: "advancedBlockingJson", advancedBlockingText: "advancedBlockingText", message: "message"), jsonUrl: someUrl)
        XCTAssertEqual(jsonProvider.jsonUrl, someUrl)

        jsonStorage.stubbedGetConverterResultResult = nil
        XCTAssertNil(jsonProvider.jsonUrl)
    }
}
