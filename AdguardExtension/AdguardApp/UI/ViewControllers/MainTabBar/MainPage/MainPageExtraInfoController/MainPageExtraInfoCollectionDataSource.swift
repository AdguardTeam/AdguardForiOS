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

final class MainPageExtraInfoCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    private let collectionView: UICollectionView
    private let theme: ThemeServiceProtocol
    private let model: MainPageExtraInfoModel
    private let statisticsModel: StatisticsModelProtocol
    
    private var statisticsHeader: StatisticsCollectionReusableView?
    
    init(collectionView: UICollectionView, theme: ThemeServiceProtocol, model: MainPageExtraInfoModel, statisticsModel: StatisticsModelProtocol) {
        self.collectionView = collectionView
        self.theme = theme
        self.model = model
        self.statisticsModel = statisticsModel
        super.init()
        
        statisticsModel.observers.append(self)
        registerCells()
    }
    
    // MARK: - Public methods
    
    func systemProtectionChanged() {
        statisticsHeader?.chartViewIsEnabled = model.systemProtectionIsEnabled
    }
    
    // MARK: - Data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.storiesModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return storyCell(forIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch model.fullViewType {
        case .storiesWithNativeDns: return nativeDnsHeaderView(indexPath)
        case .storiesWithStatistics: return statisticsHeaderView(indexPath)
        case .storiesWithProStatusPromotion: return proStatusPromotionHeaderView(indexPath)
        }
    }
    
    // MARK: - Private methods
    
    /* Returns story cell for index path */
    private func storyCell(forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.reuseIdentifier, for: indexPath) as! StoryCollectionViewCell
        let model = self.model.storiesModels[indexPath.row]
        cell.model = model
        return cell
    }
    
    /* Returns header view for native DNS implementation config */
    private func nativeDnsHeaderView(_ indexPath: IndexPath) -> NativeDnsCollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NativeDnsCollectionReusableView.reuseIdentifier, for: indexPath) as! NativeDnsCollectionReusableView
        headerView.nativeDnsModel = model.nativeViewModel
        headerView.updateTheme(theme)
        return headerView
    }
    
    /* Returns header view with requests chart and statistics */
    private func statisticsHeaderView(_ indexPath: IndexPath) -> StatisticsCollectionReusableView {
        if let statisticsHeader = statisticsHeader {
            return statisticsHeader
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StatisticsCollectionReusableView.reuseIdentifier, for: indexPath) as! StatisticsCollectionReusableView
            headerView.delegate = self
            headerView.chartDateType = statisticsModel.mainPageDateType
            headerView.chartViewConfig = statisticsModel.chartViewConfig(for: statisticsModel.mainPageDateType)
            headerView.statisticsModel = statisticsModel.statistics(for: statisticsModel.mainPageDateType)
            headerView.chartViewIsEnabled = model.systemProtectionIsEnabled
            headerView.updateTheme(theme)
            statisticsHeader = headerView
            return headerView
        }
    }
    
    /* Returns header view with PRO status promotion */
    private func proStatusPromotionHeaderView(_ indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProStatusPromotionCollectionReusableView.reuseIdentifier, for: indexPath) as! ProStatusPromotionCollectionReusableView
        headerView.updateTheme(theme)
        return headerView
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: "NativeDnsCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NativeDnsCollectionReusableView.reuseIdentifier)
        collectionView.register(UINib(nibName: "StatisticsCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StatisticsCollectionReusableView.reuseIdentifier)
        collectionView.register(UINib(nibName: "ProStatusPromotionCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProStatusPromotionCollectionReusableView.reuseIdentifier)
        collectionView.register(UINib(nibName: "StoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: StoryCollectionViewCell.reuseIdentifier)
    }
}

// MARK: - MainPageExtraInfoCollectionDataSource + StatisticsCollectionReusableViewDelegate

extension MainPageExtraInfoCollectionDataSource: StatisticsCollectionReusableViewDelegate {
    func newDateTypeSelected(_ newDateType: ChartDateType) {
        statisticsModel.mainPageDateType = newDateType
    }
}

// MARK: - MainPageExtraInfoCollectionDataSource + StatisticsModelObserver

extension MainPageExtraInfoCollectionDataSource: StatisticsModelObserver {
    func statisticsChanged() {
        statisticsHeader?.chartViewConfig = statisticsModel.chartViewConfig(for: statisticsModel.mainPageDateType)
        statisticsHeader?.statisticsModel = statisticsModel.statistics(for: statisticsModel.mainPageDateType)
        statisticsHeader?.chartDateType = statisticsModel.mainPageDateType
    }
    
    func mainPageDateTypeChanged() {
        statisticsHeader?.chartViewConfig = statisticsModel.chartViewConfig(for: statisticsModel.mainPageDateType)
        statisticsHeader?.statisticsModel = statisticsModel.statistics(for: statisticsModel.mainPageDateType)
        statisticsHeader?.chartDateType = statisticsModel.mainPageDateType
    }
    
    func activityPageDateTypeChanged() {
        // Unimplemented
    }
}

// MARK: - MainPageExtraInfoCollectionDataSource + ThemableProtocol

extension MainPageExtraInfoCollectionDataSource: ThemableProtocol {
    func updateTheme() {
        statisticsHeader?.updateTheme(theme)
        collectionView.reloadData()
    }
}
