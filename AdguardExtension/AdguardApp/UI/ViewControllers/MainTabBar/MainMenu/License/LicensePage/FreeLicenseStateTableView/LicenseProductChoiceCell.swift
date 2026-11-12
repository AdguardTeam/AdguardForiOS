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

protocol LicenseProductChoiceCellDelegate: AnyObject {
    func productChoiceButtonTapped()
    func subscribeButtonTapped()
    func restorePurchaseButtonTapped()
}

/// This cell displays info about subscription plans and restoring purchase available for the user
final class LicenseProductChoiceCell: UITableViewCell, Reusable {

    weak var delegate: LicenseProductChoiceCellDelegate?

    var usesCompactLayout = false {
        didSet {
            guard usesCompactLayout != oldValue else { return }
            layout(for: traitCollection)
            setFonts(for: traitCollection)
            licenseProductButton.usesCompactLayout = usesCompactLayout
        }
    }

    // MARK: - Private properties

    /* UI elements */

    private lazy var trialLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.greyText = true
        label.textAlignment = .center
        return label
    }()

    private lazy var licenseProductButton: LicenseProductButton = {
        let button = LicenseProductButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(productButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var subscribeButton: RoundRectButton = {
        let button = RoundRectButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.needsToDisplayIndicator = true
        button.layer.cornerRadius = 8.0
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.AdGuardColor.lightGreen1
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(subscribeButtonTapped), for: .touchUpInside)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = .init(top: 8, left: 0, bottom: 8, right: 0)
        return button
    }()

    private lazy var restorePurchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle(String.localizedString("restore_purchase_button_title"), for: .normal)
        button.setTitleColor(UIColor.AdGuardColor.lightGreen1, for: .normal)
        button.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        return button
    }()

    /* Constraints */
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var iPhoneConstraints: [NSLayoutConstraint] = []
    private var iPadConstraints: [NSLayoutConstraint] = []
    private var compactConstraints: [NSLayoutConstraint] = []
    private var licenseProductButtonTopConstraintWithTrialLabel: NSLayoutConstraint!
    private var licenseProductButtonTopConstraintWithoutTrialLabel: NSLayoutConstraint!
    private lazy var compactSubscribeHeightConstraint =
        subscribeButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44.0)


    // MARK: - Public methods

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollection.onSizeClassChange(previousTraitCollection) {
            layout(for: traitCollection)
            setFonts(for: traitCollection)
        }
    }

    func setTrialLabelTitle(_ title: String?) {
        trialLabel.text = title
    }

    func setProductButtonTitle(_ title: String?) {
        subscribeButton.setTitle(title, for: .normal)
    }

    func setTrialAvailability(_ isAvailable: Bool) {
        trialLabel.isHidden = !isAvailable
        licenseProductButtonTopConstraintWithTrialLabel.isActive = isAvailable
        licenseProductButtonTopConstraintWithoutTrialLabel.isActive = !isAvailable
    }

    func setLicenseProduct(_ title: String?, _ price: String?) {
        licenseProductButton.productDescription = title
        licenseProductButton.productPrice = price
    }

    func setLoading(_ isLoading: Bool) {
        subscribeButton.isEnabled = !isLoading
        restorePurchaseButton.isEnabled = !isLoading
        if isLoading {
            subscribeButton.startIndicator()
        } else {
            subscribeButton.stopIndicator()
        }
    }

    func updateTheme(_ themeService: ThemeServiceProtocol) {
        themeService.setupTableCell(self)
        themeService.setupLabel(trialLabel)
        licenseProductButton.updateTheme(themeService)
    }

    // MARK: - Private methods

    private func initialize() {
        selectionStyle = .none
        setupLayer()
        initializeConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        layout(for: traitCollection)
        setFonts(for: traitCollection)
    }

    private func setupLayer() {
        layer.cornerRadius = 8.0
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
    }

    private func initializeConstraints() {
        let container = UILayoutGuide()
        contentView.addLayoutGuide(container)

        contentView.addSubview(trialLabel)
        contentView.addSubview(licenseProductButton)
        contentView.addSubview(subscribeButton)
        contentView.addSubview(restorePurchaseButton)

        licenseProductButtonTopConstraintWithTrialLabel = licenseProductButton.topAnchor.constraint(equalTo: trialLabel.bottomAnchor, constant: isIpadTrait ? 32.0 : 24.0)
        licenseProductButtonTopConstraintWithoutTrialLabel = licenseProductButton.topAnchor.constraint(equalTo: container.topAnchor)

        sharedConstraints = [
            trialLabel.topAnchor.constraint(equalTo: container.topAnchor),
            trialLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            trialLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            licenseProductButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            licenseProductButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            subscribeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            subscribeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            restorePurchaseButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            restorePurchaseButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            restorePurchaseButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ]

        iPhoneConstraints = [
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.0),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),

            licenseProductButton.heightAnchor.constraint(equalToConstant: 40.0),

            subscribeButton.topAnchor.constraint(equalTo: licenseProductButton.bottomAnchor, constant: 16.0),

            restorePurchaseButton.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 16.0),
            restorePurchaseButton.heightAnchor.constraint(equalToConstant: 40.0)
        ]

        iPadConstraints = [
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.0),
            container.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            container.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),

            licenseProductButton.heightAnchor.constraint(equalToConstant: 50.0),

            subscribeButton.topAnchor.constraint(equalTo: licenseProductButton.bottomAnchor, constant: 24.0),

            restorePurchaseButton.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 24.0),
            restorePurchaseButton.heightAnchor.constraint(equalToConstant: 50.0)
        ]

        // Compact metrics for short wide windows (Duo unfolded):
        // tighter paddings and standard 44 pt tap-target button heights.
        compactConstraints = [
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),

            licenseProductButton.heightAnchor.constraint(equalToConstant: 44.0),

            subscribeButton.topAnchor.constraint(equalTo: licenseProductButton.bottomAnchor, constant: 8.0),

            restorePurchaseButton.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 8.0),
            restorePurchaseButton.heightAnchor.constraint(equalToConstant: 44.0)
        ]
    }

    private func layout(for traitCollection: UITraitCollection) {
        let largeMetrics = traitCollection.isIpadTraitCollection && !usesCompactLayout
        let trialSpacing: CGFloat = usesCompactLayout ? 12.0 : (largeMetrics ? 32.0 : 24.0)
        licenseProductButtonTopConstraintWithTrialLabel.constant = trialSpacing

        let buttonInset: CGFloat = usesCompactLayout ? 4.0 : 8.0
        subscribeButton.contentEdgeInsets = .init(top: buttonInset, left: 0, bottom: buttonInset, right: 0)
        compactSubscribeHeightConstraint.isActive = usesCompactLayout

        NSLayoutConstraint.deactivate(iPhoneConstraints + iPadConstraints + compactConstraints)
        if usesCompactLayout {
            NSLayoutConstraint.activate(compactConstraints)
        } else if largeMetrics {
            NSLayoutConstraint.activate(iPadConstraints)
        } else {
            NSLayoutConstraint.activate(iPhoneConstraints)
        }
        if trialLabel.isHidden {
            NSLayoutConstraint.activate([licenseProductButtonTopConstraintWithoutTrialLabel])
        } else {
            NSLayoutConstraint.activate([licenseProductButtonTopConstraintWithTrialLabel])
        }
    }

    private func setFonts(for traitCollection: UITraitCollection) {
        let isIpad = traitCollection.isIpadTraitCollection && !usesCompactLayout
        let trialLabelFont = UIFont.systemFont(ofSize: isIpad ? 24.0 : 16.0, weight: .bold)
        let buttonFont = UIFont.systemFont(ofSize: isIpad ? 24.0 : 16.0, weight: .regular)

        trialLabel.font = trialLabelFont
        subscribeButton.titleLabel?.font = buttonFont
        restorePurchaseButton.titleLabel?.font = buttonFont
    }

    @objc private final func productButtonTapped() {
        delegate?.productChoiceButtonTapped()
    }

    @objc private final func subscribeButtonTapped() {
        delegate?.subscribeButtonTapped()
    }

    @objc private final func restoreButtonTapped() {
        delegate?.restorePurchaseButtonTapped()
    }
}
