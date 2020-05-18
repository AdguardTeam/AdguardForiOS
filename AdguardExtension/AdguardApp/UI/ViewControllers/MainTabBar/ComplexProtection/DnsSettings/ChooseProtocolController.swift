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
    func protocolSelected(chosenProtocol: DnsProtocol)
}

class ChooseProtocolController: BottomAlertController {
    
    // MARK: - public variables
    
    var selectedProtocol: DnsProtocol?
    var provider: DnsProviderInfo?
    var delegate: ChooseProtocolControllerDelegate?
    
    // MARK: - constants
    
    var cellHeight: CGFloat {
        get {
            let isBigScreen = traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular
            return isBigScreen ? 80.0 : 60.0
        }
    }
    
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
        delegate?.protocolSelected(chosenProtocol: .dns)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dnsCryptAction(_ sender: Any) {
        delegate?.protocolSelected(chosenProtocol: .dnsCrypt)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dohAction(_ sender: Any) {
        delegate?.protocolSelected(chosenProtocol: .doh)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dotAction(_ sender: Any) {
        delegate?.protocolSelected(chosenProtocol: .dot)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    
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
        contentView.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupPopupButtons(buttons)
        theme.setupSeparators(separators)
    }
}
