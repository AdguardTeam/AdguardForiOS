//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

protocol SwitchTableViewCellDelegate: AnyObject {
    func switchStateChanged(to enabled: Bool)
}

final class SwitchTableViewCell: UITableViewCell, Reusable {

    weak var delegate: SwitchTableViewCellDelegate?

    var switchIsOn = false {
        didSet {
            titleLabel.text = switchIsOn.localizedStateDescription
            stateSwitch.setOn(switchIsOn, animated: true)
        }
    }

    private lazy var stateSwitch: UISwitch = {
        let stateSwitch = UISwitch()
        stateSwitch.translatesAutoresizingMaskIntoConstraints = false
        stateSwitch.onTintColor = UIColor.AdGuardColor.lightGreen1
        stateSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return stateSwitch
    }()

    private lazy var titleLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.greyText = true
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    // MARK: - Layout metrics

    private var layoutConstraints: [NSLayoutConstraint] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollection.onSizeClassChange(previousTraitCollection) {
            applyLayoutMetrics()
        }
    }

    func updateTheme(_ themeService: ThemeServiceProtocol) {
        themeService.setupLabel(titleLabel)
        themeService.setupTableCell(self)
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stateSwitch)
        applyLayoutMetrics()
    }

    private func applyLayoutMetrics() {
        let verticalInset: CGFloat = isIpadTrait ? 20.0 : 16.0
        let sideInset: CGFloat = isIpadTrait ? 24.0 : 16.0

        titleLabel.font = UIFont.systemFont(ofSize: isIpadTrait ? 24.0 : 16.0, weight: .regular)

        NSLayoutConstraint.deactivate(layoutConstraints)
        layoutConstraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalInset),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideInset),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalInset),
            titleLabel.trailingAnchor.constraint(equalTo: stateSwitch.leadingAnchor, constant: -sideInset),

            stateSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideInset),
            stateSwitch.widthAnchor.constraint(equalToConstant: 50.0),
            stateSwitch.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ]
        NSLayoutConstraint.activate(layoutConstraints)

    }

    /// Switch action handler
    @objc private final func switchValueChanged(_ sender: UISwitch) {
        switchIsOn = sender.isOn
        delegate?.switchStateChanged(to: sender.isOn)
    }
}
