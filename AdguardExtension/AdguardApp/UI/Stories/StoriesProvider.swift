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

protocol StoriesProviderDelegate: AnyObject {
    func storiesChanged()
}

protocol StoriesProviderProtocol: AnyObject {
    var stories: [StoryGroup] { get }
    var categories: [StoryCategory] { get }
    var actions: [StoryActionType] { get }
    var unwatchedStories: Set<StoryCategory.CategoryType> { get }
    var unwatchedStoriesCount: Int { get }
}

/* StoriesProvider contains all information about stories */
final class StoriesProvider: StoriesProviderProtocol {
    
    // MARK: - Public properties
    
    weak var delegate: StoriesProviderDelegate?
    
    var unwatchedStoriesCount: Int { unwatchedStories.count }
    
    var unwatchedStories: Set<StoryCategory.CategoryType> {
        let watchedStories = resources.watchedStoriesCategories
        var allAvailableStories: Set<StoryCategory.CategoryType> = Set(stories.map { $0.category.type })
        allAvailableStories.subtract(watchedStories)
        return allAvailableStories
    }
    
    private(set) var stories: [StoryGroup] = []
    private(set) lazy var categories: [StoryCategory] = { storiesContext?.categories ?? [] }()
    private(set) lazy var actions: [StoryActionType] = { storiesContext?.actions ?? [] }()
    
    // MARK: - Private properties
    
    private lazy var allStories = { storiesContext?.stories ?? [] }()
    
    private lazy var storiesContext: StoriesContext? = {
        storiesInitQueue.sync {
            return generateStoriesFromFile()
        }
    }()
    
    private let storiesInitQueue = DispatchQueue(label: "stories.init.queue")
    private let workingQueue = DispatchQueue(label: "stories.working.queue")
    
    /* Services */
    private let configuration: ConfigurationService
    private let resources: AESharedResourcesProtocol
    
    /* Observers */
    private var appWillEnterForegroundObserver: NotificationToken?
    private var proStatusObserver: NSKeyValueObservation?
    
    // MARK: - Initializer
    
    init(configuration: ConfigurationService, resources: AESharedResourcesProtocol) {
        self.configuration = configuration
        self.resources = resources
        processStories()
        addObservers()
    }
    
    deinit {
        if let proStatusObserver = proStatusObserver {
            NotificationCenter.default.removeObserver(proStatusObserver)
        }
    }
    
    // MARK: - Private methods
    
    private func addObservers() {
        proStatusObserver = configuration.observe(\.proStatus) { [weak self] (_, _) in
            DDLogDebug("(StoriesProvider) - Received Pro status change notification")
            self?.processStories()
        }
        
        appWillEnterForegroundObserver = NotificationCenter.default.observe(name: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
            self?.processStories()
        }
    }
    
    private func processStories() {
        workingQueue.async { [weak self] in
            self?.processStoriesSync()
        }
    }
    
    private func processStoriesSync() {
        var newStories = allStories
        
        if configuration.proStatus {
            newStories = excludeStoriesWithScope(.forFree, stories: newStories)
        } else {
            /* Do not show stories about license activation for premium users */
            newStories = excludeStoriesWithScope(.forPro, stories: newStories)
        }
        
        if stories != newStories {
            DispatchQueue.main.async { [weak self] in
                self?.stories = newStories
                self?.delegate?.storiesChanged()
            }
        }
    }
    
    private func generateStoriesFromFile() -> StoriesContext? {
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
    
    private func excludeStoriesWithScope(_ scope: StoryScope, stories: [StoryGroup]) -> [StoryGroup] {
        var newStories = stories
        var vpnProtectionCategoryIndex: Int?
        newStories.enumerated().forEach {
            if $0.element.category.type == .vpnProtection && UIApplication.adGuardVpnIsInstalled {
                vpnProtectionCategoryIndex = $0.offset
            }
            let categoryIndex = $0.offset
            newStories[categoryIndex].storyTokens = $0.element.storyTokens.filter {
                $0.scope != scope
            }
        }
        if let index = vpnProtectionCategoryIndex { newStories.remove(at: index) }
        return newStories
    }
}

// MARK: - StoriesContext

/*
 StoriesContext is a helper for StoriesProvider
 It helps to decode stories.json in a convenient way
 */
fileprivate struct StoriesContext: Decodable {
    let stories: [StoryGroup]
    let categories: [StoryCategory]
    let actions: [StoryActionType]
    let buttonStyles: [StoryButtonStyle]
    let storyScopes: [StoryScope]
    
    private enum CodingKeys: String, CodingKey {
        case stories = "stories"
        case categories = "categories"
        case actions = "actions"
        case buttonStyles = "button_styles"
        case storyScopes = "scopes"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        let actionsKeys = try container.decode([String].self, forKey: .actions)
        let buttonStylesKeys = try container.decode([String].self, forKey: .buttonStyles)
        let storyScopesKeys = try container.decode([String].self, forKey: .storyScopes)
        
        self.categories = try container.decode([StoryCategory].self, forKey: .categories)
        self.actions = actionsKeys.compactMap { StoryActionType(rawValue: $0) }
        self.buttonStyles = buttonStylesKeys.compactMap{ StoryButtonStyle(rawValue: $0) }
        self.storyScopes = storyScopesKeys.compactMap { StoryScope(rawValue: $0) }
        
        let stories = try container.decode([StoryGroup].self, forKey: .stories)
        self.stories = Self.setCategoriesForStories(self.categories, stories)
    }
    
    private static func setCategoriesForStories(_ categories: [StoryCategory], _ stories: [StoryGroup]) -> [StoryGroup] {
        var storiesWithCategory: [StoryGroup] = []
        for story in stories {
            let storyType = story.category.type
            let category = categories.first(where: { $0.type == storyType })!
            let newStory = StoryGroup(category: category, storyTokens: story.storyTokens)
            storiesWithCategory.append(newStory)
        }
        return storiesWithCategory
    }
}
