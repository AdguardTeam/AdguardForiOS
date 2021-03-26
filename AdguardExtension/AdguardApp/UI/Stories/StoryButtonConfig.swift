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

enum StoryActionType: String, CaseIterable {
    case readChangeLog = "READ_CHANGELOG"
    case activateLicense = "ACTIVATE_LICENSE"
    case downloadAdguardVpn = "DOWNLOAD_ADGUARD_VPN"
    case moreOnDns = "MORE_ON_DNS"
    case enableAdguardDns = "ENABLE_ADGUARD_DNS"
    case enableGoogleDns = "ENABLE_GOOGLE_DNS"
    case enableCloudflareDns = "ENABLE_CLOUDFLARE_DNS"
    case addCustomDns = "ADD_CUSTOM_DNS"
}

struct StoryButtonConfig: Decodable {
    let title: String
    let actionType: StoryActionType
    
    private enum CodingKeys: String, CodingKey {
        case title = "action_title"
        case actionType = "action"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let buttonTitleKey = try container.decode(String.self, forKey: .title)
        let buttonActionKey = try container.decode(String.self, forKey: .actionType)
        
        guard let actionType = StoryActionType(rawValue: buttonActionKey) else {
            throw DecodingError.dataCorruptedError(forKey: .actionType, in: container, debugDescription: "Unknown action type")
        }
        
        self.title = String.localizedString(buttonTitleKey)
        self.actionType = actionType
    }
}
