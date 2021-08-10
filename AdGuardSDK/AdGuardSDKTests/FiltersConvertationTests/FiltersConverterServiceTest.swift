import XCTest

class FiltersConverterServiceTest: XCTestCase {
    
    var configuration: SafariConfigurationMock!
    var filesStorage: FilterFilesStorageMock!
    var filtersService: FiltersServiceMock!
    var filtersConverter: FiltersConverterMock!
    var safariManagers: SafariUserRulesManagersProviderMock!
    var converterService: FiltersConverterServiceProtocol!

    override func setUp() {
        configuration = SafariConfigurationMock()
        filesStorage = FilterFilesStorageMock()
        filtersService = FiltersServiceMock()
        filtersConverter = FiltersConverterMock()
        safariManagers = SafariUserRulesManagersProviderMock()
        converterService = FiltersConverterService(configuration: configuration, filtersService: filtersService, filterFilesStorage: filesStorage, safariManagers: safariManagers, filtersConverter: filtersConverter)
    }

    func testConvertionWithSuccess() {
        filtersService.groups = getGroups()
        filesStorage.getFilterResultHandler = { return "testFilter_\($0)" }
        configuration.allowlistIsInverted = false
        configuration.safariProtectionEnabled = true
        
        let blockRules = [UserRule(ruleText: "block_rule_1", isEnabled: true), UserRule(ruleText: "block_rule_2", isEnabled: false)]
        (safariManagers.blocklistRulesManager as! BlocklistRulesManagerMock).allRules = blockRules
        
        let allowRules = [UserRule(ruleText: "allow_rule_1", isEnabled: false), UserRule(ruleText: "allow_rule_2", isEnabled: true)]
        (safariManagers.allowlistRulesManager as! AllowlistRulesManagerMock).allRules = allowRules
        
        let invAllowRules = [UserRule(ruleText: "inv_allow_rule_1", isEnabled: false), UserRule(ruleText: "inv_allow_rule_2", isEnabled: true)]
        (safariManagers.invertedAllowlistRulesManager as! InvertedAllowlistRulesManagerMock).allRules = invAllowRules
        
        filtersConverter.resultFilters = []
        let _ = try! converterService.convertFiltersAndUserRulesToJsons()
        
        XCTAssertEqual(filtersConverter.convertCalledCount, 1)
        
        let expectedFilters = [FilterFileContent(text: "testFilter_3", group: .socialWidgets)]
        XCTAssertEqual(expectedFilters, filtersConverter.passedFilters)
        XCTAssertEqual(["block_rule_1"], filtersConverter.passedBlocklistRules)
        XCTAssertEqual(["allow_rule_2"], filtersConverter.passedAllowlistRules)
    }
    
    func testConversionWithFailure() {
        filtersConverter.resultFilters = nil
        configuration.safariProtectionEnabled = true
        
        XCTAssertThrowsError(try converterService.convertFiltersAndUserRulesToJsons()) { error in
            XCTAssertEqual(error as! FiltersConverterService.ConvertionError, .failedToConvertRules)
            XCTAssertEqual(filtersConverter.convertCalledCount, 1)
        }
    }
    
    // TODO: - Add more tests for premium groups and disabled safari protection
    
    private func getGroups() -> [SafariGroup] {
        var adsGroup = SafariGroup(filters: [], isEnabled: false, groupType: .ads, groupName: "ads", displayNumber: 1)
        let adsFilter1 = SafariGroup.Filter(name: "adsFilter1", description: nil, isEnabled: true, filterId: 1, version: nil, lastUpdateDate: nil, updateFrequency: nil, group: adsGroup, displayNumber: 1, languages: [], tags: [], homePage: nil, filterDownloadPage: nil, rulesCount: nil)
        let adsFilter2 = SafariGroup.Filter(name: "adsFilter2", description: nil, isEnabled: false, filterId: 2, version: nil, lastUpdateDate: nil, updateFrequency: nil, group: adsGroup, displayNumber: 2, languages: [], tags: [], homePage: nil, filterDownloadPage: nil, rulesCount: nil)
        adsGroup.filters = [adsFilter1, adsFilter2]
        
        
        var socialGroup = SafariGroup(filters: [], isEnabled: true, groupType: .socialWidgets, groupName: "social", displayNumber: 2)
        let socialFilter1 = SafariGroup.Filter(name: "socialFilter1", description: nil, isEnabled: true, filterId: 3, version: nil, lastUpdateDate: nil, updateFrequency: nil, group: socialGroup, displayNumber: 1, languages: [], tags: [], homePage: nil, filterDownloadPage: nil, rulesCount: nil)
        let socialFilter2 = SafariGroup.Filter(name: "socialFilter2", description: nil, isEnabled: false, filterId: 4, version: nil, lastUpdateDate: nil, updateFrequency: nil, group: socialGroup, displayNumber: 2, languages: [], tags: [], homePage: nil, filterDownloadPage: nil, rulesCount: nil)
        let socialFilter3 = SafariGroup.Filter(name: "socialFilter3", description: nil, isEnabled: false, filterId: 5, version: nil, lastUpdateDate: nil, updateFrequency: nil, group: socialGroup, displayNumber: 3, languages: [], tags: [], homePage: nil, filterDownloadPage: nil, rulesCount: nil)
        socialGroup.filters = [socialFilter1, socialFilter2, socialFilter3]
        
        return [adsGroup, socialGroup]
    }
}
