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

struct FilterDetailsCellModel {
    let title: String
    let description: String
    let isLink: Bool
}

final class FilterDetailsCell: UITableViewCell, Reusable {

    var model: FilterDetailsCellModel! {
        didSet {
            titleLabel.text = model.title
            descriptionLabel.text = model.description
        }
    }

    private lazy var titleLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.greyText = true
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var descriptionLabel: ThemableLabel = {
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
        themeService.setupLabel(descriptionLabel)
        themeService.setupTableCell(self)
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        applyLayoutMetrics()
    }

    private func applyLayoutMetrics() {
        let sideInset: CGFloat = isIpadTrait ? 24.0 : 16.0
        let verticalInset: CGFloat = isIpadTrait ? 20.0 : 16.0

        titleLabel.font = .systemFont(ofSize: isIpadTrait ? 24.0 : 16.0, weight: .bold)
        descriptionLabel.font = .systemFont(ofSize: isIpadTrait ? 24.0 : 16.0, weight: .regular)

        NSLayoutConstraint.deactivate(layoutConstraints)
        layoutConstraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalInset),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideInset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideInset),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideInset),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideInset),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalInset)
        ]
        NSLayoutConstraint.activate(layoutConstraints)

    }
}
