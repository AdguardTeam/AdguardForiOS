import XCTest

class ContentBlockersInfoStorageTest: XCTestCase {

    let allCbInfoKey = "AdGuardSDK.allCbInfoKey"

    var userDefaultsStorage: UserDefaultsStorageMock!
    var infoStorage: ContentBlockersInfoStorageProtocol!

    override func setUpWithError() throws {
        userDefaultsStorage = UserDefaultsStorageMock()
        infoStorage = try ContentBlockersInfoStorage(jsonStorageUrl: TestsFileManager.workingUrl, userDefaultsStorage: userDefaultsStorage)
    }

    func testAdvancedRulesFileUrl() {
        TestsFileManager.clearRootDirectory()
        let advancedRules = [
            "unique_rule\nunique_rule1\n\nunique_rule2",
            "unique_rule\nunique_rule1\nunique_rule3",
            "unique_rule\nunique_rule1\nunique_rule4",
            "unique_rule\nunique_rule1\nunique_rule5",
            "unique_rule\nunique_rule1\nunique_rule6",
            "unique_rule\nunique_rule1"
        ]
        let results = getFilterConvertionResultsForAdvancedRules(advancedRules)
        try! infoStorage.save(converterResults: results)

        let rulesString = try! String(contentsOf: infoStorage.advancedRulesFileUrl)
        let rules = rulesString.split(separator: "\n")
        XCTAssertEqual(rules.count, 7)
        XCTAssertEqual(infoStorage.advancedRulesCount, 7)

        let rulesSet = Set(advancedRules.reduce("", { $0 + "\n" + $1 }).split(separator: "\n"))
        XCTAssertEqual(rulesSet.count, 7)
        rules.forEach {
            XCTAssert(rulesSet.contains($0))
        }
    }

    func testAllConverterResults() {
        fillStorage()
    }

    func testSaveCbJsonsWithError() {
        let filters = [
            FiltersConverterResult(type: .general, jsonString: "some_string", totalRules: 100, totalConverted: 20, overlimit: true, errorsCount: 1, advancedBlockingConvertedCount: 1, advancedBlockingJson: "some_json", advancedBlockingText: "some_text", message: "message"),
            FiltersConverterResult(type: .general, jsonString: "some_string_1", totalRules: 120, totalConverted: 30, overlimit: false, errorsCount: 0, advancedBlockingConvertedCount: 100, advancedBlockingJson: nil, advancedBlockingText: "some_text_1", message: "message_1")
        ]
        XCTAssertThrowsError(try infoStorage.save(converterResults: filters)) { error in
            if case CommonError.error(message: _) = error as! CommonError {}
            else {
                XCTFail()
            }
        }

        XCTAssert(infoStorage.allConverterResults.isEmpty)
    }

    func testSaveCbJsonsWithSuccess() {
        let results = getFilterConvertionResults()
        try! infoStorage.save(converterResults: results)
        XCTAssertEqual(infoStorage.allConverterResults.count, 6)
    }

    func testGetInfo() {
        fillStorage()
        let info = infoStorage.getConverterResult(for: .socialWidgetsAndAnnoyances)!
        let result = getFilterConvertionResults().first(where: { $0.type == .socialWidgetsAndAnnoyances })!
        XCTAssertEqual(result.type, info.type)
        XCTAssertEqual(result.overlimit, info.overlimit)
        XCTAssertEqual(result.totalRules, info.totalRules)
        XCTAssertEqual(result.totalConverted, info.totalConverted)
        XCTAssertEqual(result.overlimit, info.overlimit)
        XCTAssertEqual(result.errorsCount, info.errorsCount)
        XCTAssertEqual(result.advancedBlockingConvertedCount, info.advancedBlockingConvertedCount)
        XCTAssertEqual(result.message, info.message)
    }

    func testGetInfoWithNilResult() {
        let info = infoStorage.getConverterResult(for: .general)
        XCTAssertNil(info)
    }

    func testReset() {
        fillStorage()
        try! infoStorage.reset()
        XCTAssert(infoStorage.allConverterResults.isEmpty)

        let items = try! FileManager.default.contentsOfDirectory(at: TestsFileManager.workingUrl, includingPropertiesForKeys: nil, options: [])
        XCTAssert(items.isEmpty)

        // Test that service continues operating as usual
        testSaveCbJsonsWithSuccess()
    }

    private func fillStorage() {
        XCTAssert(infoStorage.allConverterResults.isEmpty)
        let someUrl = TestsFileManager.workingUrl
        let results = getFilterConvertionResults()
        let someInfo = results.map { ConverterResult(result: $0, jsonUrl: someUrl) }
        let encoder = JSONEncoder()
        let cbInfoData = try! encoder.encode(someInfo)
        userDefaultsStorage.storage.setValue(cbInfoData, forKey: allCbInfoKey)

        XCTAssertEqual(infoStorage.allConverterResults, someInfo)
    }

    private func getFilterConvertionResults() -> [FiltersConverterResult] {
        let results = [
            FiltersConverterResult(type: .general, jsonString: "some_string", totalRules: 100, totalConverted: 20, overlimit: true, errorsCount: 1, advancedBlockingConvertedCount: 1, advancedBlockingJson: "some_json", advancedBlockingText: "some_text", message: "message"),
            FiltersConverterResult(type: .privacy, jsonString: "some_string_1", totalRules: 120, totalConverted: 30, overlimit: false, errorsCount: 0, advancedBlockingConvertedCount: 100, advancedBlockingJson: nil, advancedBlockingText: "some_text_1", message: "message_1"),
            FiltersConverterResult(type: .socialWidgetsAndAnnoyances, jsonString: "some_string_2", totalRules: 90, totalConverted: 34, overlimit: true, errorsCount: 2, advancedBlockingConvertedCount: 3, advancedBlockingJson: nil, advancedBlockingText: "some_text_2", message: "message_2"),
            FiltersConverterResult(type: .other, jsonString: "some_string_3", totalRules: 80, totalConverted: 32, overlimit: false, errorsCount: 1, advancedBlockingConvertedCount: 21, advancedBlockingJson: "some_json_2", advancedBlockingText: "some_text_3", message: "message_3"),
            FiltersConverterResult(type: .custom, jsonString: "some_string_4", totalRules: 130, totalConverted: 45, overlimit: true, errorsCount: 3, advancedBlockingConvertedCount: 89, advancedBlockingJson: nil, advancedBlockingText: "some_text_4", message: "message_4"),
            FiltersConverterResult(type: .security, jsonString: "some_string_5", totalRules: 400, totalConverted: 68, overlimit: false, errorsCount: 9, advancedBlockingConvertedCount: 1, advancedBlockingJson: nil, advancedBlockingText: "some_text_5", message: "message_5")
        ]
        return results
    }

    private func getFilterConvertionResultsForAdvancedRules(_ advancedRules: [String]) -> [FiltersConverterResult] {
        let results = [
            FiltersConverterResult(type: .general, jsonString: "", totalRules: 0, totalConverted: 0, overlimit: false, errorsCount: 0, advancedBlockingConvertedCount: 0, advancedBlockingJson: "", advancedBlockingText: advancedRules[0], message: ""),
            FiltersConverterResult(type: .privacy, jsonString: "", totalRules: 0, totalConverted: 0, overlimit: false, errorsCount: 0, advancedBlockingConvertedCount: 0, advancedBlockingJson: "", advancedBlockingText: advancedRules[1], message: ""),
            FiltersConverterResult(type: .socialWidgetsAndAnnoyances, jsonString: "", totalRules: 0, totalConverted: 0, overlimit: false, errorsCount: 0, advancedBlockingConvertedCount: 0, advancedBlockingJson: "", advancedBlockingText: advancedRules[2], message: ""),
            FiltersConverterResult(type: .other, jsonString: "", totalRules: 0, totalConverted: 0, overlimit: false, errorsCount: 0, advancedBlockingConvertedCount: 0, advancedBlockingJson: "", advancedBlockingText: advancedRules[3], message: ""),
            FiltersConverterResult(type: .custom, jsonString: "", totalRules: 0, totalConverted: 0, overlimit: false, errorsCount: 0, advancedBlockingConvertedCount: 0, advancedBlockingJson: "", advancedBlockingText: advancedRules[4], message: ""),
            FiltersConverterResult(type: .security, jsonString: "", totalRules: 0, totalConverted: 0, overlimit: false, errorsCount: 0, advancedBlockingConvertedCount: 0, advancedBlockingJson: "", advancedBlockingText: advancedRules[5], message: "")
        ]
        return results
    }
}
