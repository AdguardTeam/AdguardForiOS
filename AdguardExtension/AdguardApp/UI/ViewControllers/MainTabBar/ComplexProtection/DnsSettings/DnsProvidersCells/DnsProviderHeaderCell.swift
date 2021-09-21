import UIKit
/**
      This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
      Copyright © Adguard Software Limited. All rights reserved.

      Adguard for iOS is free software: you can redistribute it and/or modify
      it under the terms of the GNU General Public License as published by
      the Free Software Foundation, either version 3 of the License, or
      (at your option) any later version.

      Adguard for iOS is distributed in the hope that it will be useful,
      but WITHOUT ANY WARRANTY; without even the implied warranty of
      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      GNU General Public License for more details.

      You should have received a copy of the GNU General Public License
      along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/


/// Header cell
final class DnsProviderHeaderCell : UITableViewCell, Reusable {
    //MARK: - Properties
    
    /// Logo image
    var logoImage: UIImage? {
        didSet {
            logoImageView.lightThemeImage = logoImage
        }
    }
    
    /// Logo image for dark theme
    var darkLogoImage: UIImage? {
        didSet {
            logoImageView.darkThemeImage = darkLogoImage
        }
    }
    
    /// Description string
    var descriptionString: String = "" {
        didSet {
            descriptionLabel.text = descriptionString
        }
    }
    
    private var logoImageView: ThemableImageView = {
        let imageView = ThemableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = true
        label.lightGreyText = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: isIpadTrait ? 24.0 : 16.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraint()
    }
    
    //MARK: - Public methods
    func updateTheme(themeService: ThemeServiceProtocol) {
        themeService.setupLabels([descriptionLabel])
        themeService.setupImage(logoImageView)
        themeService.setupTableCell(self)
    }
    
    //MARK: - Private methods
    private func setupConstraint() {
        self.contentView.addSubview(logoImageView)
        self.contentView.addSubview(descriptionLabel)
        
        let logoImageViewHeightConst = isIpadTrait ? 168.0 : 56.0
        let logoImageViewWidthConst = isIpadTrait ? 936.0 : 312.0
        let topConst = isIpadTrait ? 40.0 : 16.0
        let bottomConst = isIpadTrait ? 96.0 : 32.0
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16.0),
            logoImageView.heightAnchor.constraint(equalToConstant: logoImageViewHeightConst),
            logoImageView.widthAnchor.constraint(equalToConstant: logoImageViewWidthConst),
            logoImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: topConst),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -bottomConst)
        ])
        self.selectionStyle = .none
    }
}
