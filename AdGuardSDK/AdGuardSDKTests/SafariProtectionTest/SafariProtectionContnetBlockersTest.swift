import XCTest

class SafariProtectionContnetBlockersTest: XCTestCase {
    var configuration: SafariConfigurationMock!
    var defaultConfiguration: SafariConfigurationMock!
    var userDefaults: UserDefaultsStorageMock!
    var filters: FiltersServiceMock!
    var converter: FiltersConverterServiceMock!
    var cbStorage: ContentBlockersInfoStorageMock!
    var cbService: ContentBlockerServiceMock!
    var safariManagers: SafariUserRulesManagersProviderMock!
    
    var safariProtection: SafariProtectionProtocol!
    var mocks: [UserRulesManagerMock] = []
    
    override func setUp() {
        configuration = SafariConfigurationMock()
        defaultConfiguration = SafariConfigurationMock()
        userDefaults = UserDefaultsStorageMock()
        filters = FiltersServiceMock()
        converter = FiltersConverterServiceMock()
        cbStorage = ContentBlockersInfoStorageMock()
        cbService = ContentBlockerServiceMock()
        safariManagers = SafariUserRulesManagersProviderMock()
        safariProtection = SafariProtection(configuration: configuration,
                                            defaultConfiguration: defaultConfiguration,
                                            userDefaults: userDefaults,
                                            filters: filters,
                                            converter: converter,
                                            cbStorage: cbStorage,
                                            cbService: cbService,
                                            safariManagers: safariManagers)
        
        mocks = [safariManagers.blocklistRulesManagerMock,
                 safariManagers.allowlistRulesManagerMock,
                 safariManagers.invertedAllowlistRulesManagerMock]
    }
    
    func testReloadingContentBlockers() {
        cbService.reloadingContentBlockers = [.general: true]
        XCTAssertEqual(safariProtection.reloadingContentBlockers, cbService.reloadingContentBlockers)
        
        cbService.reloadingContentBlockers = [:]
        XCTAssert(safariProtection.reloadingContentBlockers.isEmpty)
    }
    
    func testAdvancedRulesCount() {
        cbStorage.advancedRulesCount = 0
        XCTAssertEqual(safariProtection.advancedRulesCount, 0)
        
        cbStorage.advancedRulesCount = 10
        XCTAssertEqual(safariProtection.advancedRulesCount, 10)
    }
    
    func testAllContentBlockersStates() {
        cbService.allContentBlockersStates = [.custom: true,
                                              .general: false,
                                              .privacy: true]
        XCTAssertEqual(cbService.allContentBlockersStates, safariProtection.allContentBlockersStates)
        
        cbService.allContentBlockersStates = [:]
        XCTAssert(safariProtection.allContentBlockersStates.isEmpty)
    }
    
    func testAllContentBlockersInfo() {
        let someUrl = TestsFileManager.workingUrl
        cbStorage.stubbedAllConverterResults = [
            ConverterResult(result: FiltersConverterResult(type: .general, jsonString: "jsonString", totalRules: 100, totalConverted: 20, overlimit: false, errorsCount: 2, advancedBlockingConvertedCount: 20, advancedBlockingJson: "advancedBlockingJson", advancedBlockingText: "advancedBlockingText", message: "message"), jsonUrl: someUrl)
        ]
        
        XCTAssertEqual(cbStorage.allConverterResults, safariProtection.allConverterResults)
        
        cbStorage.stubbedAllConverterResults = []
        XCTAssert(safariProtection.allConverterResults.isEmpty)
    }
    
    func testGetState() {
        cbService.getStateResult = true
        let customState = safariProtection.getState(for: .custom)
        cbService.getStateResult = false
        let generalState = safariProtection.getState(for: .general)
        
        XCTAssert(customState)
        XCTAssertFalse(generalState)
    }
}
