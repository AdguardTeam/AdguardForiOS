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
    private unowned let controller: MainPageExtraInfoController // TODO: - maybe unneeded
    private let theme: ThemeServiceProtocol
    private let model: MainPageExtraInfoModel
    private let statisticsModel: StatisticsModelProtocol
    
    private var statisticsCell: StatisticsCollectionViewCell?
    
    init(controller: MainPageExtraInfoController, theme: ThemeServiceProtocol, model: MainPageExtraInfoModel, statisticsModel: StatisticsModelProtocol) {
        self.collectionView = controller.collectionView
        self.controller = controller
        self.theme = theme
        self.model = model
        self.statisticsModel = statisticsModel
        super.init()
        
        statisticsModel.observers.append(self)
        registerCells()
    }
    
    // MARK: - Data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch model.fullViewType {
        case .stories: return 1
        case .storiesWithStatistics: return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (model.fullViewType, section) {
        case (.stories, 0): return model.storiesModels.count
        case (.storiesWithStatistics, 0): return 1
        case (.storiesWithStatistics, 1): return model.storiesModels.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch model.fullViewType {
        case .stories: return storyCell(forIndexPath: indexPath)
        case .storiesWithStatistics: return storiesWithStatistics(forIndexPath: indexPath)
        }
    }
    
    // MARK: - Private methods
    
    /* Returns cell for collection view modification with stories and statistics */
    private func storiesWithStatistics(forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: StatisticsCollectionViewCell
            if statisticsCell != nil {
                cell = statisticsCell!
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsCollectionViewCell.reuseIdentifier, for: indexPath) as! StatisticsCollectionViewCell
                statisticsCell = cell
                cell.delegate = self
            }

            cell.updateTheme(theme)
            cell.chartDateType = statisticsModel.mainPageDateType
            cell.chartViewConfig = statisticsModel.chartViewConfig(for: statisticsModel.mainPageDateType)
            return cell
        } else if indexPath.section == 1 {
            return storyCell(forIndexPath: indexPath)
        }
        return UICollectionViewCell()
    }
    
    /* Returns story cell for index path, it will return story cell from cache if it was already created */
    private func storyCell(forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.reuseIdentifier, for: indexPath) as! StoryCollectionViewCell
        let model = self.model.storiesModels[indexPath.row]
        cell.model = model
        return cell
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: "StoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: StoryCollectionViewCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "StatisticsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: StatisticsCollectionViewCell.reuseIdentifier)
    }
}

// MARK: - MainPageExtraInfoCollectionDataSource + StatisticsCollectionViewCellDelegate

extension MainPageExtraInfoCollectionDataSource: StatisticsCollectionViewCellDelegate {
    func newDateTypeSelected(_ newDateType: ChartDateType) {
        statisticsModel.mainPageDateType = newDateType
    }
}

// MARK: - MainPageExtraInfoCollectionDataSource + StatisticsModelObserver

extension MainPageExtraInfoCollectionDataSource: StatisticsModelObserver {
    func statisticsChanged() {
        statisticsCell?.chartViewConfig = statisticsModel.chartViewConfig(for: statisticsModel.mainPageDateType)
        statisticsCell?.statisticsModel = statisticsModel.statistics(for: statisticsModel.mainPageDateType)
        statisticsCell?.chartDateType = statisticsModel.mainPageDateType
    }
    
    func mainPageDateTypeChanged() {
        statisticsCell?.chartViewConfig = statisticsModel.chartViewConfig(for: statisticsModel.mainPageDateType)
        statisticsCell?.statisticsModel = statisticsModel.statistics(for: statisticsModel.mainPageDateType)
        statisticsCell?.chartDateType = statisticsModel.mainPageDateType
    }
    
    func activityPageDateTypeChanged() {
        // Unimplemented
    }
}

// MARK: - MainPageExtraInfoCollectionDataSource + ThemableProtocol

extension MainPageExtraInfoCollectionDataSource: ThemableProtocol {
    func updateTheme() {
        collectionView.reloadData()
    }
}
