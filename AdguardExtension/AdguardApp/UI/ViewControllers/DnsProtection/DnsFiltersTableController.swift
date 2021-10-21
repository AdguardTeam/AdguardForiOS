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
import DnsAdGuardSDK

// TODO: - Process tunnel overlimit error 'dns_filters_overlimit_title'

/// Screen with DNS filters list
final class DnsFiltersTableController: UITableViewController {

    // MARK: - UI elements

    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var searchButton: UIBarButtonItem!

    // MARK: - Private variables

    private var headerView: AGSearchView?
    private var selectedFilter: DnsFilter!
    private var themeObserver: NotificationToken?

    /* Services */
    private let model: DnsFiltersTableModel
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsProtection: DnsProtectionProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!

    // MARK: - UIViewController lifecycle

    required init?(coder: NSCoder) {
        self.model = DnsFiltersTableModel(dnsProtection: dnsProtection, vpnManager: vpnManager)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [searchButton]
        setupTableView()
        updateTheme()
        setupBackButton()
        model.delegate = self

        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }

    // MARK: - Actions

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItems = [searchButton]
        setTitleHeaderView()
    }

    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItems = [cancelButton]
        setSearchHeaderView()
        headerView?.textField.becomeFirstResponder()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.isSearching ? model.cellModels.count : model.cellModels.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !model.isSearching && indexPath.row == 0 {
            let cell = AddTableViewCell.getCell(forTableView: tableView)
            cell.addTitle = String.localizedString("add_new_filter")
            cell.updateTheme(themeService)
            return cell
        }

        let cell = DnsFilterCell.getCell(forTableView: tableView)
        cell.delegate = model
        cell.updateTheme(themeService)
        let cellModelIndex = cellModelIndex(for: indexPath.row)
        cell.model = model.cellModels[cellModelIndex]
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        if !model.isSearching && indexPath.row == 0 {
            addNewFilterTapped()
            return
        }

        let filterIndex = cellModelIndex(for: indexPath.row)
        selectedFilter = dnsProtection.filters[filterIndex]
        filterTapped()
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    // MARK: - Private methods

    private func setupTableView() {
        AddTableViewCell.registerCell(forTableView: tableView)
        DnsFilterCell.registerCell(forTableView: tableView)
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        setTitleHeaderView()
    }

    private func addNewFilterTapped() {
        let storyboard = UIStoryboard(name: "Filters", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "AddCustomFilterController") as? AddCustomFilterController else {
            return
        }

        controller.type = .dnsCustom
        controller.delegate = model
        present(controller, animated: true, completion: nil)
    }

    private func filterTapped() {
        let storyboard = UIStoryboard(name: "Filters", bundle: .main)
        guard let filterDetailsVC = storyboard.instantiateViewController(withIdentifier: "FilterDetailsViewController") as? FilterDetailsViewController else {
            return
        }

        filterDetailsVC.filterMeta = selectedFilter
        filterDetailsVC.delegate = model
        navigationController?.pushViewController(filterDetailsVC, animated: true)
    }

    private func cellModelIndex(for row: Int) -> Int {
        model.isSearching ? row : row - 1
    }

    private func setSearchHeaderView() {
        headerView = AGSearchView()
        headerView?.delegate = self
        tableView.tableHeaderView = headerView

    }

    private func setTitleHeaderView() {
        let title = String.localizedString("dns_filters_title")
        let format = String.localizedString("dns_filters_number_title")
        let descr = String(format: format, "\(model.enabledRulesCount)")
        tableView.tableHeaderView = ExtendedTitleTableHeaderView(title: title, normalDescription: descr)
    }

    private func updateTitleHeaderView() {
        let format = String.localizedString("dns_filters_number_title")
        let descr = String(format: format, "\(model.enabledRulesCount)")
        guard let header = tableView.tableHeaderView as? ExtendedTitleTableHeaderView else { return }
        header.setNormalTitle(descr)
    }
}

// MARK: - DnsFiltersTableController + DnsFiltersTableModelDelegate

extension DnsFiltersTableController: DnsFiltersTableModelDelegate {
    func modelsChanged() {
        tableView.reloadData()
        updateTitleHeaderView()
    }

    func filterAdded() {
        let indexPath = IndexPath(row: model.cellModels.count, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        updateTitleHeaderView()
    }
}

// MARK: - DnsFiltersTableController + ThemableProtocol

extension DnsFiltersTableController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupTable(tableView)
        tableView.reloadData()
    }
}

// MARK: - DnsFiltersTableController + AGSearchViewDelegate

extension DnsFiltersTableController: AGSearchViewDelegate {
    func textChanged(to newText: String) {
        model.searchString = newText
    }
}
