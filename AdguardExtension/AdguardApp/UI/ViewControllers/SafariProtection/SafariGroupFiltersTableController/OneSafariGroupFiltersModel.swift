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

protocol SafariGroupFiltersModelDelegate: AnyObject {
    func filterTapped(_ filter: SafariFilterProtocol)
    func tagTapped(_ tagName: String)
}

protocol SafariGroupFiltersModelProtocol: UITableViewDelegate, UITableViewDataSource, SafariFilterCellDelegate, SafariGroupStateHeaderDelegate {
    var searchString: String? { get set }
    var tableView: UITableView? { get set }
    var delegate: SafariGroupFiltersModelDelegate? { get set }
    func setup(tableView: UITableView)
}

final class OneSafariGroupFiltersModel: NSObject, SafariGroupFiltersModelProtocol {
    
    // MARK: - Public properties
    
    var searchString: String? {
        didSet {
            processSearchString()
        }
    }
    
    weak var tableView: UITableView?
    weak var delegate: SafariGroupFiltersModelDelegate?
    
    // MARK: - Private properties
    
    private var group: SafariGroup
    private var groupModel: SafariGroupStateHeaderModel
    private var filtersModels: [SafariFilterCellModel] { modelsProvider.filtersModels.first ?? [] }
    
    /* Services */
    private let safariProtection: SafariProtectionProtocol
    private let configuration: ConfigurationServiceProtocol
    private var modelsProvider: SafariGroupFiltersModelsProvider
    
    private var proStatusObserver: NotificationToken?
    
    // MARK: - Initialization
    
    init(groupType: SafariGroup.GroupType, safariProtection: SafariProtectionProtocol, configuration: ConfigurationServiceProtocol) {
        self.safariProtection = safariProtection
        self.configuration = configuration
        self.group = safariProtection.groups.first(where: { $0.groupType == groupType })! as! SafariGroup
        self.modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: [group], proStatus: configuration.proStatus)
        self.groupModel = modelsProvider.groupModels.first!
        super.init()
        
        self.proStatusObserver = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: [self.group], proStatus: self.configuration.proStatus)
            self.groupModel = self.modelsProvider.groupModels.first!
            self.tableView?.reloadData()
        }
    }
    
    // MARK: - Public methods

    func setup(tableView: UITableView) {
        TitleTableViewCell.registerNibCell(forTableView: tableView)
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
}

// MARK: - OneSafariGroupFiltersModel + SafariFilterCellDelegate

extension OneSafariGroupFiltersModel {
    func safariFilterStateChanged(_ filterId: Int, _ groupType: SafariGroup.GroupType, _ newState: Bool) {
        safariProtection.setFilter(withId: filterId, groupType.id, enabled: newState) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                DDLogError("(OneSafariGroupFiltersModel) - setFilter; DB error when setting filter with id=\(filterId) group=\(groupType) to state=\(newState); Error: \(error)")
            }
            self.group = self.safariProtection.groups.first(where: { $0.groupType == groupType })! as! SafariGroup
            self.modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: [self.group], proStatus: self.configuration.proStatus)
            self.modelsProvider.searchString = self.searchString
            self.groupModel = self.modelsProvider.groupModels.first!
            
            let row = self.filtersModels.firstIndex(where: { $0.filterId == filterId })!
            self.tableView?.reloadRows(at: [IndexPath(row: row, section: Section.filters.rawValue)], with: .none)
        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(OneSafariGroupFiltersModel) - setFilter; Reload CB error when setting filter with id=\(filterId) group=\(groupType) to state=\(newState); Error: \(error)")
            }
        }
    }
    
    func tagTapped(_ tagName: String) {
        delegate?.tagTapped(tagName)
    }
}

// MARK: - OneSafariGroupFiltersModel + SafariGroupStateHeaderDelegate

extension OneSafariGroupFiltersModel {
    func stateChanged(for groupType: SafariGroup.GroupType, newState: Bool) {
        DDLogInfo("(OneSafariGroupFiltersModel) - setGroup; Trying to change group=\(groupType) to state=\(newState)")
        
        safariProtection.setGroup(groupType, enabled: newState) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                DDLogError("(OneSafariGroupFiltersModel) - setGroup; DB error when changing group=\(groupType) to state=\(newState); Error: \(error)")
            }
            
            self.group = self.safariProtection.groups.first(where: { $0.groupType == groupType })! as! SafariGroup
            self.modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: [self.group], proStatus: self.configuration.proStatus)
            self.modelsProvider.searchString = self.searchString
            self.groupModel = self.modelsProvider.groupModels.first!
            
            self.tableView?.reloadSections(IndexSet(integer: Section.filters.rawValue), with: .automatic)
        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(OneSafariGroupFiltersModel) - setGroup; Reload CB error when changing group=\(groupType) to state=\(newState); Error: \(error)")
            }
        }
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
        if indexPath.section == Section.title.rawValue {
            return
        }
        let filterId = filtersModels[indexPath.row].filterId
        let filter = group.filters.first(where: { $0.filterId == filterId })!
        delegate?.filterTapped(filter)
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
            cell.delegate = self
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
            headerView.delegate = self
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
