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

class HowToSetupController: BottomAlertController {

    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var openSettingsButton: UIButton!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - Observers
    private var themeObserver: NotificationToken?
    
    // MARK: - services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openSettingsButton.makeTitleTextUppercased()
        openSettingsButton.applyStandardGreenStyle()
        
        updateTheme()
        setupLabels()
        
        themeObserver = NotificationCenter.default.observe(name: NSNotification.Name(ConfigurationService.themeChangeNotification), object: nil, queue: .main) {[weak self] (notification) in
            self?.updateTheme()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func openSettingsTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    // MARK: - Private methods

    private func updateTheme() {
        contentView.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
    }
    
    private func setupLabels() {
        let titleFormat = String.localizedString("native_dns_setup_title")
        let title = String(format: titleFormat, Bundle.main.applicationName ?? "AdGuard")
        titleLabel.text = title
        
        let descriptionFormat = String.localizedString("native_dns_setup_description")
        let description = String(format: descriptionFormat, Bundle.main.applicationName ?? "AdGuard")
        descriptionLabel.attributedText = NSMutableAttributedString.fromHtml(description, fontSize: descriptionLabel.font!.pointSize, color: theme.grayTextColor, attachmentImage: nil, textAlignment: .center)
    }
}
