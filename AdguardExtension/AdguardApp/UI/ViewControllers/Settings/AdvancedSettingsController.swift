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

class AdvancedSettingsController: UITableViewController {

    @IBOutlet weak var useSimplifiedFiltersSwitch: UISwitch!
    @IBOutlet weak var showProgressbarSwitch: UISwitch!
    @IBOutlet weak var restartProtectionSwitch: UISwitch!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let safariService: SafariService = ServiceLocator.shared.getService()!
    private let filterService: FiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let antibannerController: AntibannerControllerProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: APVPNManager = ServiceLocator.shared.getService()!
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    private let segueIdentifier = "contentBlockersScreen"
    
    private let useSimplifiedRow = 0
    private let showProgressRow = 1
    private let restartProtectionRow = 2
    
    private var proObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        setupBackButton()
        
        useSimplifiedFiltersSwitch.isOn = resources.sharedDefaults().bool(forKey: AEDefaultsJSONConverterOptimize)
        restartProtectionSwitch.isOn = vpnManager.restartByReachability
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.APVpnChanged, object: nil, queue: nil) {
            [weak self] (notification) in
            guard let sSelf = self else { return }
            DispatchQueue.main.async{
                sSelf.restartProtectionSwitch.isOn = sSelf.vpnManager.enabled
            }
            if sSelf.vpnManager.lastError != nil {
                ACSSystemUtils.showSimpleAlert(for: sSelf, withTitle: nil, message: ACLocalizedString("general_settings_restart_tunnel_error", nil))
            }
        }
    }
    
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier{
            let contentBlockersDataSource = ContentBlockersDataSource(safariService: safariService, resources: resources, filterService: filterService, antibannerController: antibannerController)
            let destinationVC = segue.destination as? ContentBlockerStateController
            destinationVC?.contentBlockersDataSource = contentBlockersDataSource
            destinationVC?.theme = theme
        }
    }
    
    // MARK: - Switch actions
    
    @IBAction func useSimplifiedFiltersAction(_ sender: UISwitch) {
        change(senderSwitch: sender, forKey: AEDefaultsJSONConverterOptimize)
    }
    
    @IBAction func showProgressbarAction(_ sender: UISwitch) {
    }
    
    @IBAction func restartProtectionAction(_ sender: UISwitch) {
        vpnManager.restartByReachability = sender.isOn
    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if indexPath.row == restartProtectionRow && !configuration.proStatus{
            cell.isHidden = !configuration.proStatus
        }
        
        theme.setupTableCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case useSimplifiedRow:
            useSimplifiedFiltersSwitch.setOn(!useSimplifiedFiltersSwitch.isOn, animated: true)
            useSimplifiedFiltersAction(useSimplifiedFiltersSwitch)
        case showProgressRow:
            showProgressbarSwitch.setOn(!showProgressbarSwitch.isOn, animated: true)
            showProgressbarAction(showProgressbarSwitch)
        case restartProtectionRow:
            restartProtectionSwitch.setOn(!restartProtectionSwitch.isOn, animated: true)
            restartProtectionAction(restartProtectionSwitch)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == restartProtectionRow && !configuration.proStatus{
            return 0.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    // MARK: - Private methods
    
    private func change(senderSwitch: UISwitch, forKey key: String) {
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
        
        let oldValue = resources.sharedDefaults().bool(forKey: key)
        let newValue = senderSwitch.isOn
        
        if oldValue != newValue {
            resources.sharedDefaults().set(newValue, forKey: key)
            
            contentBlockerService.reloadJsons(backgroundUpdate: false) { [weak self] (error) in
                if error != nil {
                    self?.resources.sharedDefaults().set(oldValue, forKey: key)
                    DispatchQueue.main.async {
                        senderSwitch.setOn(oldValue, animated: true)
                    }
                }
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        }
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        theme.setupSwitch(useSimplifiedFiltersSwitch)
        theme.setupSwitch(showProgressbarSwitch)
        theme.setupSwitch(restartProtectionSwitch)

        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
}
