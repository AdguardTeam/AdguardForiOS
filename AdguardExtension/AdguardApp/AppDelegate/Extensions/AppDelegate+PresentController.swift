//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import enum SharedAdGuardSDK.UserRuleType

// TODO: - We should check all these methods because practically all the screens changed
extension AppDelegate {

    static let shared = UIApplication.shared.delegate as! AppDelegate

    private var proStatus: Bool {
        let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
        return configuration.proStatus
    }

    /* returns launch screen from LaunchScreen.storyboard */
    func getLaunchScreen() -> UIViewController? {
        let launchScreenStoryboard = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main)
        let launchScreenController = launchScreenStoryboard.instantiateViewController(withIdentifier: "LaunchScreen")
        return launchScreenController
    }

    /* Returns MainPageController from current navigation stack */
    func getMainPageController() -> MainPageController? {
        guard let navController = getNavigationController(for: .mainTab) else {
            DDLogError("Navigation controller is nil")
            return nil
        }

        let mainPageController = navController.viewControllers.first as? MainPageController
        return mainPageController
    }

    /* Returns DnsLogContainerController from current navigation stack */
    func getDnsLogContainerController() -> DnsLogContainerController? {
        guard let navController = getNavigationController(for: .activityTab) else {
            DDLogError("Navigation controller is nil")
            return nil
        }

        let dnsLogContainerController = navController.viewControllers.first as? DnsLogContainerController
        return dnsLogContainerController
    }

    /*
     Presents DnsSettingsController
     Returns true on success and false otherwise
     */
    @discardableResult func presentDnsSettingsController(showLaunchScreen: Bool = false, dnsProtectionIsEnabled enabled: Bool? = nil) -> Bool {
        guard let tabBar = getMainTabController() else {
            DDLogError("Tab bar is nil")
            return false
        }

        guard let navController = getNavigationController(for: .settingTab) else {
            DDLogError("Navigation controller is nil")
            return false
        }

        if showLaunchScreen, let launchScreen = getLaunchScreen() {
            window?.rootViewController = launchScreen
        }

        guard let mainMenuController = navController.viewControllers.first as? MainMenuController else {
            DDLogError("Navigation controller first VC is not MainMenuController")
            return false
        }

        let dnsSettingsStoryBoard = UIStoryboard(name: "DnsSettings", bundle: Bundle.main)
        guard let dnsSettingsController = dnsSettingsStoryBoard.instantiateViewController(withIdentifier: "DnsSettingsController") as? DnsSettingsController else {
            DDLogError("DnsSettings.storyboard doesn't have DnsSettingsController")
            return false
        }
        dnsSettingsController.stateFromWidget = enabled
        navController.viewControllers = [mainMenuController, dnsSettingsController]

        dnsSettingsController.loadViewIfNeeded()
        tabBar.selectedViewController = navController
        window?.rootViewController = tabBar

        return true
    }

    /*
     Presents MainPageController
     Returns true on success and false otherwise
     */
    func presentMainPageController(showLaunchScreen: Bool = false, complexProtectionIsEnabled enabled: Bool? = nil) -> Bool {
        guard let tabBar = getMainTabController() else {
            DDLogError("Tab bar is nil")
            return false
        }

        guard let navController = getNavigationController(for: .mainTab) else {
            DDLogError("Navigation controller is nil")
            return false
        }

        if showLaunchScreen, let launchScreen = getLaunchScreen() {
            window?.rootViewController = launchScreen
        }

        let mainPageStoryboard = UIStoryboard(name: "MainPage", bundle: Bundle.main)
        guard let mainPageController = mainPageStoryboard.instantiateViewController(withIdentifier: "MainPageController") as? MainPageController else {
            DDLogError("MainPage.storyboard doesn't have MainPageController")
            return false
        }
        mainPageController.stateFromWidget = enabled
        mainPageController.loadViewIfNeeded()

        navController.viewControllers = [mainPageController]
        tabBar.selectedViewController = navController
        window?.rootViewController = tabBar

        return true
    }

    /*
     Presents EmailSignInController
     Returns true on success and false otherwise
     */
    func presentLoginController(showLaunchScreen: Bool = false, withLicenseKey key: String? = nil) -> Bool {
        if proStatus {
            return openMainPageController(showLaunchScreen: false, complexProtectionIsEnabled: nil)
        }

        guard let tabBar = getMainTabController() else {
            DDLogError("Tab bar is nil")
            return false
        }

        guard let navController = getNavigationController(for: .mainTab) else {
            DDLogError("Navigation controller is nil")
            return false
        }

        if showLaunchScreen, let launchScreen = getLaunchScreen() {
            window?.rootViewController = launchScreen
        }

        let mainPageStoryboard = UIStoryboard(name: "MainPage", bundle: Bundle.main)
        guard let mainPageController = mainPageStoryboard.instantiateViewController(withIdentifier: "MainPageController") as? MainPageController else {
            DDLogError("MainPage.storyboard doesn't have MainPageController")
            return false
        }

        let licenseStoryboard = UIStoryboard(name: "License", bundle: Bundle.main)
        guard let getProController = licenseStoryboard.instantiateViewController(withIdentifier: "GetProController") as? GetProController else {
            DDLogError("License.storyboard doesn't have GetProController")
            return false
        }

        guard let loginController = licenseStoryboard.instantiateViewController(withIdentifier: "EmailSignInScene") as? EmailSignInController else {
            DDLogError("License.storyboard doesn't have EmailSignInController")
            return false
        }
        loginController.licenseKey = key
        loginController.loadViewIfNeeded()

        navController.viewControllers = [mainPageController, getProController, loginController]
        tabBar.selectedViewController = navController
        window?.rootViewController = tabBar

        return true
    }

    /*
     Presents DnsProvidersController
     Returns true on success and false otherwise
     */
    func presentDnsProvidersController(showLaunchScreen: Bool = false, url: String? = nil) -> Bool {
        if !proStatus { return presentPurchaseLicenseController() }

        guard let tabBar = getMainTabController() else {
            DDLogError("Tab bar is nil")
            return false
        }

        guard let navController = getNavigationController(for: .settingTab) else {
            DDLogError("Navigation controller is nil")
            return false
        }

        if showLaunchScreen, let launchScreen = getLaunchScreen() {
            window?.rootViewController = launchScreen
        }

        guard let mainMenuController = navController.viewControllers.first as? MainMenuController else {
            DDLogError("Navigation controller first VC is not MainMenuController")
            return false
        }

        let dnsSettingsStoryBoard = UIStoryboard(name: "DnsSettings", bundle: Bundle.main)
        guard let dnsSettingsController = dnsSettingsStoryBoard.instantiateViewController(withIdentifier: "DnsSettingsController") as? DnsSettingsController else {
            DDLogError("DnsSettings.storyboard doesn't have DnsSettingsController")
            return false
        }

        guard let dnsProvidersController = dnsSettingsStoryBoard.instantiateViewController(withIdentifier: "DnsProvidersController") as? DnsProvidersController else {
            DDLogError("DnsSettings.storyboard doesn't have DnsProvidersController")
            return false
        }
        dnsProvidersController.openUrl = url

        navController.viewControllers = [mainMenuController, dnsSettingsController, dnsProvidersController]
        dnsProvidersController.loadViewIfNeeded()
        tabBar.selectedViewController = navController
        window?.rootViewController = tabBar

        return true
    }

    /*
     Presents FiltersMasterController
     Returns true on success and false otherwise
     */
    func presentFiltersMasterController(showLaunchScreen: Bool = false, url: String? = nil, title: String? = nil) -> Bool {
        if !proStatus { return presentPurchaseLicenseController() }
        
        guard let tabBar = getMainTabController() else {
            DDLogError("Tab bar is nil")
            return false
        }

        guard let navController = getNavigationController(for: .settingTab) else {
            DDLogError("Navigation controller is nil")
            return false
        }

        if showLaunchScreen, let launchScreen = getLaunchScreen() {
            window?.rootViewController = launchScreen
        }

        guard let mainMenuController = navController.viewControllers.first as? MainMenuController else {
            DDLogError("Navigation controller first VC is not MainMenuController")
            return false
        }

        let filtersStoryboard = UIStoryboard(name: "Filters", bundle: Bundle.main)
        guard let safariProtectionController = filtersStoryboard.instantiateViewController(withIdentifier: "SafariProtectionController") as? SafariProtectionController else {
            DDLogError("Filters.storyboard doesn't have SafariProtectionController")
            return false
        }

        guard let safariGroupTableController = filtersStoryboard.instantiateViewController(withIdentifier: "SafariGroupTableController") as? SafariGroupTableController else {
            DDLogError("Filters.storyboard doesn't have SafariGroupTableController")
            return false
        }
        safariGroupTableController.loadViewIfNeeded()

        guard let safariGroupFiltersTableController = filtersStoryboard.instantiateViewController(withIdentifier: "SafariGroupFiltersTableController") as? SafariGroupFiltersTableController else {
            DDLogError("Filters.storyboard doesn't have SafariGroupFiltersTableController")
            return false
        }

        safariGroupFiltersTableController.titleForImport = title
        safariGroupFiltersTableController.urlStringForImport = url
        safariGroupFiltersTableController.displayType = .one(groupType: .custom)

        window?.rootViewController = tabBar
        tabBar.selectedViewController = navController
        navController.viewControllers = [mainMenuController, safariProtectionController, safariGroupTableController, safariGroupFiltersTableController]

        return true
    }

    /*
     Presents DnsFiltersController
     Returns true on success and false otherwise
     */

    // FIXME: We use this method for presenting dns controller if handle overlimit error from AppDelegate method `postDnsFiltersOverlimitNotificationIfNedeed`
    func presentDnsFiltersController(showLaunchScreen: Bool = false) -> Bool {

//        guard let tabBar = getMainTabController() else {
//            DDLogError("Tab bar is nil")
//            return false
//        }
//
//        guard let navController = getNavigationController(for: .protectionTab) else {
//            DDLogError("Navigation controller is nil")
//            return false
//        }
//
//        if showLaunchScreen, let launchScreen = getLaunchScreen() {
//            window?.rootViewController = launchScreen
//        }
//
//        guard let complexProtectionController = navController.viewControllers.first as? ComplexProtectionController else {
//            DDLogError("Navigation controller first VC is not ComplexProtectionController")
//            return false
//        }
//
//        let dnsSettingsStoryboard = UIStoryboard(name: "DnsSettings", bundle: nil)
//        guard let dnsSettingsController = dnsSettingsStoryboard.instantiateViewController(withIdentifier: "DnsSettingsController") as? DnsSettingsController else {
//            DDLogError("DnsSettings.storyboard doesnt't have DnsSettingsController")
//            return false
//        }
//
//        guard let requestsBlockingController = dnsSettingsStoryboard.instantiateViewController(withIdentifier: "RequestsBlockingController") as? RequestsBlockingController else {
//            DDLogError("DnsSettings.storyboard doesnt't have RequestsBlockingController")
//            return false
//        }
//
//        guard let dnsFiltersController = dnsSettingsStoryboard.instantiateViewController(withIdentifier: "DnsFiltersController") as? DnsFiltersController else {
//            DDLogError("DnsSettings.storyboard doesnt't have DnsFiltersController")
//            return false
//        }
//        dnsFiltersController.loadViewIfNeeded()
//
//        navController.viewControllers = [complexProtectionController, dnsSettingsController, requestsBlockingController, dnsFiltersController]
//        tabBar.selectedViewController = navController
//        window?.rootViewController = tabBar
//
        return true
    }

    /*
     Presents RateAppController
     */
    func presentRateAppController() {
        guard let topVC = Self.topViewController() else {
            DDLogError("Failed to get top view controller")
            return
        }
        let rateAppStoryboard = UIStoryboard(name: "RateApp", bundle: nil)
        guard let rateAppController = rateAppStoryboard.instantiateViewController(withIdentifier: "RateAppController") as? RateAppController else {
            DDLogError("RateApp.storyboard doesnt't have RateAppController")
            return
        }
        // Check if VC does not present any controller
        if topVC.presentedViewController == nil {
            topVC.present(rateAppController, animated: true)
            return
        }
    }

    /*
     Presents RateAppProblemController
     */
    func presentRateAppProblemController() {
        guard let topVC = Self.topViewController() else {
            DDLogError("Failed to get top view controller")
            return
        }
        let rateAppStoryboard = UIStoryboard(name: "RateApp", bundle: nil)
        guard let rateAppController = rateAppStoryboard.instantiateViewController(withIdentifier: "RateAppProblemController") as? RateAppProblemController else {
            DDLogError("RateApp.storyboard doesnt't have RateAppProblemController")
            return
        }
        // Check if VC does not present any controller
        if topVC.presentedViewController == nil {
            topVC.present(rateAppController, animated: true)
            return
        }
    }

    func presentBugReportController(withType type: ReportType) {
        guard let tabBar = getMainTabController() else {
            DDLogError("Tab bar is nil")
            return
        }

        guard let navController = getNavigationController(for: .settingTab) else {
            DDLogError("Navigation controller is nil")
            return
        }

        guard let mainMenuController = navController.viewControllers.first as? MainMenuController else {
            DDLogError("Navigation controller first VC is not MainMenuController")
            return
        }

        let mainMenuStoryBoard = UIStoryboard(name: "MainMenu", bundle: nil)
        guard let supportVC = mainMenuStoryBoard.instantiateViewController(withIdentifier: "SupportTableViewController") as? SupportTableViewController else {
            DDLogError("MainMenu.storyboard doesnt't have SupportTableViewController")
            return
        }

        guard let bugReportVC = mainMenuStoryBoard.instantiateViewController(withIdentifier: "BugReportController") as? BugReportController else {
            DDLogError("MainMenu.storyboard doesnt't have BugReportController")
            return
        }

        supportVC.loadViewIfNeeded()
        bugReportVC.reportType = type

        navController.viewControllers = [mainMenuController, supportVC, bugReportVC]
        tabBar.selectedViewController = navController
        window?.rootViewController = tabBar
    }

    /*
     Presents DnsModeController
     Returns true on success and false otherwise
     */
    func presentTunnelModeController(showLaunchScreen: Bool = false) -> Bool {
        guard let tabBar = getMainTabController() else {
            DDLogError("Tab bar is nil")
            return false
        }

        guard let navController = getNavigationController(for: .settingTab) else {
            DDLogError("Navigation controller is nil")
            return false
        }

        if showLaunchScreen, let launchScreen = getLaunchScreen() {
            window?.rootViewController = launchScreen
        }

        guard let mainMenuController = navController.viewControllers.first as? MainMenuController else {
            DDLogError("Navigation controller first VC is not MainMenuController")
            return false
        }

        let settingsStoryBoard = UIStoryboard(name: "Settings", bundle: .main)
        guard let settingsController = settingsStoryBoard.instantiateViewController(withIdentifier: "SettingsController") as? SettingsController,
              let advancedSettingsController = settingsStoryBoard.instantiateViewController(withIdentifier: "AdvancedSettingsController") as? AdvancedSettingsController,
              let dnsModeController = settingsStoryBoard.instantiateViewController(withIdentifier: "DnsModeController") as? DnsModeController
        else {
            DDLogError("Missing controller from Settings.storyboard")
            return false
        }

        mainMenuController.loadViewIfNeeded()
        settingsController.loadViewIfNeeded()
        advancedSettingsController.loadViewIfNeeded()

        navController.viewControllers = [mainMenuController, settingsController, advancedSettingsController, dnsModeController]
        tabBar.selectedViewController = navController
        window?.rootViewController = tabBar

        return true
    }

    /*
     Sets main page as current
     */
    func setMainPageAsCurrentAndPopToRootControllersEverywhere() {
        window?.rootViewController?.dismiss(animated: true) { [weak self] in
            self?.dismissToMainPage()
            self?.updateTheme()
        }
    }

    /*
     Finds all navigation controllers and calls 'popToRootViewController' for each
     */
    func dismissToMainPage(animated: Bool = false) {
        guard let tabBar = self.getMainTabController() else {
            DDLogError("Tab bar is nil")
            return
        }

        guard let navController = self.getNavigationController(for: .mainTab) else {
            DDLogError("Navigation controller is nil")
            return
        }

        if let tabs = tabBar.viewControllers {
            for viewController in tabs {
                if let navController = viewController as? UINavigationController {
                    navController.popToRootViewController(animated: animated)
                }
            }
        }

        tabBar.selectedViewController = navController
    }

    /* Presents HowToSetupController for top view controller in navigation stack */
    func presentHowToSetupController() {
        let dnsStoryboard = UIStoryboard(name: "DnsSettings", bundle: nil)
        guard let howToSetupVC = dnsStoryboard.instantiateViewController(withIdentifier: "HowToSetupController") as? HowToSetupController else {
            DDLogError("DnsSettings.storyboard doesn't have HowToSetupController")
            return
        }
        guard let topVC = AppDelegate.topViewController() else {
            DDLogError("Failed to get top view controller")
            return
        }
        topVC.present(howToSetupVC, animated: true, completion: nil)
    }

    /*
     Presents DnsModeController
     Returns true on success and false otherwise
     */
    func presentImportSettingsController(showLaunchScreen: Bool = false, settings: ImportSettings) -> Bool {
        guard let tabBar = getMainTabController() else {
            DDLogError("Tab bar is nil")
            return false
        }

        guard let navController = getNavigationController(for: .mainTab) else {
            DDLogError("Navigation controller is nil")
            return false
        }

        if showLaunchScreen, let launchScreen = getLaunchScreen() {
            window?.rootViewController = launchScreen
        }

        let mainPageStoryboard = UIStoryboard(name: "MainPage", bundle: Bundle.main)
        guard let mainPageController = mainPageStoryboard.instantiateViewController(withIdentifier: "MainPageController") as? MainPageController else {
            DDLogError("MainPage.storyboard doesn't have MainPageController")
            return false
        }
        mainPageController.importSettings = settings

        navController.viewControllers = [mainPageController]
        tabBar.selectedViewController = navController
        window?.rootViewController = tabBar

        return true
    }

    func presentUserRulesRedirectController(for action: UserRulesRedirectAction) -> Bool {
        guard let topVC = Self.topViewController() else {
            DDLogError("Failed to get top view controller")
            return false
        }
        let userFilterStoryboard = UIStoryboard(name: "UserFilter", bundle: nil)
        guard let userRulesRedirectVC = userFilterStoryboard.instantiateViewController(withIdentifier: "UserRulesRedirectController") as? UserRulesRedirectController else {
            DDLogError("UserFilter.storyboard doesn't have UserRulesRedirectController")
            return false
        }
        // Check if VC does not present any controller
        if topVC.presentedViewController == nil {
            userRulesRedirectVC.action = action
            topVC.present(userRulesRedirectVC, animated: true)
            return true
        }

        return false
    }

    func presentPurchaseLicenseController() -> Bool {
        if proStatus { return false }

        guard let tabBar = getMainTabController() else {
            DDLogError("Tab bar is nil")
            return false
        }

        guard let navController = getNavigationController(for: .mainTab) else {
            DDLogError("Navigation controller is nil")
            return false
        }

        let mainPageStoryboard = UIStoryboard(name: "MainPage", bundle: Bundle.main)
        guard let mainPageController = mainPageStoryboard.instantiateViewController(withIdentifier: "MainPageController") as? MainPageController else {
            DDLogError("MainPage.storyboard doesnt't have MainPageController")
            return false
        }

        let licenseStoryboard = UIStoryboard(name: "License", bundle: Bundle.main)
        guard let getProController = licenseStoryboard.instantiateViewController(withIdentifier: "GetProController") as? GetProController else {
            DDLogError("License.storyboard doesnt't have GetProController")
            return false
        }

        navController.viewControllers = [mainPageController, getProController]
        tabBar.selectedViewController = navController
        window?.rootViewController = tabBar

        return true
    }

    func presentUserRulesTableController(for type: UserRuleType) {
        guard let tabBar = getMainTabController() else {
            DDLogError("Tab bar is nil")
            return
        }

        guard let navController = getNavigationController(for: .protectionTab) else {
            DDLogError("Navigation controller is nil")
            return
        }

        let protectionStoryboard = UIStoryboard(name: "Protection", bundle: .main)
        guard let complexProtectionController = protectionStoryboard.instantiateViewController(withIdentifier: "ComplexProtectionController") as? ComplexProtectionController else {
            DDLogError("Protection.storyboard doesnt't have ComplexProtectionController")
            return
        }

        let filtersStoryboard = UIStoryboard(name: "Filters", bundle: .main)
        guard let safariProtectionController = filtersStoryboard.instantiateViewController(withIdentifier: "SafariProtectionController") as? SafariProtectionController else {
            DDLogError("Filters.storyboard doesnt't have SafariProtectionController")
            return
        }

        let userFilterStoryboard = UIStoryboard(name: "UserFilter", bundle: .main)
        guard let userRulesTableController = userFilterStoryboard.instantiateViewController(withIdentifier: "UserRulesTableController") as? UserRulesTableController else {
            DDLogError("UserFilter.storyboard doesnt't have UserRulesTableController")
            return
        }

        userRulesTableController.rulesType = type
        navController.viewControllers = [complexProtectionController, safariProtectionController, userRulesTableController]
        complexProtectionController.loadViewIfNeeded()
        safariProtectionController.loadViewIfNeeded()
        userRulesTableController.loadViewIfNeeded()
        tabBar.selectedViewController = navController
        window?.rootViewController = tabBar
    }

    func presentAdvancedProtectionController() -> Bool {
        guard let tabBar = getMainTabController() else {
            DDLogError("Tab bar is nil")
            return false
        }

        guard let navController = getNavigationController(for: .protectionTab) else {
            DDLogError("Navigation controller is nil")
            return false
        }

        let protectionStoryboard = UIStoryboard(name: "Protection", bundle: .main)
        guard let complexProtectionController = protectionStoryboard.instantiateViewController(withIdentifier: "ComplexProtectionController") as? ComplexProtectionController else {
            DDLogError("Protection.storyboard doesnt't have ComplexProtectionController")
            return false
        }
        guard let advancedProtectionController = protectionStoryboard.instantiateViewController(withIdentifier: "AdvancedProtectionController") as? AdvancedProtectionController else {
            DDLogError("Protection.storyboard doesnt't have AdvancedProtectionController")
            return false
        }

        navController.viewControllers = [complexProtectionController, advancedProtectionController]
        complexProtectionController.loadViewIfNeeded()
        advancedProtectionController.loadViewIfNeeded()
        tabBar.selectedViewController = navController
        window?.rootViewController = tabBar

        return true
    }

    /* Returns top view controller for controller  */
    static func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    /* Presenting loading alert */
    func presentLoadingAlert() {
        let alert = UIAlertController(title: nil, message: String.localizedString("loading_message"), preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    /* Returns navigation controller for certain tab */
    private func getNavigationController(for tab: TabBarTabs) -> MainNavigationController? {
        let tabBar = getMainTabController()
        let navController = tabBar?.viewControllers?[tab.rawValue] as? MainNavigationController
        assert(navController != nil, "Tab bar doesn't have navigation controller for tab = \(tab.rawValue)")
        return navController
    }

    /* Returns main tab bar controller */
    private func getMainTabController() -> MainTabBarController? {
        let mainTabBar = window?.rootViewController as? MainTabBarController
        assert(mainTabBar != nil, "Root view controller is not MainTabBarController")
        return mainTabBar
    }
}
