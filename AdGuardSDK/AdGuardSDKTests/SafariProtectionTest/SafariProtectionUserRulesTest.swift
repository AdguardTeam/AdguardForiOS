import XCTest

class SafariProtectionUserRulesTest: XCTestCase {
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

    func testRulesString() {
        let blocklistManager = safariManagers.blocklistRulesManagerMock
        testRulesString(blocklistManager)
        
        let allowlistManager = safariManagers.allowlistRulesManagerMock
        testRulesString(allowlistManager)
        
        let invertedAllowlistManager = safariManagers.invertedAllowlistRulesManagerMock
        testRulesString(invertedAllowlistManager)
    }
    
    private func testRulesString(_ mock: UserRulesManagerMock) {
        mock.rulesString = "rulesString"
        XCTAssertEqual(safariProtection.rulesString(for: mock.type), mock.rulesString)
        mock.rulesString = ""
        XCTAssertEqual(safariProtection.rulesString(for: mock.type), mock.rulesString)
    }
    
    func testAllRules() {
        let blocklistManager = safariManagers.blocklistRulesManagerMock
        testAllRules(blocklistManager)
        
        let allowlistManager = safariManagers.allowlistRulesManagerMock
        testAllRules(allowlistManager)
        
        let invertedAllowlistManager = safariManagers.invertedAllowlistRulesManagerMock
        testAllRules(invertedAllowlistManager)
    }
    
    private func testAllRules(_ mock: UserRulesManagerMock) {
        mock.allRules = [UserRule(ruleText: "rule_1", isEnabled: true),
                         UserRule(ruleText: "rule_2", isEnabled: false)]
        XCTAssertEqual(safariProtection.allRules(for: mock.type) as! [UserRule], mock.allRules as! [UserRule])
        mock.allRules = []
        XCTAssert(safariProtection.allRules(for: mock.type).isEmpty)
    }
    
    // MARK: - Test addRule
    
    func testAddRule() {
        mocks.forEach { mock in
            let method: (_ completion: @escaping (Error?) -> Void) -> Void = { completion in
                self.safariProtection.add(rule: UserRule(ruleText: "rule"), for: mock.type, override: true) { error in
                    completion(error)
                }
            }
            
            testMethodWithSuccess(mock, propertyCalledCount: &mock.addRuleCalledCount) { completion in
                method(completion)
            }
            
            testMethodWithError(mock, propertyError: &mock.addRuleError, propertyCalledCount: &mock.addRuleCalledCount) { completion in
                method(completion)
            }
            
            testMethodWithCbReloadError(mock, propertyCalledCount: &mock.addRuleCalledCount) { completion in
                method(completion)
            }
        }
    }
    
    // MARK: - Test addRules
    
    func testAddRules() {
        mocks.forEach { mock in
            let method: (_ completion: @escaping (Error?) -> Void) -> Void = { completion in
                let rules = [UserRule(ruleText: "rule1"), UserRule(ruleText: "rule2")]
                self.safariProtection.add(rules: rules, for: mock.type, override: true) { error in
                    completion(error)
                }
            }
            
            testMethodWithSuccess(mock, propertyCalledCount: &mock.addRulesCalledCount) { completion in
                method(completion)
            }
            
            testMethodWithError(mock, propertyError: &mock.addRulesError, propertyCalledCount: &mock.addRulesCalledCount) { completion in
                method(completion)
            }
            
            testMethodWithCbReloadError(mock, propertyCalledCount: &mock.addRulesCalledCount) { completion in
                method(completion)
            }
        }
    }
    
    // MARK: - Test modifyRule
    
    func testModifyRule() {
        mocks.forEach { mock in
            let method: (_ completion: @escaping (Error?) -> Void) -> Void = { completion in
                self.safariProtection.modifyRule("rule", UserRule(ruleText: "rule1"), for: mock.type) { error in
                    completion(error)
                }
            }
            
            testMethodWithSuccess(mock, propertyCalledCount: &mock.modifyRuleCalledCount) { completion in
                method(completion)
            }
            
            testMethodWithError(mock, propertyError: &mock.modifyRuleError, propertyCalledCount: &mock.modifyRuleCalledCount) { completion in
                method(completion)
            }
            
            testMethodWithCbReloadError(mock, propertyCalledCount: &mock.modifyRuleCalledCount) { completion in
                method(completion)
            }
        }
    }
    
    // MARK: - Test removeRule
    
    func testRemoveRule() {
        mocks.forEach { mock in
            let method: (_ completion: @escaping (Error?) -> Void) -> Void = { completion in
                self.safariProtection.removeRule(withText: "rule", for: mock.type) { error in
                    completion(error)
                }
            }
            
            testMethodWithSuccess(mock, propertyCalledCount: &mock.removeRuleCalledCount) { completion in
                method(completion)
            }
            
            testMethodWithError(mock, propertyError: &mock.removeRuleError, propertyCalledCount: &mock.removeRuleCalledCount) { completion in
                method(completion)
            }
            
            testMethodWithCbReloadError(mock, propertyCalledCount: &mock.removeRuleCalledCount) { completion in
                method(completion)
            }
        }
    }
    
    // MARK: - Test removeAllRules
    
    func testRemoveAllRules() {
        mocks.forEach { mock in
            let method: (_ completion: @escaping (Error?) -> Void) -> Void = { completion in
                self.safariProtection.removeAllRules(for: mock.type) { error in
                    completion(error)
                }
            }
            
            testMethodWithSuccess(mock, propertyCalledCount: &mock.removeAllRulesCalledCount) { completion in
                method(completion)
            }
    
            testMethodWithCbReloadError(mock, propertyCalledCount: &mock.removeAllRulesCalledCount) { completion in
                method(completion)
            }
        }
    }
    
    // MARK: - Methods to help testing
    
    private func testMethodWithSuccess(_ mock: UserRulesManagerMock, propertyCalledCount: inout Int, methodToTest: (_ completion: @escaping (Error?) -> Void) -> Void) {
        propertyCalledCount = 0
        converter.convertFiltersCalledCount = 0
        cbStorage.saveCbInfosCalledCount = 0
        cbService.updateContentBlockersCalledCount = 0
        
        let expectation = XCTestExpectation()
        methodToTest { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(propertyCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    private func testMethodWithError(_ mock: UserRulesManagerMock, propertyError: inout Error?, propertyCalledCount: inout Int, methodToTest: (_ completion: @escaping (Error?) -> Void) -> Void) {
        propertyCalledCount = 0
        converter.convertFiltersCalledCount = 0
        cbStorage.saveCbInfosCalledCount = 0
        cbService.updateContentBlockersCalledCount = 0
        
        propertyError = MetaStorageMockError.error
        let expectation = XCTestExpectation()
        methodToTest { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(propertyCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        
        propertyError = nil
    }
    
    private func testMethodWithCbReloadError(_ mock: UserRulesManagerMock, propertyCalledCount: inout Int, methodToTest: (_ completion: @escaping (Error?) -> Void) -> Void) {
        propertyCalledCount = 0
        converter.convertFiltersCalledCount = 0
        cbStorage.saveCbInfosCalledCount = 0
        cbService.updateContentBlockersCalledCount = 0
        
        cbService.updateContentBlockersError = MetaStorageMockError.error
        let expectation = XCTestExpectation()
        methodToTest { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(propertyCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        
        cbService.updateContentBlockersError = nil
    }
}
