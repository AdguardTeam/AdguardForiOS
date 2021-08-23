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
    
    // MARK: - Private methods
    
    private func processSearchString() {
        modelsProvider.searchString = searchString
        tableView?.reloadData()
    }
    
    private func reinit() {
        modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: safariProtection.groups as! [SafariGroup], proStatus: configuration.proStatus)
        modelsProvider.searchString = searchString
    }
}

// MARK: - AllSafariGroupsFiltersModel + FilterDetailsViewControllerDelegate

extension AllSafariGroupsFiltersModel {
    func deleteFilter(with groupId: Int, filterId: Int, onFilterDeleted: @escaping () -> Void) {
        let groupType = SafariGroup.GroupType(rawValue: groupId)!
        safariProtection.deleteCustomFilter(withId: filterId) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                DDLogError("(AllSafariGroupsFiltersModel) - deleteFilter; DB error when removing filter with id=\(filterId) group=\(groupType); Error: \(error)")
            }
            let section = self.groupModels.firstIndex(where: { $0.groupType == groupType })!
            let row = self.filtersModels[section].firstIndex(where: { $0.filterId == filterId })!
            self.reinit()
            self.tableView?.deleteRows(at: [IndexPath(row: row, section: section)], with: .automatic)
            onFilterDeleted()
        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(AllSafariGroupsFiltersModel) - deleteFilter; Reload CB error when removing filter with id=\(filterId) group=\(groupType); Error: \(error)")
            }
        }
    }
    
    func editFilter(with groupId: Int, filterId: Int, onFilterEdited: @escaping (SafariFilterProtocol) -> Void) {
        // TODO: - implement
    }
    
    func setFilter(with groupId: Int, filterId: Int, enabled: Bool, onFilterSet: @escaping (SafariFilterProtocol) -> Void) {
        let groupType = SafariGroup.GroupType(rawValue: groupId)!
        safariProtection.setFilter(withId: filterId, groupId, enabled: enabled) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                DDLogError("(AllSafariGroupsFiltersModel) - setFilter; DB error when setting filter with id=\(filterId) group=\(groupType) to state=\(enabled); Error: \(error)")
            }
            self.reinit()
            let section = self.groupModels.firstIndex(where: { $0.groupType == groupType })!
            let row = self.filtersModels[section].firstIndex(where: { $0.filterId == filterId })!
            self.tableView?.reloadRows(at: [IndexPath(row: row, section: section)], with: .automatic)
            
            let group = self.safariProtection.groups.first(where: { $0.groupType == groupType })!
            let newFilterMeta = group.filters.first(where: { $0.filterId == filterId })!
            onFilterSet(newFilterMeta)
        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(AllSafariGroupsFiltersModel) - setFilter; Reload CB error when changing group=\(groupType) to state=\(enabled); Error: \(error)")
            }
        }
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
            
            let sectionToReloadIndex = self.groupModels.firstIndex(where: { $0.groupType == groupType })!
            self.tableView?.reloadSections(IndexSet(integer: sectionToReloadIndex), with: .automatic)
        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(AllSafariGroupsFiltersModel) - setGroup; Reload CB error when changing group=\(groupType) to state=\(newState); Error: \(error)")
            }
        }
    }
}


// MARK: - AllSafariGroupsFiltersModel + SafariFilterCellDelegate

extension AllSafariGroupsFiltersModel {
    func safariFilterStateChanged(_ filterId: Int, _ groupType: SafariGroup.GroupType, _ newState: Bool) {
        setFilter(with: groupType.id, filterId: filterId, enabled: newState) { _ in }
    }
    
    func tagTapped(_ tagName: String) {
        delegate?.tagTapped(tagName)
    }
}

// MARK: - AllSafariGroupsFiltersModel + UITableViewDelegate

extension AllSafariGroupsFiltersModel {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupType = groupModels[indexPath.section].groupType
        let group = safariProtection.groups.first(where: { $0.groupType == groupType })!
        
        let filterId = filtersModels[indexPath.section][indexPath.row].filterId
        let filter = group.filters.first(where: { $0.filterId == filterId })!
        delegate?.filterTapped(filter)
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
