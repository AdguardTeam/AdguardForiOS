import XCTest


class URLSchemeParcerTest: XCTestCase {
    private var urlParcer: IURLSchemeParser?

    override func setUpWithError() throws {
        let executor = URLSchemeExecutorMock()
        let configuration = ConfigurationServiceMock()
        let purchaseService = PurchaseServiceMock()

        urlParcer = URLSchemeParser(executor: executor, configurationService: configuration, purchaseService: purchaseService)

    }

    override func tearDownWithError() throws {
        urlParcer = nil
    }
    
    func testAddLicenceUrl() {
        let urlParcer = self.urlParcer!
        let emptyLicenseUrl = URL(string: "adguard:license=")!
        let incorrectLicenseUrl = URL(string: "adguard:lic")!
        let licenseUrl = URL(string: "adguard:license=Foo")!
        
        let emptyLicenseUrlResult = urlParcer.parse(url: emptyLicenseUrl)
        let incorrectLicenseUrlResult = urlParcer.parse(url: incorrectLicenseUrl)
        let licenseUrlResult = urlParcer.parse(url: licenseUrl)
        
        XCTAssertTrue(emptyLicenseUrlResult)
        XCTAssertFalse(incorrectLicenseUrlResult)
        XCTAssertTrue(licenseUrlResult)
    }
    
    func testAddSafariRuleUrl() {
        let urlParcer = self.urlParcer!
        let safariRuleUrl = URL(string: "adguard://add/foo")!
        let safariEmptyRuleUrl = URL(string: "adguard://add/")!
        let incorrectCommand = URL(string: "adguard://ad")!
        
        let safariRuleUrlResult = urlParcer.parse(url: safariRuleUrl)
        let safariEmptyRuleUrlResult = urlParcer.parse(url: safariEmptyRuleUrl)
        let incorrectCommandResult = urlParcer.parse(url: incorrectCommand)
        
        XCTAssertTrue(safariRuleUrlResult)
        XCTAssertFalse(safariEmptyRuleUrlResult)
        XCTAssertFalse(incorrectCommandResult)
    }
    
    func testWidgetSystemProtectionChangedUrl() {
        let urlParcer = self.urlParcer!
        let systemProtectionUrlOn = URL(string: "adguard://systemProtection/on")!
        let systemProtectionUrlOff = URL(string: "adguard://systemProtection/off")!
        let systemProtectionUrlEmpty = URL(string: "adguard://systemProtection/")!
        let incorrectSystemProtectionUrl = URL(string: "adguard://systemProtection/Foo")!
        
        let systemProtectionUrlOnResult = urlParcer.parse(url: systemProtectionUrlOn)
        let systemProtectionUrlOffResult = urlParcer.parse(url: systemProtectionUrlOff)
        let systemProtectionUrlEmptyResult = urlParcer.parse(url: systemProtectionUrlEmpty)
        let incorrectSystemProtectionUrlResult = urlParcer.parse(url: incorrectSystemProtectionUrl)
        
        XCTAssertTrue(systemProtectionUrlOnResult)
        XCTAssertTrue(systemProtectionUrlOffResult)
        XCTAssertTrue(systemProtectionUrlEmptyResult)
        XCTAssertTrue(incorrectSystemProtectionUrlResult)
    }
    
    func testWidgetComplexProtectionCangedUrl() {
        let urlParcer = self.urlParcer!
        let complexProtectionUrlOn = URL(string: "adguard://complexProtection/on")!
        let complexProtectionUrlOff = URL(string: "adguard://complexProtection/off")!
        let complexProtectionUrlEmpty = URL(string: "adguard://complexProtection/")!
        let incorrectComplexProtectionUrl = URL(string: "adguard://complexProtection/Foo")!
         
        let complexProtectionUrlOnResult = urlParcer.parse(url: complexProtectionUrlOn)
        let complexProtectionUrlOffResult = urlParcer.parse(url: complexProtectionUrlOff)
        let complexProtectionUrlEmptyResult = urlParcer.parse(url: complexProtectionUrlEmpty)
        let incorrectComplexProtectionUrlResult = urlParcer.parse(url: incorrectComplexProtectionUrl)
        
        XCTAssertTrue(complexProtectionUrlOnResult)
        XCTAssertTrue(complexProtectionUrlOffResult)
        XCTAssertTrue(complexProtectionUrlEmptyResult)
        XCTAssertTrue(incorrectComplexProtectionUrlResult)
    }
    
    func testAddDnsUrl() {
        let urlParcer = self.urlParcer!
        let customDnsUrl = URL(string: "sdns://fooBar")!
        let emptyCustomDnsUrl = URL(string: "sdns://")!
        let incorrectSchemeUrl = URL(string: "sdddns://fooBar")!
        
        let customDnsUrlResult = urlParcer.parse(url: customDnsUrl)
        let emptyCustomDnsUrlResult = urlParcer.parse(url: emptyCustomDnsUrl)
        let incorrectSchemeUrlResult = urlParcer.parse(url: incorrectSchemeUrl)
        
        XCTAssertTrue(customDnsUrlResult)
        XCTAssertFalse(emptyCustomDnsUrlResult)
        XCTAssertFalse(incorrectSchemeUrlResult)
    }
    
    func testImportSettingsUrl() {
        let urlParcer = self.urlParcer!
        // %7B == {   %7D == }
        let importSettingsUrl = URL(string: "adguard://apply_settings?json=%7Bfoo:bar%7D")!
        let emptyImportSetingsUrl = URL(string: "adguard://apply_settings?json=")!
        let emptyJsonImportSettingsUrl = URL(string: "adguard://apply_settings?json=%7B%7D")!
        let incorrectImportSettingsUrl = URL(string: "adguard://apply_settings?")!
        
        let importSettingsUrlResult = urlParcer.parse(url: importSettingsUrl)
        let emptyImportSetingsUrlResult = urlParcer.parse(url: emptyImportSetingsUrl)
        let emptyJsonImportSettingsUrlResult = urlParcer.parse(url: emptyJsonImportSettingsUrl)
        let incorrectImportSettingsUrlResult = urlParcer.parse(url: incorrectImportSettingsUrl)
        
        XCTAssertTrue(importSettingsUrlResult)
        XCTAssertFalse(emptyImportSetingsUrlResult)
        XCTAssertTrue(emptyJsonImportSettingsUrlResult)
        XCTAssertFalse(incorrectImportSettingsUrlResult)
    }
    
    func testSubscribeUrl() {
        let urlParcer = self.urlParcer!
        let subscribeUrl = URL(string: "abp://subscribe?location=https://FOO.bar&title=Foo")!
        let emptyParamsSubscriptionUrl = URL(string: "abp://subscribe?location=&title=")!
        
        let subscribeUrlResult = urlParcer.parse(url: subscribeUrl)
        let emptyParamsSubscriptionUrlResult = urlParcer.parse(url: emptyParamsSubscriptionUrl)
        
        XCTAssertTrue(subscribeUrlResult)
        XCTAssertFalse(emptyParamsSubscriptionUrlResult)
    }
    
    func testOpenTunnelUrl() {
        let urlParcer = self.urlParcer!
        let openTunnelUrl = URL(string: "adguard://openTunnelModeSettings")!
        let incorrectOpenTunnelUrl = URL(string: "adguard://openTunnelModeSettingsFoo")!
        
        let openTunnelUrlResult = urlParcer.parse(url: openTunnelUrl)
        let incorrectOpenTunnelUrlResult = urlParcer.parse(url: incorrectOpenTunnelUrl)
        
        XCTAssertTrue(openTunnelUrlResult)
        XCTAssertFalse(incorrectOpenTunnelUrlResult)
    }
    
    func testAuthUrl() {
        let urlParcer = self.urlParcer!
        let authUrl = URL(string: "adguard://auth#access_token=Foo&token_type=bar&state=123&expires_in=321")!
        let emptyAuthUrl = URL(string: "adguard://auth#access_token=&token_type=&state=&expires_in=")!
        let incorrectAuthUrl = URL(string: "adguard://auth#")!
        let errorAuthUrl = URL(string: "adguard://auth#error=some_error")!
        
        let authUrlResult = urlParcer.parse(url: authUrl)
        let emptyAuthUrlResult = urlParcer.parse(url: emptyAuthUrl)
        let incorrectAuthUrlResult = urlParcer.parse(url: incorrectAuthUrl)
        let errorAuthResult = urlParcer.parse(url: errorAuthUrl)

        XCTAssertTrue(authUrlResult)
        XCTAssertFalse(emptyAuthUrlResult)
        XCTAssertFalse(incorrectAuthUrlResult)
        XCTAssertFalse(errorAuthResult)
    }
}
