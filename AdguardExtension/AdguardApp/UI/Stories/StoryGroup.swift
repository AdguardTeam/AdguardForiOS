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
struct StoryGroup: Decodable, Equatable {
    let category: StoryCategory
    var storyTokens: [StoryToken]
    
    private enum CodingKeys: String, CodingKey {
        case category
        case storyTokens = "tokens"
    }
    
    init(category: StoryCategory, storyTokens: [StoryToken]) {
        self.category = category
        self.storyTokens = storyTokens
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let typeKey = try container.decode(String.self, forKey: .category)
        let tokens = try container.decode([StoryToken].self, forKey: .storyTokens)
        
        let type = StoryCategory.CategoryType(rawValue: typeKey)!
        self.category = StoryCategory(type: type)
        self.storyTokens = tokens
    }
}
