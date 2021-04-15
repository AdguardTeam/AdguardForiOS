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
    
    private lazy var contentBlockersView: ContentBlockersNoteView = {
        let view = ContentBlockersNoteView()
        view.onViewTapped = { [weak self] in
            self?.showContentBlockersHelperController()
        }
        return view
    }()
    
    // MARK: - Private properties
    
    /* Services */
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    /* Models */
    private let datePickerModel: StatisticsDatePickerModelProtocol
    private let statisticsModel: StatisticsModelProtocol = ServiceLocator.shared.getService()!
    private let contentBlockersModel: ContentBlockersStateModelProtocol
    
    /* Helper variables */
    
    // MARK: - ViewController lifecycle
    
    required init?(coder: NSCoder) {
        datePickerModel = StatisticsDatePickerModel(resources: resources, configuration: configuration)
        contentBlockersModel = ContentBlockersStateModel(configuration: configuration)
        super.init(coder: coder)
        
        (datePickerModel as! StatisticsDatePickerModel).delegate = self
        (contentBlockersModel as! ContentBlockersStateModel).delegate = self
    }
    
    override func viewDidLoad() {
        let mainPageExtraInfoVC = storyboard?.instantiateViewController(withIdentifier: "MainPageExtraInfoController") as! MainPageExtraInfoController
        self.contentController = mainPageExtraInfoVC
        super.viewDidLoad()
        
        statisticsModel.observers.append(self)
        setStatisticsDateButtonTitle()
        chooseStatisticsDateTypeButton.isHidden = !datePickerModel.shouldShowDateTypePicker
        contentBlockersStateChanged()
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

// MARK: - MainPageViewController + StatisticsDatePickerModelDelegate

extension MainPageViewController: StatisticsDatePickerModelDelegate {
    func shouldShowDateTypePickerChanged() {
        chooseStatisticsDateTypeButton.isHidden = !datePickerModel.shouldShowDateTypePicker
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

// MARK: - MainPageViewController + ContentBlockersStateModelDelegate

extension MainPageViewController: ContentBlockersStateModelDelegate {
    func contentBlockersStateChanged() {
        if contentBlockersModel.shouldShowContentBlockersView {
            showContentBlockersView()
        } else {
            contentBlockersView.dismiss()
        }
    }
    
    private func showContentBlockersView() {
        contentBlockersView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(contentBlockersView, belowSubview: pullableView)
        
        contentBlockersView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: isIpadTrait ? -182.0 : -116.0).isActive = true
        if isIpadTrait {
            contentBlockersView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            contentBlockersView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.5).isActive = true
        } else {
            contentBlockersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
            contentBlockersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
        }
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

// MARK: - MainPageViewController + ShowContentBlockersHelperController

fileprivate extension UIViewController {
    func showContentBlockersHelperController() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        guard let navController = storyboard.instantiateViewController(withIdentifier: "OnboardingNavigationController") as? UINavigationController,
              let controller = storyboard.instantiateViewController(withIdentifier: "OnboardingController") as? OnboardingController else {
            return
        }
        navController.viewControllers = [controller]
        controller.delegate = self as? OnboardingControllerDelegate
        controller.needsShowingPremium = false
        present(navController, animated: true)
    }
}

// MARK: - MainPageViewController + OnboardingControllerDelegate

extension MainPageViewController: OnboardingControllerDelegate {
    func onboardingDidFinish() {
        // TODO: - Process it
    }
}
