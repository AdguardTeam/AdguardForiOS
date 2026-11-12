//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
import UIKit

enum TabBarTabs: Int, CaseIterable {
    typealias RawValue = Int

    case mainTab = 0
    case protectionTab = 1
    case activityTab = 2
    case settingTab = 3
}

class MainTabBarController: UIViewController {

    // Storyboard identifiers of the tab root navigation controllers.
    private enum TabStoryboardIds {
        static let main = "mainNavigationController"
        static let protection = "ProtectionMainNavigationControllerId"
        static let activity = "ActivityMainNavigationControllerId"
        static let settings = "SettingsMainNavigationControllerId"
    }

    private struct Tab {
        let tab: TabBarTabs
        let controller: UIViewController
    }

    private let resource: AESharedResourcesProtocol = ServiceLocator.shared.getService()!

    private var onSettingsImportDidEndObserver: NotificationToken?
    private var onSettingsResetObserver: NotificationToken?

    private lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()

    /// The custom tab bar (exposed read-only for keyboard avoidance in child screens).
    private(set) var tabBarView: CustomTabBarView!
    private var contentContainer: UIView!

    /// Tab controllers in display order.
    private var tabs: [Tab] = []

    /// Index of the selected tab in `tabs`.
    private var selectedTabIndex: Int = TabBarTabs.mainTab.rawValue

    /// The currently displayed child controller.
    private(set) var displayedController: UIViewController?

    /// Guards the tab switch animation (replaces the former `transitionCoordinator == nil` check).
    private var isSwitchingTabs = false

    /// A programmatic tab selection that arrived while a slide animation was in
    /// flight (e.g. a deep link right after a user tap); applied when the animation ends.
    private var pendingTabSelection: Int?

    // MARK: - Compatibility API (the former UITabBarController surface)

    /// The tab root controllers in display order.
    var viewControllers: [UIViewController] {
        return tabs.map { $0.controller }
    }

    /// The index of the selected tab; setting it switches the tab.
    var selectedIndex: Int {
        get { return selectedTabIndex }
        set { setSelectedTab(at: newValue, animated: true) }
    }

    /// The selected tab controller; setting it switches the tab.
    var selectedViewController: UIViewController? {
        get {
            return tabs.indices.contains(selectedTabIndex) ? tabs[selectedTabIndex].controller : nil
        }
        set {
            guard let controller = newValue,
                  let index = tabs.firstIndex(where: { $0.controller === controller }) else { return }
            setSelectedTab(at: index, animated: true)
        }
    }

    /// The enum of the currently selected tab (nil if the selected tab is not present in `tabs`).
    var selectedTab: TabBarTabs? {
        return tabs.indices.contains(selectedTabIndex) ? tabs[selectedTabIndex].tab : nil
    }

    /// Returns the navigation controller of the given tab
    /// (nil if the tab is not currently present, e.g. the removed activity tab).
    func navigationController(for tab: TabBarTabs) -> MainNavigationController? {
        return tabs.first { $0.tab == tab }?.controller as? MainNavigationController
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupTabs()
        addOrRemoveActivityTabIfNeeded()
        showSelectedTab()

        onSettingsImportDidEndObserver = NotificationCenter.default.observe(name: .settingsImportDidEnd, object: nil, queue: .main) { [weak self] _ in
            self?.addOrRemoveActivityTabIfNeeded()
        }

        onSettingsResetObserver = NotificationCenter.default.observe(name: .resetSettings, object: nil, queue: .main) { [weak self] _ in
            self?.addOrRemoveActivityTabIfNeeded()
        }

        updateTheme()
    }

    // Forwards the status bar appearance to the selected tab (as the former UITabBarController did).
    override var childForStatusBarStyle: UIViewController? { displayedController }
    override var childForStatusBarHidden: UIViewController? { displayedController }
    override var childForHomeIndicatorAutoHidden: UIViewController? { displayedController }
    override var childForScreenEdgesDeferringSystemGestures: UIViewController? { displayedController }

    // MARK: - Layout setup

    private func setupLayout() {
        contentContainer = UIView()
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentContainer)

        tabBarView = CustomTabBarView()
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        tabBarView.onItemTap = { [weak self] index in
            self?.selectTab(at: index, animated: true)
        }

        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: view.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: tabBarView.topAnchor),

            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupTabs() {
        let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
        let initialTabs: [(tab: TabBarTabs, storyboardId: String)] = [
            (.mainTab, TabStoryboardIds.main),
            (.protectionTab, TabStoryboardIds.protection),
            (.activityTab, TabStoryboardIds.activity),
            (.settingTab, TabStoryboardIds.settings)
        ]

        tabs = initialTabs.compactMap { tabInfo in
            guard let controller = storyboard.instantiateViewController(withIdentifier: tabInfo.storyboardId) as? MainNavigationController else {
                assertionFailure("MainPage.storyboard doesn't contain a controller with id \(tabInfo.storyboardId)")
                return nil
            }
            return Tab(tab: tabInfo.tab, controller: controller)
        }
    }

    /// Rebuilds the tab bar items to match `tabs` and the current selection.
    private func refreshTabBarItems() {
        let items = tabs.map { tab -> TabBarItem in
            switch tab.tab {
            case .mainTab:
                return TabBarItem(image: UIImage(named: "home"), accessibilityLabel: String.localizedString("main_page_tab"))
            case .protectionTab:
                return TabBarItem(image: UIImage(named: "adguard-small-icon"), accessibilityLabel: String.localizedString("protection_page_tab"))
            case .activityTab:
                return TabBarItem(image: UIImage(named: "activity"), accessibilityLabel: String.localizedString("activity_page_tab"))
            case .settingTab:
                return TabBarItem(image: UIImage(named: "advanced-settings-icon"), accessibilityLabel: String.localizedString("settings_page_tab"))
            }
        }
        tabBarView.setItems(items)
    }

    private func addOrRemoveActivityTabIfNeeded() {
        let activityIndex = tabs.firstIndex { $0.tab == TabBarTabs.activityTab }

        if resource.disableSecurityRelatedFeatures, let activityIndex = activityIndex, tabs.count == TabBarTabs.allCases.count {
            tabs.remove(at: activityIndex)

            if selectedTabIndex == activityIndex {
                selectedTabIndex = TabBarTabs.mainTab.rawValue
            } else if selectedTabIndex > activityIndex {
                selectedTabIndex -= 1
            }
        } else if !resource.disableSecurityRelatedFeatures, activityIndex == nil, tabs.count < TabBarTabs.allCases.count,
            let activityController = UIStoryboard(name: "MainPage", bundle: nil).instantiateViewController(withIdentifier: TabStoryboardIds.activity) as? MainNavigationController
        {
            tabs.insert(Tab(tab: .activityTab, controller: activityController), at: TabBarTabs.activityTab.rawValue)
            if selectedTabIndex >= TabBarTabs.activityTab.rawValue {
                selectedTabIndex += 1
            }
        } else {
            return
        }

        refreshTabBarItems()

        // Re-show the selected tab if the displayed controller has changed
        // (e.g. the activity tab was selected at the moment it was removed).
        if isViewLoaded,
           tabs.indices.contains(selectedTabIndex),
           displayedController !== tabs[selectedTabIndex].controller {
            switchToTab(at: selectedTabIndex, animated: false)
        }
    }

    // MARK: - Tab switching

    /// Selects the tab at the given index (user-driven: re-selecting the current tab
    /// pops its navigation stack to root, the former system tab bar behavior).
    /// Selections made while a slide transition is in flight are queued and applied
    /// when the transition completes (see `pendingTabSelection`).
    func selectTab(at index: Int, animated: Bool) {
        guard tabs.indices.contains(index) else { return }

        if index == selectedTabIndex {
            if let navController = tabs[index].controller as? UINavigationController {
                navController.popToRootViewController(animated: animated)
            }
            return
        }

        if !isViewLoaded {
            // The selection is stored and applied by `showSelectedTab()` on the initial show.
            selectedTabIndex = index
            return
        }

        switchToTab(at: index, animated: animated)
    }

    /// Selects the tab at the given index (programmatic: re-selecting the current tab does nothing).
    /// Selections made while a slide transition is in flight are queued and applied
    /// when the transition completes (see `pendingTabSelection`).
    private func setSelectedTab(at index: Int, animated: Bool) {
        guard tabs.indices.contains(index) else { return }
        guard index != selectedTabIndex else { return }

        if !isViewLoaded {
            // The selection is stored and applied by `showSelectedTab()` on the initial show.
            selectedTabIndex = index
            return
        }

        switchToTab(at: index, animated: animated)
    }

    /// Displays the tab selected by `selectedTabIndex` (used on the initial show).
    private func showSelectedTab() {
        refreshTabBarItems()
        switchToTab(at: selectedTabIndex, animated: false)
    }

    private func switchToTab(at newIndex: Int, animated: Bool) {
        guard tabs.indices.contains(newIndex) else { return }
        let newController = tabs[newIndex].controller
        let previousController = displayedController
        guard previousController !== newController else {
            pendingTabSelection = nil
            return
        }

        // Queue the selection while a slide transition is in flight; it is applied
        // in the transition completion so that a programmatic switch is never dropped.
        if isSwitchingTabs {
            pendingTabSelection = newIndex
            return
        }

        addChild(newController)
        newController.view.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(newController.view)
        pin(newController.view, to: contentContainer)
        displayedController = newController
        // The selected index is updated atomically with the displayed controller,
        // so `selectedIndex` never reports a tab that is not on screen yet.
        selectedTabIndex = newIndex

        if previousController == nil || !animated {
            previousController?.willMove(toParent: nil)
            previousController?.view.removeFromSuperview()
            previousController?.removeFromParent()
            newController.didMove(toParent: self)
            tabBarView.setSelectedItemIndex(newIndex)
            return
        }

        // Slide transition replicating the former CustomNavigationTransitionAnimator
        // that used to be provided by UITabBarControllerDelegate.
        isSwitchingTabs = true
        let previousIndex = tabs.firstIndex { $0.controller === previousController } ?? newIndex
        let presenting = newIndex > previousIndex
        tabBarView.setSelectedItemIndex(newIndex)

        guard let previousView = previousController?.view else { return }
        animateSlide(of: newController.view, over: previousView, presenting: presenting) { [weak self] in
            guard let self = self else { return }
            previousController?.willMove(toParent: nil)
            previousController?.view.removeFromSuperview()
            previousController?.removeFromParent()
            newController.didMove(toParent: self)
            self.isSwitchingTabs = false
            self.applyPendingTabSelectionIfNeeded()
        }
    }

    /// Applies a tab selection that was queued while a slide transition was in flight.
    private func applyPendingTabSelectionIfNeeded() {
        guard let pending = pendingTabSelection, !isSwitchingTabs else { return }
        pendingTabSelection = nil
        switchToTab(at: pending, animated: true)
    }

    private func pin(_ childView: UIView, to container: UIView) {
        NSLayoutConstraint.activate([
            childView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            childView.topAnchor.constraint(equalTo: container.topAnchor),
            childView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }

    /// Slides the new tab view over the old one, moving to the left when
    /// switching to a tab on the right (`presenting`) and to the right otherwise —
    /// a replica of the former `CustomNavigationTransitionAnimator` keyframes.
    private func animateSlide(of newView: UIView, over oldView: UIView, presenting: Bool, completion: @escaping () -> Void) {
        let width = contentContainer.bounds.width
        newView.transform = CGAffineTransform(translationX: presenting ? width : -width, y: 0)

        if presenting {
            contentContainer.addSubview(newView)
        } else {
            contentContainer.insertSubview(newView, belowSubview: oldView)
        }

        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: {
            newView.transform = .identity
            oldView.transform = CGAffineTransform(translationX: presenting ? -width : width, y: 0)
        }, completion: { _ in
            oldView.transform = .identity
            completion()
        })
    }
}

extension MainTabBarController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        tabBarView.updateTheme()
    }
}

extension UIViewController {
    /// Searches the parent chain for a container of the given type
    /// (a replacement for the former `tabBarController` lookups).
    func findParentContainer<T: UIViewController>(of type: T.Type) -> T? {
        var current: UIViewController? = self
        while let candidate = current {
            if let match = candidate as? T {
                return match
            }
            current = candidate.parent
        }
        return nil
    }
}
