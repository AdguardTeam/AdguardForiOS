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

import SafariAdGuardSDK

final class AllSafariGroupsFiltersModel: NSObject, SafariGroupFiltersModelProtocol {
    // MARK: - Public properties
    
    
    // MARK: - Private properties
    
    private var groupModels: [SafariGroupStateHeaderModel] = []
    private var filtersModels: [[SafariFilterCellModel]] = []
    
    /* Services */
    private let safariProtection: SafariProtectionProtocol
    private let configuration: ConfigurationServiceProtocol
    
    // MARK: - Initialization
    
    init(safariProtection: SafariProtectionProtocol, configuration: ConfigurationServiceProtocol) {
        self.safariProtection = safariProtection
        self.configuration = configuration
        super.init()
        
        let models = SafariGroupFiltersModelsProvider.models(for: safariProtection.groups as! [SafariGroup], proStatus: configuration.proStatus)
        models.forEach { groupModels.append($0.groupModel); filtersModels.append($0.filtersModel) }
    }
    
    // MARK: - Public methods
    
    func setup(tableView: UITableView) {
        SafariFilterCell.registerCell(forTableView: tableView)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 84.0
        tableView.sectionFooterHeight = 0.01
    }
}

// MARK: - AllSafariGroupsFiltersModel + UITableViewDelegate

extension AllSafariGroupsFiltersModel {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AllSafariGroupsFiltersModel + UITableViewDataSource

extension AllSafariGroupsFiltersModel {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = filtersModels[indexPath.section][indexPath.row]
        let cell = SafariFilterCell.getCell(forTableView: tableView)
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let groupModel = groupModels[section]
        let headerView = SafariGroupStateHeaderView(model: groupModel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
