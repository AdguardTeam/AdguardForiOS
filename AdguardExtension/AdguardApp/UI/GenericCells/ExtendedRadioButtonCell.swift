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

protocol ExtendedRadioButtonCellDelegate: AnyObject {
    func radioButtonTapped(with tag: Int)
}


// Cell model
struct ExtendedRadioButtonCellModel {
    let cellTag: Int
    let titleString: String
    let descriptionString: String
    let radioButtonSelected: Bool
    let isArrowRightHidden: Bool
    let delegate: ExtendedRadioButtonCellDelegate?
}

/// Generic cell with title and description labels and radio button that shows selected state
final class ExtendedRadioButtonCell: UITableViewCell, Reusable {
    
    //MARK: - Properties
    
    var cellTag: Int?
    
    var titleString: String = "" {
        didSet {
            titleLabel.text = titleString
        }
    }
    
    var descriptionString: String = "" {
        didSet {
            descriptionLabel.text = descriptionString
        }
    }
    
    var radioButtonSelected: Bool = false {
        didSet {
            radioButton.isSelected = radioButtonSelected
        }
    }
    
    var isArrowRightHidden: Bool = false {
        didSet {
            arrowRight.isHidden = isArrowRightHidden
        }
    }
    
    var model: ExtendedRadioButtonCellModel? {
        didSet {
            guard let model = model else { return }
            cellTag = model.cellTag
            titleString = model .titleString
            descriptionString = model.descriptionString
            radioButtonSelected = model.radioButtonSelected
            isArrowRightHidden = model.isArrowRightHidden
            delegate = model.delegate
        }
    }
    
    weak var delegate: ExtendedRadioButtonCellDelegate?
    
    private lazy var titleLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = true
        label.lightGreyText = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: isIpadTrait ? 24.0 : 16.0, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = false
        label.lightGreyText = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: isIpadTrait ? 18.0 : 12.0)
        label.numberOfLines = 0
        return label
    }()
    
    private var radioButton: RadioButton = {
        let button = RadioButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var arrowRight: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "arrow_right")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addConstraints()
    }
    
    //MARK: - Public methods
    func updateTheme(themeService: ThemeServiceProtocol) {
        themeService.setupTableCell(self)
        themeService.setupLabels([titleLabel, descriptionLabel])
    }
    
    //MARK: - Private methods
    
    private func addConstraints() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(radioButton)
        self.contentView.addSubview(arrowRight)
            
        let widthHeightConst: CGFloat = isIpadTrait ? 32.0 : 24.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16.0),
            
            radioButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            radioButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24.0),
            radioButton.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -20.0),
            
            radioButton.widthAnchor.constraint(equalToConstant: widthHeightConst),
            radioButton.heightAnchor.constraint(equalToConstant: widthHeightConst),
            
            arrowRight.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            arrowRight.widthAnchor.constraint(equalToConstant: widthHeightConst),
            arrowRight.heightAnchor.constraint(equalToConstant: widthHeightConst),
            arrowRight.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24.0),
            arrowRight.leadingAnchor.constraint(equalTo: self.descriptionLabel.trailingAnchor, constant: 24.0)
        ])
        
        radioButton.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc
    private final func radioButtonTapped(_ sender: RadioButton) {
        guard let tag = cellTag else { return }
        delegate?.radioButtonTapped(with: tag)
    }
}
