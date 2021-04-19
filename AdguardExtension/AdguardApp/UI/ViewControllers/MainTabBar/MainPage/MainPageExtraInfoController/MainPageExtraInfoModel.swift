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

protocol MainPageExtraInfoModelDelegate: AnyObject {
    func dnsImplementationChanged()
    func dnsServerChanged()
    func systemProtectionChanged()
    func proStatusChanged()
}

protocol MainPageExtraInfoModelProtocol {
    var delegate: MainPageExtraInfoModelDelegate? { get set }
    var storiesModels: [StoryCollectionViewModel] { get }
    var compactViewType: MainPageExtraInfoModel.CompactViewType { get }
    
    func categoryWasWatched(_ category: StoryCategory.CategoryType)
}

final class MainPageExtraInfoModel: MainPageExtraInfoModelProtocol {
    
    weak var delegate: MainPageExtraInfoModelDelegate?
    
    var storiesModels: [StoryCollectionViewModel] = []
    
    var compactViewType: MainPageExtraInfoModel.CompactViewType {
        if configuration.proStatus {
            if resources.dnsImplementation == .native {
                return .nativeImplementationInfo
            }
            return .statisticsInfo
        } else {
            let watched = resources.watchedStoriesCategories.count
            let all = StoriesProvider.allCategories.count
            // It means that all stories are watched
            if watched == all {
                return .getPro
            } else {
                return .unreadStories(unreadStoriesCount: all - watched)
            }
        }
    }
    
    enum CompactViewType: Equatable {
        case nativeImplementationInfo
        case statisticsInfo
        case unreadStories(unreadStoriesCount: Int)
        case getPro
    }
    
    var fullViewType: MainPageExtraInfoModel.FullViewType {
        if configuration.proStatus {
            return resources.dnsImplementation == .native ? .stories : .storiesWithStatistics
        } else {
            return .stories
        }
    }
    
    enum FullViewType {
        case stories
        case storiesWithStatistics
    }
    
    // MARK: - Services
    
    private let resources: AESharedResourcesProtocol
    private let configuration: ConfigurationService
    
    // MARK: - Observers
    
    private var dnsImplementationObserver: NotificationToken?
    private var currentDnsServerObserver: NotificationToken?
    private var systemProtectionObserver: NotificationToken?
    private var proStatusObserver: NSKeyValueObservation?
    
    init(resources: AESharedResourcesProtocol, configuration: ConfigurationService) {
        self.resources = resources
        self.configuration = configuration
        
        addObservers()
    
        // Initialize stories models
        let stories = StoriesProvider.stories
        self.storiesModels = stories.map {
            StoryCollectionViewModel(title: $0.category.title,
                                     storyIsWatched: resources.watchedStoriesCategories.contains($0.category.type),
                                     category: $0.category.type,
                                     backGroundImage: $0.category.categoryImage)
        }
    }
    
    // MARK: - Public methods
    
    func categoryWasWatched(_ category: StoryCategory.CategoryType) {
        let index = storiesModels.firstIndex(where: { $0.category == category })!
        let story = storiesModels[index]
        let newStory = StoryCollectionViewModel(title: story.title, storyIsWatched: true, category: story.category, backGroundImage: story.backGroundImage)
        storiesModels[index] = newStory
    }
    
    // MARK: - Private methods
    
    private func addObservers() {
        dnsImplementationObserver = NotificationCenter.default.observe(name: .dnsImplementationChanged, object: nil, queue: .main) { [weak self] _ in
            DDLogDebug("(MainPageExtraInfoModel) - Received DNS implementation change notification")
            self?.delegate?.dnsImplementationChanged()
        }
        
        currentDnsServerObserver = NotificationCenter.default.observe(name: .currentDnsServerChanged, object: nil, queue: .main) { [weak self] _ in
            DDLogDebug("(MainPageExtraInfoModel) - Received DNS server change notification")
            self?.delegate?.dnsServerChanged()
        }
        
        systemProtectionObserver = NotificationCenter.default.observe(name: ComplexProtectionService.systemProtectionChangeNotification, object: nil, queue: .main) { [weak self] _ in
            DDLogDebug("(MainPageExtraInfoModel) - Received system protection change notification")
            self?.delegate?.systemProtectionChanged()
        }
        
        proStatusObserver = configuration.observe(\.proStatus) { (_, _) in
            DDLogDebug("(MainPageExtraInfoModel) - Received Pro status change notification")
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.proStatusChanged()
            }
        }
    }
}
