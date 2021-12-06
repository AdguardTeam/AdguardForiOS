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

/// This button is used in `LicenseProductChoiceCell`
/// It looks rather complex, so it's appearence is set in separate object
class LicenseProductButton: UIButton {

    // MARK: - Public properties

    var productDescription: String? {
        didSet {
            productDescriptionLabel.text = productDescription
        }
    }

    var productPrice: String? {
        didSet {
            productPriceLabel.text = productPrice
        }
    }

    // MARK: - Private properties

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "arrow_down")
        return imageView
    }()

    private lazy var productDescriptionLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.greyText = true
        return label
    }()

    private lazy var productPriceLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.greyText = true
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    /* Constraints */
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var iPhoneConstraints: [NSLayoutConstraint] = []
    private var iPadConstraints: [NSLayoutConstraint] = []

    // MARK: - Public methods

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    init() {
        super.init(frame: .zero)
        initialize()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollection.onSizeClassChange(previousTraitCollection) {
            layout(for: traitCollection)
            setFonts(for: traitCollection)
        }
    }

    func updateTheme(_ themeService: ThemeServiceProtocol) {
        themeService.setupLabels([productDescriptionLabel, productPriceLabel])
    }

    // MARK: - Private methods

    private func initialize() {
        setupLayer()
        initializeConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        layout(for: traitCollection)
        setFonts(for: traitCollection)
    }

    private func setupLayer() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        layer.borderColor = UIColor.AdGuardColor.lightGray3.cgColor
        layer.borderWidth = 1.0
    }

    private func initializeConstraints() {
        addSubview(containerView)
        bringSubviewToFront(containerView)
        containerView.addSubview(arrowImageView)
        containerView.addSubview(productDescriptionLabel)
        containerView.addSubview(productPriceLabel)

        sharedConstraints = [
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),

            productDescriptionLabel.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: 8.0),
            productDescriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: productPriceLabel.leadingAnchor, constant: -8.0),
            productDescriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            productPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            productPriceLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]

        iPhoneConstraints = [
            arrowImageView.widthAnchor.constraint(equalToConstant: 24.0),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24.0)
        ]

        iPadConstraints = [
            arrowImageView.widthAnchor.constraint(equalToConstant: 32.0),
            arrowImageView.heightAnchor.constraint(equalToConstant: 32.0)
        ]
    }

    private func layout(for traitCollection: UITraitCollection) {
        if traitCollection.isIpadTraitCollection {
            NSLayoutConstraint.deactivate(iPhoneConstraints)
            NSLayoutConstraint.activate(iPadConstraints)
        } else {
            NSLayoutConstraint.deactivate(iPadConstraints)
            NSLayoutConstraint.activate(iPhoneConstraints)
        }
    }

    private func setFonts(for traitCollection: UITraitCollection) {
        let buttonFont = UIFont.systemFont(ofSize: traitCollection.isIpadTraitCollection ? 24.0 : 16.0, weight: .regular)
        productDescriptionLabel.font = buttonFont
        productPriceLabel.font = buttonFont
    }
}
