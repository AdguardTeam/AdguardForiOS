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

class DnsProviderCell : UITableViewCell {
    
    @IBOutlet weak var nameLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var selectedButton: UIButton!
}

class DnsProvidersController: UITableViewController {
    //MARK: - IB Outlets
    
    // MARK: - services
    
    let vpnManager: APVPNManager = ServiceLocator.shared.getService()!
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: Private properties
    private lazy var providers = { self.vpnManager.providers } ()
    private var selectedCellRow = 0
    private var activeProviderObservation: NSKeyValueObservation?
    private var providersObservation: NSKeyValueObservation?
    private var providerToShow: DnsProviderInfo?
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        
        let selectCellFunc = { [weak self] in
            guard let sSelf = self else { return }
            var row = 0
            for provider in sSelf.providers {
                if sSelf.vpnManager.isActiveProvider(provider) {
                    sSelf.selectedCellRow = row
                    break
                }
                row += 1
            }
        }
        
        selectCellFunc()
        
        activeProviderObservation = vpnManager.observe(\.activeDnsServer) {[weak self]  (server, change)  in
            DispatchQueue.main.async {
                selectCellFunc()
                self?.tableView.reloadData()
            }
        }
        
        providersObservation = vpnManager.observe(\.providers) {[weak self]  (server, change)  in
            DispatchQueue.main.async {
                guard let sSelf = self else { return }
                sSelf.providers = sSelf.vpnManager.providers
                sSelf.tableView.reloadData()
            }
        }
        
        updateTheme()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DnsServerCell") as! DnsProviderCell
        
        let provider = providers[indexPath.row]
        
        cell.nameLabel.text = provider.name
        if provider.summary != nil {
            cell.descriptionLabel.text = ACLocalizedString(provider.summary!, nil)
        }
        else {
            cell.descriptionLabel.text = ""
        }
        
        cell.selectedButton.isSelected = selectedCellRow == indexPath.row
        cell.selectedButton.tag = indexPath.row
        
        theme.setupTableCell(cell)
        theme.setupLabel(cell.nameLabel)
        theme.setupLabel(cell.descriptionLabel)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return providers.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if vpnManager.isCustomProvider(providers[indexPath.row]) {
            guard let parentController = self.parent as? DnsProvidersContainerController else { return }
            parentController.editProvider(providers[indexPath.row])
        }
        else {
            providerToShow = providers[indexPath.row]
            performSegue(withIdentifier: "dnsDetailsSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "dnsDetailsSegue" {
            let controller = segue.destination as! DnsProviderContainerController
            controller.provider = providerToShow
            controller.defaultDnsServer = defaultServer(providerToShow!)
        }
    }
    
    // MARK: Actions
    
    @IBAction func selectProviderAction(_ sender: UIButton) {
        let provider = providers[sender.tag]
        
        guard let server = defaultServer(provider) else { return }
        
        // select first server in provider
        vpnManager.activeDnsServer = server
        
        selectedCellRow = sender.tag
        
        tableView.reloadData()
    }
    
    // MARK: private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
    }
    
    private func defaultServer(_ provider: DnsProviderInfo)->DnsServerInfo? {
        
        let dot = provider.servers?.first { (dns) -> Bool in
            return dns.dnsProtocol == DnsProtocol.dot
        }
        
        if dot != nil {
            return dot
        }
        
        let doh = provider.servers?.first { (dns) -> Bool in
            return dns.dnsProtocol == DnsProtocol.doh
        }
        
        if doh != nil {
            return doh
        }
        
        let dnsCrypt = provider.servers?.first { (dns) -> Bool in
            return dns.dnsProtocol == DnsProtocol.dnsCrypt
        }
        
        if dnsCrypt != nil {
            return dnsCrypt
        }
        
        let regular = provider.servers?.first { (dns) -> Bool in
            return dns.dnsProtocol == DnsProtocol.dns
        }
        
        return regular
    }
}
