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
import typealias SafariAdGuardSDK.SafariProtectionProtocol

/// This screen is responsible for displaying All Safari Content Blockers information
final class ContentBlockersTableController: UITableViewController {

    // MARK: - Private properties
    
    private let model: ContentBlockersTableModel
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - UITableViewController lifecycle
    
    required init?(coder: NSCoder) {
        model = ContentBlockersTableModel(safariProtection: safariProtection, configuration: configuration)
        super.init(coder: coder)
        model.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateTheme()
        setupBackButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cbModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ContentBlockerTableViewCell.getCell(forTableView: tableView)
        cell.model = model.cbModels[indexPath.row]
        cell.updateTheme(themeService)
        return cell
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let title = String.localizedString("cb_screen_content_blockers_title")
        tableView.tableHeaderView = TitleTableHeaderView(title: title)
        ContentBlockerTableViewCell.registerCell(forTableView: tableView)
    }
}

// MARK: - ContentBlockersTableController + ContentBlockersTableModelDelegate

extension ContentBlockersTableController: ContentBlockersTableModelDelegate {
    func cbStatesChanged() {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

// MARK: - ContentBlockersTableController + ThemableProtocol

extension ContentBlockersTableController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupTable(tableView)
        tableView.reloadData()
        if let header = tableView.tableHeaderView as? TitleTableHeaderView {
            header.updateTheme(themeService)
        }
    }
}
