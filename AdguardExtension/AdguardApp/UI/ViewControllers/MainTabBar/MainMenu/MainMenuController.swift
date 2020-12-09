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

import Foundation

class MainMenuController: UITableViewController {
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let support: AESSupportProtocol = ServiceLocator.shared.getService()!
    private var dnsProviders: DnsProvidersServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let filtersService: FiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let nativeProviders: NativeProvidersServiceProtocol = ServiceLocator.shared.getService()!
    
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var safariProtectionLabel: ThemableLabel!
    @IBOutlet weak var systemProtectionLabel: ThemableLabel!
    @IBOutlet weak var supportCell: UITableViewCell!
    @IBOutlet weak var LicenseCell: UITableViewCell!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private var themeObserver: NotificationToken?
    private var filtersCountObservation: Any?
    private var activeFiltersCountObservation: Any?
    
    private var proStatus: Bool {
        return configuration.proStatus
    }
    
    // MARK: - view controler life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
        updateServerName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsImageView.image = UIImage(named: "advanced-settings-icon")
        
        themeObserver = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        let updateFilters: ()->() = { [weak self] in
            guard let self = self else { return }
            let safariFiltersTextFormat = String.localizedString("safari_filters_format")
            self.safariProtectionLabel.text = String.localizedStringWithFormat(safariFiltersTextFormat, self.filtersService.activeFiltersCount)
        }

        activeFiltersCountObservation = (filtersService as! FiltersService).observe(\.activeFiltersCount) { (_, _) in
            updateFilters()
        }
        
        updateFilters()
        
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
    
    // MARK: - private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
    
    private func updateServerName() {
        if proStatus {
            if resources.dnsImplementation == .adGuard {
                systemProtectionLabel.text = dnsProviders.currentServerName
            } else {
                systemProtectionLabel.text = nativeProviders.serverName
            }
        } else {
            systemProtectionLabel.text = String.localizedString("system_dns_server")
        }
    }
}
