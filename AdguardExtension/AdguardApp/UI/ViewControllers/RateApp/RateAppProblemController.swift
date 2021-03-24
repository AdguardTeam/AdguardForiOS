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

class RateAppProblemController: BottomAlertController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var problemIsDoneButton: UIButton!
    @IBOutlet weak var problemRemainsButton: UIButton!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // Services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // Theme observer
    private var themeObserver: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDescriptionTextView()
        
        problemIsDoneButton.makeTitleTextUppercased()
        problemIsDoneButton.applyStandardGreenStyle()
        
        problemRemainsButton.makeTitleTextUppercased()
        problemRemainsButton.applyStandardOpaqueStyle(color: .green)
        
        updateTheme()
        themeObserver = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: .main) {[weak self] _ in
            self?.updateTheme()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func problemIsDoneTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func problemRemains(_ sender: UIButton) {
        dismiss(animated: true) {
            AppDelegate.shared.presentBugReportController(withType: .bugReport)
        }
    }
    
    // MARK: - Private methods

    private func updateTheme() {
        theme.setupLabels(themableLabels)
        theme.setupTextView(descriptionTextView)
        setupDescriptionTextView()
    }
    
    private func setupDescriptionTextView() {
        let problemDescription = String.localizedString("rate_app_problem_description")
        descriptionTextView.attributedText = NSMutableAttributedString.fromHtml(problemDescription, fontSize: descriptionTextView.font!.pointSize, color: theme.blackTextColor, attachmentImage: nil, textAlignment: .center)
    }
}
