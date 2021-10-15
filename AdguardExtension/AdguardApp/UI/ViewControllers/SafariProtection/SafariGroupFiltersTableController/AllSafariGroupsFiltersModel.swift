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

import SharedAdGuardSDK
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

    private var groupModels: [StateHeaderViewModel<SafariGroup.GroupType>] { modelsProvider.groupModels }
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
        self.modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: safariProtection.groups, proStatus: configuration.proStatus)
        super.init()

        self.proStatusObserver = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
            self?.reinit()
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
        modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: safariProtection.groups, proStatus: configuration.proStatus)
        modelsProvider.searchString = searchString
        tableView?.reloadData()
    }
}

// MARK: - AllSafariGroupsFiltersModel + FilterDetailsViewControllerDelegate

extension AllSafariGroupsFiltersModel {

    func deleteFilter(filterId: Int) throws {
        try safariProtection.deleteCustomFilter(withId: filterId, onCbReloaded: nil)
        reinit()
    }

    func setFilter(with groupId: Int?, filterId: Int, enabled: Bool) throws -> FilterDetailsProtocol {
        guard let groupId = groupId, let groupType = SafariGroup.GroupType(rawValue: groupId) else {
            assertionFailure("SafariGroup.GroupType initialized with wrong rawValue=\(groupId ?? -1)")
            throw CommonError.missingData
        }

        try safariProtection.setFilter(withId: filterId, groupId, enabled: enabled, onCbReloaded: nil)
        reinit()

        guard let group = self.safariProtection.groups.first(where: { $0.groupType == groupType }),
              let newFilterMeta = group.filters.first(where: { $0.filterId == filterId })
        else {
            assertionFailure("Failed to find filter with groupType=\(groupType) filterId=\(filterId)")
            throw CommonError.missingData
        }
        return newFilterMeta
    }

    func addCustomFilter(_ meta: ExtendedCustomFilterMetaProtocol, _ onFilterAdded: @escaping (Error?) -> Void) {
        safariProtection.add(customFilter: meta, enabled: true) { error in
            DispatchQueue.asyncSafeMain { [weak self] in
                self?.reinit()
                onFilterAdded(error)
            }
        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(AllSafariGroupsFiltersModel) - addCustomFilter; Reload CB error when adding custom filter with url=\(meta.filterDownloadPage ?? "nil"); Error: \(error)")
            }
        }
    }

    func renameFilter(withId filterId: Int, to newName: String) throws -> FilterDetailsProtocol {
        try safariProtection.renameCustomFilter(withId: filterId, to: newName)
        reinit()
        guard let group = safariProtection.groups.first(where: { $0.groupType == .custom }),
              let newFilterMeta = group.filters.first(where: { $0.filterId == filterId })
        else {
            assertionFailure("Failed to find custom filter with filterId=\(filterId)")
            throw CommonError.missingData
        }
        return newFilterMeta
    }
}

// MARK: - AllSafariGroupsFiltersModel + SafariGroupStateHeaderDelegate

extension AllSafariGroupsFiltersModel {
    func modelChanged<Model>(_ newModel: Model) where Model : IdentifiableObject {
        guard let newModel = newModel as? StateHeaderViewModel<SafariGroup.GroupType> else { return }

        let groupType = newModel.id
        DDLogInfo("(AllSafariGroupsFiltersModel) - setGroup; Trying to change group=\(groupType) to state=\(newModel.isEnabled)")

        do {
            try safariProtection.setGroup(groupType, enabled: newModel.isEnabled, onCbReloaded: nil)
        }
        catch {
            DDLogError("(AllSafariGroupsFiltersModel) - setGroup; DB error when changing group=\(groupType) to state=\(newModel.isEnabled); Error: \(error)")
        }

        modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: safariProtection.groups, proStatus: configuration.proStatus)
        modelsProvider.searchString = searchString

        guard let sectionToReloadIndex = groupModels.firstIndex(where: { $0.id == groupType }) else {
            assertionFailure("Failed to find group with groupType=\(groupType)")
            return
        }
        tableView?.reloadSections(IndexSet(integer: sectionToReloadIndex), with: .automatic)
    }
}


// MARK: - AllSafariGroupsFiltersModel + SafariFilterCellDelegate

extension AllSafariGroupsFiltersModel {
    func safariFilterStateChanged(_ filterId: Int, _ groupType: SafariGroup.GroupType, _ newState: Bool) {
        do {
            _ = try setFilter(with: groupType.id, filterId: filterId, enabled: newState)
        }
        catch {
            DDLogError("(OneSafariGroupFiltersModel) - safariFilterStateChanged; Error changing safari filter state; Error: \(error)")
        }
    }

    func tagTapped(_ tagName: String) {
        delegate?.tagTapped(tagName)
    }
}

// MARK: - AllSafariGroupsFiltersModel + UITableViewDelegate

extension AllSafariGroupsFiltersModel {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupType = groupModels[indexPath.section].id
        let group = safariProtection.groups.first(where: { $0.groupType == groupType })

        let filterId = filtersModels[indexPath.section][indexPath.row].filterId
        let filter = group?.filters.first(where: { $0.filterId == filterId })

        guard group != nil,
              let filter = filter
        else {
            assertionFailure("Failed to find filter with groupType=\(groupType) filterId=\(filterId)")
            return
        }

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
        cell.updateTheme()
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let groupModel = groupModels[section]
        let headerView = StateHeaderView<SafariGroup.GroupType>(frame: .zero)
        headerView.config = IdentifiableViewConfig(model: groupModel, delegate: self)
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
