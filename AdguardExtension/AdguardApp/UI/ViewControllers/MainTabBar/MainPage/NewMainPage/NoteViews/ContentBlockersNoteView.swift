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

final class ContentBlockersNoteView: MainPageNoteView {
    
    // MARK: - UI elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        let fontSize: CGFloat = isIpadTrait ? 20.0 : 14.0
        let fontColor = UIColor.AdGuardColor.lightGray2
        let fontHintColor = UIColor.AdGuardColor.errorRedColor
        let format = String.localizedString("disabled_content_blockers_note")
        let text = String(format: format, fontHintColor.hex())
        label.setAttributedTitle(text, fontSize: fontSize, color: fontColor, attachmentImage: nil, textAlignment: .left)
        
        return label
    }()
    
    // MARK: - initialization
    
    override init() {
        super.init()
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        // Title label
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: crossButton.leadingAnchor, constant: -16.0).isActive = true
    }
}
