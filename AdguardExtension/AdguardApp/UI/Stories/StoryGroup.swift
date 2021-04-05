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

/* StoryGroup is a model for multiple stories */
struct StoryGroup: Decodable {
    let title: String
    let groupType: StoryGroupType
    let storyTokens: [StoryToken]
    
    private enum CodingKeys: String, CodingKey {
        case title = "category_title"
        case groupType = "category"
        case storyTokens = "tokens"
    }
    
    init(title: String, groupType: StoryGroupType, storyTokens: [StoryToken]) {
        self.title = title
        self.groupType = groupType
        self.storyTokens = storyTokens
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let titleKey = try container.decode(String.self, forKey: .title)
        let groupKey = try container.decode(String.self, forKey: .groupType)
        let tokens = try container.decode([StoryToken].self, forKey: .storyTokens)
        
        guard let grType = StoryGroupType(rawValue: groupKey) else {
            let error = DecodingError.dataCorruptedError(forKey: CodingKeys.groupType, in: container, debugDescription: "")
            throw error
        }
        
        self.title = String.localizedString(titleKey)
        self.groupType = grType
        self.storyTokens = tokens
    }
}
