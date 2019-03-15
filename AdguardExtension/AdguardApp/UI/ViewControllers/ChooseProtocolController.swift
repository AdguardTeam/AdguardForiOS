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

protocol ChooseProtocolControllerDelegate {
    func protocolSelected(protocol: DnsProtocol)
}

class ChooseProtocolController: BottomAlertController {
    
    // public variables
    
    var selectedProtocol = DnsProtocol.dns
    var provider: DnsProviderInfo?
    var delegate: ChooseProtocolControllerDelegate?
    
    // IB Outlets
    
    @IBOutlet weak var regularHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dnscryptHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dohHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dotHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var regularCheck: UIImageView!
    @IBOutlet weak var dnsCryptCheck: UIImageView!
    @IBOutlet weak var dohCheck: UIImageView!
    @IBOutlet weak var dotCheck: UIImageView!
    
    // MARK: - services
    
    let vpnManager: APVPNManager = ServiceLocator.shared.getService()!
    
    // MARK: - viewcontroller lifecycle
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        setupChecks()
    }
    
    // MARK: - Actions
    
    @IBAction func regualrAction(_ sender: Any) {
        vpnManager.activeDnsServer = provider?.serverByProtocol(dnsProtocol: .dns)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dnsCryptAction(_ sender: Any) {
        vpnManager.activeDnsServer = provider?.serverByProtocol(dnsProtocol: .dnsCrypt)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dohAction(_ sender: Any) {
        vpnManager.activeDnsServer = provider?.serverByProtocol(dnsProtocol: .doh)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dotAction(_ sender: Any) {
        vpnManager.activeDnsServer = provider?.serverByProtocol(dnsProtocol: .dot)
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Private methods
    
    func setupChecks() {
        
        regularCheck.isHidden = true
        dnsCryptCheck.isHidden = true
        dohCheck.isHidden = true
        dotCheck.isHidden = true
        
        switch selectedProtocol {
        case .dns:
            regularCheck.isHidden = false
        case .dnsCrypt:
            dnsCryptCheck.isHidden = false
        case .doh:
            dohCheck.isHidden = false
        case .dot:
            dotCheck.isHidden = false
        }
    }
}
