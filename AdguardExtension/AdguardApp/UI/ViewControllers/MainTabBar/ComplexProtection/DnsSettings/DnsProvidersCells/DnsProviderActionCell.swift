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

import Foundation

final class DnsProviderActionCell: UITableViewCell, Reusable {
    //MARK: - Properties
    var actionNameTitle: String = "" {
        didSet {
            actionNameLabel.text = actionNameTitle
        }
    }
    
    var selectedOptionTitle: String = "" {
        didSet {
            selectedOptionLabel.text = selectedOptionTitle
        }
    }
    
    private lazy var actionNameLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = true
        label.lightGreyText = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: isIpadTrait ? 24.0 : 16.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var selectedOptionLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = true
        label.lightGreyText = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: isIpadTrait ? 24.0 : 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var rightArrowImageView: UIImageView = {
        let image = UIImage(named: "arrow_right")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
        self.selectionStyle = .none
    }
    
    //MARK: - Public methods
    
    func updateTheme(themeService: ThemeServiceProtocol) {
        themeService.setupLabels([actionNameLabel, selectedOptionLabel])
        themeService.setupTableCell(self)
    }
    
    //MARK: - Private methods
    private func setupConstraints() {
        self.contentView.addSubview(actionNameLabel)
        self.contentView.addSubview(selectedOptionLabel)
        self.contentView.addSubview(rightArrowImageView)
        
        let topBottomConst = isIpadTrait ? 20.0 : 16.0
        let leadingTrailingConst = isIpadTrait ? 24.0 : 16.0
        let heightWidthConst = isIpadTrait ? 32.0 : 24.0
        
        NSLayoutConstraint.activate([
            actionNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: topBottomConst),
            actionNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: leadingTrailingConst),
            actionNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.selectedOptionLabel.leadingAnchor, constant: -20.0),
            actionNameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -topBottomConst),
            
            selectedOptionLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            selectedOptionLabel.trailingAnchor.constraint(equalTo: rightArrowImageView.leadingAnchor, constant: -leadingTrailingConst),
            
            rightArrowImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            rightArrowImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -leadingTrailingConst),
            rightArrowImageView.heightAnchor.constraint(equalToConstant: heightWidthConst),
            rightArrowImageView.widthAnchor.constraint(equalToConstant: heightWidthConst)
        ])
    }
}
