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

final class SafariGroupTableController: UITableViewController {

    // MARK: - Private properties
    
    private let licenseSegueId = "licenseSegueId"
    
    private let titleSection = 0
    private let groupsSection = 1
    
    /* Services */
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private let model: SafariGroupsModel
    
    // MARK: - Initializer
    
    required init?(coder: NSCoder) {
        self.model = SafariGroupsModel(safariProtection: safariProtection, configuration: configuration)
        super.init(coder: coder)
    }
    
    // MARK: - UITableViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        
        setupTableView()
        updateTheme()
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        TitleTableViewCell.registerNibCell(forTableView: tableView)
        SafariProtectionGroupCell.registerNibCell(forTableView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Table view delegate

extension SafariGroupTableController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == titleSection {
            return
        } else {
            let groupModel = model.groups[indexPath.row]
            if !groupModel.isAccessible {
                performSegue(withIdentifier: licenseSegueId, sender: self)
            } else {
                // TODO: - Redirect to detailed filter page
            }
        }
    }
}

// MARK: - Table view data source

extension SafariGroupTableController {
    
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
        } else {
            return model.groups.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == titleSection {
            let cell = TitleTableViewCell.getCell(forTableView: tableView)
            cell.title = String.localizedString("navigation_item_filters_title")
            return cell
        } else {
            let cell = SafariProtectionGroupCell.getCell(forTableView: tableView)
            let cellModel = model.groups[indexPath.row]
            cell.delegate = self
            cell.model = cellModel
            return cell
        }
    }
}

// MARK: - SafariGroupTableController + SafariGroupsModelDelegate

extension SafariGroupTableController: SafariGroupsModelDelegate {
    func modelsChanged() {
        tableView.reloadData()
    }
}

// MARK: - SafariGroupTableController + SafariProtectionGroupCellDelegate

extension SafariGroupTableController: SafariProtectionGroupCellDelegate {
    func stateChanged(for groupType: SafariGroup.GroupType, newState: Bool) {
        model.setGroup(groupType, enabled: newState)
    }
}

// MARK: - SafariGroupTableController + ThemableProtocol

extension SafariGroupTableController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupTable(tableView)
        tableView.reloadData()
    }
}
