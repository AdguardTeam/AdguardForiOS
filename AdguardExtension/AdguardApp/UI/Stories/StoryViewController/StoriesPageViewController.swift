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

import UIKit

protocol StoriesPageViewControllerDelegate: AnyObject {
    func allStoriesInCategoryWereWatched(_ category: StoryCategory.CategoryType)
}

final class StoriesPageViewController: UIPageViewController {
    
    // MARK: - Public properties
    
    weak var storiesDelegate: StoriesPageViewControllerDelegate?
    
    // MARK: - Private properties
    
    private let storiesGroups: [StoryGroup]
    private let startCategory: StoryCategory.CategoryType
    private lazy var groupIndex: Int = { storiesGroups.firstIndex(where: { startCategory == $0.category.type }) ?? 0 }()
    
    // UI elements
    private let crossButton: UIButton = {
        let button = UIButton()
        let crossImage = UIImage(named: "cross")
        button.setBackgroundImage(crossImage, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var contentViewControllers: [StoryViewController] = {
        storiesGroups.map { group in
            let storyVC = StoryViewController(storyGroup: group)
            storyVC.delegate = self
            return storyVC
        }
    }()
    
    // Services
    private let theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    private let resources: AESharedResourcesProtocol = { ServiceLocator.shared.getService()! }()
    
    // Observers
    private var themeNotificationToken: NotificationToken?
    private var willResignActiveObserver: NotificationToken?
    private var didBecomeActiveObserver: NotificationToken?
    
    // MARK: - UIPageViewController lifecycle
    
    init(storiesGroups: [StoryGroup], startCategory: StoryCategory.CategoryType) {
        self.storiesGroups = storiesGroups
        self.startCategory = startCategory
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        self.storiesGroups = []
        self.startCategory = .whatsNew
        super.init(coder: coder)
        
        self.delegate = self
        self.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([contentViewControllers[groupIndex]], direction: .forward, animated: false)
        setupCrossButton()
        setupSwipeDownGesture()
        
        themeNotificationToken = NotificationCenter.default.observe(name: NSNotification.Name(ConfigurationService.themeChangeNotification), object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
        
        willResignActiveObserver = NotificationCenter.default.observe(name: UIApplication.willResignActiveNotification, object: nil, queue: .main, using: { [weak self] (_) in
            self?.pauseStory()
        })

        didBecomeActiveObserver = NotificationCenter.default.observe(name: UIApplication.didBecomeActiveNotification, object: nil, queue: .main, using: { [weak self] (_) in
            self?.resumeStory()
        })
    }
    
    override var prefersStatusBarHidden: Bool { true }
    
    private func setupSwipeDownGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    private func pauseStory() {
        guard let controller = viewControllers?.first as? StoryViewController else { return }
        controller.pauseStory()
    }
    
    private func resumeStory() {
        guard let controller = viewControllers?.first as? StoryViewController else { return }
        controller.resumeStory()
    }
}

// MARK: - StoriesPageViewController + UIPageViewControllerDataSource

extension StoriesPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentStoryVC = viewController as? StoryViewController,
              let currentVcIndex = contentViewControllers.firstIndex(of: currentStoryVC)
        else {
            return nil
        }
        
        if currentVcIndex > 0 {
            return contentViewControllers[currentVcIndex - 1]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentStoryVC = viewController as? StoryViewController,
              let currentVcIndex = contentViewControllers.firstIndex(of: currentStoryVC)
        else {
            return nil
        }
        
        if currentVcIndex < contentViewControllers.count - 1 {
            return contentViewControllers[currentVcIndex + 1]
        }
        
        return nil
    }
}

// MARK: - StoriesPageViewController + UIPageViewControllerDelegate

extension StoriesPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        view.isUserInteractionEnabled = false
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        view.isUserInteractionEnabled = true
    }
}

// MARK: - StoriesPageViewController + StoryViewControllerDelegate

extension StoriesPageViewController: StoryViewControllerDelegate {
    private var nextStoryVC: StoryViewController? {
        guard let currentViewController = viewControllers?.first else { return nil }
        let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) as? StoryViewController
        return nextViewController
    }
    
    private var previousStoryVC: StoryViewController? {
        guard let currentViewController = viewControllers?.first else { return nil }
        let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) as? StoryViewController
        return previousViewController
    }
    
    func previousStoriesAreOver() {
        if let prev = previousStoryVC {
            view.isUserInteractionEnabled = false
            setViewControllers([prev], direction: .reverse, animated: true) { [weak self] _ in
                self?.view.isUserInteractionEnabled = true
            }
        }
    }
    
    /* Delegate method is called when stories in category's ended up */
    func nextStoriesAreOver() {
        if let next = nextStoryVC {
            view.isUserInteractionEnabled = false
            setViewControllers([next], direction: .forward, animated: true) { [weak self] _ in
                self?.view.isUserInteractionEnabled = true
            }
        } else {
            dismiss(animated: true)
        }
    }
    
    func lastStoryInCategoryWasWatched() {
        if let currentViewController = viewControllers?.first as? StoryViewController {
            let category = currentViewController.category
            if !resources.watchedStoriesCategories.contains(category) {
                resources.watchedStoriesCategories.insert(category)
                storiesDelegate?.allStoriesInCategoryWereWatched(category)
            }
        }
    }
}

// MARK: - StoriesPageViewController + Setup UI

extension StoriesPageViewController {
    private func setupCrossButton() {
        view.addSubview(crossButton)
        view.bringSubviewToFront(crossButton)
        crossButton.widthAnchor.constraint(equalToConstant: isIpadTrait ? 48.0 : 32.0).isActive = true
        crossButton.heightAnchor.constraint(equalToConstant: isIpadTrait ? 48.0 : 32.0).isActive = true
        crossButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: isIpadTrait ? 64.0 : 32.0).isActive = true
        crossButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
    }
}
