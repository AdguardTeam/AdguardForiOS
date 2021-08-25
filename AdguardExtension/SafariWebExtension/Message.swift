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

/// `MessageType` is a type of message that we receive from JS
/// Knowing the `Message.type` tells us what to do with `Message.data`
enum MessageType: String {
    case getJsonRules = "get_json_rules"
    case getBlockingData = "get_blocking_data"
    case writeToLog = "write_in_native_log"
    case addToUserRules = "add_to_userrules"

    // Response cases
    case success = "success"
    case error = "error"
}

// MARK: - Message
// Object representation of message that we receive from JS

struct Message {
    static let messageTypeKey = "type"
    static let messageDataKey = "data"
    
    let type: MessageType
    let data: String
}

/// Initializer from Dictionary. We receive message as dictionary from JS
extension Message {
    init?(message: [String: Any]) {
        guard let typeString = message[Self.messageTypeKey] as? String,
              let type = MessageType(rawValue: typeString),
              let data = message[Self.messageDataKey] as? String
        else {
            return nil
        }
        
        self.type = type
        self.data = data
    }
}
