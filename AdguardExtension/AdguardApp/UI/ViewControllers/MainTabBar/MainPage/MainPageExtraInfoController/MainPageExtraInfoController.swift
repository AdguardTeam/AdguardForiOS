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

final class MainPageExtraInfoController: PullableContentController {
    
    // MARK: - UI elements
    
    @IBOutlet weak var compactView: UIView!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let statisticsInfoView = StatisticsInfoView(clickableButtons: false)
    private let nativeImplementationView = NativeImplementationView()
    private let getProView = GetProCompactView()
    private let unreadStoriesView = UnreadStoriesView()
    
    private let vibrationGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - Helper models
    
    private lazy var model: MainPageExtraInfoModel = {
        let md = MainPageExtraInfoModel(resources: resources, configuration: configuration, complexProtection: complexProtection, nativeProviders: nativeProviders)
        md.delegate = self
        return md
    }()
    private lazy var dataSource: MainPageExtraInfoCollectionDataSource = {
        return MainPageExtraInfoCollectionDataSource(collectionView: collectionView, theme: theme, model: model, statisticsModel: statisticsModel)
    }()
    private lazy var delegate: MainPageExtraInfoCollectionDelegate = {
        return MainPageExtraInfoCollectionDelegate(controller: self, model: model)
    }()
    
    // MARK: - Services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let statisticsModel: StatisticsModelProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let complexProtection: ComplexProtectionServiceProtocol = ServiceLocator.shared.getService()!
    private let nativeProviders: NativeProvidersServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticsModel.observers.append(self)
        
        fullView.alpha = 0.0
        fullView.isHidden = true
        
        processCompactView()
        setupCollectionView()
        updateTheme()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    override func parentViewWillTransitionToFullSize() {
        super.parentViewWillTransitionToFullSize()
        fullView.fadeIn(0.3, 0.1)
        compactView.fadeOut(0.1)
        collectionView.isScrollEnabled = true
        vibrationGenerator.impactOccurred()
    }
    
    override func parentViewWillTransitionToCompactSize() {
        super.parentViewWillTransitionToCompactSize()
        
        // Check if we need to change unread stories number
        if case let MainPageExtraInfoModel.CompactViewType.unreadStories(unreadStoriesCount: unread) = model.compactViewType {
            processUnreadStories(unread)
        }
        
        // Check if we've watched all stories and need to set Get PRO view
        if model.compactViewType == .getPro && getProView.superview == nil {
            processCompactView()
        }
        
        compactView.fadeIn(0.1, 0.3)
        fullView.fadeOut(0.3)
        collectionView.isScrollEnabled = false
        vibrationGenerator.impactOccurred()
    }
    
    override func parentViewIsTransitioning(percent: CGFloat) {
        super.parentViewIsTransitioning(percent: percent)
    
        /*
         Between 0% and 30% of bottom view transition to full height
         we are hiding compact view and changing it's alpha to 0.0
         */
        if percent >= 0 && percent <= 30.0 {
            compactView.isHidden = false
            fullView.isHidden = true
            let alpha = 1 - percent / 30.0
            compactView.alpha = alpha
            return
        }
        
        /*
         Between 30% and 60% of bottom view transition to full height
         we are showing full view and changing it's alpha to 1.0
        */
        if percent > 30 && percent <= 60 {
            fullView.isHidden = false
            compactView.isHidden = true
            let alpha = (percent - 30.0) / 30.0
            fullView.alpha = alpha
            return
        }
    }
    
    // MARK: - Private methods
    
    private func setupCollectionView() {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
    
    /* Provides compact view with actual info */
    private func processCompactView() {
        switch model.compactViewType {
        case .getPro:
            setCompactView(getProView)
        case .unreadStories(unreadStoriesCount: let unread):
            setCompactView(unreadStoriesView)
            processUnreadStories(unread)
        case .nativeImplementationInfo:
            setCompactView(nativeImplementationView)
            processNativeImplementationInfo()
        case .statisticsInfo:
            setCompactView(statisticsInfoView)
            processStatisticsInfo()
        }
    }
    
    private func setCompactView(_ view: UIView) {
        compactView.removeAllSubviews()
        compactView.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: compactView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: compactView.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: compactView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: compactView.trailingAnchor).isActive = true
    }
    
    private func processUnreadStories(_ unread: Int) {
        unreadStoriesView.unreadStoriesCount = unread
    }
    
    private func processNativeImplementationInfo() {
        nativeImplementationView.model = model.nativeViewModel
    }
    
    private func processStatisticsInfo() {
        compactView.removeAllSubviews()
        compactView.addSubview(statisticsInfoView)
        
        statisticsInfoView.translatesAutoresizingMaskIntoConstraints = false
        statisticsInfoView.topAnchor.constraint(equalTo: compactView.topAnchor).isActive = true
        statisticsInfoView.bottomAnchor.constraint(equalTo: compactView.bottomAnchor).isActive = true
        statisticsInfoView.leadingAnchor.constraint(equalTo: compactView.leadingAnchor).isActive = true
        statisticsInfoView.trailingAnchor.constraint(equalTo: compactView.trailingAnchor).isActive = true
        
        let statistics = statisticsModel.statistics(for: statisticsModel.mainPageDateType)
        statisticsInfoView.statisticsModel = statistics
    }
}

// MARK: - MainPageExtraInfoController + MainPageExtraInfoModelDelegate

extension MainPageExtraInfoController: MainPageExtraInfoModelDelegate {
    func dnsImplementationChanged() {
        processCompactView()
        collectionView.reloadData()
    }
    
    func dnsServerChanged() {
        processCompactView()
    }
    
    func systemProtectionChanged() {
        processCompactView()
        dataSource.systemProtectionChanged()
    }
    
    func proStatusChanged() {
        processCompactView()
        collectionView.reloadData()
    }
    
    func storiesChanged() {
        collectionView.reloadData()
        // Check if we need to change unread stories number
        if case let MainPageExtraInfoModel.CompactViewType.unreadStories(unreadStoriesCount: unread) = model.compactViewType {
            processUnreadStories(unread)
        }
    }
}

// MARK: - MainPageExtraInfoController + StatisticsModelObserver

extension MainPageExtraInfoController: StatisticsModelObserver {
    func statisticsChanged() {
        let statistics = statisticsModel.statistics(for: statisticsModel.mainPageDateType)
        statisticsInfoView.statisticsModel = statistics
    }
    
    func mainPageDateTypeChanged() {
        let statistics = statisticsModel.statistics(for: statisticsModel.mainPageDateType)
        statisticsInfoView.statisticsModel = statistics
    }
    
    func activityPageDateTypeChanged() {
        // Unimplemented
    }
}

// MARK: - MainPageExtraInfoController + StoriesPageViewControllerDelegate

extension MainPageExtraInfoController: StoriesPageViewControllerDelegate {
    func allStoriesInCategoryWereWatched(_ category: StoryCategory.CategoryType) {
        model.categoryWasWatched(category)
        collectionView.reloadData()
    }
}

// MARK: - MainPageExtraInfoController + ThemableProtocol

extension MainPageExtraInfoController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.popupBackgroundColor
        collectionView.backgroundColor = theme.popupBackgroundColor
        statisticsInfoView.updateTheme(theme)
        nativeImplementationView.updateTheme(theme)
        getProView.updateTheme(theme)
        unreadStoriesView.updateTheme(theme)
        dataSource.updateTheme()
    }
}
