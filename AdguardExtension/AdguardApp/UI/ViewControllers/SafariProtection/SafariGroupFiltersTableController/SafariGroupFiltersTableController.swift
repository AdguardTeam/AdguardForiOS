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

final class SafariGroupFiltersTableController: UITableViewController {
    
    var displayType: DisplayType!
    
    enum DisplayType {
        case one(groupType: SafariGroup.GroupType)
        case all
    }
    
    // MARK: - Private properties
    
    /* Services */
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private var model: SafariGroupFiltersModelProtocol!
        
    // MARK: - UITableViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch displayType {
        case .one(let groupType):
            model = OneSafariGroupFiltersModel(groupType: groupType, safariProtection: safariProtection, configuration: configuration)
        case .all:
            model = AllSafariGroupsFiltersModel(safariProtection: safariProtection, configuration: configuration)
        case .none:
            break
        }
        tableView.delegate = model
        tableView.dataSource = model
        model.setup(tableView: tableView)
        updateTheme()
        setupBackButton()
    }
}

// MARK: - SafariGroupFiltersTableController +

extension SafariGroupFiltersTableController {
    func modelsChanged() {
        tableView.reloadData()
    }
}

// MARK: - SafariGroupFiltersTableController + ThemableProtocol

extension SafariGroupFiltersTableController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupTable(tableView)
        tableView.reloadData()
    }
}
