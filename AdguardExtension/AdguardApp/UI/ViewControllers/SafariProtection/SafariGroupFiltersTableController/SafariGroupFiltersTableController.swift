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
    
    var displayType: SafariGroupFiltersModel.DisplayType!
    
    // MARK: - Private properties
    
    /* Services */
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private var model: SafariGroupFiltersModel!
        
    // MARK: - UITableViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = SafariGroupFiltersModel(displayType: displayType, safariProtection: safariProtection, configuration: configuration)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Table view data source

extension SafariGroupFiltersTableController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerModel: SafariGroupStateHeaderModel
        if case .one(_) = displayType {
            if section == 0 {
                return UIView()
            }
            headerModel = model.models[0].0
        } else {
            headerModel = model.models[section].0
        }
        let header = SafariGroupStateHeaderView(model: headerModel)
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SafariGroupStateHeaderView.height(isIpadTrait: isIpadTrait)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch displayType {
        case .one(groupType: _): return 2
        case .all: return model.models.count
        case .none: return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch displayType {
        case .one(groupType: _):
            if section == 0 {
                return 1
            } else {
                return model.models[0].1.count
            }
        case .all: return model.models[section].1.count
        case .none: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if case .one(_) = displayType {
            if indexPath.section == 0 {
                let cell = TitleTableViewCell.getCell(forTableView: tableView)
                cell.title = model.models[0].0.groupName
                return cell
            } else {
                let cell = SafariFilterCell.getCell(forTableView: tableView)
                cell.model = model.models[0].1[indexPath.row]
                return cell
            }
        }
        let cell = SafariFilterCell.getCell(forTableView: tableView)
        cell.model = model.models[indexPath.section].1[indexPath.row]
        return cell
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
