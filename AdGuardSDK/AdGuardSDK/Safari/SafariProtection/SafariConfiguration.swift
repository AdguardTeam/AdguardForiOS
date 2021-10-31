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
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///

import SharedAdGuardSDK

// MARK: - ConfigurationProtocol

public protocol SafariConfigurationProtocol: ConfigurationProtocol {
    var iosVersion: Int { get set } // iOS version is used in SafariConverter lib, it can be obtained with UIDevice.current.systemVersion
    var safariProtectionEnabled: Bool { get set }
    var advancedBlockingIsEnabled: Bool { get set } // Feature is available since iOS 15
    var blocklistIsEnabled: Bool { get set }
    var allowlistIsEnabled: Bool { get set }
    var allowlistIsInverted: Bool { get set }

    // Application information
    var appBundleId: String { get set } // Application bundle identifier
    var appProductVersion: String { get set } // Application product version for example 4.1.1 for AdGuard
    var appId: String { get set } // Application id for example "ios_pro" or "ios"
    var cid: String { get set } // UIDevice.current.identifierForVendor?.uuidString should be passed
}

// MARK: - Configuration

public final class SafariConfiguration: SafariConfigurationProtocol {
    public var iosVersion: Int
    public var currentLocale: Locale
    public var proStatus: Bool
    public var safariProtectionEnabled: Bool
    public var advancedBlockingIsEnabled: Bool
    public var blocklistIsEnabled: Bool
    public var allowlistIsEnabled: Bool
    public var allowlistIsInverted: Bool

    public var appBundleId: String
    public var appProductVersion: String
    public var appId: String
    public var cid: String

    public init(
        iosVersion: Int,
        currentLocale: Locale,
        proStatus: Bool,
        safariProtectionEnabled: Bool,
        advancedBlockingIsEnabled: Bool,
        blocklistIsEnabled: Bool,
        allowlistIsEnabled: Bool,
        allowlistIsInverted: Bool,
        appBundleId: String,
        appProductVersion: String,
        appId: String,
        cid: String
    ) {
        self.iosVersion = iosVersion
        self.currentLocale = currentLocale
        self.proStatus = proStatus
        self.safariProtectionEnabled = safariProtectionEnabled
        self.advancedBlockingIsEnabled = advancedBlockingIsEnabled
        self.blocklistIsEnabled = blocklistIsEnabled
        self.allowlistIsEnabled = allowlistIsEnabled
        self.allowlistIsInverted = allowlistIsInverted
        self.appBundleId = appBundleId
        self.appProductVersion = appProductVersion
        self.appId = appId
        self.cid = cid
    }
}

extension SafariConfigurationProtocol {
    func updateConfig(with newConfig: SafariConfigurationProtocol) {
        self.currentLocale = newConfig.currentLocale
        self.proStatus = newConfig.proStatus
        self.iosVersion = newConfig.iosVersion
        self.safariProtectionEnabled = newConfig.safariProtectionEnabled
        self.advancedBlockingIsEnabled = newConfig.advancedBlockingIsEnabled
        self.blocklistIsEnabled = newConfig.blocklistIsEnabled
        self.allowlistIsEnabled = newConfig.allowlistIsEnabled
        self.allowlistIsInverted = newConfig.allowlistIsInverted
        self.appBundleId = newConfig.appBundleId
        self.appProductVersion = newConfig.appProductVersion
        self.appId = newConfig.appId
        self.cid = newConfig.cid
    }
}
