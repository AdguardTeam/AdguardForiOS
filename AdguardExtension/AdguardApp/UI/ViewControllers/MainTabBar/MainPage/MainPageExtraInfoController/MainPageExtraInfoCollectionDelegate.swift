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

final class MainPageExtraInfoCollectionDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    private let itemSpacing: CGFloat = 8.0
    
    private unowned let controller: MainPageExtraInfoController
    private let model: MainPageExtraInfoModel
    
    init(controller: MainPageExtraInfoController, model: MainPageExtraInfoModel) {
        self.controller = controller
        self.model = model
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer { collectionView.deselectItem(at: indexPath, animated: true) }
                
        switch (model.fullViewType, indexPath.section) {
        case (.stories, 0):
            let model = self.model.storiesModels[indexPath.row]
            StoriesManager.showStories(forVC: controller, fromCategory: model.category)
            return
        case (.storiesWithStatistics, 0):
            return
        case (.storiesWithStatistics, 1):
            let model = self.model.storiesModels[indexPath.row]
            StoriesManager.showStories(forVC: controller, fromCategory: model.category)
        default: return
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        switch (model.fullViewType, indexPath.section) {
        case (.stories, 0): return storyCellSize(forWidth: width)
        case (.storiesWithStatistics, 0): return statisticsCellSize(forWidth: width)
        case (.storiesWithStatistics, 1): return storyCellSize(forWidth: width)
        default: return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: itemSpacing, bottom: 0.0, right: itemSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    // MARK: - Private methods
    
    private func storyCellSize(forWidth width: CGFloat) -> CGSize {
        let numberOfItemsPerRow: CGFloat = controller.isIpadTrait ? 3 : 2
        let totalSpacing = (2 * itemSpacing) + ((numberOfItemsPerRow - 1) * itemSpacing)
        let cellWidth = (width - totalSpacing ) / numberOfItemsPerRow
        return CGSize(width: cellWidth, height: cellWidth * 2 / 3)
    }
    
    private func statisticsCellSize(forWidth width: CGFloat) -> CGSize {
        let height: CGFloat = controller.isIpadTrait ? 350.0 : 250.0
        return CGSize(width: width, height: height)
    }
}
