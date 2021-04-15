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
    
    private let vibrationGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - Helper models
    
    private lazy var model: MainPageExtraInfoModel = {
        let md = MainPageExtraInfoModel(resources: resources, configuration: configuration)
        md.delegate = self
        return md
    }()
    private lazy var dataSource: MainPageExtraInfoCollectionDataSource = {
        return MainPageExtraInfoCollectionDataSource(controller: self, theme: theme, model: model, statisticsModel: statisticsModel)
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
    
    override func parentViewWillTransitionToFullSize() {
        super.parentViewWillTransitionToFullSize()
        
        if model.compactViewType != .none {
            fullView.fadeIn(0.3, 0.1)
            compactView.fadeOut(0.1)
        }
        vibrationGenerator.impactOccurred()
    }
    
    override func parentViewWillTransitionToCompactSize() {
        super.parentViewWillTransitionToCompactSize()
        
        if model.compactViewType != .none {
            compactView.fadeIn(0.1, 0.3)
            fullView.fadeOut(0.3)
        }
        vibrationGenerator.impactOccurred()
    }
    
    override func parentViewIsTransitioning(percent: CGFloat) {
        super.parentViewIsTransitioning(percent: percent)
        
        // We don't need to animate views change if compact view is none
        if model.compactViewType == .none {
            return
        }
        
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
        case .none:
            processEmptyCompactView()
        case .nativeImplementationInfo:
            processNativeImplementationInfo()
        case .statisticsInfo:
            processStatisticsInfo()
        }
    }
    
    private func processEmptyCompactView() {
        compactView.removeAllSubviews()
        compactView.alpha = 0.0
        compactView.isHidden = true
        fullView.alpha = 1.0
        fullView.isHidden = false
    }
    
    private func processNativeImplementationInfo() {
        compactView.removeAllSubviews()
        compactView.addSubview(nativeImplementationView)
        
        nativeImplementationView.translatesAutoresizingMaskIntoConstraints = false
        nativeImplementationView.topAnchor.constraint(equalTo: compactView.topAnchor).isActive = true
        nativeImplementationView.bottomAnchor.constraint(equalTo: compactView.bottomAnchor).isActive = true
        nativeImplementationView.leadingAnchor.constraint(equalTo: compactView.leadingAnchor).isActive = true
        nativeImplementationView.trailingAnchor.constraint(equalTo: compactView.trailingAnchor).isActive = true
        
        let dnsProtocol = nativeProviders.currentServer?.dnsProtocol ?? .doh
        nativeImplementationView.dnsProtocol = String.localizedString(DnsProtocol.stringIdByProtocol[dnsProtocol]!)
        nativeImplementationView.dnsIsWorking = complexProtection.systemProtectionEnabled
        nativeImplementationView.dnsProviderName = nativeProviders.currentProvider?.name ?? ""
        
        if isCompact == true {
            compactView.alpha = 1.0
            compactView.isHidden = false
        }
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
        
        if isCompact == true {
            compactView.alpha = 1.0
            compactView.isHidden = false
        }
    }
}

// MARK: - MainPageExtraInfoController + MainPageExtraInfoModelDelegate

extension MainPageExtraInfoController: MainPageExtraInfoModelDelegate {
    func dnsImplementationChanged() {
        processCompactView()
        collectionView.reloadData()
    }
    
    func dnsServerChanged() {
        processNativeImplementationInfo()
    }
    
    func systemProtectionChanged() {
        processNativeImplementationInfo()
    }
    
    func proStatusChanged() {
        processCompactView()
        collectionView.reloadData()
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
        view.backgroundColor = theme.backgroundColor
        collectionView.backgroundColor = theme.backgroundColor
        statisticsInfoView.updateTheme(theme)
        nativeImplementationView.updateTheme(theme)
        dataSource.updateTheme()
    }
}
