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

class DnsSettingsController : UITableViewController, VpnServiceNotifierDelegate {
    
    //MARK: - IB Outlets
    
    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var serverName: ThemableLabel!
    @IBOutlet weak var systemProtectionStateLabel: ThemableLabel!
    @IBOutlet weak var requestBlockingStateLabel: ThemableLabel!
    @IBOutlet weak var topSeparator: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    private let antibanner: AESAntibannerProtocol = ServiceLocator.shared.getService()!
    private let vpnService: VpnServiceProtocol = ServiceLocator.shared.getService()!
    
    private var themeObserver: NotificationToken?
    
    var stateFromWidget: Bool?
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vpnService.notifier = self
        
        themeObserver = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }

        updateVpnInfo()
        setupBackButton()
        updateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let enabled = stateFromWidget {
            vpnService.turnSystemProtection(to: enabled, with: self, completion: {[weak self] in
                self?.stateFromWidget = nil
            })
        }
    }
    
    // MARK: - VpnServiceNotifierDelegate methods
    
    func tunnelModeChanged() {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.updateVpnInfo()
        }
    }
    
    func vpnConfigurationChanged(with error: Error?) {
        DispatchQueue.main.async{[weak self] in
            guard let self = self else { return }
            
            if error != nil {
                ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: error?.localizedDescription)
                self.enabledSwitch.isOn = false
            } else {
                self.enabledSwitch.isOn = self.vpnService.vpnEnabled
            }
        }
    }
    
    func cancelledAddingVpnConfiguration() {
        DispatchQueue.main.async {[weak self] in
            self?.enabledSwitch.isOn = false
        }
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        if indexPath.section != 0 {
            cell.contentView.alpha = vpnService.vpnEnabled ? 1.0 : 0.5
            cell.isUserInteractionEnabled = vpnService.vpnEnabled
        }

        theme.setupTableCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 32.0 : 0.1
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // MARK: Actions
    @IBAction func toggleEnableSwitch(_ sender: UISwitch) {
        let enabled = sender.isOn
        
        vpnService.turnSystemProtection(to: enabled, with: self, completion: {})
    }
    
    // MARK: private methods
    
    private func updateVpnInfo() {
        enabledSwitch.isOn = vpnService.vpnEnabled
        systemProtectionStateLabel.text = enabledSwitch.isOn ? ACLocalizedString("on_state", nil) : ACLocalizedString("off_state", nil)
        
        serverName.text = vpnService.currentServerName
        
        tableView.reloadData()
    }

    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupTable(tableView)
        theme.setupSwitch(enabledSwitch)
        topSeparator.backgroundColor = theme.separatorColor
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
}
