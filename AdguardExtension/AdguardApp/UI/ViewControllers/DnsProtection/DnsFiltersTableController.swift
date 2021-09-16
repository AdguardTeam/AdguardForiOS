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

final class DnsFiltersTableController: UITableViewController {
    
    // MARK: - UI elements
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var searchButton: UIBarButtonItem!
    
    // MARK: - Private variables
    
    private let model: DnsFiltersTableModel
    
    private var themeObserver: NotificationToken?
    
    /* Services */
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - UIViewController lifecycle

    required init?(coder: NSCoder) {
        self.model = DnsFiltersTableModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [searchButton]
        setupTableView()
        updateTheme()
        setupBackButton()
        
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
    }
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItems = [cancelButton]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AddTableViewCell.getCell(forTableView: tableView)
        cell.addTitle = String.localizedString("add_new_filter")
        cell.updateTheme(themeService)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        AddTableViewCell.registerCell(forTableView: tableView)
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension

        let title = String.localizedString("dns_filters_title")
        // TODO: - Process tunnel overlimit error 'dns_filters_overlimit_title'
        let format = String.localizedString("dns_filters_number_title")
        let descr = String(format: format, "0")
        tableView.tableHeaderView = ExtendedTitleTableHeaderView(title: title, normalDescription: descr)
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
