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

final class MainPageViewController: PullableContainerController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var chooseStatisticsDateTypeButton: UIButton!
    
    // MARK: - Private properties
    
    /* Services */
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    /* Models */
    private let model: MainPageModelProtocol
    private let statisticsModel: StatisticsModelProtocol = ServiceLocator.shared.getService()!
    
    /* Helper variables */
    
    // MARK: - ViewController lifecycle
    
    required init?(coder: NSCoder) {
        model = MainPageModel(resources: resources, configuration: configuration)
        super.init(coder: coder)
        
        (model as! MainPageModel).delegate = self
    }
    
    override func viewDidLoad() {
        let mainPageExtraInfoVC = storyboard?.instantiateViewController(withIdentifier: "MainPageExtraInfoController") as! MainPageExtraInfoController
        self.contentController = mainPageExtraInfoVC
        super.viewDidLoad()
        
        statisticsModel.observers.append(self)
        setStatisticsDateButtonTitle()
        chooseStatisticsDateTypeButton.isHidden = !model.shouldShowDateTypePicker
    }
    
    // MARK: - Actions
    
    @IBAction func chooseStatisticsDateTapped(_ sender: UIButton) {
        presentChooseStatisticsDateAlert { [weak self] dateType in
            self?.statisticsModel.mainPageDateType = dateType
        }
    }
    
    // MARK: - Private methods
    
    private func setStatisticsDateButtonTitle() {
        let statisticsButtonTitle = statisticsModel.mainPageDateType.getDateTypeString()
        chooseStatisticsDateTypeButton.setTitle(statisticsButtonTitle, for: .normal)
    }
}

// MARK: - MainPageViewController + MainPageModelDelegate

extension MainPageViewController: MainPageModelDelegate {
    func shouldShowDateTypePickerChanged() {
        chooseStatisticsDateTypeButton.isHidden = !model.shouldShowDateTypePicker
    }
}

// MARK: - MainPageViewController + StatisticsModelObserver

extension MainPageViewController: StatisticsModelObserver {
    func statisticsChanged() {
        setStatisticsDateButtonTitle()
    }
    
    func mainPageDateTypeChanged() {
        setStatisticsDateButtonTitle()
    }
    
    func activityPageDateTypeChanged() {
        // Unimplemented
    }
}

// MARK: - MainPageViewController + UIGestureRecognizerDelegate

extension MainPageViewController {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer,
              let mainPageExtraInfoVC = contentController as? MainPageExtraInfoController,
              let collectionView = mainPageExtraInfoVC.collectionView else {
            return false
        }
        let direction = gesture.velocity(in: view).y

        if (isCompact == false && collectionView.contentOffset.y == 0 && direction > 0) || isCompact == true {
            collectionView.isScrollEnabled = false
        } else {
            collectionView.isScrollEnabled = true
        }
        return false
    }
}
