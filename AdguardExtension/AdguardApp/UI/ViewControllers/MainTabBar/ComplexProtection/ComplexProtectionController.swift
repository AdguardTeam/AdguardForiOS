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

class ComplexProtectionController: UITableViewController, VpnServiceNotifierDelegate {

    // MARK: - Safari protection outlets
    
    @IBOutlet weak var safariIcon: UIImageView!
    @IBOutlet weak var freeTextView: UITextView! {
        didSet{
            freeTextView.text = freeTextView.text.uppercased()
            freeTextView.textContainerInset = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
            
            freeTextView.layer.borderColor = UIColor(hexString: "#5a9c69").cgColor
            freeTextView.layer.borderWidth = 1.0
            
            freeTextView.clipsToBounds = true
            freeTextView.layer.cornerRadius = 4.0
        }
    }
    @IBOutlet weak var safariProtectionLabel: ThemableLabel!
    @IBOutlet weak var safariDescriptionLabel: ThemableLabel!
    @IBOutlet weak var safariProtectionSwitch: UISwitch!
    
    @IBOutlet weak var freeTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var freeTextViewSpacing: NSLayoutConstraint!
    
    
    // MARK: - System protection outlets
    
    @IBOutlet weak var systemIcon: UIImageView!
    @IBOutlet weak var premiumTextView: UITextView! {
        didSet{
            premiumTextView.text = premiumTextView.text.uppercased()
            premiumTextView.textContainerInset = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
            
            premiumTextView.clipsToBounds = true
            premiumTextView.layer.cornerRadius = 4.0
        }
    }
    @IBOutlet weak var systemProtectionLabel: ThemableLabel!
    @IBOutlet weak var systemDescriptionLabel: ThemableLabel!
    @IBOutlet weak var systemProtectionSwitch: UISwitch!
    
    @IBOutlet weak var premiumTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var premiumTextViewSpacing: NSLayoutConstraint!
    
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    
    // MARK: - Variables
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let vpnService: VpnServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let complexProtection: ComplexProtectionServiceProtocol = ServiceLocator.shared.getService()!
    
    private var themeNotification: NotificationToken?
    private var proObservation: NSKeyValueObservation?
    
    private var proStatus: Bool {
        return configuration.proStatus
    }
    
    private let enabledColor = UIColor(hexString: "#67B279")
    private let disabledColor = UIColor(hexString: "#D8D8D8")
    
    private let safariProtectionCell = 0
    private let systemProtectionCell = 1
    
    private let showGetProSwgueId = "showGetProSwgueId"
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        updateTheme()

        themeNotification = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        proObservation = configuration.observe(\.proStatus) {[weak self] (_, _) in
            guard let self = self else { return }
            self.observeProStatus()
        }
        
        resources.sharedDefaults().addObserver(self, forKeyPath: SafariProtectionState, options: .new, context: nil)
        
        freeTextView.text = freeTextView.text.uppercased()
        premiumTextView.text = premiumTextView.text.uppercased()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateVpnInfo()
        updateSafariProtectionInfo()
        observeProStatus()
        vpnService.notifier = self
        updateVpnInfo()
    }
    
    deinit {
        resources.sharedDefaults().removeObserver(self, forKeyPath: SafariProtectionState)
    }

    
    // MARK: - Actions

    @IBAction func safariProtectionChanged(_ sender: UISwitch) {
        let enabled = sender.isOn
        complexProtection.switchSafariProtection(state: enabled)
    }
    
    @IBAction func systemProtectionChanged(_ sender: UISwitch) {
        let enabled = sender.isOn
        vpnService.turnSystemProtection(to: enabled, with: self, completion: {})
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
                self.systemProtectionSwitch.isOn = false
            } else {
                self.systemProtectionSwitch.isOn = self.vpnService.vpnEnabled
            }
        }
    }
    
    func cancelledAddingVpnConfiguration() {
        DispatchQueue.main.async {[weak self] in
            self?.systemProtectionSwitch.isOn = false
        }
    }
    
    
    // MARK: - Table view delegates and dataSource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == safariProtectionCell {
            safariProtectionSwitch.setOn(!safariProtectionSwitch.isOn, animated: true)
            safariProtectionChanged(safariProtectionSwitch)
        } else if indexPath.row == systemProtectionCell {
            if proStatus{
                systemProtectionSwitch.setOn(!systemProtectionSwitch.isOn, animated: true)
                systemProtectionChanged(systemProtectionSwitch)
            } else {
                performSegue(withIdentifier: showGetProSwgueId, sender: self)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Observer
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == SafariProtectionState {
            updateSafariProtectionInfo()
        }
    }
    
    // MARK: - Private methods
    
    /**
     Updates theme
     */
    private func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        premiumTextView.backgroundColor = theme.invertedBackgroundColor
        premiumTextView.textColor = theme.backgroundColor

        theme.setupSwitch(safariProtectionSwitch)
        theme.setupSwitch(systemProtectionSwitch)
        theme.setupTable(tableView)
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupLabels(themableLabels)
        
        tableView.reloadData()
    }
    
    /**
     Called when pro status is changed
     */
    private func observeProStatus(){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            
            self.freeTextViewHeight.constant = self.proStatus ? 0.0 : 18.0
            self.premiumTextViewHeight.constant = self.proStatus ? 0.0 : 18.0
            
            self.freeTextViewSpacing.constant = self.proStatus ? 0.0 : 12.0
            self.premiumTextViewSpacing.constant = self.proStatus ? 0.0 : 12.0
            
            self.systemProtectionLabel.alpha = self.proStatus ? 1.0 : 0.5
            self.systemDescriptionLabel.alpha = self.proStatus ? 1.0 : 0.5
            
            self.tableView.reloadData()
        }
    }
    
    /**
     Called when vpn configuration changes
     */
    private func updateVpnInfo(){
        let enabled = vpnService.vpnEnabled
        systemProtectionSwitch.isOn = enabled
        systemProtectionSwitch.isEnabled = proStatus
        systemIcon.tintColor = enabled ? enabledColor : disabledColor
        tableView.reloadData()
    }
    
    private func updateSafariProtectionInfo(){
        let protectionEnabled = resources.safariProtectionEnabled
        safariProtectionSwitch.isOn = protectionEnabled
        safariIcon.tintColor = protectionEnabled ? enabledColor : disabledColor
    }
}
