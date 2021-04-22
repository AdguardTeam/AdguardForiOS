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

final class ProStatusPromotionCollectionReusableView: UICollectionReusableView, Reusable, NibInitializable {
    
    // MARK: - UI elements
    
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var proButton: UIButton! {
        didSet {
            proButton.layer.cornerRadius = 8.0
            proButton.layer.masksToBounds = true
            setButtonAttributedTitle()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func proButtonTouched(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            self.proButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @IBAction func proButtonTouchCanceled(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            self.proButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @IBAction func proButtonUntouched(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            self.proButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        AppDelegate.shared.presentLicenseScreen()
    }
    
    // MARK: - Public methods
    
    func updateTheme(_ theme: ThemeServiceProtocol) {
        theme.setupLabels([titleLabel, descriptionLabel])
    }
    
    // MARK: - Private methods
    
    private func setButtonAttributedTitle() {
        let string = String.localizedString("header_pro_status_promo_title")
        let fontSize = proButton.titleLabel?.font.pointSize ?? 16.0
        let fontColor = proButton.titleColor(for: .normal) ?? .white
        proButton.setAttributedTitle(string, fontSize: fontSize, color: fontColor, attachmentImage: nil, textAlignment: .left)
    }
}
