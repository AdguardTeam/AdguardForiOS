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

/// Description cell  from DnsSettings.storyboard
final class DescriptionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
}

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
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    
    // View model
    private let model: DnsProvidersModelProtocol
    
    // MARK: Private properties
    private var providers: [DnsProviderCellModel] { model.providers }
    
    private lazy var titleHeader: ExtendedTitleTableHeaderView = {
        ExtendedTitleTableHeaderView(title: model.headerTitle, htmlDescription: model.headerDescription)
    }()
    
    // MARK: - Observers
    private var currentServerObserver: NotificationToken?
    
    private var providerToShowId: Int?
    private let sections: [DnsProvidersSection] = DnsProvidersSection.allCases
    
    //MARK: - Init
    
    required init?(coder: NSCoder) {
        let dnsProviderManager: DnsProvidersManagerProtocol = ServiceLocator.shared.getService()!
        model = DnsProvidersModel(dnsProvidersManager: dnsProviderManager, resources: resources, vpnManager: vpnManager)
        super.init(coder: coder)
    }
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddTableViewCell.registerCell(forTableView: tableView)
        ExtendedRadioButtonCell.registerCell(forTableView: tableView)
        
        currentServerObserver = NotificationCenter.default.observe(name: .currentDnsServerChanged, object: nil, queue: .main, using: { [weak self] _ in
            self?.tableView.reloadData()
        })

        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = titleHeader
        setupBackButton()
        updateTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if openUrl != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.presentNewDnsServerController(controllerType: .add, nil)
                self.openUrl = nil
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dnsDetailsSegue" {
            let controller = segue.destination as! DnsProviderDetailsController
            if let providerId = providerToShowId, let model = model.modelForPredefinedProvider(providerId: providerId) {
                controller.model = model
                controller.delegate = self
            }
        }
    }
    
    // MARK: - table view methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .providerSection:
            let cell = ExtendedRadioButtonCell.getCell(forTableView: tableView)
            let provider = providers[indexPath.row]
            cell.delegate = self
            cell.cellTag = indexPath.row
            cell.titleString = provider.name ?? ""
            cell.descriptionString = provider.providerDescription ?? ""
            cell.radioButtonSelected = provider.isCurrent
            cell.isArrowRightHidden = provider.isDefaultProvider
            cell.updateTheme()
            return cell
            
        case .addProviderSection :
            let cell = AddTableViewCell.getCell(forTableView: tableView)
            cell.addTitle = String.localizedString("add_custom_dns_server_title")
            theme.setupTableCell(cell)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .addProviderSection: return 1
        case .providerSection: return providers.count
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
            let provider = providers[indexPath.row]
            
            if provider.isDefaultProvider, let providerId = provider.providerId {
                model.setProviderActive(with: providerId)
                tableView.reloadData()
                return
            }
            
            if provider.isCustomProvider {
                presentNewDnsServerController(controllerType: .edit, provider)
            } else {
                providerToShowId = provider.providerId
                performSegue(withIdentifier: "dnsDetailsSegue", sender: self)
            }
            
        case .addProviderSection: presentNewDnsServerController(controllerType: .add, nil)
        }
        
    }
        
    // MARK: - Private methods
    private func presentNewDnsServerController(controllerType: DnsServerControllerType, _ provider: DnsProviderCellModel?) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "NewDnsServerController") as? NewDnsServerController else { return }
        
        switch controllerType {
        case .add:
            controller.openUrl = openUrl
            controller.model = self.model.defaultNewDnsServerModel
        case .edit:
            guard let id = provider?.providerId else { return }
            controller.model = self.model.modelForCustomProvider(providerId: id)
        }
        
        controller.controllerType = controllerType
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
}

extension DnsProvidersController: NewDnsServerControllerDelegate {
    func providerAdded() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func providerDeleted() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func providerChanged() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension DnsProvidersController: DnsProviderDetailsControllerDelegate {
    /// Select active provider from details  controller
    func activeServerChanged(_ newServer: DnsServerInfo) {
        //TODO: change active server
    }
}

extension DnsProvidersController: ExtendedRadioButtonCellDelegate {
    /// Select active provider from selected cell
    func radioButtonTapped(with tag: Int) {
        guard let providerId = providers[tag].providerId else { return }
        model.setProviderActive(with: providerId)
        tableView.reloadData()
    }
}

extension DnsProvidersController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        theme.setupNavigationBar(navigationController?.navigationBar)
        tableView.reloadData()
    }
}
