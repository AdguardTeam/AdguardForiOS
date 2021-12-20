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

protocol SafariWebExtensionMessageProcessorProtocol {
    func process(message: Message) -> [String: Any?]
}

final class SafariWebExtensionMessageProcessor: SafariWebExtensionMessageProcessorProtocol {

    // TODO: - This is a temporary workaround; Should be fixed later
    private var shouldUpdateAdvancedRules: Bool {
        get {
            resources.sharedDefaults().bool(forKey: "SafariAdGuardSDK.shouldUpdateAdvancedRulesKey")
        }
        set {
            resources.sharedDefaults().set(newValue, forKey: "SafariAdGuardSDK.shouldUpdateAdvancedRulesKey")
        }
    }

    private var fileReader: ChunkFileReader?

    private let resources: AESharedResourcesProtocol

    init(resources: AESharedResourcesProtocol) {
        self.resources = resources
    }

    func process(message: Message) -> [String: Any?]  {
        switch message.type {
        case .getInitData:
            // URL of the website extension is open
            let url = message.data as? String
            return getInitData(url)
        case .getAdvancedRules:
            // True if rules file should be read from the beginning
            let fromBeginning = message.data as? Bool
            return getAdvancedRules(fromBeginning ?? false)
        case .shouldUpdateAdvancedRules:
            let shouldUpdate = shouldUpdateAdvancedRules
            // TODO: - Maybe we should set it to false later?
            shouldUpdateAdvancedRules = false
            return [Message.shouldUpdateAdvancedRules: shouldUpdate]
        default:
            DDLogError("Received bad case")
            return [Message.messageTypeKey: MessageType.error.rawValue]
        }
    }

    // MARK: - Private methods

    private func getInitData(_ url: String?) -> [String: Any] {
        let resources = AESharedResources()
        // We set it to be sure the user opened Extension
        resources.safariWebExtensionIsOn = true

        let cbService = ContentBlockerService(appBundleId: Bundle.main.hostAppBundleId)
        let domain = URL(string: url ?? "")?.domain

        // Selected theme
        let themeName = resources.themeMode.messageName

        // Safari Content Blockers states
        let someContentBlockersEnabled = cbService.allContentBlockersStates.values.reduce(false, { $0 || $1 })

        // User Pro status
        let isPro = Bundle.main.isPro ? true : resources.isProPurchased

        // Check if there are blocklist rules associated with passed domain
        let blocklistManager = SafariUserRulesManagersProvider(userDefaults: resources.sharedDefaults()).blocklistRulesManager
        let hasUserRules = domain == nil ? false : blocklistManager.hasUserRules(for: domain!)

        return [
            Message.appearanceTheme: themeName,
            Message.contentBlockersEnabled: someContentBlockersEnabled,
            Message.hasUserRules: hasUserRules,
            Message.premiumApp: isPro,
            Message.protectionEnabled: isSafariProtectionEnabled(for: domain, resources: resources),
            Message.advancedBlockingEnabled: resources.advancedProtection,
            Message.allowlistIsInverted: resources.invertedWhitelist,
            Message.platform: UIDevice.current.platformString,
            Message.safariProtectionEnabled: resources.safariProtectionEnabled,

            Message.enableSiteProtectionLink: UserRulesRedirectAction.enableSiteProtection(domain: "", absoluteDomainString: "").scheme,
            Message.disableSiteProtectionLink: UserRulesRedirectAction.disableSiteProtection(domain: "", absoluteDomainString: "").scheme,
            Message.addToBlocklistLink: UserRulesRedirectAction.addToBlocklist(domain: "", absoluteDomainString: "").scheme,
            Message.removeAllBlocklistRulesLink: UserRulesRedirectAction.removeAllBlocklistRules(domain: "", absoluteDomainString: "").scheme,
            Message.upgradeAppLink: "\(Bundle.main.inAppScheme)://upgradeApp",
            Message.enableAdvancedBlockingLink: "\(Bundle.main.inAppScheme)://enableAdvancedProtection",
            Message.reportProblemLink: constructReportLink(url ?? "unknown"),
            Message.enableSafariProtectionLink: UserRulesRedirectAction.enableSiteAndSafariProtection(domain: "").scheme
        ]
    }

    /// Returns chunk of advanced rules or nil if offset is at the end or the is problem with file
    /// Will return next chunk of file when calling once more
    /// - Parameter fromBeginning: If true the file will be read from the beginning
    private func getAdvancedRules(_ fromBeginning: Bool) -> [String: Any?] {
        let advancedRulesFileUrl = SharedStorageUrls().advancedRulesFileUrl

        // Create file reader object if doesn't exist
        if fileReader == nil {
            fileReader = ChunkFileReader(fileUrl: advancedRulesFileUrl, chunkSize: 65536)
        }
        // Rewind file reader if fromBeginning is true
        else if fromBeginning {
            let success = fileReader?.rewind() ?? false
            if !success {
                return [Message.advancedRulesKey: nil]
            }
        }

        if let chunk = fileReader?.nextChunk() {
            return [Message.advancedRulesKey: chunk]
        } else {
            fileReader?.close()
            fileReader = nil
            return [Message.advancedRulesKey: nil]
        }
    }

    private func isSafariProtectionEnabled(for domain: String?, resources: AESharedResources) -> Bool {
        guard let domain = domain else { return false }

        let isAllowlistInverted = resources.invertedWhitelist
        let safariUserRulesStorage = SafariUserRulesStorage(
            userDefaults: resources.sharedDefaults(),
            rulesType: isAllowlistInverted ? .invertedAllowlist : .allowlist
        )
        let enabledRules = safariUserRulesStorage.rules.compactMap { $0.isEnabled ? $0.ruleText : nil }
        let isDomainInRules = enabledRules.contains(domain)
        return isAllowlistInverted ? isDomainInRules : !isDomainInRules
    }

    private func constructReportLink(_ problemUrl: String) -> String {
        let url = "https://reports.adguard.com/new_issue.html"
        let params: [String: String] = [
            "product_type": "iOS",
            "product_version": ADProductInfo().version() ?? "0",
            "browser": "Safari",
            "url": problemUrl
        ]
        let paramsString = params.constructLink(url: url)
        return paramsString ?? ""
    }
}

fileprivate extension UIDevice {
    var platformString: String {
        switch userInterfaceIdiom {
        case .pad: return "ipad"
        case .phone: return "iphone"
        default: return "unsupported"
        }
    }
}
