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
import SafariAdGuardSDK

struct SafariGroupStateHeaderModel {
    let iconImage: UIImage
    let groupName: String
    let isEnabled: Bool
    let groupType: SafariGroup.GroupType
}

extension SafariGroupStateHeaderModel {
    init() {
        self.iconImage = UIImage()
        self.groupName = ""
        self.isEnabled = false
        self.groupType = .ads
    }
    
    init(group: SafariGroup, proStatus: Bool) {
        self.iconImage = group.groupType.iconImage
        self.groupName = group.groupName
        self.isEnabled = group.isEnabled
        self.groupType = group.groupType
    }
}

// MARK: - SafariGroupStateTableCell

protocol SafariGroupStateHeaderDelegate: AnyObject {
    func stateChanged(for groupType: SafariGroup.GroupType, newState: Bool)
}

final class SafariGroupStateHeaderView: UIView {
    
    
    weak var delegate: SafariGroupStateHeaderDelegate?
    
    static func height(isIpadTrait: Bool) -> CGFloat {
        let topInset: CGFloat = 14.0
        let bottomInset: CGFloat = 14.0
        let iconHeight: CGFloat = isIpadTrait ? 32.0 : 24.0
        return topInset + iconHeight + bottomInset
    }
    
    // MARK: - UI Elements
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var groupNameLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.greyText = true
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textAlignment = .left
        label.text = model.groupName
        return label
    }()
    
    private lazy var stateSwitch: UISwitch = {
        let stateSwitch = UISwitch()
        stateSwitch.translatesAutoresizingMaskIntoConstraints = false
        stateSwitch.onTintColor = UIColor.AdGuardColor.green
        stateSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return stateSwitch
    }()
    
    // MARK: - Services
    
    private let model: SafariGroupStateHeaderModel
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // MARK: - Properties
    private var themeObserver: NotificationToken?
    
    required init?(coder: NSCoder) {
        self.model = SafariGroupStateHeaderModel()
        super.init(coder: coder)
        setupUI()
        process(model: model)
        setupTheme()
    }
    
    override init(frame: CGRect) {
        self.model = SafariGroupStateHeaderModel()
        super.init(frame: frame)
        setupUI()
        process(model: model)
        setupTheme()
    }
    
    init(model: SafariGroupStateHeaderModel) {
        self.model = model
        super.init(frame: .zero)
        setupUI()
        process(model: model)
        setupTheme()
    }
    
    /// Switch action handler
    @objc private final func switchValueChanged() {
        delegate?.stateChanged(for: model.groupType, newState: !model.isEnabled)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        addSubview(iconImageView)
        addSubview(groupNameLabel)
        addSubview(stateSwitch)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24.0),
            iconImageView.heightAnchor.constraint(equalToConstant: 24.0),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 14.0),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14.0),
            
            groupNameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16.0),
            groupNameLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            
            stateSwitch.leadingAnchor.constraint(equalTo: groupNameLabel.trailingAnchor, constant: 16.0),
            stateSwitch.widthAnchor.constraint(equalToConstant: 50.0),
            stateSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            stateSwitch.centerYAnchor.constraint(equalTo: groupNameLabel.centerYAnchor)
        ])
    }
    
    private func process(model: SafariGroupStateHeaderModel) {
        self.iconImageView.image = model.iconImage
        self.groupNameLabel.text = model.groupName
        self.stateSwitch.isOn = model.isEnabled
    }
    
    private func setupTheme() {
        iconImageView.tintColor = UIColor.AdGuardColor.green
        updateTheme()
        
        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }
}

// MARK: - SafariGroupStateHeaderView + ThemableProtocol

extension SafariGroupStateHeaderView: ThemableProtocol {
    func updateTheme() {
        backgroundColor = themeService.backgroundColor
        themeService.setupLabel(groupNameLabel)
    }
}
