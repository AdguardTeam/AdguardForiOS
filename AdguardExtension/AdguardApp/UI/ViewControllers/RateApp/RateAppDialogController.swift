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

class RateAppDialogController: UIViewController {
    
    
    @IBOutlet weak var rateAppTitle: ThemableLabel!
    @IBOutlet weak var manImageView: UIImageView!
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var messageLabel: ThemableLabel!
    @IBOutlet weak var rateButton: UIButton!
    
    @IBOutlet var starsButtons: [UIButton]!
    
    private var selectedStar: Int = 5
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeToken: NotificationToken?
    
    private let rateAppService: RateAppServiceProtocol = ServiceLocator.shared.getService()!
    
    private let goodCaseImage = UIImage(named: "smile_man")
    private let badCaseImage = UIImage(named: "sad_man")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starsButtons.forEach({ $0.isSelected = true })
        titleLabel.text = String.localizedString("5_star_title")
        messageLabel.text = String.localizedString("5_star_message")
        updateTheme()
        setupBackButton()
        title = String.localizedString("rate_app_title")
        rateButton.makeTitleTextUppercased()
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rateButton.layoutIfNeeded()
        rateButton.layer.cornerRadius = rateButton.frame.height / 2
    }

    @IBAction func starButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        selectedStar = tag
        starsButtons.forEach({ $0.isSelected = $0.tag <= tag })
        manImageView.image = tag > 3 ? goodCaseImage : badCaseImage
        titleLabel.text = String.localizedString("\(tag)_star_title")
        messageLabel.text = String.localizedString("\(tag)_star_message")
    }
    
    @IBAction func rateButtonTapped(_ sender: UIButton) {
        weak var pvc = presentationController?.presentingViewController
        rateAppService.rateApp(selectedStar) {
            dismiss(animated: true) {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "RateApp", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "FeedbackController")
                    controller.modalTransitionStyle = .crossDissolve
                    pvc?.present(controller, animated: true)
                }
            }
        }
        dismiss(animated: true)
    }
    
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.popupBackgroundColor
        theme.setupLabel(titleLabel)
        theme.setupLabel(messageLabel)
        theme.setupLabel(rateAppTitle)
    }
}
