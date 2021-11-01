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
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import UIKit

/// This cell is responsible for displaying info about certain Safari Content Blocker
final class ContentBlockerTableViewCell: UITableViewCell, Reusable {

    // MARK: - Public properties

    var model = ContentBlockerTableViewCellModel() {
        didSet {
            processModel()
        }
    }

    // MARK: - UI elements

    private lazy var stateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var cbNameLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.greyText = true
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 24.0 : 16.0, weight: .medium)
        label.textAlignment = .left
        return label
    }()

    private lazy var cbDescriptionLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.greyText = false
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 20.0 : 14.0, weight: .regular)
        label.textAlignment = .left
        return label
    }()

    private lazy var cbFiltersLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.greyText = false
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 20.0 : 14.0, weight: .regular)
        label.textAlignment = .left
        return label
    }()

    // MARK: - Private properties

    // We use this constraint to reduce cell size when filters are empty
    private var cbFiltersLabelBottomConstraint: NSLayoutConstraint!
    private var cbDescriptionLabelBottomConstraint: NSLayoutConstraint!

    // MARK: - Initialization

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    private func initialize() {
        self.selectionStyle = .none

        contentView.addSubview(stateImageView)
        contentView.addSubview(cbNameLabel)
        contentView.addSubview(cbDescriptionLabel)

        cbDescriptionLabelBottomConstraint = cbDescriptionLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: isIpadTrait ? -24.0 : -16.0
        )
        cbFiltersLabelBottomConstraint = cbFiltersLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: isIpadTrait ? -24.0 : -16.0
        )

        NSLayoutConstraint.activate([
            stateImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: isIpadTrait ? 24.0 : 16.0),
            stateImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: isIpadTrait ? 20.0 : 16.0),
            stateImageView.widthAnchor.constraint(equalToConstant: isIpadTrait ? 32.0 : 24.0),
            stateImageView.heightAnchor.constraint(equalToConstant: isIpadTrait ? 32.0 : 24.0),

            cbNameLabel.leadingAnchor.constraint(equalTo: stateImageView.trailingAnchor, constant: isIpadTrait ? 24.0 : 16.0),
            cbNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: isIpadTrait ? -24.0 : -16.0),
            cbNameLabel.topAnchor.constraint(equalTo: stateImageView.topAnchor),

            cbDescriptionLabel.leadingAnchor.constraint(equalTo: cbNameLabel.leadingAnchor),
            cbDescriptionLabel.trailingAnchor.constraint(equalTo: cbNameLabel.trailingAnchor),
            cbDescriptionLabel.topAnchor.constraint(equalTo: cbNameLabel.bottomAnchor, constant: -2.0)
        ])

        layoutFiltersLabel()
    }

    private func layoutFiltersLabel() {
        cbDescriptionLabelBottomConstraint.isActive = false
        cbFiltersLabel.removeFromSuperview()
        contentView.addSubview(cbFiltersLabel)

        NSLayoutConstraint.activate([
            cbFiltersLabel.leadingAnchor.constraint(equalTo: cbDescriptionLabel.leadingAnchor),
            cbFiltersLabel.trailingAnchor.constraint(equalTo: cbDescriptionLabel.trailingAnchor),
            cbFiltersLabel.topAnchor.constraint(equalTo: cbDescriptionLabel.bottomAnchor, constant: isIpadTrait ? 40.0 : 20.0),
            cbFiltersLabelBottomConstraint
        ])
    }

    // MARK: - Public methods

    func updateTheme(_ themeService: ThemeServiceProtocol) {
        themeService.setupTableCell(self)
        themeService.setupLabels([cbNameLabel, cbDescriptionLabel, cbFiltersLabel])
    }

    // MARK: - Private methods

    private func processModel() {
        stateImageView.image = model.image
        cbNameLabel.text = model.name
        cbDescriptionLabel.text = model.description
        cbFiltersLabel.text = model.filtersString

        if model.filtersString == nil {
            cbFiltersLabelBottomConstraint.isActive = false
            cbFiltersLabel.removeFromSuperview()
            cbDescriptionLabelBottomConstraint.isActive = true
        } else {
            layoutFiltersLabel()
        }

        stateImageView.rotateImage(isNedeed: model.shouldRotateImage)
    }
}
