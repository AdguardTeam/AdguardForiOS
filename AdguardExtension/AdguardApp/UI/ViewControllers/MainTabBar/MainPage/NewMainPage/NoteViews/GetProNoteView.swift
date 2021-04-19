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

final class GetProNoteView: MainPageNoteView {
    // MARK: - UI elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        
        let fontSize: CGFloat = isIpadTrait ? 20.0 : 14.0
        let format = String.localizedString("get_pro_note_view_title")
        let text = String(format: format, Bundle.main.applicationName)
        label.text = text
        label.textColor = UIColor.AdGuardColor.lightGray2
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 20.0 : 14.0, weight: .regular)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "adguard-small-icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        // Image view
        addSubview(imageView)
        let side: CGFloat = isIpadTrait ? 32.0 : 24.0
        imageView.widthAnchor.constraint(equalToConstant: side).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: side).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        // Title label
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: crossButton.leadingAnchor, constant: -16.0).isActive = true
    }
}
