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

    @IBOutlet weak var showStatusbarSwitch: UISwitch!
    @IBOutlet weak var restartProtectionSwitch: UISwitch!
    @IBOutlet weak var debugLogsSwitch: UISwitch!
    @IBOutlet weak var lastSeparator: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let safariService: SafariService = ServiceLocator.shared.getService()!
    private let filterService: FiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let antibanner: AESAntibannerProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    private let segueIdentifier = "contentBlockersScreen"
    
    private let showStatusbarRow = 0
    private let restartProtectionRow = 1
    private let debugLogsRow = 2
    private let removeVpnProfile = 5
    
    private var vpnConfigurationObserver: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        setupBackButton()

        restartProtectionSwitch.isOn = resources.restartByReachability
        debugLogsSwitch.isOn = resources.isDebugLogs
        showStatusbarSwitch.isOn = configuration.showStatusBar
        
        vpnConfigurationObserver = NotificationCenter.default.observe(name: ComplexProtectionService.systemProtectionChangeNotification, object: nil, queue: .main) { [weak self] (note) in
            self?.lastSeparator.isHidden = false
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier{
            let contentBlockersDataSource = ContentBlockersDataSource(safariService: safariService, resources: resources, filterService: filterService, antibanner: antibanner, contentBlockerService: contentBlockerService)
            let destinationVC = segue.destination as? ContentBlockerStateController
            destinationVC?.contentBlockersDataSource = contentBlockersDataSource
            destinationVC?.theme = theme
        }
    }
    
    // MARK: - actions
    
    @IBAction func showProgressbarAction(_ sender: UISwitch) {
        if !sender.isOn {
           NotificationCenter.default.post(name: NSNotification.Name.HideStatusView, object: self)
        }
        configuration.showStatusBar = sender.isOn
    }
    
    @IBAction func restartProtectionAction(_ sender: UISwitch) {
        resources.restartByReachability = sender.isOn
        vpnManager.updateSettings(completion: nil)
    }
    
    @IBAction func debugLogsAction(_ sender: UISwitch) {
        let isDebugLogs = sender.isOn
        resources.isDebugLogs = isDebugLogs
        DDLogInfo("Log level changed to \(isDebugLogs ? "DEBUG" : "Normal")")
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
        vpnManager.updateSettings(completion: nil) // restart tunnel to apply new log level
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.isHidden = false
        
        if indexPath.row == restartProtectionRow && !configuration.proStatus{
            cell.isHidden = true
        }
        
        if indexPath.row == removeVpnProfile && (!vpnManager.vpnInstalled || resources.dnsImplementation == .native) {
            cell.isHidden = true
        }
        
        theme.setupTableCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case showStatusbarRow:
            showStatusbarSwitch.setOn(!showStatusbarSwitch.isOn, animated: true)
            showProgressbarAction(showStatusbarSwitch)
        case restartProtectionRow:
            restartProtectionSwitch.setOn(!restartProtectionSwitch.isOn, animated: true)
            restartProtectionAction(restartProtectionSwitch)
        case debugLogsRow:
            debugLogsSwitch.setOn(!debugLogsSwitch.isOn, animated: true)
            debugLogsAction(debugLogsSwitch)
        case removeVpnProfile:
            showRemoveVpnAlert(indexPath)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == restartProtectionRow && !configuration.proStatus{
            return 0.0
        }
        
        if indexPath.row == removeVpnProfile && (!vpnManager.vpnInstalled || resources.dnsImplementation == .native) {
            lastSeparator.isHidden = true
            return 0.0
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    // MARK: - Private methods
    
    private func showRemoveVpnAlert(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: String.localizedString("delete_vpn_profile_message"), preferredStyle: .deviceAlertStyle)
        
        let removeAction = UIAlertAction(title: String.localizedString("delete_title").uppercased(), style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            self.vpnManager.removeVpnConfiguration {(error) in
                DispatchQueue.main.async {
                    DDLogInfo("AdvancedSettingsController - removing VPN profile")
                    if error != nil {
                        ACSSystemUtils.showSimpleAlert(for: self, withTitle: String.localizedString("remove_vpn_profile_error_title"), message: String.localizedString("remove_vpn_profile_error_message"))
                        DDLogError("AdvancedSettingsController - error removing VPN profile")
                    }
                }
            }
        }
        
        alert.addAction(removeAction)
        
        let cancelAction = UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel) { _ in
        }
        
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }

}

extension AdvancedSettingsController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        theme.setupSeparators(separators)
        theme.setupSwitch(showStatusbarSwitch)
        theme.setupSwitch(restartProtectionSwitch)
        theme.setupSwitch(debugLogsSwitch)

        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
}
