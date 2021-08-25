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
    func process(message: Message) -> [String: String]
}

struct SafariWebExtensionMessageProcessor: SafariWebExtensionMessageProcessorProtocol {
    
    func process(message: Message) -> [String: String]  {
        switch message.type {
        case .getJsonRules: return getJsonRules()
        case .getBlockingData: return getBlockingData()
        case .writeToLog: return writeToLog(message.data)
        case .addToUserRules: return addToUserRules(message.data)
        default:
            DDLogError("Received bad case")
            return [Message.messageTypeKey: MessageType.error.rawValue]
        }
    }
    
    // MARK: - Private methods
    
    private func getJsonRules() -> [String: String] {
        return [Message.messageTypeKey: MessageType.success.rawValue]
    }
    
    private func getBlockingData() -> [String: String] {
        return [Message.messageTypeKey: MessageType.success.rawValue]
    }
    
    private func writeToLog(_ message: String) -> [String: String] {
        DDLogInfo(message)
        return [Message.messageTypeKey: MessageType.success.rawValue]
    }
    
    private func addToUserRules(_ rule: String) -> [String: String] {
        return [Message.messageTypeKey: MessageType.success.rawValue]
    }
}
