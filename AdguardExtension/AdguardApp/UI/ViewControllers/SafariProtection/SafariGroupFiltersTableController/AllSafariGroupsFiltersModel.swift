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
    
    var searchString: String? {
        didSet {
            processSearchString()
        }
    }
    
    weak var tableView: UITableView?
    weak var delegate: SafariGroupFiltersModelDelegate?
    
    // MARK: - Private properties
    
    private var groupModels: [SafariGroupStateHeaderModel] { modelsProvider.groupModels }
    private var filtersModels: [[SafariFilterCellModel]] { modelsProvider.filtersModels }
    
    /* Services */
    private let safariProtection: SafariProtectionProtocol
    private let configuration: ConfigurationServiceProtocol
    private var modelsProvider: SafariGroupFiltersModelsProvider
    
    private var proStatusObserver: NotificationToken?
    
    // MARK: - Initialization
    
    init(safariProtection: SafariProtectionProtocol, configuration: ConfigurationServiceProtocol) {
        self.safariProtection = safariProtection
        self.configuration = configuration
        self.modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: safariProtection.groups as! [SafariGroup], proStatus: configuration.proStatus)
        super.init()
        
        self.proStatusObserver = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: self.safariProtection.groups as! [SafariGroup], proStatus: self.configuration.proStatus)
            self.tableView?.reloadData()
        }
    }
    
    // MARK: - Public methods
    
    func setup(tableView: UITableView) {
        SafariFilterCell.registerCell(forTableView: tableView)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 84.0
        tableView.sectionFooterHeight = 0.01
        tableView.estimatedRowHeight = 105.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func safariFilterStateChanged(_ filterId: Int, _ newState: Bool) {
        
    }
    
    func tagTapped(_ tagName: String) {
        delegate?.tagTapped(tagName)
    }
    
    // MARK: - Private methods
    
    private func processSearchString() {
        modelsProvider.searchString = searchString
        tableView?.reloadData()
    }
}

// MARK: - AllSafariGroupsFiltersModel + SafariGroupStateHeaderDelegate

extension AllSafariGroupsFiltersModel {
    func stateChanged(for groupType: SafariGroup.GroupType, newState: Bool) {
        DDLogInfo("(AllSafariGroupsFiltersModel) - setGroup; Trying to change group=\(groupType) to state=\(newState)")
        
        safariProtection.setGroup(groupType, enabled: newState) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                DDLogError("(AllSafariGroupsFiltersModel) - setGroup; DB error when changing group=\(groupType) to state=\(newState); Error: \(error)")
            }
            
            self.modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: self.safariProtection.groups as! [SafariGroup], proStatus: self.configuration.proStatus)
            self.modelsProvider.searchString = self.searchString
            
            // This delay is done for smooth switch animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self = self else { return }
                let sectionToReloadIndex = self.groupModels.firstIndex(where: { $0.groupType == groupType })!
                self.tableView?.reloadSections(IndexSet(integer: sectionToReloadIndex), with: .automatic)
            }
        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(AllSafariGroupsFiltersModel) - setGroup; Reload CB error when changing group=\(groupType) to state=\(newState); Error: \(error)")
            }
        }
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let groupModel = groupModels[section]
        let headerView = SafariGroupStateHeaderView(model: groupModel)
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
