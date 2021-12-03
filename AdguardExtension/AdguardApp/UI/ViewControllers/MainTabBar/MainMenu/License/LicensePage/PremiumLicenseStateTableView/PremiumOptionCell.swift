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

final class PremiumOptionCell: UITableViewCell, Reusable {

    // MARK: - Public properties

    var model: PremiumFeatureViewModel? {
        didSet {
            featureImageView.image = model?.icon
            featureNameLabel.text = model?.featureName
            featureDescriptionLabel.text = model?.featureDescription
        }
    }

    // MARK: - Private properties

    private lazy var featureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.AdGuardColor.lightGreen1
        return imageView
    }()

    private lazy var featureNameLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.greyText = true
        label.textAlignment = .left
        return label
    }()

    private lazy var featureDescriptionLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lightGreyText = true
        label.textAlignment = .left
        return label
    }()

    private var sharedConstraints: [NSLayoutConstraint] = []
    private var iPhoneConstraints: [NSLayoutConstraint] = []
    private var iPadConstraints: [NSLayoutConstraint] = []

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
            setupFonts(for: traitCollection)
        }
    }

    func updateTheme(_ themeService: ThemeServiceProtocol) {
        themeService.setupLabels([featureNameLabel, featureDescriptionLabel])
    }

    // MARK: - Private methods

    private func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
        initializeConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        layout(for: traitCollection)
        setupFonts(for: traitCollection)
    }

    private func initializeConstraints() {
        contentView.addSubview(featureImageView)
        contentView.addSubview(featureNameLabel)
        contentView.addSubview(featureDescriptionLabel)

        sharedConstraints = [
            featureImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            featureDescriptionLabel.topAnchor.constraint(equalTo: featureNameLabel.bottomAnchor, constant: 2.0),
            featureDescriptionLabel.leadingAnchor.constraint(equalTo: featureNameLabel.leadingAnchor),
            featureDescriptionLabel.trailingAnchor.constraint(equalTo: featureNameLabel.trailingAnchor)
        ]

        iPhoneConstraints = [
            featureImageView.widthAnchor.constraint(equalToConstant: 32.0),
            featureImageView.heightAnchor.constraint(equalToConstant: 32.0),
            featureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),

            featureNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            featureNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            featureNameLabel.trailingAnchor.constraint(equalTo: featureImageView.leadingAnchor, constant: -16.0),

            featureDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
        ]

        iPadConstraints = [
            featureImageView.widthAnchor.constraint(equalToConstant: 48.0),
            featureImageView.heightAnchor.constraint(equalToConstant: 48.0),
            featureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0),

            featureNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            featureNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
            featureNameLabel.trailingAnchor.constraint(equalTo: featureImageView.leadingAnchor, constant: -24.0),

            featureDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.0)
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

    private func setupFonts(for traitCollection: UITraitCollection) {
        let isIpad = traitCollection.isIpadTraitCollection
        featureNameLabel.font = UIFont.systemFont(ofSize: isIpad ? 24.0 : 16.0, weight: .regular)
        featureDescriptionLabel.font = UIFont.systemFont(ofSize: isIpad ? 20.0 : 14.0, weight: .regular)
    }
}
