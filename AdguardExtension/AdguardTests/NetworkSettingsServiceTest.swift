import XCTest

class NetworkSettingsServiceTest: XCTestCase, NetworkSettingsChangedDelegate {

    var resources: AESharedResourcesProtocol!
    var vpnManager = VpnManagerMock()
    var networkSettingsService: NetworkSettingsServiceProtocol!
    
    var settingsChangedCalledCount = 0
    
    private lazy var exeption1: WifiException = {
        let wifiName1 = "Network name 1"
        let enabled1 = false
        let exeption1 = WifiException(rule: wifiName1, enabled: enabled1)
        return exeption1
    }()
    
    private lazy var exeption2: WifiException = {
        let wifiName2 = "Network name 2"
        let enabled2 = true
        let exeption2 = WifiException(rule: wifiName2, enabled: enabled2)
        return exeption2
    }()
    
    private lazy var exeption3: WifiException = {
        let wifiName3 = "Network name 3"
        let enabled3 = true
        let exeption3 = WifiException(rule: wifiName3, enabled: enabled3)
        return exeption3
    }()
    
    override func setUp() {
        resources = SharedResourcesMock()
        networkSettingsService = NetworkSettingsService(resources: resources)
        networkSettingsService.delegate = self
        settingsChangedCalledCount = 0
    }
    
    // MARK: - test filterWifiDataEnabled
    
    func testFilterWifiDataEnabledSetWithNewValue(){
        let enabled = false
        resources.sharedDefaults().set(enabled, forKey: AEDefaultsFilterWifiEnabled)
        networkSettingsService.filterWifiDataEnabled = !enabled
        
        let valueFromResources = resources.sharedDefaults().object(forKey: AEDefaultsFilterWifiEnabled) as? Bool
        XCTAssertNotNil(valueFromResources)
        
        XCTAssert(valueFromResources == !enabled)
    }
    
    func testFilterWifiDataEnabledSetWithCurrentValue(){
        let enabled = false
        resources.sharedDefaults().set(enabled, forKey: AEDefaultsFilterWifiEnabled)
        networkSettingsService.filterWifiDataEnabled = enabled
        
        let valueFromResources = resources.sharedDefaults().object(forKey: AEDefaultsFilterWifiEnabled) as? Bool
        XCTAssertNotNil(valueFromResources)
        
        XCTAssert(valueFromResources == enabled)
    }
    
    // MARK: - test filterMobileDataEnabled
    
    func testFilterModbileataEnabledSetWithNewValue(){
        let enabled = false
        resources.sharedDefaults().set(enabled, forKey: AEDefaultsFilterMobileEnabled)
        networkSettingsService.filterMobileDataEnabled = !enabled
        
        let valueFromResources = resources.sharedDefaults().object(forKey: AEDefaultsFilterMobileEnabled) as? Bool
        XCTAssertNotNil(valueFromResources)
        
        XCTAssert(valueFromResources == !enabled)
    }
    
    func testFilterMobileDataEnabledSetWithCurrentValue(){
        let enabled = false
        resources.sharedDefaults().set(enabled, forKey: AEDefaultsFilterMobileEnabled)
        networkSettingsService.filterMobileDataEnabled = enabled
        
        let valueFromResources = resources.sharedDefaults().object(forKey: AEDefaultsFilterMobileEnabled) as? Bool
        XCTAssertNotNil(valueFromResources)
        
        XCTAssert(valueFromResources == enabled)
    }
    
    
    // MARK: - test add(exception: WifiException)
    
    func testAddExeptionWithNormalRule() {
        let wifiName = "Network name"
        let enabled = true
        let exeption = WifiException(rule: wifiName, enabled: enabled)
        
        networkSettingsService.add(exception: exeption)

        XCTAssert(settingsChangedCalledCount == 1)
        
        XCTAssertEqual([exeption], networkSettingsService.exceptions)
        XCTAssertEqual([exeption], networkSettingsService.enabledExceptions)
    }
    
    func testAddExeptionWithExistingRule() {
        
        // Add first exeption
        testAddExeptionWithNormalRule()
        
        // Add second existing exeption
        let wifiName = "Network name"
        let enabled = false
        let exeption = WifiException(rule: wifiName, enabled: enabled)
            
        networkSettingsService.add(exception: exeption)

        XCTAssert(settingsChangedCalledCount == 1)
            
        XCTAssertEqual([exeption], networkSettingsService.exceptions)
    }
    
    func testAddExeptionWithMultipleRules() {
        fillExeptions()
    }
    
    // MARK: - test delete(exception: WifiException)
    
    func testDeleteExeptionWithNormalEnabledRule(){
        fillExeptions()
        
        // Deleting second rule
        networkSettingsService.delete(exception: exeption2)
        XCTAssertEqual([exeption1, exeption3], networkSettingsService.exceptions)
        XCTAssertEqual([exeption3], networkSettingsService.enabledExceptions)
        XCTAssert(settingsChangedCalledCount == 4)
    }
    
    func testDeleteExeptionWithDifferentEnabledStates(){
        fillExeptions()
        
        let ruleToDeleteName = exeption2.rule
        let ruleToDeleteEnabled = !exeption2.enabled
        let exeptionToDelete = WifiException(rule: ruleToDeleteName, enabled: ruleToDeleteEnabled)

        // Deleting rule
        networkSettingsService.delete(exception: exeptionToDelete)
        XCTAssertEqual([exeption1, exeption3], networkSettingsService.exceptions)
        XCTAssertEqual([exeption3], networkSettingsService.enabledExceptions)
        XCTAssert(settingsChangedCalledCount == 4)
    }
    
    func testDeleteExeptionWithAbsentRule(){
        fillExeptions()
        
        let absentRuleName = "Absent name"
        let absentRuleEnabled = false
        let exeptionToDelete = WifiException(rule: absentRuleName, enabled: absentRuleEnabled)

        // Deleting rule
        networkSettingsService.delete(exception: exeptionToDelete)
        XCTAssertEqual([exeption1, exeption2, exeption3], networkSettingsService.exceptions)
        XCTAssertEqual([exeption2, exeption3], networkSettingsService.enabledExceptions)
        XCTAssert(settingsChangedCalledCount == 3)
    }
    
    // MARK: - test change(oldException: WifiException, newException: WifiException)
    
    func testChangeExeptionNameWithNormalRules(){
        fillExeptions()
        
        // Change second exeption name
        let newName = "New name"
        let newExeption = WifiException(rule: newName, enabled: exeption2.enabled)
        
        networkSettingsService.change(oldException: exeption2, newException: newExeption)
        XCTAssertEqual([exeption1, newExeption, exeption3], networkSettingsService.exceptions)
        XCTAssert(settingsChangedCalledCount == 4)
    }
    
    func testChangeExeptionStateWithNormalRules(){
        fillExeptions()
        
        // Change second exeption state
        let newEnabled = !exeption2.enabled
        let newExeption = WifiException(rule: exeption2.rule, enabled: newEnabled)
        
        networkSettingsService.change(oldException: exeption2, newException: newExeption)
        XCTAssertEqual([exeption1, newExeption, exeption3], networkSettingsService.exceptions)
        XCTAssertEqual([exeption3], networkSettingsService.enabledExceptions)
        XCTAssert(settingsChangedCalledCount == 4)
    }
    
    func testChangeExeptionWithAbsentRule(){
        fillExeptions()
        
        let absentName = "Absent name"
        let absentEnabled = true
        let absentExeption = WifiException(rule: absentName, enabled: absentEnabled)
        
        let newName = "New name"
        let newEnabled = false
        let newExeption = WifiException(rule: newName, enabled: newEnabled)
        
        networkSettingsService.change(oldException: absentExeption, newException: newExeption)
        XCTAssertEqual([exeption1, exeption2, exeption3], networkSettingsService.exceptions)
        XCTAssertEqual([exeption2, exeption3], networkSettingsService.enabledExceptions)
        XCTAssert(settingsChangedCalledCount == 3)
    }
    
    // MARK: - NetworkSettingsChangedDelegate method
    
    func settingsChanged() {
        settingsChangedCalledCount += 1
    }
    
    // MARK: - Private methods
    
    // Adds 3 rules to exeptions
    private func fillExeptions() {
        networkSettingsService.add(exception: exeption1)
        XCTAssertEqual([exeption1], networkSettingsService.exceptions)
        XCTAssertEqual([], networkSettingsService.enabledExceptions)
        XCTAssert(settingsChangedCalledCount == 1)
        
        networkSettingsService.add(exception: exeption2)
        XCTAssertEqual([exeption1, exeption2], networkSettingsService.exceptions)
        XCTAssertEqual([exeption2], networkSettingsService.enabledExceptions)
        XCTAssert(settingsChangedCalledCount == 2)
        
        networkSettingsService.add(exception: exeption3)
        XCTAssertEqual([exeption1, exeption2, exeption3], networkSettingsService.exceptions)
        XCTAssertEqual([exeption2, exeption3], networkSettingsService.enabledExceptions)
        XCTAssert(settingsChangedCalledCount == 3)
    }
}
