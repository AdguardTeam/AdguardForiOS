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

struct StoryCategory: Decodable {
    
    enum CategoryType: String, CaseIterable {
        case whatsNew = "WhatsNew"
        case dnsProtection = "DnsProtection"
        case vpnProtection = "VpnProtection"
        case safariProtection = "SafariProtection"
        case youtubeAds = "YouTubeAds"
        case dnsServers = "DnsServers"
    }
    
    let title: String
    let type: CategoryType
    let buttonColor: UIColor
    let buttonFigureColor: UIColor
    
    init(type: CategoryType) {
        self.type = type
        self.title = ""
        self.buttonColor = .clear
        self.buttonFigureColor = .clear
    }
    
    init(title: String, type: StoryCategory.CategoryType, buttonColor: UIColor, buttonFigureColor: UIColor) {
        self.title = title
        self.type = type
        self.buttonColor = buttonColor
        self.buttonFigureColor = buttonFigureColor
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case title
        case buttonColor = "button_background_color"
        case buttonFigureColor = "button_figure_color"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let typeKey = try container.decode(String.self, forKey: .type)
        let titleKey = try container.decode(String.self, forKey: .title)
        let buttonBackgroundColorHex = try container.decode(String.self, forKey: .buttonColor)
        let buttonFigureColorHex = try container.decode(String.self, forKey: .buttonFigureColor)
        
        self.type = CategoryType(rawValue: typeKey)!
        self.title = String.localizedString(titleKey)
        self.buttonColor = UIColor(hexString: buttonBackgroundColorHex)
        self.buttonFigureColor = UIColor(hexString: buttonFigureColorHex)
    }
}
