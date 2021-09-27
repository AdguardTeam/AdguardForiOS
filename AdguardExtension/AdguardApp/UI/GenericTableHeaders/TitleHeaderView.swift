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

final class TitleTableHeaderView: UIView {
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 40.0 : 24.0, weight: .bold)
        return label
    }()
    
    // MARK: - Properties
    
    var title: String {
        didSet {
            titleLabel.text = title
        }
    }
    
    required init?(coder: NSCoder) {
        self.title = ""
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        self.title = ""
        super.init(frame: frame)
    }
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupUI()
    }
    
    // MARK: - Internal methods
    
    func updateTheme(_ themeService: ThemeServiceProtocol) {
        backgroundColor = themeService.backgroundColor
        themeService.setupLabel(titleLabel)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        titleLabel.text = title
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: isIpadTrait ? 24.0 : 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: isIpadTrait ? -24.0 : -16.0),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: titleLabel.font.pointSize + 2.0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: isIpadTrait ? -24.0 : -16.0),
        ])
    }
}
