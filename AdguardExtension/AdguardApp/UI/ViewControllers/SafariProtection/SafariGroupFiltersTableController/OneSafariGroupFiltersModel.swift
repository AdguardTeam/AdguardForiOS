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
    func addNewFilterTapped()
}

protocol SafariGroupFiltersModelProtocol: UITableViewDelegate, UITableViewDataSource, SafariFilterCellDelegate, SafariGroupStateHeaderDelegate, FilterDetailsViewControllerDelegate {
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
    private lazy var isCustom: Bool = { group.groupType == .custom }()
    private var isSearching: Bool { modelsProvider.isSearching }
    private var addButtonIsDisplayed: Bool { isCustom && !isSearching }
    private var groupModel: SafariGroupStateHeaderModel
    private var filtersModels: [SafariFilterCellModel] { modelsProvider.filtersModels.first ?? [] }
    
    /* Services */
    private let safariProtection: SafariProtectionProtocol
    private let configuration: ConfigurationServiceProtocol
    private let themeService: ThemeServiceProtocol
    private var modelsProvider: SafariGroupFiltersModelsProvider
    
    private var proStatusObserver: NotificationToken?
    
    // MARK: - Initialization
    
    init(groupType: SafariGroup.GroupType, safariProtection: SafariProtectionProtocol, configuration: ConfigurationServiceProtocol, themeService: ThemeServiceProtocol) {
        self.safariProtection = safariProtection
        self.configuration = configuration
        self.themeService = themeService
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
        AddTableViewCell.registerCell(forTableView: tableView)
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
        group = safariProtection.groups.first(where: { $0.groupType == group.groupType })! as! SafariGroup
        modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: [group], proStatus: configuration.proStatus)
        modelsProvider.searchString = searchString
        tableView?.reloadData()
    }
}

// MARK: - OneSafariGroupFiltersModel + FilterDetailsViewControllerDelegate

extension OneSafariGroupFiltersModel {
    func deleteFilter(with groupId: Int, filterId: Int, onFilterDeleted: @escaping () -> Void) {
        safariProtection.deleteCustomFilter(withId: filterId) { [weak self] error in
            if let error = error {
                DDLogError("(OneSafariGroupFiltersModel) - deleteFilter; DB error when removing filter with id=\(filterId) groupId=\(groupId); Error: \(error)")
            }
            self?.reinit()
            onFilterDeleted()
        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(OneSafariGroupFiltersModel) - deleteFilter; Reload CB error when removing filter with id=\(filterId) groupId=\(groupId); Error: \(error)")
            }
        }
    }
    
    func setFilter(with groupId: Int, filterId: Int, enabled: Bool, onFilterSet: @escaping (SafariFilterProtocol) -> Void) {
        safariProtection.setFilter(withId: filterId, groupId, enabled: enabled) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                DDLogError("(OneSafariGroupFiltersModel) - setFilter; DB error when setting filter with id=\(filterId) groupId=\(groupId) to state=\(enabled); Error: \(error)")
            }
            self.reinit()
            let newFilterMeta = self.group.filters.first(where: { $0.filterId == filterId })!
            onFilterSet(newFilterMeta)
        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(OneSafariGroupFiltersModel) - setFilter; Reload CB error when setting filter with id=\(filterId) groupId=\(groupId) to state=\(enabled); Error: \(error)")
            }
        }
    }
    
    func addCustomFilter(_ meta: ExtendedCustomFilterMetaProtocol, _ onFilterAdded: @escaping (Error?) -> Void) {
        safariProtection.add(customFilter: meta, enabled: true) { error in
            DispatchQueue.asyncSafeMain { [weak self] in
                self?.reinit()
                onFilterAdded(error)
            }
        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(OneSafariGroupFiltersModel) - addCustomFilter; Reload CB error when adding custom filter with url=\(meta.filterDownloadPage ?? "nil"); Error: \(error)")
            }
        }
    }
    
    func renameFilter(withId filterId: Int, to newName: String) throws -> SafariFilterProtocol {
        try safariProtection.renameCustomFilter(withId: filterId, to: newName)
        reinit()
        let newFilterMeta = group.filters.first(where: { $0.filterId == filterId })!
        return newFilterMeta
    }
}

// MARK: - OneSafariGroupFiltersModel + SafariFilterCellDelegate

extension OneSafariGroupFiltersModel {
    func safariFilterStateChanged(_ filterId: Int, _ groupType: SafariGroup.GroupType, _ newState: Bool) {
        setFilter(with: groupType.id, filterId: filterId, enabled: newState) { _ in }
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
            self.groupModel = SafariGroupStateHeaderModel(
                iconImage: self.groupModel.iconImage,
                groupName: self.groupModel.groupName,
                isEnabled: newState,
                groupType: self.groupModel.groupType
            )
            self.reinit()
        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(OneSafariGroupFiltersModel) - setGroup; Reload CB error when changing group=\(groupType) to state=\(newState); Error: \(error)")
            }
        }
    }
}

// MARK: - OneSafariGroupFiltersModel + UITableViewDelegate

extension OneSafariGroupFiltersModel {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.title.rawValue {
            return
        }
        
        if addButtonIsDisplayed && indexPath.row == 0 {
            delegate?.addNewFilterTapped()
        } else {
            let index = addButtonIsDisplayed ? indexPath.row - 1 : indexPath.row
            let filterId = filtersModels[index].filterId
            let filter = group.filters.first(where: { $0.filterId == filterId })!
            delegate?.filterTapped(filter)
        }
        
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
        case .filters: return isCustom && !isSearching ? filtersModels.count + 1 : filtersModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sct = Section(rawValue: indexPath.section)!
        switch sct {
        case .title:
            let cell = TitleTableViewCell.getCell(forTableView: tableView)
            cell.title = groupModel.groupName
            cell.updateTheme(themeService)
            return cell
        case .filters:
            if isCustom && indexPath.row == 0 && !isSearching {
                let cell = AddTableViewCell.getCell(forTableView: tableView)
                cell.addTitle = String.localizedString("add_new_filter")
                cell.updateTheme(themeService)
                return cell
            }
            let index = addButtonIsDisplayed ? indexPath.row - 1 : indexPath.row
            let cell = SafariFilterCell.getCell(forTableView: tableView)
            cell.model = filtersModels[index]
            cell.updateTheme()
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

// MARK: - OneSafariGroupFiltersModel + Section

fileprivate extension OneSafariGroupFiltersModel {
    enum Section: Int, CaseIterable {
        case title = 0
        case filters
    }
}
