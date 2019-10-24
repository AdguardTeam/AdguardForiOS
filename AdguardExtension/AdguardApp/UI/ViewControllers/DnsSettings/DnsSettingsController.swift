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

class DnsSettingsController : UITableViewController{
    
    //MARK: - IB Outlets
    
    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var serverName: ThemableLabel!
    @IBOutlet weak var systemProtectionStateLabel: ThemableLabel!
    @IBOutlet weak var requestBlockingStateLabel: ThemableLabel!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - services
    
    private let vpnManager: APVPNManager = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    private let antibanner: AESAntibannerProtocol = ServiceLocator.shared.getService()!
    
    private var observation: NSKeyValueObservation?
    private let wifiExceptionSegue = "wifiExceptionSegue"
    
    private var themeObserver: NotificationToken?
    private var vpnObserver: NotificationToken?
    
    // MARK: - view controller life cycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == wifiExceptionSegue {
            if let controller = segue.destination as? ListOfRulesController {
                let dnsFiltersService: DnsFiltersServiceProtocol = ServiceLocator.shared.getService()!
                let model = ListOfRulesModel(listOfRulesType: .wifiExceptions, resources: resources, contentBlockerService: contentBlockerService, antibanner: antibanner, theme: theme, dnsFiltersService: dnsFiltersService)
                controller.model = model
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeObserver = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        observation = vpnManager.observe(\.tunnelMode) { [weak self] (mode, change) in
            DispatchQueue.main.async {
                self?.updateVpnState()
            }
        }
        
        vpnObserver = NotificationCenter.default.observe(name: NSNotification.Name.APVpnChanged, object: nil, queue: nil) {
            [weak self] (notification) in
            guard let sSelf = self else { return }
            DispatchQueue.main.async{
                sSelf.enabledSwitch.isOn = sSelf.vpnManager.enabled
            }
            if sSelf.vpnManager.lastError != nil {
                ACSSystemUtils.showSimpleAlert(for: sSelf, withTitle: nil, message: sSelf.vpnManager.lastError?.localizedDescription)
            }
        }
        
        self.updateVpnState()
        setupBackButton()
        updateTheme()
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        if indexPath.row != 0{
            cell.contentView.alpha = vpnManager.enabled ? 1.0 : 0.5
            cell.isUserInteractionEnabled = vpnManager.enabled
        }
        
        theme.setupTableCell(cell)
        return cell
    }
    
    // MARK: Actions
    @IBAction func toggleEnableSwitch(_ sender: UISwitch) {
        
        let enabled = sender.isOn
        
        if enabled && !vpnManager.vpnInstalled {
            showConfirmVpnAlert{ [weak self] in
                guard let sSelf = self else { return }
                sSelf.vpnManager.enabled = enabled
            }
        }else {
            self.vpnManager.enabled = enabled
        }
    }
    
    // MARK: private methods
    
    private func updateVpnState() {
        enabledSwitch.isOn = vpnManager.enabled
        systemProtectionStateLabel.text = enabledSwitch.isOn ? ACLocalizedString("on_state", nil) : ACLocalizedString("off_state", nil)
        
        if vpnManager.isCustomServerActive() {
            serverName.text = vpnManager.activeDnsServer!.name
        }
        else if vpnManager.activeDnsServer?.dnsProtocol == nil {
            serverName.text = ACLocalizedString("no_dns_server_selected", nil)
        }
        else {
            let server = vpnManager.activeDnsProvider?.name ?? vpnManager.activeDnsServer?.name ?? ""
            let protocolName = ACLocalizedString(DnsProtocol.stringIdByProtocol[vpnManager.activeDnsServer!.dnsProtocol], nil)
            serverName.text = "\(server) (\(protocolName))"
        }
        
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupTable(tableView)
        theme.setupSwitch(enabledSwitch)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
    
    private func showConfirmVpnAlert(yesAction: @escaping ()->()){
        let title: String = ACLocalizedString("vpn_confirm_title", nil)
        let message: String = ACLocalizedString("vpn_confirm_message", nil)
        let okTitle: String = ACLocalizedString("common_action_ok", nil)
        let cancelTitle: String = ACLocalizedString("common_action_cancel", nil)
        let privacyTitle: String = ACLocalizedString("privacy_policy_action", nil)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default) {(alert) in
            yesAction()
        }
        let privacyAction = UIAlertAction(title: privacyTitle, style: .default) { [weak self] (alert) in
            guard let sSelf = self else { return }
            UIApplication.shared.openAdguardUrl(action: "privacy", from: "DnsSettingsController")
            sSelf.enabledSwitch.isOn = false
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) {[weak self] (alert) in
            guard let sSelf = self else { return }
            sSelf.enabledSwitch.isOn = false
        }
        
        alert.addAction(okAction)
        alert.addAction(privacyAction)
        alert.addAction(cancelAction)
        
        alert.preferredAction = okAction
        
        present(alert, animated: true, completion: nil)
    }
}
