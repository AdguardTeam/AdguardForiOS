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
import SwiftUI

protocol SafariGroupFiltersModelProtocol: UITableViewDelegate, UITableViewDataSource {
    func setup(tableView: UITableView)
}

final class OneSafariGroupFiltersModel: NSObject, SafariGroupFiltersModelProtocol {
    
    // MARK: - Public properties
    
    
    // MARK: - Private properties
    
    private let groupType: SafariGroup.GroupType
    private var groupModel: SafariGroupStateHeaderModel
    private var filtersModels: [SafariFilterCellModel]
    
    /* Services */
    private let safariProtection: SafariProtectionProtocol
    private let configuration: ConfigurationServiceProtocol
    
    // MARK: - Initialization
    
    init(groupType: SafariGroup.GroupType, safariProtection: SafariProtectionProtocol, configuration: ConfigurationServiceProtocol) {
        self.groupType = groupType
        self.safariProtection = safariProtection
        self.configuration = configuration
        
        let group = safariProtection.groups.first(where: { $0.groupType == groupType })!
        let model = SafariGroupFiltersModelsProvider.model(for: group as! SafariGroup, proStatus: configuration.proStatus)
        self.groupModel = model.groupModel
        self.filtersModels = model.filtersModel
        super.init()
    }
    
    // MARK: - Public methods

    func setup(tableView: UITableView) {
        TitleTableViewCell.registerNibCell(forTableView: tableView)
        SafariFilterCell.registerCell(forTableView: tableView)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 84.0
        tableView.sectionFooterHeight = 0.01
    }
}

fileprivate extension OneSafariGroupFiltersModel {
    enum Section: Int, CaseIterable {
        case title = 0
        case filters
    }
}

// MARK: - OneSafariGroupFiltersModel + UITableViewDelegate

extension OneSafariGroupFiltersModel {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - OneSafariGroupFiltersModel + UITableViewDataSource

extension OneSafariGroupFiltersModel {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sct = Section(rawValue: section)!
        switch sct {
        case .title: return 1
        case .filters: return filtersModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sct = Section(rawValue: indexPath.section)!
        switch sct {
        case .title:
            let cell = TitleTableViewCell.getCell(forTableView: tableView)
            cell.title = groupModel.groupName
            return cell
        case .filters:
            let cell = SafariFilterCell.getCell(forTableView: tableView)
            cell.model = filtersModels[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sct = Section(rawValue: section)!
        switch sct {
        case .title:
            return UIView()
        case .filters:
            let headerView = SafariGroupStateHeaderView(model: groupModel)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
