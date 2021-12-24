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

        jsonStorage.stubbedJsonUrls = [.privacy: someUrl]

        XCTAssertEqual(jsonProvider.jsonUrl, someUrl)
    }
}
