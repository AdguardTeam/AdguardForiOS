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

class DescriptionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
}

final class DnsProvidersController: UITableViewController {
    
    // MARK: - public fields
    
    var openUrl: String?
    
    required init?(coder: NSCoder) {
        model = DnsProvidersModel(dnsProvidersService: dnsProvidersService, nativeProvidersService: nativeProvidersService, resources: resources, vpnManager: vpnManager)
        super.init(coder: coder)
    }
    
    // MARK: - services
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    private let dnsProvidersService: DnsProvidersServiceProtocol = ServiceLocator.shared.getService()!
    private let nativeProvidersService: NativeProvidersServiceProtocol = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    
    // View model
    private let model: DnsProvidersModelProtocol
    
    // MARK: Private properties
    private var providers: [DnsProviderCellModel] { model.providers }
    private var providerToShow: DnsProviderCellModel?
    
    // MARK: - Observers
    private var currentServerObserver: NotificationToken?
    
    private let descriptionSection = 0
    private let providerSection = 1
    private let addProviderSection = 2
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentServerObserver = NotificationCenter.default.observe(name: .currentDnsServerChanged, object: nil, queue: .main, using: { [weak self] _ in
            self?.tableView.reloadData()
        })

        tableView.rowHeight = UITableView.automaticDimension
        setupBackButton()
        updateTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if openUrl != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showNewServer()
                self.openUrl = nil
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dnsDetailsSegue" {
            let controller = segue.destination as! DnsProviderDetailsController
            if let selectedProvider = providerToShow, let id = selectedProvider.providerId, let provider = model.getProvider(byId: id) {
                controller.provider = provider
                controller.delegate = self
            }
        }
    }
    
    // MARK: - Publice methods
    
    enum ProviderToSelectType {
        case adguard
        case google
        case cloudflare
        case addNewCustom
    }
    
    /* Should be called when we want to select an exact provider when view is loaded */
    func selectProviderWhenViewIsLoaded(_ provider: ProviderToSelectType) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            switch provider {
            case .addNewCustom: self?.showNewServer()
            case .adguard: self?.selectProvider(byId: DnsProvidersService.ProviderId.adGuard.rawValue)
            case .google: self?.selectProvider(byId: DnsProvidersService.ProviderId.google.rawValue)
            case .cloudflare: self?.selectProvider(byId: DnsProvidersService.ProviderId.cloudflare.rawValue)
            }
        }
    }
    
    // MARK: table view methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case descriptionSection:
            let reuseId = "descriptionCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? DescriptionCell else { return UITableViewCell() }
            theme.setupLabel(cell.descriptionLabel)
            theme.setupLabel(cell.titleLabel)
            theme.setupTableCell(cell)
            return cell
            
        case providerSection:
            let provider = providers[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "DnsServerCell") as! DnsProviderCell
            cell.delegate = self
            cell.themeService = theme
            cell.model = provider
            cell.tag = indexPath.row
            return cell
            
        case addProviderSection :
            let reuseId = "AddServer"
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) ?? UITableViewCell()
            theme.setupTableCell(cell)
            return cell
            
        default:
            assertionFailure("unknown tableview section")
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case descriptionSection:
            return 1
        case providerSection:
            return providers.count
        case addProviderSection:
            return 1
        default:
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case descriptionSection:
            return 0.01 // hide bottom separator
        default:
            return 0.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        
        switch indexPath.section {
        case providerSection:
            let provider = providers[indexPath.row]
            
            if provider.isDefaultProvider {
                model.setServerAsActive(nil)
                return
            }
            
            if provider.isCustomProvider {
                editProvider(provider)
                return
            } else {
                providerToShow = provider
                performSegue(withIdentifier: "dnsDetailsSegue", sender: self)
            }
       
        case addProviderSection:
            showNewServer()
            
        default:
            break
        }
    }
        
    // MARK: - private methods
    
    private func editProvider(_ provider: DnsProviderCellModel) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "NewDnsServerController") as? NewDnsServerController else { return }
        if let id = provider.providerId, let providerInfo = model.getProvider(byId: id) {
            controller.controllerType = .edit
            controller.provider = providerInfo
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        }
    }
    
    private func showNewServer() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "NewDnsServerController") as? NewDnsServerController else { return }
        controller.openUrl = openUrl
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

extension DnsProvidersController: DnsProviderCellDelegate {
    func selectedProvider(withTag tag: Int) {
        let provider = providers[tag]
        guard let id = provider.providerId else {
            DDLogError("Error finding provider with id = \(provider.providerId ?? 0)")
            return
        }
        if provider.isDefaultProvider {
            model.setServerAsActive(nil)
            return
        }
        
        selectProvider(byId: id)
    }
    
    private func selectProvider(byId providerId: Int) {
        var server: DnsServerInfo?
        
        if let providerInfo = model.getProvider(byId: providerId) {
            
            if let prot = providerInfo.getActiveProtocol(resources) {
                server = providerInfo.serverByProtocol(dnsProtocol: prot)
            }
            /* If there is no active protocol in the provider than it means that it is custom one */
            else if let customServer = providerInfo.servers?.first {
                server = customServer
            }
        }
        model.setServerAsActive(server)
    }
}

extension DnsProvidersController: DnsProviderDetailsControllerDelegate {
    func activeServerChanged(_ newServer: DnsServerInfo) {
        model.setServerAsActive(newServer)
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
