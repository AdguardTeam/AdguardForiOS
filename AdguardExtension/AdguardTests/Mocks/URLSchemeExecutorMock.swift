class URLSchemeExecutorMock: IURLSchemeExecutor {
    func openUserFilterController(rule: String) -> Bool {
        true
    }
    
    func openDnsSettingsController(showLaunchScreen: Bool, dnsProtectionIsEnabled: Bool?) -> Bool {
        true
    }
    
    func openMainPageController(showLaunchScreen: Bool, complexProtectionIsEnabled: Bool?) -> Bool {
        true
    }
    
    func openLoginController(showLaunchScreen: Bool, license: String?) -> Bool {
        true
    }
    
    func openDnsProvidersController(showLaunchScreen: Bool, urlAbsoluteString: String) -> Bool {
        true
    }
    
    func openImportSettingsController(showLaunchScreen: Bool, settings: Settings?) -> Bool {
        true
    }
    
    func openFiltersMasterController(showLaunchScreen: Bool, url: String?, title: String?) -> Bool {
        true
    }
    
    func openTunnelModeController(showLaunchScreen: Bool) -> Bool {
        true
    }
    
    func login(withAccessToken: String?, state: String?) -> Bool {
        true
    }
    

}
