//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import SharedAdGuardSDK
import SafariAdGuardSDK

protocol FilterDetailsViewControllerDelegate: NewCustomFilterDetailsControllerDelegate {
    func deleteFilter(filterId: Int) throws
    func setFilter(with groupId: Int?, filterId: Int, enabled: Bool) throws -> FilterDetailsProtocol
}

private let LOG = LoggerFactory.getLoggerWrapper(FilterDetailsViewController.self)

final class FilterDetailsViewController: UIViewController {

    // MARK: - UI Elements

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Public properties

    weak var delegate: FilterDetailsViewControllerDelegate!
    var filterMeta: FilterDetailsProtocol!

    // MARK: - Private properties

    private var model: FilterDetailsViewModel!
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeObserver: NotificationToken?

    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        processBottomButtons()
        setupBackButton()

        updateTheme()
        setupTableView()
        tableView.tableHeaderView = ExtendedTitleTableHeaderView(title: filterMeta.filterName, normalDescription: filterMeta.description ?? "")

        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }

    // MARK: - Private methods

    private func setupTableView() {
        model = FilterDetailsViewModel(filterMeta: filterMeta, themeService: themeService)
        model.delegate = self
        tableView.backgroundColor = .clear
        tableView.delegate = model
        tableView.dataSource = model
        tableView.separatorStyle = .none

        SwitchTableViewCell.registerCell(forTableView: tableView)
        FilterDetailsCell.registerCell(forTableView: tableView)
        FilterDetailsTagsCell.registerCell(forTableView: tableView)
    }

    private func processBottomButtons() {
        if filterMeta.editable {
            let title = String.localizedString("common_edit").capitalized
            let button = button(withTitle: title)
            button.applyStandardOpaqueStyle()
            button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

            buttonsStackView.addArrangedSubview(button)
            stackViewHeightConstraint.constant = 40.0
        }

        if filterMeta.removable {
            let title = String.localizedString("common_delete").capitalized
            let button = button(withTitle: title)
            button.applyStandardOpaqueStyle(color: UIColor.AdGuardColor.red)
            button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

            buttonsStackView.addArrangedSubview(button)
            if buttonsStackView.arrangedSubviews.isEmpty {
                stackViewHeightConstraint.constant = 40.0
            } else {
                stackViewHeightConstraint.constant = 88.0
            }
        }
    }

    private func button(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        return button
    }

    @objc private final func editButtonTapped() {
        let storyboard = UIStoryboard(name: "Filters", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "NewCustomFilterDetailsController") as? NewCustomFilterDetailsController else {
            return
        }
        let model = EditCustomFilterModel(
            filterName: filterMeta.filterName,
            filterId: filterMeta.filterId,
            rulesCount: filterMeta.rulesCount,
            homePage: filterMeta.homepage
        )
        controller.editFilterModel = model
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }

    @objc private final func deleteButtonTapped() {
        do {
            try delegate.deleteFilter(filterId: filterMeta.filterId)
            DispatchQueue.asyncSafeMain { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
        catch {
            LOG.error("Error deleting custom filter with id=\(filterMeta.filterId); Error: \(error)")
            showUnknownErrorAlert()
        }
    }

    private func updateTableHeader(_ filterMeta: FilterDetailsProtocol) {
        DispatchQueue.asyncSafeMain { [weak self] in
            if let header = self?.tableView.tableHeaderView as? ExtendedTitleTableHeaderView {
                header.title = filterMeta.filterName
                header.setNormalTitle(filterMeta.description ?? "")
                self?.tableView.layoutTableHeaderView()
            }
        }
    }
}

// MARK: - FilterDetailsTableController + SwitchTableViewCellDelegate

extension FilterDetailsViewController: SwitchTableViewCellDelegate {
    func switchStateChanged(to enabled: Bool) {
        do {
            let newFilterMeta = try delegate.setFilter(with: filterMeta.groupId, filterId: filterMeta.filterId, enabled: enabled)
            filterMeta = newFilterMeta
        }
        catch {
            LOG.error("Error changing state for filter with id=\(filterMeta.filterId), group id=\(filterMeta.groupId.debugDescription); Error: \(error)")
            showUnknownErrorAlert()
        }
    }
}

// MARK: - FilterDetailsViewController + NewCustomFilterDetailsControllerDelegate

extension FilterDetailsViewController: NewCustomFilterDetailsControllerDelegate {

    func addCustomFilter(_ meta: ExtendedCustomFilterMetaProtocol, _ onFilterAdded: @escaping (Error?) -> Void) {
        delegate.addCustomFilter(meta, onFilterAdded)
    }

    func renameFilter(withId filterId: Int, to newName: String) throws -> FilterDetailsProtocol {
        let newFilterMeta = try delegate.renameFilter(withId: filterId, to: newName)
        filterMeta = newFilterMeta
        updateTableHeader(filterMeta)
        return newFilterMeta
    }
}

// MARK: - FilterDetailsTableController + ThemableProtocol

extension FilterDetailsViewController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupTable(tableView)
        tableView.reloadData()
    }
}
