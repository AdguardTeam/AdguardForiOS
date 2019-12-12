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

protocol DnsProtocolChangedDelegate: class {
    func changesWereApplied(_ applied: Bool)
}

class DnsProviderContainerController : UIViewController {

    // MARK: - public fields

    var provider: DnsProviderInfo?
    var defaultDnsServer: DnsServerInfo?
    var chosenProtocol: DnsProtocol?
    
    weak var delegate: DnsProtocolChangedDelegate?
    
    // MARK: - IB Outlets

    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    private var notificationToken: NotificationToken?
    
    private var childController: DnsProviderDetailsController?
    
    // MARK: - services

    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    let vpnManager: APVPNManager = ServiceLocator.shared.getService()!
    

    // MARK: - view controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        if provider == nil { return }
        
        if vpnManager.isActiveProvider(provider!) {
            chosenProtocol = vpnManager.activeDnsServer?.dnsProtocol
        }
        else {
            chosenProtocol = defaultDnsServer?.dnsProtocol
        }
        
        navigationItem.title = provider?.name
        
        setupBackButton()
        updateTheme()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let protocolChanged = childController?.protocolWasChanged {
            delegate?.changesWereApplied(!protocolChanged)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "providerDetailsEmbedSegue" {
            guard let controller = segue.destination as? DnsProviderDetailsController else { return }
            controller.provider = provider
            
            childController = controller
    
            var server: DnsServerInfo?
            
            if vpnManager.isActiveProvider(provider!) {
                server = vpnManager.activeDnsServer
            }
            else {
                server = defaultDnsServer
            }
            
            if let dnsProtocol = server?.dnsProtocol {
                controller.selectedProtocol = dnsProtocol
            }
        }
    }

    // MARK: - Actions

    @IBAction func useServerAction(_ sender: Any) {
        /**
         When we tap "select" button we apply protocol changes
         */
        childController?.protocolWasChanged = false
        if let currentProtocol: DnsProtocol = childController?.selectedProtocol {
            if let defaultServer = defaultDnsServer {
                let currentServer: DnsServerInfo = provider?.serverByProtocol(dnsProtocol: currentProtocol) ?? defaultServer
                activateServer(currentServer)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    

    // MARK: - private methods

    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        separator.backgroundColor = theme.separatorColor
        topSeparator.backgroundColor = theme.separatorColor
    }
    
    private func activateServer(_ server: DnsServerInfo) {
        vpnManager.activeDnsServer = server
        vpnManager.enabled = true
        dismiss(animated: true, completion: nil)
    }
}
