import XCTest

class SafariProtectionContnetBlockersTest: XCTestCase {
    var configuration: ConfigurationMock!
    var defaultConfiguration: ConfigurationMock!
    var userDefaults: UserDefaultsStorageMock!
    var filters: FiltersServiceMock!
    var converter: FiltersConverterServiceMock!
    var cbStorage: ContentBlockersInfoStorageMock!
    var cbService: ContentBlockerServiceMock!
    var userRulesManagersProvider: UserRulesManagersProviderMock!
    
    var safariProtection: SafariProtectionProtocol!
    var mocks: [UserRulesManagerMock] = []
    
    override func setUp() {
        configuration = ConfigurationMock()
        defaultConfiguration = ConfigurationMock()
        userDefaults = UserDefaultsStorageMock()
        filters = FiltersServiceMock()
        converter = FiltersConverterServiceMock()
        cbStorage = ContentBlockersInfoStorageMock()
        cbService = ContentBlockerServiceMock()
        userRulesManagersProvider = UserRulesManagersProviderMock()
        safariProtection = SafariProtection(configuration: configuration,
                                            defaultConfiguration: defaultConfiguration,
                                            userDefaults: userDefaults,
                                            filters: filters,
                                            converter: converter,
                                            cbStorage: cbStorage,
                                            cbService: cbService,
                                            userRulesManagersProvider: userRulesManagersProvider)
        
        mocks = [userRulesManagersProvider.blocklistRulesManagerMock,
                 userRulesManagersProvider.allowlistRulesManagerMock,
                 userRulesManagersProvider.invertedAllowlistRulesManagerMock]
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
        cbStorage.allCbInfo = [.custom: ConverterResult(contentBlockerType: .custom, totalRules: 0, totalConverted: 10, overlimit: true, jsonUrl: someUrl),
                               .general: ConverterResult(contentBlockerType: .general, totalRules: 100, totalConverted: 50, overlimit: false, jsonUrl: someUrl)]
        XCTAssertEqual(cbStorage.allCbInfo, safariProtection.allContentBlockersInfo)
        
        cbStorage.allCbInfo = [:]
        XCTAssert(safariProtection.allContentBlockersInfo.isEmpty)
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
