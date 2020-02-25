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

class RateAppController: UIViewController {

    @IBOutlet weak var rateAppView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var verticalSeparatorView: UIView!
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var messageLabel: ThemableLabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet var stars: [UIButton]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeToken: NotificationToken?
    
    private let rateAppService: RateAppServiceProtocol = ServiceLocator.shared.getService()!
    
    private var selectedStar: Int? = nil {
        didSet {
            submitButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        setupRateApp()
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
            self?.changeBackgroungOnShow()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.backgroundColor = .clear
    }

    @IBAction func starTapped(_ sender: UIButton) {
        let tag = sender.tag
        selectedStar = tag
        
        stars.forEach({ $0.isSelected = $0.tag <= tag })
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        rateAppService.cancelTapped()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        weak var pvc = self.presentingViewController
        dismiss(animated: true) {[weak self] in
            guard let self = self else { return }
            if let selectedStar = self.selectedStar {
                self.rateAppService.rateApp(selectedStar) {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "RateApp", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "FeedbackController")
                        controller.modalTransitionStyle = .crossDissolve
                        pvc?.present(controller, animated: true)
                    }
                }
            }
        }
    }
    
    private func updateTheme() {
        rateAppView.backgroundColor = theme.popupBackgroundColor
        separatorView.backgroundColor = theme.separatorColor
        verticalSeparatorView.backgroundColor = theme.separatorColor
        cancelButton.backgroundColor = theme.popupBackgroundColor
        submitButton.backgroundColor = theme.popupBackgroundColor
        theme.setupLabel(titleLabel)
        theme.setupLabel(messageLabel)
    }
    
    private func setupRateApp(){
        rateAppView.layer.cornerRadius = 15.0
        rateAppView.clipsToBounds = true
    }
    
    private func changeBackgroungOnShow(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let self = self else { return }
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            }
        }
    }
}
