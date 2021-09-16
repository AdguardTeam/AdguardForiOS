/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © Adguard Software Limited. All rights reserved.
 
    Adguard for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
 
    Adguard for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
 
    You should have received a copy of the GNU General Public License
    along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation
import SafariAdGuardSDK

protocol SafariWebExtensionMessageProcessorProtocol {
    func process(message: Message) -> [String: Any?]
}

final class SafariWebExtensionMessageProcessor: SafariWebExtensionMessageProcessorProtocol {

    private var fileReader: ChunkFileReader?

    func process(message: Message) -> [String: Any?]  {
        switch message.type {
        case .getInitData: return getInitData(message.data)
        case .getAdvancedRules: return getAdvancedRules()
        default:
            DDLogError("Received bad case")
            return [Message.messageTypeKey: MessageType.error.rawValue]
        }
    }
    
    // MARK: - Private methods
    
    // TODO: - We need to pass domain here
    private func getInitData(_ domain: String?) -> [String: Any] {
        let resources = AESharedResources()
        let cbService = ContentBlockerService(appBundleId: Bundle.main.hostAppBundleId)
        
        // Safari Content Blockers states
        let allContentBlockersEnabled = cbService.allContentBlockersStates.values.reduce(true, { $0 && $1 })
        
        // User Pro status
        let isPro = Bundle.main.isPro ? true : resources.isProPurchased
        
        // Check if there are blocklist rules associated with passed domain
        let blocklistManager = SafariUserRulesManagersProvider(userDefaults: resources.sharedDefaults()).blocklistRulesManager
        let hasUserRules = domain == nil ? false : blocklistManager.hasUserRules(for: domain!)
        
        return [
            Message.appearanceTheme: "system",
            Message.contentBlockersEnabled: allContentBlockersEnabled,
            Message.hasUserRules: hasUserRules,
            Message.premiumApp: isPro,
            Message.protectionEnabled: isSafariProtectionEnabled(for: domain, resources: resources),

            Message.removeFromAllowlistLink: UserRulesRedirectAction.removeFromAllowlist(domain: "").scheme,
            Message.addToAllowlistLink: UserRulesRedirectAction.addToAllowlist(domain: "").scheme,
            Message.addToBlocklistLink: UserRulesRedirectAction.addToBlocklist(domain: "").scheme,
            Message.removeAllBlocklistRulesLink: UserRulesRedirectAction.removeAllBlocklistRules(domain: "").scheme,
            Message.upgradeAppLink: "\(Bundle.main.appScheme)://upgradeApp",
            Message.reportProblemLink: constructReportLink()
        ]
    }

    private func getAdvancedRules() -> [String: Any?] {
        let advancedRulesFileUrl = SharedStorageUrls().advancedRulesFileUrl
        if fileReader == nil {
            fileReader = ChunkFileReader(fileUrl: advancedRulesFileUrl)
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
        let rules = safariUserRulesStorage.rules.map { $0.ruleText }
        let isDomainInRules = rules.contains(domain)
        return isAllowlistInverted ? isDomainInRules : !isDomainInRules
    }
    
    private func constructReportLink() -> String {
        let url = "https://reports.adguard.com/new_issue.html"
        let params: [String: String] = [
            "product_type": "iOS",
            "product_version": ADProductInfo().version() ?? "0",
            "browser": "Safari"
        ]
        let paramsString = params.constructLink(url: url)
        return paramsString ?? ""
    }
}
