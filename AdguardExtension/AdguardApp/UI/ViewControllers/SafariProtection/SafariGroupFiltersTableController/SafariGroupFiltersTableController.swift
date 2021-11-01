///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import UIKit
import SafariAdGuardSDK

final class SafariGroupFiltersTableController: UITableViewController {

    // MARK: - UI Elements

    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!

    // MARK: - Public properties

    var titleForImport: String?
    var urlStringForImport: String?

    var displayType: DisplayType!

    enum DisplayType {
        case one(groupType: SafariGroup.GroupType)
        case all
    }

    // MARK: - Private properties

    private let filterDetailsSegueId = "FilterDetailsSegueId"
    private var selectedFilter: SafariGroup.Filter!
    private var headerSearchView: AGSearchView?
    private var headerTitleView: ExtendedTitleTableHeaderView?

    /* Services */
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private var model: SafariGroupFiltersModelProtocol!

    // Observer
    private var proStatusObserver: NotificationToken?

    // MARK: - UITableViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()

        // Setup view model
        switch displayType {
        case .one(let groupType):
            model = OneSafariGroupFiltersModel(groupType: groupType, safariProtection: safariProtection, configuration: configuration, themeService: themeService)
            navigationItem.rightBarButtonItems = [searchButton]
            addHeaderTitleView()

            proStatusObserver = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
                if self?.configuration.proStatus == false && groupType.proOnly {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        case .all:
            model = AllSafariGroupsFiltersModel(safariProtection: safariProtection, configuration: configuration)
            title = String.localizedString("navigation_item_filters_title")
            navigationItem.rightBarButtonItems = [cancelButton]
            addHeaderSearchView()
            headerSearchView?.textField.becomeFirstResponder()
        case .none:
            break
        }
        tableView.delegate = model
        tableView.dataSource = model
        model.setup(tableView: tableView)
        model.tableView = tableView
        model.delegate = self

        updateTheme()
        presentOnImport()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let destinationVC = segue.destination as? FilterDetailsViewController else {
            return
        }
        destinationVC.filterMeta = selectedFilter
        destinationVC.delegate = model
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }

    // MARK: - Actions

    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItems = [cancelButton]
        addHeaderSearchView()
        headerSearchView?.textField.becomeFirstResponder()
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        setupBackButton()
        navigationItem.setHidesBackButton(false, animated: true)
        navigationItem.rightBarButtonItems = [searchButton]
        switch displayType {
        case .one(_): addHeaderTitleView()
        case .all: removeTableHeaderView()
        case .none: break
        }
        model.searchString = nil
    }

    // MARK: - Private methods

    private func addHeaderSearchView() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.setHidesBackButton(true, animated: true)
        headerTitleView = nil
        headerSearchView = AGSearchView()
        headerSearchView?.delegate = self
        headerSearchView?.textField.returnKeyType = .search
        tableView.tableHeaderView = headerSearchView
    }

    private func addHeaderTitleView() {
        guard let oneGroupModel = model as? OneSafariGroupFiltersModel else {
            return
        }
        headerSearchView = nil
        headerTitleView = ExtendedTitleTableHeaderView(title: oneGroupModel.title, normalDescription: oneGroupModel.summary)
        tableView.tableHeaderView = headerTitleView
    }

    private func removeTableHeaderView() {
        headerSearchView = nil
        tableView.tableHeaderView = nil
    }

    private func presentOnImport() {
        guard titleForImport != nil, urlStringForImport != nil else { return }
        addNewFilterTapped()
        titleForImport = nil
        urlStringForImport = nil
    }
}

// MARK: - SafariGroupFiltersTableController + SafariGroupFiltersModelDelegate

extension SafariGroupFiltersTableController: SafariGroupFiltersModelDelegate {

    func filterTapped(_ filter: SafariGroup.Filter) {
        selectedFilter = filter
        performSegue(withIdentifier: filterDetailsSegueId, sender: self)
    }

    func tagTapped(_ tagName: String) {
        if headerSearchView == nil {
            addHeaderSearchView()
        }

        let searchText = headerSearchView?.textField.text ?? ""

        if !searchText.isEmpty {
            headerSearchView?.textField.text = searchText + " " + tagName
        } else {
            headerSearchView?.textField.text = tagName
        }
        model.searchString = headerSearchView?.textField.text

        headerSearchView?.textField.rightView?.isHidden = false
        navigationItem.rightBarButtonItems = [cancelButton]
    }

    func addNewFilterTapped() {
        let storyboard = UIStoryboard(name: "Filters", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "AddCustomFilterController") as? AddCustomFilterController else {
            return
        }

        controller.openTitle = titleForImport
        controller.openUrl = urlStringForImport
        controller.type = .safariCustom
        controller.delegate = model
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - SafariGroupFiltersTableController + AGSearchViewDelegate

extension SafariGroupFiltersTableController: AGSearchViewDelegate {
    func textChanged(to newText: String) {
        model.searchString = newText
    }
}

// MARK: - SafariGroupFiltersTableController + ThemableProtocol

extension SafariGroupFiltersTableController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupTable(tableView)
        tableView.reloadData()
    }
}
