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

struct PremiumFeatureViewModel {
    let icon: UIImage?
    let featureName: String
    let featureDescription: String
}

/// This view is responsible for displaying premium feature
final class PremiumFeatureView: UIView {

    // MARK: - Internal properties

    var model: PremiumFeatureViewModel? {
        didSet {
            processModel()
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
        label.textAlignment = .center
        return label
    }()

    private lazy var featureDescriptionLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.greyText = true
        label.textAlignment = .center
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
            setupFonts(for: traitCollection)
        }
    }

    func updateTheme(_ themeService: ThemeServiceProtocol) {
        themeService.setupLabels([featureNameLabel, featureDescriptionLabel])
    }

    // MARK: - Private methods

    private func initialize() {
        backgroundColor = .clear

        addSubview(featureImageView)
        addSubview(featureNameLabel)
        addSubview(featureDescriptionLabel)

        initializeConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        layout(for: traitCollection)
        setupFonts(for: traitCollection)
    }

    private func initializeConstraints() {
        sharedConstraints = [
            featureImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            featureDescriptionLabel.leadingAnchor.constraint(equalTo: featureNameLabel.leadingAnchor),
            featureDescriptionLabel.trailingAnchor.constraint(equalTo: featureNameLabel.trailingAnchor)
        ]

        iPhoneConstraints = [
            featureImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            featureImageView.widthAnchor.constraint(equalToConstant: 56.0),
            featureImageView.heightAnchor.constraint(equalToConstant: 56.0),

            featureNameLabel.topAnchor.constraint(equalTo: featureImageView.bottomAnchor, constant: 16.0),
            featureNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.0),
            featureNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.0),

            featureDescriptionLabel.topAnchor.constraint(equalTo: featureNameLabel.bottomAnchor),

            heightAnchor.constraint(equalToConstant: 200.0)
        ]

        iPadConstraints = [
            featureImageView.topAnchor.constraint(equalTo: topAnchor, constant: 72.0),
            featureImageView.widthAnchor.constraint(equalToConstant: 128.0),
            featureImageView.heightAnchor.constraint(equalToConstant: 128.0),

            featureNameLabel.topAnchor.constraint(equalTo: featureImageView.bottomAnchor, constant: 32.0),
            featureNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 76.0),
            featureNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -76.0),

            featureDescriptionLabel.topAnchor.constraint(equalTo: featureNameLabel.bottomAnchor, constant: 8.0),

            heightAnchor.constraint(equalToConstant: 400.0)
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
        featureNameLabel.font = UIFont.systemFont(ofSize: traitCollection.isIpadTraitCollection ? 36.0 : 20.0, weight: .bold)
        featureDescriptionLabel.font = UIFont.systemFont(ofSize: traitCollection.isIpadTraitCollection ? 24.0 : 14.0)
    }

    private func processModel() {
        self.featureImageView.image = model?.icon
        self.featureNameLabel.text = model?.featureName
        self.featureDescriptionLabel.text = model?.featureDescription
    }
}
