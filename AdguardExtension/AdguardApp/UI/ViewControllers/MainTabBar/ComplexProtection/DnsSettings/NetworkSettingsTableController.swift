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

class NetworkSettingsTableController: UITableViewController, AddRuleControllerDelegate, RuleDetailsControllerDelegate, NetworkSettingsChangedDelegate {
    
    /* Variables */
    private var themeObserver: Any? = nil
    
    /* Cell reuse ids */
    private let networkSettingsTitleCellId = "NetworkSettingsTitleCell"
    private let filterDataCellReuseId = "FilterDataCell"
    private let networkSettingsDescriptionCellReuseId = "NetworkSettingsDescriptionCell"
    private let addExceptionCellReuseId = "AddExceptionCell"
    private let wifiExceptionsCellReuseId = "WifiExceptionsCell"
    
    /* Sections */
    private let titleSection = 0
    private let filterDataSection = 1
    private let descriptionSection = 2
    private let addExceptionSection = 3
    private let exceptionsSection = 4
    
    /* Rows */
    private let mobileDataRow = 0
    private let wifiDataRow = 1
    
    /* Services and models */
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let networkSettingsService: NetworkSettingsServiceProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let nativeProviders: NativeProvidersServiceProtocol = ServiceLocator.shared.getService()!
    
    private var model: NetworkSettingsModelProtocol? = nil

    // MARK: - ViewController Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        model = NetworkSettingsModel(networkSettingsService: networkSettingsService, vpnManager: vpnManager, resources: resources, nativeProviders: nativeProviders)
        model?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        updateTheme()
        setupBackButton()
    }
    
    // MARK: - Actions
    
    @IBAction func filterDataStateAction(_ sender: UISwitch) {
        let tag = sender.tag
        let enabled = sender.isOn
        
        if tag == mobileDataRow {
            model?.filterMobileDataEnabled = enabled
        } else {
            model?.filterWifiDataEnabled = enabled
        }
    }
    
    @IBAction func exeptionStateAction(_ sender: UIButton) {
        if let exeption = model?.exceptions[sender.tag] {
            model?.change(rule: exeption.rule, newEnabled: !exeption.enabled)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case titleSection:
            return 1
        case filterDataSection:
            return 2
        case descriptionSection:
            return 1
        case addExceptionSection:
            return 1
        case exceptionsSection:
            return model?.exceptions.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case titleSection:
            return setupTitleCell(row: indexPath.row)
        case filterDataSection:
            return setupFilterDataCell(row: indexPath.row)
        case descriptionSection:
            return setupNetworkSettingsDescriptionCell()
        case addExceptionSection:
            return setupAddExceptionCell()
        case exceptionsSection:
            return setupWifiExceptionsCell(row: indexPath.row)
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case filterDataSection:
            setupFilterDataAction(indexPath: indexPath)
        case addExceptionSection:
            addExceptionAction()
        case exceptionsSection:
            exceptionSelected(row: indexPath.row)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - AddRuleControllerDelegate method
    
    func addRule(rule: String) {
        model?.addException(rule: rule)
    }
    
    // MARK: - RuleDetailsControllerDelegate
    
    func removeRule(rule: RuleInfo) {
        model?.delete(rule: rule.rule)
    }
    
    func changeRule(rule: RuleInfo, newText: String) {
        model?.change(rule: rule.rule, newRule: newText)
    }
    
    // MARK: - NetworkSettingsChangedDelegate method
    
    func settingsChanged() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Private methods -
    
    // MARK: - Cells setups
    
    private func setupTitleCell(row: Int) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: networkSettingsTitleCellId) as? NetworkSettingsTitleCell {
            theme.setupTableCell(cell)
            theme.setupLabel(cell.titleLabel)
            return cell
        }
        return UITableViewCell()
    }
    
    private func setupFilterDataCell(row: Int) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: filterDataCellReuseId) as? FilterDataCell{
            cell.theme = theme
            cell.filterDataTag = row
            cell.filterDataSwitch.tag = row
            
            cell.filterDataSwitch.addTarget(self, action: #selector(filterDataStateAction(_:)), for: .valueChanged)
            
            let filteringMobileDataEnabled: Bool = model?.filterMobileDataEnabled ?? false
            let filteringWifiDataEnabled: Bool = model?.filterWifiDataEnabled ?? false
            cell.enabled = (row == mobileDataRow) ? filteringMobileDataEnabled : filteringWifiDataEnabled
            
            return cell
        }
        return UITableViewCell()
    }
    
    private func setupNetworkSettingsDescriptionCell() -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: networkSettingsDescriptionCellReuseId) as? NetworkSettingsDescriptionCell {
            cell.theme = theme
            cell.wifiExceptionsTitle = ACLocalizedString("wifi_exceptions_title", nil)
            cell.wifiExceptionsDescription = ACLocalizedString("wifi_exceptions_description", nil)
            return cell
        }
        return UITableViewCell()
    }
    
    private func setupAddExceptionCell() -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: addExceptionCellReuseId) as? AddExceptionCell {
            cell.theme = theme
            cell.exceptionLabelTitle = ACLocalizedString("add_exception_title", nil)
            return cell
        }
        return UITableViewCell()
    }
    
    private func setupWifiExceptionsCell(row: Int) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: wifiExceptionsCellReuseId) as? WifiExceptionsCell {
            cell.theme = theme
            
            let exception = model?.exceptions[row]
            cell.exceptionName = exception?.rule
            cell.enabled = exception?.enabled
            
            let count = model?.exceptions.count
            cell.sepator.isHidden = count == row + 1
            
            cell.exceptionStateButton.tag = row
            
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Cells Actions
    
    private func setupFilterDataAction(indexPath: IndexPath){
        if let cell = tableView.cellForRow(at: indexPath) as? FilterDataCell{
            let enabled = cell.filterDataSwitch.isOn
            cell.filterDataSwitch.setOn(!enabled, animated: true)
            filterDataStateAction(cell.filterDataSwitch)
        }
    }
    
    private func addExceptionAction() {
        let storyboard = UIStoryboard(name: "UserFilter", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "AddRuleController") as? AddRuleController else { return }
        controller.delegate = self
        controller.type = .wifiExceptions
            
        present(controller, animated: true, completion: nil)
    }
    
    private func exceptionSelected(row: Int){
        let storyboard = UIStoryboard(name: "UserFilter", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "RuleDetailsController") as? RuleDetailsController else { return }
        guard let exception = model?.exceptions[row] else { return }
        
        let rule = RuleInfo(exception.rule, false, true, theme)
        controller.rule = rule
        controller.delegate = self
        controller.rule = rule
        controller.type = .wifiExceptions
            
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Update theme
    
    private func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
