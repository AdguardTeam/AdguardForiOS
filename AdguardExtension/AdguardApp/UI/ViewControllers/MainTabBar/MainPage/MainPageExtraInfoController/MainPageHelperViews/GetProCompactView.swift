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

final class GetProCompactView: MainPageCompactView {
        
    // MARK: - Initializer
    
    override init() {
        super.init()
        processTitleLabel()
        descriptionLabel.text = String.localizedString("get_pro_description")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        processTitleLabel()
        descriptionLabel.text = String.localizedString("get_pro_description")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        processTitleLabel()
        descriptionLabel.text = String.localizedString("get_pro_description")
    }
    
    // MARK: - Public methods
    
    override func updateTheme(_ themeService: ThemeServiceProtocol) {
        super.updateTheme(themeService)
        processTitleLabel()
    }
    
    // MARK: - Private methods
    
    private func processTitleLabel() {
        let format = String.localizedString("get_pro_title")
        let colorHex = UIColor.AdGuardColor.lightGreen2.hex()
        let string = String(format: format, colorHex)
        let fontSize = titleLabel.font.pointSize
        let fontColor = titleLabel.textColor ?? .clear
        titleLabel.attributedText = NSMutableAttributedString.fromHtml(string, fontSize: fontSize, color: fontColor, attachmentImage: nil, textAlignment: .center)
    }
}
