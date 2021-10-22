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
import SwiftUI

protocol SafariGroupFiltersModelDelegate: AnyObject {
    func filterTapped(_ filter: SafariGroup.Filter)
    func tagTapped(_ tagName: String)
    func addNewFilterTapped()
}

protocol SafariGroupFiltersModelProtocol: UITableViewDelegate, UITableViewDataSource, SafariFilterCellDelegate, IdentifiableObjectDelegate, FilterDetailsViewControllerDelegate {
    var searchString: String? { get set }
    var tableView: UITableView? { get set }
    var delegate: SafariGroupFiltersModelDelegate? { get set }
    func setup(tableView: UITableView)
}

final class OneSafariGroupFiltersModel: NSObject, SafariGroupFiltersModelProtocol {

    // MARK: - Public properties

    var title: String { groupModel.title }

    var summary: String { "Here will be a group description when content team provides us with it" }

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
    private var groupModel: StateHeaderViewModel<SafariGroup.GroupType>
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
        self.group = safariProtection.groups.first(where: { $0.groupType == groupType })!
        self.modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: [group], proStatus: configuration.proStatus)
        self.groupModel = modelsProvider.groupModels.first!
        super.init()

        self.proStatusObserver = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: [self.group], proStatus: self.configuration.proStatus)
            guard let newGroupModel = self.modelsProvider.groupModels.first else {
                assertionFailure("modelsProvider.groupModels doesn't contain any group")
                return
            }
            self.groupModel = newGroupModel
            self.tableView?.reloadData()
        }
    }

    // MARK: - Public methods

    func setup(tableView: UITableView) {
        AddTableViewCell.registerCell(forTableView: tableView)
        SafariFilterCell.registerCell(forTableView: tableView)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 84.0
        tableView.sectionFooterHeight = 0.01
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Private methods

    private func processSearchString() {
        modelsProvider.searchString = searchString
        tableView?.reloadData()
    }

    private func reinit() {
        guard let newGroup = safariProtection.groups.first(where: { $0.groupType == group.groupType }) else {
            assertionFailure("safariProtection should contain group with type=\(group.groupType)")
            return
        }
        group = newGroup
        modelsProvider = SafariGroupFiltersModelsProvider(sdkModels: [group], proStatus: configuration.proStatus)
        modelsProvider.searchString = searchString
        tableView?.reloadData()
    }
}

// MARK: - OneSafariGroupFiltersModel + FilterDetailsViewControllerDelegate

extension OneSafariGroupFiltersModel {
    func deleteFilter(filterId: Int) throws {
        try safariProtection.deleteCustomFilter(withId: filterId, onCbReloaded: nil)
        reinit()
    }

    func setFilter(with groupId: Int?, filterId: Int, enabled: Bool) throws -> FilterDetailsProtocol {
        guard let groupId = groupId else {
            assertionFailure("Group id is nil")
            throw CommonError.missingData
        }

        try safariProtection.setFilter(withId: filterId, groupId, enabled: enabled, onCbReloaded: nil)
        reinit()

        guard let newFilterMeta = group.filters.first(where: { $0.filterId == filterId }) else {
            assertionFailure("group should contain filter with filterId=\(filterId)")
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
                DDLogError("(OneSafariGroupFiltersModel) - addCustomFilter; Reload CB error when adding custom filter with url=\(meta.filterDownloadPage ?? "nil"); Error: \(error)")
            }
        }
    }

    func renameFilter(withId filterId: Int, to newName: String) throws -> FilterDetailsProtocol {
        try safariProtection.renameCustomFilter(withId: filterId, to: newName)
        reinit()
        guard let newFilterMeta = group.filters.first(where: { $0.filterId == filterId }) else {
            assertionFailure("group should contain filter with filterId=\(filterId)")
            throw CommonError.missingData
        }
        return newFilterMeta
    }
}

// MARK: - OneSafariGroupFiltersModel + SafariFilterCellDelegate

extension OneSafariGroupFiltersModel {
    func safariFilterStateChanged(_ filterId: Int, _ groupType: SafariGroup.GroupType, _ newState: Bool) {
        do {
            _ = try setFilter(with: groupType.id, filterId: filterId, enabled: newState)
        } catch {
            DDLogError("(OneSafariGroupFiltersModel) - safariFilterStateChanged; Error changing safari filter state; Error: \(error)")
        }
    }

    func tagTapped(_ tagName: String) {
        delegate?.tagTapped(tagName)
    }
}

// MARK: - OneSafariGroupFiltersModel + IdentifiableObjectDelegate

extension OneSafariGroupFiltersModel {
    func modelChanged<Model: IdentifiableObject>(_ newModel: Model) {
        guard let newModel = newModel as? StateHeaderViewModel<SafariGroup.GroupType> else { return }

        let groupType = newModel.id
        DDLogInfo("(OneSafariGroupFiltersModel) - setGroup; Trying to change group=\(groupType) to state=\(newModel.isEnabled)")

        do {
            try safariProtection.setGroup(groupType, enabled: newModel.isEnabled, onCbReloaded: nil)
        } catch {
            DDLogError("(OneSafariGroupFiltersModel) - setGroup; DB error when changing group=\(groupType) to state=\(newModel.isEnabled); Error: \(error)")
        }

        groupModel = StateHeaderViewModel(
            iconImage: groupModel.iconImage,
            title: groupModel.title,
            isEnabled: newModel.isEnabled,
            id: groupModel.id
        )
        reinit()
    }
}

// MARK: - OneSafariGroupFiltersModel + UITableViewDelegate

extension OneSafariGroupFiltersModel {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addButtonIsDisplayed && indexPath.row == 0 {
            delegate?.addNewFilterTapped()
        } else {
            let index = addButtonIsDisplayed ? indexPath.row - 1 : indexPath.row
            let filterId = filtersModels[index].filterId
            guard let filter = group.filters.first(where: { $0.filterId == filterId }) else {
                assertionFailure("group should contain filter with filterId=\(filterId)")
                return
            }
            delegate?.filterTapped(filter)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - OneSafariGroupFiltersModel + UITableViewDataSource

extension OneSafariGroupFiltersModel {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isCustom && !isSearching ? filtersModels.count + 1 : filtersModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = StateHeaderView<SafariGroup.GroupType>(frame: .zero)
        let model = StateHeaderViewModel(
            iconImage: groupModel.iconImage,
            title: groupModel.isEnabled.localizedStateDescription,
            isEnabled: groupModel.isEnabled,
            id: group.groupType
        )
        headerView.config = IdentifiableViewConfig(model: model, delegate: self)
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
