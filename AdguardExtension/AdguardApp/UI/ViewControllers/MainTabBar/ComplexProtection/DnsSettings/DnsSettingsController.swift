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

class DnsSettingsController : UITableViewController {
    
    //MARK: - IB Outlets
    
    @IBOutlet weak var tryButton: UIButton!
    @IBOutlet weak var systemIcon: UIImageView!
    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var implementationLabel: ThemableLabel!
    @IBOutlet weak var implementationIcon: UIImageView!
    @IBOutlet weak var serverName: ThemableLabel!
    @IBOutlet weak var systemProtectionStateLabel: ThemableLabel!
    @IBOutlet weak var requestBlockingStateLabel: ThemableLabel!
    @IBOutlet weak var systemDescriptionCell: UITableViewCell!
    @IBOutlet weak var getProCell: UITableViewCell!
    @IBOutlet weak var getPtoTitleLabel: ThemableLabel!
    @IBOutlet weak var dnsServerSeparator: UIView!
    @IBOutlet weak var networkSettingsSeparator: UIView!
    @IBOutlet weak var dnsFilteringSeparator: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    private let antibanner: AESAntibannerProtocol = ServiceLocator.shared.getService()!
    private var dnsProviders: DnsProvidersServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
    private let complexProtection: ComplexProtectionServiceProtocol = ServiceLocator.shared.getService()!
    private let nativeProviders: NativeProvidersServiceProtocol = ServiceLocator.shared.getService()!
    
    private var themeObserver: NotificationToken?
    private var vpnChangeObservation: NotificationToken?
    private var didBecomeActiveNotification: NotificationToken?
    private var proObservation: NSKeyValueObservation?
    
    private var proStatus: Bool {
        return configuration.proStatus
    }
    
    var stateFromWidget: Bool?
    
    private let enabledColor = UIColor.AdGuardColor.green
    private let disabledColor = UIColor(hexString: "#888888")
    
    private let adguardImplementationIcon = UIImage(named: "ic_adguard")
    private let nativeImplementationIcon = UIImage(named: "native")
    
    // MARK: - Sections constants
    
    private let titleSection = 0
    private let menuSection = 1
    private let getProSection = 2
    
    private let titleDescriptionCell = 0
    private let titleStateCell = 1
    
    private let implementationRow = 0
    private let dnsServerRow = 1
    private let networkSettingsRow = 2
    private let dnsFilteringRow = 3
    private let howToSetupRow = 4
    
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
        
        vpnChangeObservation = NotificationCenter.default.observe(name: ComplexProtectionService.systemProtectionChangeNotification, object: nil, queue: OperationQueue.main) { [weak self] (note) in
            self?.updateVpnInfo()
        }
        
        didBecomeActiveNotification = NotificationCenter.default.observe(name: UIApplication.didBecomeActiveNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateVpnInfo()
        })
        
        let product = purchaseService.standardProduct
        getPtoTitleLabel.text = getTitleString(product: product).uppercased()

        updateVpnInfo()
        setupBackButton()
        updateTheme()
        processCurrentImplementation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let enabled = stateFromWidget {
            // We set a small delay to show user a state change
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
                self?.complexProtection.switchSystemProtection(state: enabled, for: self) { _ in }
                self?.stateFromWidget = nil
                self?.updateVpnInfo()
            }
        } else {
            DispatchQueue.main.async {[weak self] in
                self?.updateVpnInfo()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tryButton.layer.cornerRadius = tryButton.frame.height / 2
    }
    
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
            
            if indexPath.row == dnsFilteringRow && proStatus {
                cell.isHidden = !configuration.advancedMode || resources.dnsImplementation == .native
                networkSettingsSeparator.isHidden = (!configuration.advancedMode || resources.dnsImplementation == .native) && resources.dnsImplementation == .adGuard
            }
            
            if indexPath.row == howToSetupRow && (resources.dnsImplementation != .native || !ios14available) {
                cell.isHidden = true
                dnsFilteringSeparator.isHidden = resources.dnsImplementation != .native
            }
            
            if !ios14available && indexPath.row == implementationRow {
                cell.isHidden = true
            }
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
            
            if indexPath.row == dnsFilteringRow && (!configuration.advancedMode || resources.dnsImplementation == .native) {
                return 0.0
            }
            
            if indexPath.row == howToSetupRow && (resources.dnsImplementation != .native || !ios14available) {
                return 0.0
            }
            
            if !ios14available && indexPath.row == implementationRow {
                return 0.0
            }
            
            return proStatus ? normalHeight : 0.0
        }
        
        if indexPath.section == titleSection  {
            if indexPath.row == titleStateCell {
                return proStatus ? normalHeight : 0.0
            }
        }
        
        return normalHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == menuSection && indexPath.row == implementationRow {
            presentChooseDnsImplementationController()
        }
        
        if indexPath.section == menuSection && indexPath.row == howToSetupRow && resources.dnsImplementation == .native {
            AppDelegate.shared.presentHowToSetupController()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 32.0 : 0.1
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // MARK: Actions
    @IBAction func toggleEnableSwitch(_ sender: UISwitch) {
        if resources.dnsImplementation == .native {
            if #available(iOS 14.0, *), complexProtection.systemProtectionEnabled {
                nativeProviders.removeDnsManager { error in
                    DDLogError("Error removing dns manager: \(error.debugDescription)")
                    DispatchQueue.main.async { [weak self] in
                        sender.isOn = self?.complexProtection.systemProtectionEnabled ?? false
                    }
                }
            } else if #available(iOS 14.0, *) {
                sender.isOn = complexProtection.systemProtectionEnabled
                nativeProviders.saveDnsManager { error in
                    if let error = error {
                        DDLogError("Received error when turning system protection on; Error: \(error.localizedDescription)")
                    }
                    DispatchQueue.main.async {
                        AppDelegate.shared.presentHowToSetupController()
                    }
                }
            }
            return
        }
        
        let enabled = sender.isOn
    
        complexProtection.switchSystemProtection(state: enabled, for: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateVpnInfo()
            }
        }
        updateVpnInfo()
    }
    
    // MARK: private methods
    
    private func updateVpnInfo() {
        let enabled = complexProtection.systemProtectionEnabled
        enabledSwitch.isOn = enabled
        systemProtectionStateLabel.text = enabled ? ACLocalizedString("on_state", nil) : ACLocalizedString("off_state", nil)
        systemIcon.tintColor = enabled ? enabledColor : disabledColor
    
        updateServerName()
        tableView.reloadData()
    }
    
    private func updateServerName() {
        if resources.dnsImplementation == .adGuard {
            serverName.text = dnsProviders.currentServerName
        } else {
            serverName.text = nativeProviders.serverName
        }
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
        tableView.reloadData()
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
    
    private func presentChooseDnsImplementationController() {
        if let implementationVC = storyboard?.instantiateViewController(withIdentifier: "ChooseDnsImplementationController") as? ChooseDnsImplementationController {
            implementationVC.delegate = self
            present(implementationVC, animated: true, completion: nil)
        }
    }
}

extension DnsSettingsController: ChooseDnsImplementationControllerDelegate {
    func currentImplementationChanged() {
        DispatchQueue.main.async { [weak self] in
            self?.processCurrentImplementation()
            self?.tableView.reloadData()
        }
    }
    
    private func processCurrentImplementation() {
        let stringKey = resources.dnsImplementation == .adGuard ? "adguard_dns_implementation_title" : "native_dns_implementation_title"
        implementationLabel.text = String.localizedString(stringKey)
        implementationIcon.image = resources.dnsImplementation == .adGuard ? adguardImplementationIcon : nativeImplementationIcon
        updateServerName()
    }
}
