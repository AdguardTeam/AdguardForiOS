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
    
    var groupType: SafariGroup.GroupType!
    
    // MARK: - Private properties
    
    private var group: SafariGroup!
    
    private let titleSection = 0
    private let filtersSection = 1
    
    /* Services */
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private var model: SafariGroupFiltersModel!
        
    // MARK: - UITableViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        group = safariProtection.groups.first(where: { $0.groupType == groupType }) as? SafariGroup
        model = SafariGroupFiltersModel(safariProtection: safariProtection, group: group)
        model.delegate = self
        
        setupTableView()
        updateTheme()
        setupBackButton()
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        TitleTableViewCell.registerNibCell(forTableView: tableView)
        SafariFilterCell.registerCell(forTableView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Table view delegate

extension SafariGroupFiltersTableController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - Table view data source

extension SafariGroupFiltersTableController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == titleSection {
            return 1
        } else if section == filtersSection {
            return model.models.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == titleSection {
            let cell = TitleTableViewCell.getCell(forTableView: tableView)
            cell.title = group.groupName
            return cell
        } else if indexPath.section == filtersSection {
            let cell = SafariFilterCell.getCell(forTableView: tableView)
            cell.model = model.models[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - SafariGroupFiltersTableController + SafariGroupFiltersModelDelegate

extension SafariGroupFiltersTableController: SafariGroupFiltersModelDelegate {
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
