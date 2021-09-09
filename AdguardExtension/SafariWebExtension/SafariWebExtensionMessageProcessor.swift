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

    private func getInitData(_ url: String?) -> [String: Any] {
        return [
            Message.appearanceTheme: "system",
            Message.contentBlockersEnabled: true,
            Message.hasUserRules: false,
            Message.premiumApp: false,
            Message.protectionEnabled: true,

            Message.removeFromAllowlistLink: UserRulesRedirectAction.removeFromAllowlist(domain: "").scheme,
            Message.addToAllowlistLink: UserRulesRedirectAction.addToAllowlist(domain: "").scheme,
            Message.addToBlocklistLink: UserRulesRedirectAction.addToBlocklist(domain: "").scheme,
            Message.removeAllBlocklistRulesLink: UserRulesRedirectAction.removeAllBlocklistRules(domain: "").scheme
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
}
