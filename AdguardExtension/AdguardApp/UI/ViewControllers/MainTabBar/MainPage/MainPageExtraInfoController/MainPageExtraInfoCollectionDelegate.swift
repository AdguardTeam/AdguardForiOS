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
        let model = self.model.storiesModels[indexPath.row]
        showStories(forVC: controller, fromCategory: model.category)
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return storyCellSize(forWidth: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let spaceToHeader: CGFloat
        switch model.fullViewType {
        case .storiesWithNativeDns, .storiesWithStatistics: spaceToHeader = 40.0
        case .storiesWithProStatusPromotion: spaceToHeader = 16.0
        }
        return UIEdgeInsets(top: spaceToHeader, left: itemSpacing, bottom: 0.0, right: itemSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerView: UICollectionReusableView
        switch model.fullViewType {
        case .storiesWithNativeDns: headerView = NativeDnsCollectionReusableView.fromNib
        case .storiesWithStatistics: headerView = StatisticsCollectionReusableView.fromNib
        case .storiesWithProStatusPromotion: headerView = ProStatusPromotionCollectionReusableView.fromNib
        }
        var targetSize = UIView.layoutFittingCompressedSize
        targetSize.width = collectionView.frame.width
        return headerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
    }
    
    // MARK: - Private methods

    private func storyCellSize(forWidth width: CGFloat) -> CGSize {
        let numberOfItemsPerRow: CGFloat = controller.isIpadTrait ? 3 : 2
        let totalSpacing = (2 * itemSpacing) + ((numberOfItemsPerRow - 1) * itemSpacing)
        let cellWidth = (width - totalSpacing ) / numberOfItemsPerRow
        return CGSize(width: cellWidth, height: cellWidth * 2 / 3)
    }
    
    private func showStories<StoriesPresentor: UIViewController>(forVC vc: StoriesPresentor, fromCategory category: StoryCategory.CategoryType) where StoriesPresentor: StoriesPageViewControllerDelegate {
        let stories = model.storiesProvider.stories
        let storiesPageVC = StoriesPageViewController(storiesGroups: stories, startCategory: category)
        storiesPageVC.storiesDelegate = vc
        storiesPageVC.modalPresentationStyle = .fullScreen
        vc.present(storiesPageVC, animated: true)
    }
}
