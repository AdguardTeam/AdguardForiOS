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

protocol DnsProviderCellDelegate: AnyObject {
    func selectedProvider(withTag tag: Int)
}

class DnsProviderCell: UITableViewCell {
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var nameLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var arrowRight: UIImageView!
    
    weak var delegate: DnsProviderCellDelegate?
    
    var themeService: ThemeServiceProtocol? {
        didSet {
            themeService?.setupTableCell(self)
            themeService?.setupLabel(nameLabel)
            themeService?.setupLabel(descriptionLabel)
        }
    }
    
    var model: DnsProviderCellModel? {
        didSet {
            nameLabel.text = model?.name
            descriptionLabel?.text = model?.providerDescription
            selectedButton.isSelected = model?.isCurrent ?? false
            arrowRight.isHidden = model?.isDefaultProvider ?? false
        }
    }
    
    @IBAction func selectionButtonTapped(_ sender: UIButton) {
        delegate?.selectedProvider(withTag: tag)
    }
}

struct DnsProviderCellModel {
    let name: String?
    let providerDescription: String?
    let isCustomProvider: Bool
    let providerId: Int?
    let isCurrent: Bool
    let isDefaultProvider: Bool
    
    
    init(provider: DnsProviderInfo, isCurrent: Bool, isDefaultProvider: Bool) {
        self.name = provider.name
        self.providerDescription = provider.summary
        self.isCustomProvider = provider.isCustomProvider
        self.providerId = provider.providerId
        self.isCurrent = isCurrent
        self.isDefaultProvider = isDefaultProvider
    }
    
    init(name: String?, description: String?, isCurrent: Bool, isDefaultProvider: Bool, isCustomProvider: Bool, providerId: Int?) {
        self.name = name
        self.providerDescription = description
        self.isCurrent = isCurrent
        self.providerId = providerId
        self.isDefaultProvider = isDefaultProvider
        self.isCustomProvider = isCustomProvider
    }
}
