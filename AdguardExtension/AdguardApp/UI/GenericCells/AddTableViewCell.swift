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

final class AddTableViewCell: UITableViewCell, Reusable {

    var addTitle: String = "" {
        didSet {
            descriptionLabel.text = addTitle
        }
    }

    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "plus")
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.AdGuardColor.lightGreen1
        label.font = .systemFont(ofSize: isIpadTrait ? 24.0 : 16.0)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }

    func updateTheme(_ themeService: ThemeServiceProtocol) {
        themeService.setupTableCell(self)
    }

    private func setupConstraints() {
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(descriptionLabel)

        let widthHeightConst: CGFloat = isIpadTrait ? 32.0 : 24.0

        iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: -16.0).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: widthHeightConst).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: widthHeightConst).isActive = true

        descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.0).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.0).isActive = true
    }
}
