///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///

import UIKit
import SafariAdGuardSDK

struct StateHeaderViewModel<ObjectIdType: Equatable>: IdentifiableObject {
    let iconImage: UIImage?
    let title: String
    var isEnabled: Bool
    var id: ObjectIdType
}

final class StateHeaderView<ModelIdType: Equatable>: UIView, IdentifiableObjectProtocol {

    var config: IdentifiableViewConfig<StateHeaderViewModel<ModelIdType>>! {
        didSet {
            iconImageView.image = config.model.iconImage
            titleLabel.text = config.model.title
            stateSwitch.isOn = config.model.isEnabled
        }
    }

    // MARK: - UI Elements

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.greyText = true
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 24.0 : 16.0, weight: .regular)
        label.textAlignment = .left
        return label
    }()

    private lazy var stateSwitch: UISwitch = {
        let stateSwitch = UISwitch()
        stateSwitch.translatesAutoresizingMaskIntoConstraints = false
        stateSwitch.onTintColor = UIColor.AdGuardColor.lightGreen1
        stateSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return stateSwitch
    }()

    // MARK: - Services

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // MARK: - Properties
    private var themeObserver: NotificationToken?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupTheme()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTheme()
    }

    /// Switch action handler
    @objc private final func switchValueChanged() {
        config.model.isEnabled = !config.model.isEnabled
        config.delegate?.modelChanged(config.model)
    }

    // MARK: - Private methods

    private func setupUI() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(stateSwitch)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24.0),
            iconImageView.heightAnchor.constraint(equalToConstant: 24.0),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30.0),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30.0),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16.0),
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),

            stateSwitch.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16.0),
            stateSwitch.widthAnchor.constraint(equalToConstant: 50.0),
            stateSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            stateSwitch.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
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

extension StateHeaderView: ThemableProtocol {
    func updateTheme() {
        backgroundColor = themeService.backgroundColor
        themeService.setupLabel(titleLabel)
    }
}
