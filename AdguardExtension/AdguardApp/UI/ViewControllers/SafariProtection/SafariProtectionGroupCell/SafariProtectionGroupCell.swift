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
import SafariAdGuardSDK

struct SafariProtectionGroupCellModel {
    let iconImage: UIImage
    let title: String
    let description: String
    let isEnabled: Bool
    let isAccessible: Bool
    let groupType: SafariGroup.GroupType
}

extension SafariProtectionGroupCellModel {
    init() {
        self.iconImage = UIImage()
        self.title = ""
        self.description = ""
        self.isEnabled = false
        self.isAccessible = false
        self.groupType = .ads
    }
        
    init(group: SafariGroup, proStatus: Bool) {
        self.iconImage = group.groupType.iconImage
        self.title = group.groupName
        self.description = Self.getDescription(for: group, proStatus: proStatus)
        self.isEnabled = group.isEnabled
        self.isAccessible = group.groupType.proOnly ? proStatus : true
        self.groupType = group.groupType
    }
    
    private static func getDescription(for group: SafariGroup, proStatus: Bool) -> String {
        if group.groupType.proOnly && !proStatus {
            if group.groupType == .security {
                return String.localizedString("security_description")
            } else if group.groupType == .custom {
                return String.localizedString("custom_description")
            } else {
                return ""
            }
        }
        else if group.isEnabled {
            let allFiltersCount = group.filters.count
            let enabledFiltersCount = group.filters.compactMap { $0.isEnabled ? $0 : nil }.count
            let format = String.localizedString("filter_group_filters_count_format")
            return String(format: format, enabledFiltersCount, allFiltersCount)
        }
        else {
            return String.localizedString("disabled")
        }
    }
}

fileprivate extension SafariGroup.GroupType {
    var iconImage: UIImage {
        switch self {
        case .ads: return UIImage(named: "ads-group-icon")!
        case .privacy: return UIImage(named: "prvacy-group-icon")!
        case .socialWidgets: return UIImage(named: "social-group-icon")!
        case .annoyances: return UIImage(named: "annoyances-group-icon")!
        case .security: return UIImage(named: "security-group-icon")!
        case .other: return UIImage(named: "other-group-icon")!
        case .languageSpecific: return UIImage(named: "language-group-icon")!
        case .custom: return UIImage(named: "custom-group-icon")!
        }
    }
}

// MARK: - SafariProtectionGroupCell

protocol SafariProtectionGroupCellDelegate: AnyObject {
    func stateChanged(for groupType: SafariGroup.GroupType, newState: Bool)
}

final class SafariProtectionGroupCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var stateSwitch: UISwitch!
    
    // MARK: - Services
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // MARK: - Properties
    private var themeObserver: NotificationToken?
    
    weak var delegate: SafariProtectionGroupCellDelegate?
    
    var model: SafariProtectionGroupCellModel = SafariProtectionGroupCellModel() {
        didSet {
            process(model: model)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateTheme()
        iconImageView.tintColor = UIColor.AdGuardColor.green
        
        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        descriptionLabel.text = model.description
        delegate?.stateChanged(for: model.groupType, newState: !model.isEnabled)
    }
    
    private func process(model: SafariProtectionGroupCellModel) {
        iconImageView.image = model.iconImage
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        stateSwitch.isOn = model.isEnabled
        descriptionLabel.textColor = model.isAccessible ? themeService.lightGrayTextColor : UIColor.AdGuardColor.yellow2
        stateSwitch.isEnabled = model.isAccessible
    }
}

extension SafariProtectionGroupCell: ThemableProtocol {
    func updateTheme() {
        descriptionLabel.textColor = model.isAccessible ? themeService.lightGrayTextColor : UIColor.AdGuardColor.yellow2
        themeService.setupTableCell(self)
        themeService.setupLabel(titleLabel)
    }
}
