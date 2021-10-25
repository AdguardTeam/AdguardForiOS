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

final class MainMenuController: UITableViewController {

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!

    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var supportCell: UITableViewCell!
    @IBOutlet weak var LicenseCell: UITableViewCell!
    @IBOutlet var themableLabels: [ThemableLabel]!

    private var proStatus: Bool {
        return configuration.proStatus
    }

    // MARK: - view controler life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTheme()
        settingsImageView.image = UIImage(named: "advanced-settings-icon")

        if Bundle.main.isPro {
            LicenseCell.isHidden = true
        }
    }

    // MARK: - table view cells

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        if cell == LicenseCell &&  Bundle.main.isPro {
            return 0.0
        }

        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}

extension MainMenuController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        tableView.reloadData()
    }
}
