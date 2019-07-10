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
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    let vpnManager: APVPNManager = ServiceLocator.shared.getService()!
    let filtersService: FiltersServiceProtocol = ServiceLocator.shared.getService()!
    let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    let support: AESSupportProtocol = ServiceLocator.shared.getService()!
    
    static let BUGREPORT_URL = "http://agrd.io/report_ios_bug"
    
    @IBOutlet weak var bugreportCell: UITableViewCell!
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var whitelistCaption: ThemableLabel!
    @IBOutlet weak var filtersDescription: ThemableLabel!
    @IBOutlet weak var dnsServer: ThemableLabel!
    @IBOutlet weak var getProButton: RoundRectButton!
    @IBOutlet weak var dnsCell: UITableViewCell!

    @IBOutlet weak var dnsTrailingConstrint: NSLayoutConstraint!
    
    private var filtersCoutObservation: Any?
    private var activeFiltersCoutObservation: Any?
    private var dnsServerObservetion: Any?
    
    private var configurationObservation: NSKeyValueObservation?
    
    private let dnsCellRow = 1
    private let getProSegue = "getProSegue"
    private let showDnsSettingsSegue = "showDnsSettingsSegue"
    
    // MARK: - view controler life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showBlacklistSegue":
            let controller = segue.destination as! UserFilterController
            controller.whitelist = false
            
        case "showWhitelistSegue":
            let controller = segue.destination as! UserFilterController
            controller.whitelist = true
            
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let inverted = resources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
        whitelistCaption.text = ACLocalizedString(inverted ? "inverted_whitelist_title" : "whitelist_title", "")
        
        updateTheme()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let updateFilters: ()->Void = { [weak self] in
            guard let sSelf = self else { return }
            let filtersDescriptionText = String(format: ACLocalizedString("filters_description_format", nil), sSelf.filtersService.activeFiltersCount, sSelf.filtersService.filtersCount)
            sSelf.filtersDescription.text = filtersDescriptionText
        }
        
        filtersCoutObservation = (filtersService as! FiltersService).observe(\.filtersCount) { (_, _) in
            updateFilters()
        }
        
        activeFiltersCoutObservation = (filtersService as! FiltersService).observe(\.filtersCount) { (_, _) in
            updateFilters()
        }
        
        dnsServerObservetion = vpnManager.observe(\.activeDnsServer) { [weak self] (_, _) in
            DispatchQueue.main.async {
                self?.setDnsName()
            }
        }
        
        let updateStatus = { [weak self] in
            guard let sSelf = self else { return }
            DispatchQueue.main.async {
                sSelf.getProButton.isHidden = sSelf.configuration.proStatus
                sSelf.dnsCell.accessoryType = sSelf.configuration.proStatus ? UITableViewCell.AccessoryType.disclosureIndicator :  UITableViewCell.AccessoryType.none
                sSelf.setDnsName()
            }
        }
        
        updateStatus()
        
        configurationObservation = configuration.observe(\.proStatus) { (_, _) in
            updateStatus()
        }
        
        updateFilters()
    }
    
    // MARK: - Actions
    @IBAction func contactSupportAction(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: ACLocalizedString("common_action_cancel", nil), style: .cancel, handler: nil)
        
        let incorrectAction = UIAlertAction(title: ACLocalizedString("incorrect_blocking_report", nil), style: .default) { (action) in
            guard let reportUrl = self.support.composeWebReportUrl(forSite: nil) else { return }
            UIApplication.shared.open(reportUrl, options: [:], completionHandler: nil)
        }
        
        let bugReportAction = UIAlertAction(title: ACLocalizedString("action_bug_report", nil), style: .default) { (action) in
            UIApplication.shared.open(URL(string: MainMenuController.BUGREPORT_URL)!, options: [:], completionHandler: nil)
        }
        
        let contactSupportAction = UIAlertAction(title: ACLocalizedString("action_contact_support", nil), style: .default) { (action) in
            
            self.support.sendMailBugReport(withParentController: self)
        }
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(incorrectAction)
        actionSheet.addAction(bugReportAction)
        actionSheet.addAction(contactSupportAction)
        
        let popController = actionSheet.popoverPresentationController
        popController?.sourceView = self.bugreportCell
        popController?.sourceRect = self.bugreportCell.bounds
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - table view cells
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == dnsCellRow {
            if configuration.proStatus {
                performSegue(withIdentifier: showDnsSettingsSegue, sender: self)
            }
            else {
                performSegue(withIdentifier: getProSegue, sender: self)
            }
        }
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        tableView.reloadData()
    }
    
    private func setDnsName() {
        if !configuration.proStatus {
            dnsServer.text = ""
        }
        else if vpnManager.isCustomServerActive() {
            dnsServer.text = vpnManager.activeDnsServer!.name
        }
        else if vpnManager.activeDnsServer?.dnsProtocol == nil {
            dnsServer.text = ACLocalizedString("no_dns_server_selected", nil)
        }
        else {
            let serverName = vpnManager.activeDnsProvider?.name ?? vpnManager.activeDnsServer?.name ?? ""
            let protocolName = ACLocalizedString(DnsProtocol.stringIdByProtocol[vpnManager.activeDnsServer!.dnsProtocol!], nil)
            dnsServer.text = "\(serverName) (\(protocolName))"
        }
        
        dnsTrailingConstrint.constant = configuration.proStatus ? 10 : getProButton.frame.width + 10
        tableView.reloadData()
    }
}
