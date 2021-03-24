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

/* StoriesProvider contains all information about stories */
struct StoriesProvider {
    
    // MARK: - Public properties
    
    static let stories: [StoryGroup] = { storiesContext?.stories ?? [] }()
    static let allCategories: [StoryGroupType] = { storiesContext?.categories ?? [] }()
    static let allActions = { storiesContext?.actions ?? [] }()
    
    // MARK: - Private properties
    
    private static let storiesContext: StoriesContext? = {
        storiesQueue.sync {
            return generateStoriesFromFile()
        }
    }()
    
    private static let storiesQueue = DispatchQueue(label: "stories.init.queue")
    
    // MARK: - Private methods
    
    private static func generateStoriesFromFile() -> StoriesContext? {
        guard let pathString = Bundle.main.path(forResource: "stories", ofType: "json") else {
            DDLogError("Failed to get data from stories.json")
            return nil
        }
        
        let pathUrl = URL(fileURLWithPath: pathString)
        
        guard let jsonData = try? Data(contentsOf: pathUrl) else {
            DDLogError("Failed to get data from stories.json")
            return nil
        }
            
            
        let decoder = JSONDecoder()
        guard let decodedContext = try? decoder.decode(StoriesContext.self, from: jsonData) else {
            DDLogError("Failed to decode data from stories.json")
            return nil
        }

        return decodedContext
    }
}

// MARK: - StoriesContext

/*
 StoriesContext is a helper for StoriesProvider
 It helps to decode stories.json in a convenient way
 */
fileprivate struct StoriesContext: Decodable {
    let stories: [StoryGroup]
    let categories: [StoryGroupType]
    let actions: [StoryActionType]
    
    private enum CodingKeys: String, CodingKey {
        case stories = "stories"
        case categories = "categories"
        case actions = "actions"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        let categoriesKeys = try container.decode([String].self, forKey: .categories)
        let actionsKeys = try container.decode([String].self, forKey: .actions)
        
        self.stories = try container.decode([StoryGroup].self, forKey: .stories)
        self.categories = categoriesKeys.compactMap { StoryGroupType(rawValue: $0) }
        self.actions = actionsKeys.compactMap { StoryActionType(rawValue: $0) }
    }
}
