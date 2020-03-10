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

class DnsProviderContainerController : UIViewController {

    // MARK: - public fields

    var provider: DnsProviderInfo?
    
    // MARK: - IB Outlets

    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    private var notificationToken: NotificationToken?
    private var chosenProtocol: DnsProtocol?
    private var childController: DnsProviderDetailsController?
    
    // MARK: - services

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: APVPNManager = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!

    // MARK: - view controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        setupBackButton()
        updateTheme()
        
        guard let provider = provider else  { return }
        guard let protcol = provider.getActiveProtocol(resources) else { return }
        chosenProtocol = protcol
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "providerDetailsEmbedSegue" {
            guard let controller = segue.destination as? DnsProviderDetailsController else { return }
            controller.provider = provider
            childController = controller
            controller.selectedProtocol = chosenProtocol
        }
    }

    // MARK: - Actions

    @IBAction func useServerAction(_ sender: Any) {
        if let currentProtocol: DnsProtocol = childController?.selectedProtocol {
            if let currentServer: DnsServerInfo = provider?.serverByProtocol(dnsProtocol: currentProtocol){
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
