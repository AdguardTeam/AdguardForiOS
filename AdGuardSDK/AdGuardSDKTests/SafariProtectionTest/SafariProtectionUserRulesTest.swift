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
    var converterHelperMock: WebExtensionHelpersMock!

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
        converterHelperMock = WebExtensionHelpersMock()
        safariProtection = SafariProtection(configuration: configuration,
                                            defaultConfiguration: defaultConfiguration,
                                            userDefaults: userDefaults,
                                            filters: filters,
                                            converter: converter,
                                            cbStorage: cbStorage,
                                            cbService: cbService,
                                            safariManagers: safariManagers,
                                            converterHelper: converterHelperMock
        )

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
        XCTAssertEqual(safariProtection.allRules(for: mock.type), mock.allRules)
        mock.allRules = []
        XCTAssert(safariProtection.allRules(for: mock.type).isEmpty)
    }

    // MARK: - Test addRule

    typealias Method = (_ completion: @escaping (Error?) -> Void) throws -> Void

    func testAddRuleWithSuccess() {
        mocks.forEach { mock in
            mock.addRuleCalledCount = 0

            converter.convertFiltersCalledCount = 0
            cbStorage.invokedSaveCount = 0
            cbService.updateContentBlockersCalledCount = 0

            try! self.safariProtection.add(rule: UserRule(ruleText: "rule"), for: mock.type, override: true)

            XCTAssertEqual(converter.convertFiltersCalledCount, 0)
            XCTAssertEqual(cbStorage.invokedSaveCount, 0)
            XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        }
    }

    func testAddRuleWithError() {
        try! mocks.forEach { mock in
            mock.addRuleCalledCount = 0
            mock.addRuleError = MetaStorageMockError.error

            converter.convertFiltersCalledCount = 0
            cbStorage.invokedSaveCount = 0
            cbService.updateContentBlockersCalledCount = 0

            XCTAssertThrowsError(try self.safariProtection.add(rule: UserRule(ruleText: "rule"), for: mock.type, override: true)) { error in
                XCTAssertEqual(error as! MetaStorageMockError, .error)
            }

            XCTAssertEqual(converter.convertFiltersCalledCount, 0)
            XCTAssertEqual(cbStorage.invokedSaveCount, 0)
            XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        }
    }

    func testAddRuleWithReloadCB() {
        mocks.forEach { mock in
            let method: Method = { completion in
                try self.safariProtection.add(rule: UserRule(ruleText: "rule"), for: mock.type, override: true) { error in
                    completion(error)
                }
            }

            mock.addRuleCalledCount = 0
            testMethodWithSuccess() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.addRuleCalledCount, 1)

            mock.addRuleCalledCount = 0
            mock.addRuleError = MetaStorageMockError.error
            testMethodWithError() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.addRuleCalledCount, 1)
            mock.addRuleError = nil


            mock.addRuleCalledCount = 0
            testMethodWithCbReloadError() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.addRuleCalledCount, 1)
        }
    }

    // MARK: - Test addRules

    func testAddRules() {
        mocks.forEach { mock in
            let method: Method = { completion in
                let rules = [UserRule(ruleText: "rule1"), UserRule(ruleText: "rule2")]
                try self.safariProtection.add(rules: rules, for: mock.type, override: true) { error in
                    completion(error)
                }
            }

            mock.addRulesCalledCount = 0
            testMethodWithSuccess() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.addRulesCalledCount, 1)


            mock.addRulesCalledCount = 0
            mock.addRulesError = MetaStorageMockError.error
            testMethodWithError() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.addRulesCalledCount, 1)
            mock.addRulesError = nil


            mock.addRulesCalledCount = 0
            testMethodWithCbReloadError() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.addRulesCalledCount, 1)
        }
    }

    // MARK: - Test modifyRule

    func testModifyRule() {
        mocks.forEach { mock in
            let method: Method = { completion in
                try self.safariProtection.modifyRule("rule", UserRule(ruleText: "rule1"), for: mock.type) { error in
                    completion(error)
                }
            }

            mock.modifyRuleCalledCount = 0
            testMethodWithSuccess() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.modifyRuleCalledCount, 1)


            mock.modifyRuleCalledCount = 0
            mock.modifyRuleError = MetaStorageMockError.error
            testMethodWithError() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.modifyRuleCalledCount, 1)
            mock.modifyRuleError = nil


            mock.modifyRuleCalledCount = 0
            testMethodWithCbReloadError() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.modifyRuleCalledCount, 1)
        }
    }

    // MARK: - Test turnAllRules

    func testTurnAllRules() {
        mocks.forEach { mock in
            let method: Method = { completion in
                self.safariProtection.turnRules(["rule1", "rule2"], on: true, for: mock.type) { error in
                    completion(error)
                }
            }

            mock.modifyRuleCalledCount = 0
            testMethodWithSuccess() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.modifyRuleCalledCount, 2)


            mock.modifyRuleCalledCount = 0
            testMethodWithCbReloadError() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.modifyRuleCalledCount, 2)
        }
    }

    // MARK: - Test removeRule

    func testRemoveRule() {
        mocks.forEach { mock in
            let method: Method = { completion in
                try self.safariProtection.removeRule(withText: "rule", for: mock.type) { error in
                    completion(error)
                }
            }

            mock.removeRuleCalledCount = 0
            testMethodWithSuccess() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.removeRuleCalledCount, 1)


            mock.removeRuleCalledCount = 0
            mock.removeRuleError = MetaStorageMockError.error
            testMethodWithError() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.removeRuleCalledCount, 1)
            mock.removeRuleError = nil


            mock.removeRuleCalledCount = 0
            testMethodWithCbReloadError() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.removeRuleCalledCount, 1)
        }
    }

    // MARK: - Test removeRules

    func testRemoveRules() {
        mocks.forEach { mock in
            let method: Method = { completion in
                self.safariProtection.removeRules(["rule1", "rule2"], for: mock.type) { error in
                    completion(error)
                }
            }

            mock.removeRuleCalledCount = 0
            testMethodWithSuccess() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.removeRuleCalledCount, 2)


            mock.removeRuleCalledCount = 0
            testMethodWithCbReloadError() { completion in
                try method(completion)
            }
            XCTAssertEqual(mock.removeRuleCalledCount, 2)
        }
    }

    // MARK: - Test removeAllRules

    func testRemoveAllRulesWithSuccess() {
        mocks.forEach { mock in
            mock.removeAllRulesCalledCount = 0
            converter.convertFiltersCalledCount = 0
            cbStorage.invokedSaveCount = 0
            cbService.updateContentBlockersCalledCount = 0

            self.safariProtection.removeAllRules(for: mock.type)

            XCTAssertEqual(converter.convertFiltersCalledCount, 0)
            XCTAssertEqual(cbStorage.invokedSaveCount, 0)
            XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        }
    }

    func testRemoveAllRulesWithReloadCB() {
        mocks.forEach { mock in
            let method: Method = { completion in
                self.safariProtection.removeAllRules(for: mock.type) { error in
                    completion(error)
                }
            }

            mock.removeAllRulesCalledCount = 0
            testMethodWithSuccess() { completion in
                try! method(completion)
            }
            XCTAssertEqual(mock.removeAllRulesCalledCount, 1)


            mock.removeAllRulesCalledCount = 0
            testMethodWithCbReloadError() { completion in
                try! method(completion)
            }
            XCTAssertEqual(mock.removeAllRulesCalledCount, 1)
        }
    }

    // MARK: - Test removeAllUserRulesAssociatedWith

    func testRemoveAllUserRulesAssociatedWith() {
        let managerMock = safariManagers.blocklistRulesManagerMock
        managerMock.allRules = [
            UserRule(ruleText: "rule1", isEnabled: true),
            UserRule(ruleText: "rule2", isEnabled: true),
            UserRule(ruleText: "rule3", isEnabled: false),
            UserRule(ruleText: "rule4", isEnabled: false)
        ]

        converterHelperMock.userRuleIsAssociatedResultHandler = { _, rule in
            return rule == "rule2" || rule == "rule4"
        }

        let expectation = XCTestExpectation()
        safariProtection.removeAllUserRulesAssociatedWith(domain: "domain") { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)

        XCTAssertEqual(managerMock.removeRuleCalledCount, 2)
        XCTAssertEqual(managerMock.invokedRemoveRuleParameters, ["rule2", "rule4"])
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }

    func testRemoveAllUserRulesAssociatedWithCbReloadError() {
        let managerMock = safariManagers.blocklistRulesManagerMock
        managerMock.allRules = [
            UserRule(ruleText: "rule1", isEnabled: true),
            UserRule(ruleText: "rule2", isEnabled: true),
            UserRule(ruleText: "rule3", isEnabled: false),
            UserRule(ruleText: "rule4", isEnabled: false)
        ]

        converterHelperMock.userRuleIsAssociatedResultHandler = { _, rule in
            return rule == "rule2" || rule == "rule4"
        }

        cbService.updateContentBlockersError = MetaStorageMockError.error

        let expectation = XCTestExpectation()
        safariProtection.removeAllUserRulesAssociatedWith(domain: "domain") { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)

        XCTAssertEqual(managerMock.removeRuleCalledCount, 2)
        XCTAssertEqual(managerMock.invokedRemoveRuleParameters, ["rule2", "rule4"])
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }

    func testSetRulesWithSuccess() {
        mocks.forEach { mock in
            mock.setRulesCalledCount = 0
            safariProtection.set(rules: ["rule1", "rule2", "rule3"], for: mock.type)
            XCTAssertEqual(mock.setRulesCalledCount, 1)

            mock.setRulesCalledCount = 0
            safariProtection.set(rules: [], for: mock.type)
            XCTAssertEqual(mock.setRulesCalledCount, 1)
        }
    }

    func testSetRulesWithReloadCB() {
        mocks.forEach { mock in
            let method: Method = { completion in
                self.safariProtection.set(rules: ["rule1", "rule2", "rule3"], for: mock.type) { error in
                    completion(error)
                }
            }

            mock.setRulesCalledCount = 0
            testMethodWithSuccess() { completion in
                try! method(completion)
            }
            XCTAssertEqual(mock.setRulesCalledCount, 1)

            mock.setRulesCalledCount = 0
            testMethodWithCbReloadError { completion in
                try! method(completion)
            }
            XCTAssertEqual(mock.setRulesCalledCount, 1)
        }
    }

    // MARK: - Methods to help testing

    private func testMethodWithSuccess(methodToTest: Method) {
        converter.convertFiltersCalledCount = 0
        cbStorage.invokedSaveCount = 0
        cbService.updateContentBlockersCalledCount = 0

        let expectation = XCTestExpectation()
        try! methodToTest { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)

        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }

    private func testMethodWithError(methodToTest: Method) {
        converter.convertFiltersCalledCount = 0
        cbStorage.invokedSaveCount = 0
        cbService.updateContentBlockersCalledCount = 0

        let expectation = XCTestExpectation()

        do {
            try methodToTest { error in
                XCTAssertEqual(error as! MetaStorageMockError, .error)
                expectation.fulfill()
            }
            XCTFail()
        }
        catch {
            XCTAssertEqual(error as! MetaStorageMockError, .error)
        }

        wait(for: [expectation], timeout: 0.5)

        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }

    private func testMethodWithCbReloadError(methodToTest: Method) {
        converter.convertFiltersCalledCount = 0
        cbStorage.invokedSaveCount = 0
        cbService.updateContentBlockersCalledCount = 0

        cbService.updateContentBlockersError = MetaStorageMockError.error
        let expectation = XCTestExpectation()

        do {
            try methodToTest { error in
                XCTAssertEqual(error as! MetaStorageMockError, .error)
                expectation.fulfill()
            }
        }
        catch {
            XCTFail()
        }

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)

        cbService.updateContentBlockersError = nil
    }
}
