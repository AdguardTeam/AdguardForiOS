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

class RequestsBlockingController: UITableViewController {

    @IBOutlet weak var filtersLabel: ThemableLabel!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    private let antibanner: AESAntibannerProtocol = ServiceLocator.shared.getService()!
    private let dnsFiltersService: DnsFiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    private let dnsBlacklistSegue = "dnsBlacklistSegue"
    private let dnsWhitelistSegue = "dnsWhitelistSegue"
    
    private var notificationToken: NotificationToken?
    private var configurationToken: NSKeyValueObservation?
    
    private let headerSection = 0
    private let contentSection = 1
    
    private let filtersRow = 0
    
    // MARK: - View controller life cycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dnsFilterService: DnsFiltersServiceProtocol = ServiceLocator.shared.getService()!
        if segue.identifier == dnsBlacklistSegue {
            if let controller = segue.destination as? ListOfRulesController {
                let model: ListOfRulesModelProtocol = SystemBlacklistModel(resources: resources, dnsFiltersService: dnsFilterService, theme: theme, vpnManager: vpnManager)
                controller.model = model
            }
        } else if segue.identifier == dnsWhitelistSegue {
            if let controller = segue.destination as? ListOfRulesController {
                let model: ListOfRulesModelProtocol = SystemWhitelistModel(dnsFiltersService: dnsFilterService, resources: resources, theme: theme, vpnManager: vpnManager)
                controller.model = model
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        configurationToken = configuration.observe(\.developerMode) {[weak self] (_, _) in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let filtersDescriptionFormat = String.localizedString("safari_filters_format")
        let filtersDescriptionText = String.localizedStringWithFormat(filtersDescriptionFormat, dnsFiltersService.enabledFiltersCount)
        filtersLabel.text = filtersDescriptionText
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == headerSection ? 0.1 : 0.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !configuration.developerMode && (indexPath.section, indexPath.row) == (contentSection, filtersRow) {
            return 0.01
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
    
}
