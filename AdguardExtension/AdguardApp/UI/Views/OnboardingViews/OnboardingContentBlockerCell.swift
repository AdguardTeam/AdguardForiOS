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

/**
 OnboardingContentBlockerCell - Custom onboarding table view cell
 */

final class OnboardingContentBlockerCell: UITableViewCell {
    //MARK: - Properties
    private let uiSwitch: UISwitch = {
       let view = UISwitch()
        view.isOn = true
        view.isEnabled = true
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let adguardIcon: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "LoadScreen")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
       let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 17.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var titleString: String? {
        didSet {
            titleLabel.text = titleString
        }
    }
    
    var titleLabelTextColor: UIColor? {
        didSet {
            titleLabel.textColor = titleLabelTextColor
        }
    }
    
    //MARK: - Init
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupConstraints()
    }

    //MARK: - Private methods
    private func setupConstraints() {
        self.contentView.addSubview(adguardIcon)
        self.contentView.addSubview(uiSwitch)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(separator)
        
        adguardIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        adguardIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        adguardIcon.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        adguardIcon.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -16.0).isActive = true
        adguardIcon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        
        titleLabel.trailingAnchor.constraint(equalTo: uiSwitch.leadingAnchor, constant: -16.0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        uiSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -2.0).isActive = true
        uiSwitch.widthAnchor.constraint(equalToConstant: 49.0).isActive = true
        uiSwitch.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6.0).isActive = true
        uiSwitch.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6.0).isActive = true
        uiSwitch.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
}
