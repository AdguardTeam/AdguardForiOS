import XCTest

class ContentBlockersInfoStorageTest: XCTestCase {
    
    let allCbInfoKey = "AdGuardSDK.allCbInfoKey"
    
    var userDefaultsStorage: UserDefaultsStorageMock!
    var infoStorage: ContentBlockersInfoStorageProtocol!
    
    override func setUpWithError() throws {
        userDefaultsStorage = UserDefaultsStorageMock()
        infoStorage = try ContentBlockersInfoStorage(jsonStorageUrl: TestsFileManager.workingUrl, userDefaultsStorage: userDefaultsStorage)
    }
    
    func testAllCbInfo() {
        fillStorage()
    }
    
    func testSaveCbJsonWithEmptyStorage() {
        XCTAssert(infoStorage.allCbInfo.isEmpty)
        
        let filter = SafariFilter(type: .general, jsonString: "some_json", totalRules: 20, totalConverted: 15, overlimit: false)
        try! infoStorage.save(cbInfo: filter)
        
        XCTAssertEqual(infoStorage.allCbInfo.count, 1)
        XCTAssertEqual(infoStorage.allCbInfo[filter.type]!.contentBlockerType, filter.type)
        XCTAssertEqual(infoStorage.allCbInfo[filter.type]!.totalRules, filter.totalRules)
        XCTAssertEqual(infoStorage.allCbInfo[filter.type]!.totalConverted, filter.totalConverted)
        XCTAssertFalse(infoStorage.allCbInfo[filter.type]!.overlimit)
    }
    
    func testSaveCbJsonWithNonEmptyStorage() {
        fillStorage()
        
        let filter = SafariFilter(type: .other, jsonString: "some_json", totalRules: 30, totalConverted: 25, overlimit: true)
        try! infoStorage.save(cbInfo: filter)
        
        XCTAssertEqual(infoStorage.allCbInfo.count, 6)
        XCTAssertEqual(infoStorage.allCbInfo[filter.type]!.contentBlockerType, filter.type)
        XCTAssertEqual(infoStorage.allCbInfo[filter.type]!.totalRules, filter.totalRules)
        XCTAssertEqual(infoStorage.allCbInfo[filter.type]!.totalConverted, filter.totalConverted)
        XCTAssert(infoStorage.allCbInfo[filter.type]!.overlimit)
    }
    
    func testSaveCbJsons() {
        fillStorage()
        
        let filter1 = SafariFilter(type: .other, jsonString: "some_json", totalRules: 30, totalConverted: 25, overlimit: true)
        let filter2 = SafariFilter(type: .general, jsonString: "some_json", totalRules: 20, totalConverted: 15, overlimit: false)
        try! infoStorage.save(cbInfos: [filter1, filter2])
        
        XCTAssertEqual(infoStorage.allCbInfo.count, 6)
        
        XCTAssertEqual(infoStorage.allCbInfo[filter1.type]!.contentBlockerType, filter1.type)
        XCTAssertEqual(infoStorage.allCbInfo[filter1.type]!.totalRules, filter1.totalRules)
        XCTAssertEqual(infoStorage.allCbInfo[filter1.type]!.totalConverted, filter1.totalConverted)
        XCTAssert(infoStorage.allCbInfo[filter1.type]!.overlimit)
        
        XCTAssertEqual(infoStorage.allCbInfo[filter2.type]!.contentBlockerType, filter2.type)
        XCTAssertEqual(infoStorage.allCbInfo[filter2.type]!.totalRules, filter2.totalRules)
        XCTAssertEqual(infoStorage.allCbInfo[filter2.type]!.totalConverted, filter2.totalConverted)
        XCTAssertFalse(infoStorage.allCbInfo[filter2.type]!.overlimit)
    }
    
    func testGetInfo() {
        fillStorage()
        let info = infoStorage.getInfo(for: .socialWidgetsAndAnnoyances)
        
        XCTAssertEqual(info!.contentBlockerType, .socialWidgetsAndAnnoyances)
        XCTAssertEqual(info!.totalRules, 89)
        XCTAssertEqual(info!.totalConverted, 78)
        XCTAssertFalse(info!.overlimit)
    }
    
    func testGetInfoWithNilResult() {
        let info = infoStorage.getInfo(for: .socialWidgetsAndAnnoyances)
        XCTAssertNil(info)
    }
    
    func testGetEmptyRuleJsonUrl() {
        let expectedRule = "[{\"trigger\": {\"url-filter\": \".*\",\"if-domain\": [\"domain.com\"]},\"action\":{\"type\": \"ignore-previous-rules\"}}]"
        let resultRuleUrl = try! infoStorage.getEmptyRuleJsonUrl()
        let resultRule = try! String(contentsOf: resultRuleUrl)
        XCTAssertEqual(expectedRule, resultRule)
    }
    
    private func fillStorage() {
        XCTAssert(infoStorage.allCbInfo.isEmpty)
        
        let someUrl = TestsFileManager.workingUrl
        let someInfo = [
            ContentBlockerType.general: ConverterResult(contentBlockerType: .general, totalRules: 10, totalConverted: 8, overlimit: false, jsonUrl: someUrl),
            .custom: ConverterResult(contentBlockerType: .custom, totalRules: 20, totalConverted: 18, overlimit: true, jsonUrl: someUrl),
            .other: ConverterResult(contentBlockerType: .other, totalRules: 140, totalConverted: 123, overlimit: false, jsonUrl: someUrl),
            .privacy: ConverterResult(contentBlockerType: .privacy, totalRules: 440, totalConverted: 320, overlimit: true, jsonUrl: someUrl),
            .security: ConverterResult(contentBlockerType: .security, totalRules: 23, totalConverted: 20, overlimit: false, jsonUrl: someUrl),
            .socialWidgetsAndAnnoyances: ConverterResult(contentBlockerType: .socialWidgetsAndAnnoyances, totalRules: 89, totalConverted: 78, overlimit: false, jsonUrl: someUrl)
        ]
        let encoder = JSONEncoder()
        let cbInfoData = try! encoder.encode(someInfo)
        userDefaultsStorage.storage.setValue(cbInfoData, forKey: allCbInfoKey)
        
        XCTAssertEqual(infoStorage.allCbInfo, someInfo)
    }
}
