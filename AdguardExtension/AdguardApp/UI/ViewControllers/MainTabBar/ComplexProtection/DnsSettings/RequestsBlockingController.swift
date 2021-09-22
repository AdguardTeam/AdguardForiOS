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

final class RequestsBlockingController: UITableViewController {

    @IBOutlet weak var filtersLabel: ThemableLabel!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsProtection: DnsProtectionProtocol = ServiceLocator.shared.getService()!
    
    private let dnsBlacklistSegue = "dnsBlacklistSegue"
    private let dnsWhitelistSegue = "dnsWhitelistSegue"
    
    private var advancedModeObserver: NotificationToken?
    private var themeObserver: NotificationToken?
    
    private let headerSection = 0
    
    // MARK: - View controller life cycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? UserRulesTableController else {
            return
        }
        
        if segue.identifier == dnsBlacklistSegue {
            destinationVC.rulesType = .dnsBlocklist
        } else if segue.identifier == dnsWhitelistSegue {
            destinationVC.rulesType = .dnsAllowlist
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTheme()
        setupBackButton()
        
        advancedModeObserver = NotificationCenter.default.observe(name: .advancedModeChanged, object: nil, queue: .main, using: { [weak self] _ in
            self?.tableView.reloadData()
        })
        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let enabledFiltersCount = dnsProtection.filters.filter { $0.isEnabled }.count
        let filtersDescriptionFormat = String.localizedString("safari_filters_format")
        let filtersDescriptionText = String.localizedStringWithFormat(filtersDescriptionFormat, enabledFiltersCount)
        filtersLabel.text = filtersDescriptionText
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        theme.setupTableCell(cell)
        return cell
    }
    
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
}

// MARK: - RequestsBlockingController + ThemableProtocol

extension RequestsBlockingController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupTable(tableView)
        tableView.reloadData()
    }
}
