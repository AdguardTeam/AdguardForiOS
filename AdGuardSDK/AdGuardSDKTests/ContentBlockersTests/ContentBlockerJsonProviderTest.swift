import XCTest

class ContentBlockerJsonProviderTest: XCTestCase {
    var jsonStorage: ContentBlockersInfoStorageMock!
    var jsonProvider: ContentBlockerJsonProviderProtocol!
    
    override func setUp() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        jsonStorage = ContentBlockersInfoStorageMock()
        jsonProvider = ContentBlockerJsonProvider(jsonStorage: jsonStorage, type: .privacy)
    }
    
    override func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }
    
    func testGetJsonUrlWithJsonStorageThrowsError() {
        let error = NSError(domain: "test", code: 1, userInfo: nil)
        jsonStorage.getEmptyRuleJsonUrlResult = .error(error)
        XCTAssertThrowsError(try jsonProvider.getJsonUrl(true)) { receivedError in
            XCTAssertEqual(receivedError as NSError, error)
        }
    }
    
    func testGetJsonUrlWithEnabledSafariProtection() {
        try! FileManager.default.createDirectory(at: TestsFileManager.workingUrl, withIntermediateDirectories: false, attributes: nil)
        let testJsonResultUrl = TestsFileManager.workingUrl.appendingPathComponent("cb_privacy.json")
        let emptyRuleUrl = TestsFileManager.workingUrl.appendingPathComponent("empty_rule.json")
        try! "".write(to: testJsonResultUrl, atomically: true, encoding: .utf8)
        try! "".write(to: emptyRuleUrl, atomically: true, encoding: .utf8)
        
        jsonStorage.getEmptyRuleJsonUrlResult = .success(emptyRuleUrl)
        jsonStorage.getInfoResult = ConverterResult(contentBlockerType: .privacy, totalRules: 20, totalConverted: 10, overlimit: false, jsonUrl: testJsonResultUrl)
        let url = try! jsonProvider.getJsonUrl(true)
        XCTAssertEqual(url, testJsonResultUrl)
    }
    
    func testGetJsonUrlWithDisabledSafariProtection() {
        try! FileManager.default.createDirectory(at: TestsFileManager.workingUrl, withIntermediateDirectories: false, attributes: nil)
        let testJsonResultUrl = TestsFileManager.workingUrl.appendingPathComponent("cb_privacy.json")
        let emptyRuleUrl = TestsFileManager.workingUrl.appendingPathComponent("empty_rule.json")
        try! "".write(to: testJsonResultUrl, atomically: true, encoding: .utf8)
        try! "".write(to: emptyRuleUrl, atomically: true, encoding: .utf8)
        
        jsonStorage.getEmptyRuleJsonUrlResult = .success(emptyRuleUrl)
        jsonStorage.getInfoResult = ConverterResult(contentBlockerType: .privacy, totalRules: 20, totalConverted: 10, overlimit: false, jsonUrl: testJsonResultUrl)
        let url = try! jsonProvider.getJsonUrl(false)
        XCTAssertEqual(url, emptyRuleUrl)
    }
    
    func testGetJsonUrlWithJsonStorageReturningNilInfo() {
        try! FileManager.default.createDirectory(at: TestsFileManager.workingUrl, withIntermediateDirectories: false, attributes: nil)
        let testJsonResultUrl = TestsFileManager.workingUrl.appendingPathComponent("cb_privacy.json")
        let emptyRuleUrl = TestsFileManager.workingUrl.appendingPathComponent("empty_rule.json")
        try! "".write(to: testJsonResultUrl, atomically: true, encoding: .utf8)
        try! "".write(to: emptyRuleUrl, atomically: true, encoding: .utf8)
        
        jsonStorage.getEmptyRuleJsonUrlResult = .success(emptyRuleUrl)
        jsonStorage.getInfoResult = nil
        let url = try! jsonProvider.getJsonUrl(true)
        XCTAssertEqual(url, emptyRuleUrl)
    }
}
