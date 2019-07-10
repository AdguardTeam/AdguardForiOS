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

class AdvancedSettingsController: UITableViewController {
    
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    private let vpnManager: APVPNManager = ServiceLocator.shared.getService()!
    
    @IBOutlet weak var wifiUpdateSwitch: UISwitch!
    @IBOutlet weak var simplifiedSwitch: UISwitch!
    @IBOutlet weak var invertedSwitch: UISwitch!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var restartTunnelSwitch: UISwitch!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var tableFooterView: UIView!
    
    @IBOutlet weak var getProButton: RoundRectButton!
    
    @IBOutlet weak var darkModeTrailingConstraint: NSLayoutConstraint!
    
    
    var proObservation: NSKeyValueObservation?
    
    private let wifiOnlyRow = 0
    private let simplifiedRow = 1
    private let invertWhitelistRow = 2
    private let darkModeRow = 3
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        
        invertedSwitch.isOn = resources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
        simplifiedSwitch.isOn = resources.sharedDefaults().bool(forKey: AEDefaultsJSONConverterOptimize)
        let wifiOnlyObject = resources.sharedDefaults().object(forKey: AEDefaultsWifiOnlyUpdates) as? NSNumber
        let wifiOnly = wifiOnlyObject?.boolValue ?? true
        wifiUpdateSwitch.isOn = wifiOnly
        restartTunnelSwitch.isOn = vpnManager.restartByReachability
        
        proObservation = configuration.observe(\.proStatus) {[weak self] (_, _) in
            DispatchQueue.main.async {
                self?.updateUI()
                self?.tableView.reloadData()
            }
        }
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case wifiOnlyRow:
            wifiUpdateSwitch.setOn(!wifiUpdateSwitch!.isOn, animated: true)
            toggleWifiOnly(wifiUpdateSwitch)
        case simplifiedRow:
            simplifiedSwitch.setOn(!simplifiedSwitch!.isOn, animated: true)
            toggleSimplified(simplifiedSwitch)
        case invertWhitelistRow:
            invertedSwitch.setOn(!invertedSwitch!.isOn, animated: true)
            toggleInverted(invertedSwitch)
        case darkModeRow:
            if configuration.proStatus {
                darkModeSwitch.setOn(!darkModeSwitch!.isOn, animated: true)
                toggleDarkMode(darkModeSwitch)
            }
            else {
                performSegue(withIdentifier: "getProSegue", sender: self)
            }
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    // MARK: - Actions
    
    @IBAction func toggleWifiOnly(_ sender: UISwitch) {
        resources.sharedDefaults().set(sender.isOn, forKey: AEDefaultsWifiOnlyUpdates)
    }
    
    @IBAction func toggleSimplified(_ sender: UISwitch) {
        change(senderSwitch: sender, forKey: AEDefaultsJSONConverterOptimize)
    }
    
    @IBAction func toggleInverted(_ sender: UISwitch) {
        change(senderSwitch: sender, forKey: AEDefaultsInvertedWhitelist)
    }
    
    @IBAction func toggleDarkMode(_ sender: UISwitch) {
        configuration.darkTheme = sender.isOn
        updateTheme()
        tableView.reloadData()
    }
    
    @IBAction func toggleRestartTunnel(_ sender: UISwitch) {
        vpnManager.restartByReachability = sender.isOn
    }
    
    // MARK: - table view cells
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = super.tableView(tableView, numberOfRowsInSection: section)
        
        // hide last cell("restart when network changes") in free version
        return configuration.proStatus ? count : (count - 1)
    }
    
    // MARK: - private methods
    
    func change(senderSwitch: UISwitch, forKey key: String) {
        
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
        tableFooterView.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        theme.setupSwitch(invertedSwitch)
        theme.setupSwitch(simplifiedSwitch)
        theme.setupSwitch(darkModeSwitch)
        theme.setupSwitch(wifiUpdateSwitch)
    }
    
    private func updateUI() {
        
        if configuration.proStatus {
            getProButton.isHidden = true
            darkModeSwitch.isHidden = false
            darkModeTrailingConstraint.constant = darkModeSwitch.frame.width + 10
        }
        else {
            getProButton.isHidden = false
            darkModeSwitch.isHidden = true
            darkModeTrailingConstraint.constant = getProButton.frame.width + 10
        }
        
        darkModeSwitch.isOn = configuration.darkTheme
    }
}
