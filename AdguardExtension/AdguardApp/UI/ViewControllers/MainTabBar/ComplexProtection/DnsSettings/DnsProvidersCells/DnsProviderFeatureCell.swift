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

import Foundation
import UIKit

/// Feature cel
final class DnsProviderFeatureCell: UITableViewCell, Reusable {
    // MARK: - Properties

    var logoImage: UIImage? {
        didSet {
            logoImageView.image = logoImage
        }
    }

    var nameString: String = "" {
        didSet {
            nameLabel.text = nameString
        }
    }

    var descriptionString: String = "" {
        didSet {
            descriptionLabel.text = descriptionString
        }
    }

    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = true
        label.lightGreyText = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: isIpadTrait ? 24.0 : 16.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = false
        label.lightGreyText = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: isIpadTrait ? 20.0 : 14.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var logoCheckImageView: UIImageView = {
        let image = UIImage(named: "logocheck")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraint()
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraint()
        self.selectionStyle = .none
    }

    // MARK: - Public methods

    func updateTheme(themeService: ThemeServiceProtocol) {
        themeService.setupLabels([nameLabel, descriptionLabel])
        themeService.setupTableCell(self)
    }

    // MARK: - Private methods

    private func setupConstraint() {
        self.contentView.addSubview(logoImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(logoCheckImageView)

        let heightWidthConst = isIpadTrait ? 32.0 : 24.0
        let leadingTrailingConst = isIpadTrait ? 24.0 : 16.0
        let topBottomConst = isIpadTrait ? 20.0 : 16.0

        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: leadingTrailingConst),
            logoImageView.trailingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor, constant: -leadingTrailingConst),
            logoImageView.heightAnchor.constraint(equalToConstant: heightWidthConst),
            logoImageView.widthAnchor.constraint(equalToConstant: heightWidthConst),

            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: topBottomConst),
            nameLabel.trailingAnchor.constraint(equalTo: self.logoCheckImageView.leadingAnchor, constant: -30),

            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -topBottomConst),

            logoCheckImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            logoCheckImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -leadingTrailingConst),
            logoCheckImageView.heightAnchor.constraint(equalToConstant: heightWidthConst),
            logoCheckImageView.widthAnchor.constraint(equalToConstant: heightWidthConst)
        ])
    }
}

