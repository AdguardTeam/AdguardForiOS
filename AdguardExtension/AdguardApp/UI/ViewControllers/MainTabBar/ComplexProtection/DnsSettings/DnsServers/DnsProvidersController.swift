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

import DnsAdGuardSDK

/// Controller that represent all predefined and custom providers
final class DnsProvidersController: UITableViewController {
    
    fileprivate enum DnsProvidersSection: Int, CaseIterable {
        case providerSection = 0
        case addProviderSection
    }
    
    // MARK: - public fields
    var openUrl: String?
    
    // MARK: - services
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    
    // View model
    private let model: DnsProvidersModel
    
    // MARK: Private properties
    private var tableModels: [DnsProvidersTableModel] { model.tableModels }
    private var providerToShow: DnsProviderProtocol?
    private let sections: [DnsProvidersSection] = DnsProvidersSection.allCases
    
    private let dnsDetailsSegueConst = "dnsDetailsSegue"
    private let NewDnsServerControllerIdentifier = "NewDnsServerController"
    
    //MARK: - Init
    
    required init?(coder: NSCoder) {
        // TODO: - try! is bad;
        let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
        let dnsProtectionConfiguration = DnsConfiguration(resources: resources,
                                                          isProPurchased: purchaseService.isProPurchased)
        dnsProvidersManager = try! DnsProvidersManager(configuration: dnsProtectionConfiguration, userDefaults: UserDefaultsStorage(storage: resources.sharedDefaults()))
        
        model = DnsProvidersModel(dnsProvidersManager: dnsProvidersManager, vpnManager: vpnManager)
        super.init(coder: coder)
    }
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBackButton()
        updateTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let _ = openUrl else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.presentNewDnsServerController(controllerType: .add, nil)
            self?.openUrl = nil
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == dnsDetailsSegueConst,
              let controller = segue.destination as? DnsProviderDetailsController,
              let provider = providerToShow
        else { return }
        
        controller.model = DnsProviderDetailsModel(provider: provider, resources: resources)
        controller.delegate = self
    }
    
    // MARK: - table view methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .providerSection:
            let cell = ExtendedRadioButtonCell.getCell(forTableView: tableView)
            let tableModel = tableModels[indexPath.row]
            let cellModel = tableModel.getCellModel(cellTag: indexPath.row, delegate: self)
            cell.model = cellModel
            cell.updateTheme(themeService: themeService)
            return cell
            
        case .addProviderSection :
            let cell = AddTableViewCell.getCell(forTableView: tableView)
            cell.addTitle = String.localizedString("add_custom_dns_server_title")
            cell.updateTheme(themeService)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .addProviderSection: return 1
        case .providerSection: return tableModels.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        let section = sections[indexPath.section]
        
        switch section {
        case .providerSection:
            let tableModel = tableModels[indexPath.row]
            
            if tableModel.isDefaultProvider {
                do {
                    try model.setProviderActive(provider: tableModel.provider)
                    tableView.reloadData()
                } catch {
                    showUnknownErrorAlert() //TODO: process DnsProvidersManager errors
                }
                return
            }
            
            if tableModel.isCustomProvider {
                presentNewDnsServerController(controllerType: .edit, tableModel)
            } else {
                providerToShow = tableModel.provider.predefined
                performSegue(withIdentifier: dnsDetailsSegueConst, sender: self)
            }
            
        case .addProviderSection: presentNewDnsServerController(controllerType: .add, nil)
        }
        
    }
        
    // MARK: - Private methods
    private func presentNewDnsServerController(controllerType: DnsServerControllerType, _ tableModel: DnsProvidersTableModel?) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: NewDnsServerControllerIdentifier) as? NewDnsServerController else { return }
        
        switch controllerType {
        case .add:
            controller.model = NewDnsServerModel(dnsProvidersManager: dnsProvidersManager, vpnManager: vpnManager, openUrl: openUrl)
        case .edit:
            guard let provider = tableModel?.provider.custom else { return }
            controller.model = NewDnsServerModel(dnsProvidersManager: dnsProvidersManager, vpnManager: vpnManager, provider: provider)
        }
        
        controller.controllerType = controllerType
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    private func setProviderAndReloadTable(provider: DnsProviderMetaProtocol) {
        do {
            try model.setProviderActive(provider: provider)
            tableView.reloadData()
        } catch {
            showUnknownErrorAlert() //TODO: Process DnsProvidersManager errors
        }
    }
    
    private func setupTableView() {
        AddTableViewCell.registerCell(forTableView: tableView)
        ExtendedRadioButtonCell.registerCell(forTableView: tableView)
        
        let titleHeader = ExtendedTitleTableHeaderView(title: model.headerTitle, normalDescription: model.headerDescription)
        tableView.tableHeaderView = titleHeader
        tableView.rowHeight = UITableView.automaticDimension
    }
}

//MARK: - DnsProvidersController + NewDnsServerControllerDelegate
extension DnsProvidersController: NewDnsServerControllerDelegate {
    func customProviderUpdated() {
        tableView.reloadData()
    }
}

//MARK: - DnsProvidersController + DnsProviderDetailsControllerDelegate
extension DnsProvidersController: DnsProviderDetailsControllerDelegate {
    /// Select active provider from details  controller
    func providerSelected(provider: DnsProviderProtocol) {
       setProviderAndReloadTable(provider: provider)
    }
}

//MARK: - DnsProvidersController + ExtendedRadioButtonCellDelegate
extension DnsProvidersController: ExtendedRadioButtonCellDelegate {
    /// Select active provider from selected cell
    func radioButtonTapped(with tag: Int) {
        let provider = tableModels[tag].provider
        setProviderAndReloadTable(provider: provider)
    }
}

//MARK: - DnsProvidersController + ThemableProtocol
extension DnsProvidersController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupTable(tableView)
        themeService.setupNavigationBar(navigationController?.navigationBar)
        tableView.reloadData()
    }
}
