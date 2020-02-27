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
    
    @IBOutlet weak var tryButton: GradientButton!
    @IBOutlet weak var systemIcon: UIImageView!
    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var serverName: ThemableLabel!
    @IBOutlet weak var systemProtectionStateLabel: ThemableLabel!
    @IBOutlet weak var requestBlockingStateLabel: ThemableLabel!
    @IBOutlet weak var systemDescriptionCell: UITableViewCell!
    @IBOutlet weak var getProCell: UITableViewCell!
    @IBOutlet weak var getPtoTitleLabel: ThemableLabel!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    private let antibanner: AESAntibannerProtocol = ServiceLocator.shared.getService()!
    private let vpnService: VpnServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
    private let complexProtection: ComplexProtectionServiceProtocol = ServiceLocator.shared.getService()!
    
    private var themeObserver: NotificationToken?
    private var proObservation: NSKeyValueObservation?
    
    private var proStatus: Bool {
        return configuration.proStatus
    }
    
    var stateFromWidget: Bool?
    var isFromComplexSwitch: Bool?
    
    private let enabledColor = UIColor(hexString: "#67b279")
    private let disabledColor = UIColor(hexString: "#888888")
    
    // MARK: - Sections constants
    
    private let titleSection = 0
    private let menuSection = 1
    private let getProSection = 2
    
    private let titleDescriptionCell = 0
    private let titleStateCell = 1
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeObserver = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        proObservation = configuration.observe(\.proStatus) {[weak self] (_, _) in
            guard let self = self else { return }
            self.observeProStatus()
        }
        
        let product = purchaseService.standardProduct
        getPtoTitleLabel.text = getTitleString(product: product).uppercased()

        updateVpnInfo()
        setupBackButton()
        updateTheme()
        
        tryButton.setTitle(String.localizedString("try_for_free"), for: .normal)
        tryButton.accessibilityLabel = String.localizedString("try_for_free")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vpnService.notifier = self
        
        if let enabled = stateFromWidget, let isComplex = isFromComplexSwitch {
            // We set a small delay to show user a state change
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
                self?.complexProtection.switchSystemProtectionFromWidget(state: enabled, for: self, isFromComplexSwitch: isComplex)
                self?.stateFromWidget = nil
                self?.isFromComplexSwitch = nil
            }
        } else {
            DispatchQueue.main.async {[weak self] in
                self?.updateVpnInfo()
            }
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
                self.updateVpnInfo()
            }
        }
    }
    
    func cancelledAddingVpnConfiguration() {
        DispatchQueue.main.async {[weak self] in
            self?.updateVpnInfo()
        }
    }
    
    func proStatusEnableFailure() {}
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        if indexPath.section == titleSection {
            if indexPath.row == titleStateCell {
                cell.isHidden = !proStatus
            }
        }
        
        if indexPath.section == getProSection {
            cell.isHidden = proStatus
        }
        
        if indexPath.section == menuSection {
            cell.isHidden = !proStatus
            cell.contentView.alpha = vpnService.vpnEnabled ? 1.0 : 0.5
            cell.isUserInteractionEnabled = vpnService.vpnEnabled
        }

        theme.setupTableCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalHeight = super.tableView.rowHeight

        if indexPath.section == getProSection {
            return proStatus ? 0.0 : normalHeight
        }
        
        if indexPath.section == menuSection {
            return proStatus ? normalHeight : 0.0
        }
        
        if indexPath.section == titleSection  {
            if indexPath.row == titleStateCell {
                return proStatus ? normalHeight : 0.0
            }
        }
        
        return normalHeight
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
    
        complexProtection.switchSystemProtection(state: enabled, for: self)
    }
    
    // MARK: private methods
    
    private func updateVpnInfo() {
        let enabled = vpnService.vpnEnabled
        enabledSwitch.isOn = enabled
        systemProtectionStateLabel.text = enabled ? ACLocalizedString("on_state", nil) : ACLocalizedString("off_state", nil)
        systemIcon.tintColor = enabled ? enabledColor : disabledColor
        
        serverName.text = vpnService.currentServerName
        
        tableView.reloadData()
    }
    
    private func observeProStatus(){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }

    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupTable(tableView)
        theme.setupSwitch(enabledSwitch)
        theme.setupSeparators(separators)
        theme.setupNavigationBar(navigationController?.navigationBar)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
    
    private func getTitleString(product: Product?) -> String {
        
        let period = product?.trialPeriod?.unit ?? .week
        let numberOfUnits = product?.trialPeriod?.numberOfUnits ?? 1
        
        var formatString : String = ""
        
        switch period {
        case .day:
            formatString = ACLocalizedString("getPro_full_access_days", nil)
        case .week:
            if numberOfUnits == 1 {
                formatString = ACLocalizedString("getPro_full_access_days", nil)
                return String.localizedStringWithFormat(formatString, 7)
            }
            formatString = ACLocalizedString("getPro_full_access_weeks", nil)
        case .month:
            formatString = ACLocalizedString("getPro_full_access_months", nil)
        case .year:
            formatString = ACLocalizedString("getPro_full_access_years", nil)
        }
        
        let resultString : String = String.localizedStringWithFormat(formatString, numberOfUnits)
        
        return resultString
    }
}
