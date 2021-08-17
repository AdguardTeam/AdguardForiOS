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

final class ExtendedTitleTableViewCell: UITableViewCell, Reusable {
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: - Services
    
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    //MARK: - Properties
    
    private var themeObserver: NotificationToken?
    
    private var descr: String?
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0.0
        
        updateTheme()
        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    func setAttributedTitle(_ html: String) {
        descr = html
        descriptionTextView.isSelectable = true
    }
    
    func setNormalTitle(_ title: String) {
        descr = title
        descriptionTextView.isSelectable = false
    }
    
    // MARK: - Private methods
    
    private func setupTextView() {
        descriptionTextView.setAttributedTitle(descr ?? "", fontSize: 14.0, color: themeService.lightGrayTextColor)
    }
}

// MARK: - ExtendedTitleTableViewCell + ThemableProtocol

extension ExtendedTitleTableViewCell: ThemableProtocol {
    func updateTheme() {
        themeService.setupTableCell(self)
        themeService.setupLabel(titleLabel)
        setupTextView()
    }
}
