///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import SafariAdGuardSDK

extension AppDelegate: IURLSchemeExecutor {


    func openUserFilterController(rule: String) -> Bool {
        self.presentUserRulesRedirectController(for: .addToBlocklist(domain: rule))
    }

    func openDnsSettingsController(showLaunchScreen: Bool, dnsProtectionIsEnabled: Bool?) -> Bool {
        self.presentDnsSettingsController(showLaunchScreen: showLaunchScreen, dnsProtectionIsEnabled: dnsProtectionIsEnabled)
    }

    func openMainPageController(showLaunchScreen: Bool, complexProtectionIsEnabled: Bool?) -> Bool {
        self.presentMainPageController(showLaunchScreen: showLaunchScreen, complexProtectionIsEnabled: complexProtectionIsEnabled)
    }

    func openLoginController(license: String?) -> Bool {
        self.presentLoginController(showLaunchScreen: true, withLicenseKey: license)
    }

    func openDnsProvidersController(showLaunchScreen: Bool, urlAbsoluteString: String) -> Bool {
        return self.presentDnsProvidersController(showLaunchScreen: showLaunchScreen, url: urlAbsoluteString)
    }

    func openImportSettingsController(showLaunchScreen: Bool, settings: Settings?) -> Bool {
        return self.presentImportSettingsController(showLaunchScreen: showLaunchScreen, settings: settings)
    }

    func openFiltersMasterController(showLaunchScreen: Bool, url: String?, title: String?) -> Bool {
        return self.presentFiltersMasterController(showLaunchScreen: showLaunchScreen, url: url, title: title)
    }

    func openTunnelModeController(showLaunchScreen: Bool) -> Bool {
        let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
        configuration.advancedMode = true
        return self.presentTunnelModeController(showLaunchScreen: showLaunchScreen)
    }

    func login(withAccessToken: String?, state: String?) -> Bool {
        let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
        purchaseService.login(withAccessToken: withAccessToken, state: state)
        return true
    }

    func openUserRulesRedirectController(for action: UserRulesRedirectAction) -> Bool {
        DDLogInfo("(AppDelegate) - open UserRulesRedirectController with action = \(action)")
        return self.presentUserRulesRedirectController(for: action)
    }

    func openPurchaseLicenseController() -> Bool {
        DDLogInfo("(AppDelegate) - open PurchaseLicenseController")
        return self.presentPurchaseLicenseController()
    }

    func openAdvancedProtectionController() -> Bool {
        DDLogInfo("(AppDelegate) - open openAdvancedProtectionController")
        return self.presentAdvancedProtectionController()
    }
}
