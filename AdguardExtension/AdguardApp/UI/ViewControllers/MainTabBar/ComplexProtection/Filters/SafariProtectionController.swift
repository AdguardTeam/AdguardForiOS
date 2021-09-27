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
import SafariAdGuardSDK

final class SafariProtectionController: UITableViewController {

    @IBOutlet weak var safariProtectionStateLabel: UILabel!
    @IBOutlet weak var numberOfFiltersLabel: UILabel!
    @IBOutlet weak var userFilterStateLabel: UILabel!
    @IBOutlet weak var protectionStateSwitch: UISwitch!
    @IBOutlet weak var whitelistLabel: ThemableLabel!
    @IBOutlet weak var safariIcon: UIImageView!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private let complexProtection: ComplexProtectionServiceProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    
    private let descriptionSection = 0
    private let descriptionCell = 0
    
    private let contentSection = 1
    private let whiteListCell = 2
    
    private let whiteListSegue = "whiteListSegue"
    private let blackListSegue = "blackListSegue"
    
    private let enabledColor = UIColor.AdGuardColor.lightGreen1
    private let disabledColor = UIColor.AdGuardColor.lightGray3
   
    private var activeFiltersCount: Int {
        let enabledGroups = safariProtection.groups.filter { $0.isEnabled }
        let enabledFilters = enabledGroups.flatMap { $0.filters }.filter { $0.isEnabled }
        return enabledFilters.count
    }
    
    // MARK: - view controler life cycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? UserRulesTableController else {
            return
        }
        if segue.identifier == whiteListSegue {
            let inverted = resources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
            destinationVC.rulesType = inverted ? .invertedAllowlist : .allowlist
        }
        else if segue.identifier == blackListSegue {
            destinationVC.rulesType = .blocklist
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        updateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userFilterTextFormat = String.localizedString("user_rules_format")
        let userRulesNumber = safariProtection.allRules(for: .blocklist).reduce(0, { $1.isEnabled ? $0 + 1 : $0 })
        userFilterStateLabel.text = String.localizedStringWithFormat(userFilterTextFormat, userRulesNumber)
        
        let inverted = resources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
        whitelistLabel.text = inverted ? String.localizedString("inverted_whitelist_title") : String.localizedString("whitelist_title")
        
        updateFiltersCountLabel()
        updateSafariProtectionInfo()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 32.0 : 0.1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }
    
    @IBAction func protectionSwitchAction(_ sender: UISwitch) {
        let enabled = sender.isOn
        safariProtectionStateLabel.text = enabled ? String.localizedString("on_state") : String.localizedString("off_state")
        
        complexProtection.switchSafariProtection(state: enabled, for: self) { _ in }
    }
    
    // MARK: - Private methods
    
    private func updateSafariProtectionInfo(){
        let protectionEnabled = complexProtection.safariProtectionEnabled
        protectionStateSwitch.isOn = protectionEnabled
        safariProtectionStateLabel.text = protectionEnabled ? String.localizedString("on_state") : String.localizedString("off_state")
        
        safariIcon.tintColor = protectionEnabled ? enabledColor : disabledColor
    }
    
    private func updateFiltersCountLabel() {
        let safariFiltersTextFormat = String.localizedString("safari_filters_format")
        numberOfFiltersLabel.text = String.localizedStringWithFormat(safariFiltersTextFormat, activeFiltersCount)
    }
}

extension SafariProtectionController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupSwitch(protectionStateSwitch)
        theme.setupTable(tableView)
        theme.setupLabels(themableLabels)
        tableView.reloadData()
    }
}
