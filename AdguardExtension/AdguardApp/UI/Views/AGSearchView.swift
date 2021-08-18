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

final class AGSearchView: UIView {

    private let textField: AGTextField = {
        let textField = AGTextField()
        return textField
    }()
    
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeObserver: NotificationToken?
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    // MARK: - Private methods
    
    private func customInit() {
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0)
        ])
        
        updateTheme()
        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }
}

extension AGSearchView: ThemableProtocol {
    func updateTheme() {
        backgroundColor = themeService.backgroundColor
        textField.themeChanged()
    }
}


