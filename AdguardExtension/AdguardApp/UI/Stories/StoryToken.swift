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

struct StoryToken: Decodable {
    let image: UIImage?
    let title: String?
    let description: String?
    let buttonConfig: StoryButtonConfig?
    
    private enum CodingKeys: String, CodingKey {
        case image = "image"
        case title = "title"
        case description = "description"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let imageName = try container.decode(String.self, forKey: .image)
        let titleKey = try container.decode(String.self, forKey: .title)
        let descKey = try container.decode(String.self, forKey: .description)
        
        self.image = UIImage(named: imageName)
        self.title = String.localizedString(titleKey)
        self.description = String.localizedString(descKey)
        self.buttonConfig = try? StoryButtonConfig(from: decoder)
    }
}
