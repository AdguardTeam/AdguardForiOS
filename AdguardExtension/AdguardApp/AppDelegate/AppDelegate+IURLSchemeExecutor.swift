extension AppDelegate: IURLSchemeExecutor {

    
    func openUserFilterController(rule: String) -> Bool {
        let antibannerController: AntibannerControllerProtocol = ServiceLocator.shared.getService()!
        let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
        let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
//        let antibanner: AESAntibannerProtocol = ServiceLocator.shared.getService()!
        let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
        let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
        
        antibannerController.onReady { antibanner in
            DispatchQueue.main.async {
                let model: ListOfRulesModelProtocol = UserFilterModel(resources: resources,
                                                                      contentBlockerService: contentBlockerService,
                                                                      antibanner: antibanner,
                                                                      theme: themeService,
                                                                      productInfo: productInfo)
                
                self.presentUserFilterController(showLaunchScreen: true, model, newRule: rule)
            }
        }
        return true
    }
    
    func openDnsSettingsController(showLaunchScreen: Bool, dnsProtectionIsEnabled: Bool?) -> Bool {
        self.presentDnsSettingsController(showLaunchScreen: showLaunchScreen, dnsProtectionIsEnabled: dnsProtectionIsEnabled)
    }
    
    func openMainPageController(showLaunchScreen: Bool, complexProtectionIsEnabled: Bool?) -> Bool {
        self.presentMainPageController(showLaunchScreen: showLaunchScreen, complexProtectionIsEnabled: complexProtectionIsEnabled)
    }
    
    func openLoginController(showLaunchScreen: Bool, license: String?) -> Bool {
        self.presentLoginController(showLaunchScreen: showLaunchScreen, withLicenseKey: license)
    }
    
    func openDnsProvidersController(showLaunchScreen: Bool, urlAbsoluteString: String) -> Bool {
        let dnsInfo = DnsResolver.resolve(upstream: urlAbsoluteString)
        guard let dnsServer = dnsInfo.dnsServer else {
            return false
        }
        return self.presentDnsProvidersController(showLaunchScreen: showLaunchScreen, url: dnsServer)
        
    }
    
    func openImportSettingsController(showLaunchScreen: Bool, settings: Settings?) -> Bool {
        return self.presentImportSettingsController(showLaunchScreen: showLaunchScreen, settings: settings)
    }
    
    func openFiltersMasterController(showLaunchScreen: Bool, url: String?, title: String?) -> Bool {
        return self.presentFiltersMasterController(showLaunchScreen: showLaunchScreen, url: url, title: title)
    }
    
    func openTunnelModeController(showLaunchScreen: Bool) -> Bool {
        let configuration: ConfigurationService = ServiceLocator.shared.getService()!
        configuration.advancedMode = true
        return self.presentTunnelModeController(showLaunchScreen: showLaunchScreen)
    }
    
    func login(withAccessToken: String?, state: String?) -> Bool {
        let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
        purchaseService.login(withAccessToken: withAccessToken, state: state)
        return true
    }
}
