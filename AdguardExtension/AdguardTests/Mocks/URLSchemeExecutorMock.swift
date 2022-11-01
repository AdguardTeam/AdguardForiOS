class URLSchemeExecutorMock: IURLSchemeExecutor {
    func openYouTubePlayerController(videoId: String) -> Bool {
        true
    }

    func openDnsProvidersController(showLaunchScreen: Bool, upstream: String, title: String?) -> Bool {
        true
    }


    func openUserFilterController(rule: String) -> Bool {
        true
    }

    func openDnsSettingsController(showLaunchScreen: Bool, dnsProtectionIsEnabled: Bool?) -> Bool {
        true
    }

    func openMainPageController(showLaunchScreen: Bool, complexProtectionIsEnabled: Bool?) -> Bool {
        true
    }

    func openLoginController(license: String?) -> Bool {
        true
    }

    func openDnsProvidersController(showLaunchScreen: Bool, urlAbsoluteString: String) -> Bool {
        true
    }

    func openImportSettingsController(showLaunchScreen: Bool, settings: ImportSettings) -> Bool {
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

    func openUserRulesRedirectController(for action: UserRulesRedirectAction) -> Bool {
        true
    }

    func openMainPageControllerAndTurnOnProtection(for domain: String) -> Bool {
        return true
    }

    func openPurchaseLicenseController() -> Bool {
        true
    }

    func openAdvancedProtectionController(enableAdvancedProtection: Bool?) -> Bool {
        true
    }
}
