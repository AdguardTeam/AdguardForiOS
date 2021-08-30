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

import UIKit

final class ExtendedTitleTableHeaderView: UIView {
    
    //MARK: - UI Elements
    
    private lazy var titleLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 40.0 : 24.0, weight: .bold)
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.textContainerInset = .zero
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0.0
        textView.font = UIFont.systemFont(ofSize: isIpadTrait ? 20.0 : 16.0, weight: .bold)
        return textView
    }()
    
    //MARK: - Services
    
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    //MARK: - Properties
    
    private var themeObserver: NotificationToken?
    
    var title: String {
        didSet {
            titleLabel.text = title
        }
    }
    private(set) var descr: String
    
    required init?(coder: NSCoder) {
        self.title = ""
        self.descr = ""
        super.init(coder: coder)
        setupTheme()
    }
    
    override init(frame: CGRect) {
        self.title = ""
        self.descr = ""
        super.init(frame: frame)
        setupTheme()
    }
    
    init(title: String, normalDescription: String) {
        self.title = title
        self.descr = normalDescription
        super.init(frame: .zero)
        setNormalTitle(normalDescription)
        setupUI()
        setupTheme()
    }
    
    init(title: String, htmlDescription: String) {
        self.title = title
        self.descr = htmlDescription
        super.init(frame: .zero)
        setAttributedTitle(htmlDescription)
        setupUI()
        setupTheme()
    }
    
    // MARK: - Public methods
    
    func setAttributedTitle(_ html: String) {
        descr = html
        descriptionTextView.isSelectable = true
        setupTextView()
    }
    
    func setNormalTitle(_ title: String) {
        descr = title
        descriptionTextView.isSelectable = false
        setupTextView()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        titleLabel.text = title
        addSubview(titleLabel)
        addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: isIpadTrait ? 24.0 : 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: isIpadTrait ? -24.0 : -16.0),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: titleLabel.font.pointSize + 2.0),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: isIpadTrait ? 16.0 : 8.0),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: isIpadTrait ? 24.0 : 16.0),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: isIpadTrait ? -24.0 : -16.0),
            descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: isIpadTrait ? -24.0 : -16.0),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: descriptionTextView.font!.pointSize + 2.0),
        ])
    }
    
    private func setupTheme() {
        updateTheme()
        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    private func setupTextView() {
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.setAttributedTitle(
            descr,
            fontSize: descriptionTextView.font!.pointSize,
            color: themeService.grayTextColor,
            textAlignment: .center
        )
        descriptionTextView.tintColor = themeService.grayTextColor
    }
}

// MARK: - ExtendedTitleTableHeaderView + ThemableProtocol

extension ExtendedTitleTableHeaderView: ThemableProtocol {
    func updateTheme() {
        themeService.setupLabel(titleLabel)
        setupTextView()
    }
}
