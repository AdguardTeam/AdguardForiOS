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
    
    // MARK: - public variables
    
    var selectedProtocol: DnsProtocol?
    var provider: DnsProviderInfo?
    var delegate: ChooseProtocolControllerDelegate?
    
    // MARK: - constants
    
    let cellHeight: CGFloat = 60.0
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var regularHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dnscryptHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dohHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dotHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var regularCheck: UIImageView!
    @IBOutlet weak var dnsCryptCheck: UIImageView!
    @IBOutlet weak var dohCheck: UIImageView!
    @IBOutlet weak var dotCheck: UIImageView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var buttons: [RoundRectButton]!
    @IBOutlet var separators: [UIView]!
    @IBOutlet weak var scrollContentView: UIView!
    
    private var notificationToken: NotificationToken?
    
    // MARK: - services
    
    let vpnManager: APVPNManager = ServiceLocator.shared.getService()!
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - viewcontroller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        setupAvailibleProtocols()
        setupChecks()
        updateTheme()
    }
    
    // MARK: - Actions
    
    @IBAction func regualrAction(_ sender: Any) {
        activateServer(provider?.serverByProtocol(dnsProtocol: .dns))
    }
    
    @IBAction func dnsCryptAction(_ sender: Any) {
        activateServer(provider?.serverByProtocol(dnsProtocol: .dnsCrypt))
    }
    
    @IBAction func dohAction(_ sender: Any) {
        activateServer(provider?.serverByProtocol(dnsProtocol: .doh))
    }
    
    @IBAction func dotAction(_ sender: Any) {
        activateServer(provider?.serverByProtocol(dnsProtocol: .dot))
    }
    
    // MARK: - Private methods
    
    private func activateServer(_ server: DnsServerInfo?) {
        vpnManager.activeDnsServer = server
        vpnManager.enabled = server != nil
        dismiss(animated: true, completion: nil)
    }
    
    func setupChecks() {
        
        guard let dnsProtocol = selectedProtocol else {
            return
        }
        
        regularCheck.isHidden = true
        dnsCryptCheck.isHidden = true
        dohCheck.isHidden = true
        dotCheck.isHidden = true
        
        switch dnsProtocol {
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
    
    func setupAvailibleProtocols() {
        
        guard  let protocols = provider?.protocols else { return }
        
        regularHeightConstraint.constant = 0
        dnscryptHeightConstraint.constant = 0
        dohHeightConstraint.constant = 0
        dotHeightConstraint.constant = 0
        
        for dnsProtocol in protocols {
            switch dnsProtocol {
            case .dns:
                regularHeightConstraint.constant = cellHeight
            case .dnsCrypt:
                dnscryptHeightConstraint.constant = cellHeight
            case .doh:
                dohHeightConstraint.constant = cellHeight
            case .dot:
                dotHeightConstraint.constant = cellHeight
            }
        }
    }
    
    private func updateTheme() {
        
        scrollContentView.backgroundColor = theme.popupBackgroundColor
        theme.setupLabels(themableLabels)
        theme.setupPopupButtons(buttons)
        theme.setupSeparators(separators)
    }
}
