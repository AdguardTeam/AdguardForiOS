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

import SafariAdGuardSDK

/// This service is responsible for current application configuration
final class ConfigurationService: ConfigurationServiceProtocol {

    // MARK: - Private properties

    /* Services */
    private var purchaseService : PurchaseStatusProtocol
    private var resources: AESharedResourcesProtocol
    private var safariProtection: SafariProtectionProtocol

    // Pro status observer
    private var purchaseServiceObserver: NotificationToken?

    // MARK: - Initialization

    init(purchaseService : PurchaseStatusProtocol, resources: AESharedResourcesProtocol, safariProtection: SafariProtectionProtocol) {
        self.purchaseService = purchaseService
        self.resources = resources
        self.safariProtection = safariProtection
        self.contentBlockerEnabled = safariProtection.allContentBlockersStates

        let notificationName = Notification.Name(PurchaseAssistant.kPurchaseServiceNotification)
        self.purchaseServiceObserver = NotificationCenter.default.observe(
            name: notificationName,
            object: nil,
            queue: nil)
        { [weak self] note in
            guard let self = self else { return }

            let command = note.userInfo?[PurchaseAssistant.kPSNotificationTypeKey] as! String
            if  command == PurchaseAssistant.kPSNotificationPremiumStatusChanged {
                self.safariProtection.update(proStatus: self.proStatus, onCbReloaded: nil)

                let enableAdvancedProtection = self.proStatus && self.resources.complexProtectionEnabled
                self.safariProtection.update(advancedProtectionEnabled: enableAdvancedProtection)
                self.isAdvancedProtectionEnabled = enableAdvancedProtection
                self.proStatusChanged()
            }
        }
    }

    // MARK: - Public properties

    /// This flag indicates that pro fetures are purchased
    var proStatus: Bool { Bundle.main.isPro ? true : purchaseService.isProPurchased }

    /// This flag indicated whether advanced protection is enabled. Note that this feature is pro only
    var isAdvancedProtectionEnabled: Bool {
        get {
            if !proStatus { return false }
            return resources.advancedProtection
        }
        set {
            if newValue != isAdvancedProtectionEnabled {
                if proStatus {
                    resources.advancedProtection = newValue
                } else {
                    resources.advancedProtection = false
                }
                Self.advancedProtectionStateChanged()
            }
        }
    }

    /// Every Content Blocker state
    var contentBlockerEnabled: [ContentBlockerType: Bool]

    /// This flag indicates that all Safari Content Blockers are enabled in Safari settings
    var allContentBlockersEnabled: Bool {
        contentBlockerEnabled.reduce(true, { $0 && $1.value })
    }

    /// This flag indicates that at least one Safari Content Blocker is enabled in Safari settings
    var someContentBlockersEnabled: Bool {
        contentBlockerEnabled.values.contains(true)
    }

    /// Dark or light theme of app UI
    var darkTheme: Bool {
        switch userThemeMode {
        case .systemDefault: return systemAppearenceIsDark
        case .light: return false
        case .dark: return true
        }
    }

    /// User theme mode of app UI
    var userThemeMode: ThemeMode {
        set {
            if newValue != userThemeMode {
                resources.themeMode = newValue
                Self.themeChanged()
            }
        }
        get {
            resources.themeMode
        }
    }

    /// System appearence style
    var systemAppearenceIsDark: Bool {
        get {
            resources.systemAppearenceIsDark
        }
        set {
            if newValue != systemAppearenceIsDark {
                resources.systemAppearenceIsDark = newValue
                Self.themeChanged()
            }
        }
    }

    /// Advanced mode state
    var advancedMode: Bool {
        get {
            resources.sharedDefaults().bool(forKey: AEDefaultsDeveloperMode)
        }
        set {
            if newValue != advancedMode {
                resources.sharedDefaults().set(newValue, forKey: AEDefaultsDeveloperMode)
                Self.advancedModeChanged()
            }
        }
    }

    /// Status bar is shown in the bottom of the app
    var showStatusBar: Bool {
        get {
            resources.sharedDefaults().object(forKey: AEDefaultsShowStatusBar) as? Bool ?? true
        }
        set{
            if newValue != showStatusBar {
                resources.sharedDefaults().set(newValue, forKey: AEDefaultsShowStatusBar)
                Self.showStatusBarChanged()
            }
        }
    }

    // MARK: - Public method

    /// Checks Safari Content blockers state (enabled/disabled)
    func checkContentBlockerEnabled() {
        let allCB = safariProtection.allContentBlockersStates
        let cbChanges = allCB != contentBlockerEnabled
        let allEnabled = allCB.reduce(true, { $0 && $1.value })

        if !allEnabled || cbChanges {
            contentBlockerEnabled = allCB
            Self.contentBlockersStateChanged()
        }
    }

    // MARK: - Private methods

    private func proStatusChanged() {
        NotificationCenter.default.post(name: .proStatusChanged, object: self)
    }

    private static func themeChanged() {
        NotificationCenter.default.post(name: .themeChanged, object: self)
    }

    private static func advancedModeChanged() {
        NotificationCenter.default.post(name: .advancedModeChanged, object: self)
    }

    private static func contentBlockersStateChanged() {
        NotificationCenter.default.post(name: .contentBlockersStateChanged, object: self)
    }

    private static func advancedProtectionStateChanged() {
        NotificationCenter.default.post(name: .advancedProtectionStateChanged, object: self)
    }

    private static func showStatusBarChanged() {
        NotificationCenter.default.post(name: .showStatusBarChanged, object: self)
    }
}

extension Notification.Name {
    static var themeChanged: Notification.Name { return .init(rawValue: "themeChanged") }
    static var proStatusChanged: Notification.Name { return .init(rawValue: "proStatusChanged") }
    static var advancedModeChanged: Notification.Name { return .init(rawValue: "advancedModeChanged") }
    static var contentBlockersStateChanged: Notification.Name { return .init(rawValue: "contentBlockersStateChanged") }
    static var advancedProtectionStateChanged: Notification.Name { return .init(rawValue: "advancedProtectionStateChanged") }
    static var showStatusBarChanged: Notification.Name { return .init(rawValue: "showStatusBarChanged") }
}
