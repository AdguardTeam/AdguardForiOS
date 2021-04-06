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
    @IBOutlet weak var quicHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var regularRadioButton: RadioButton!
    @IBOutlet weak var dnsCryptRadioButton: RadioButton!
    @IBOutlet weak var dohRadioButton: RadioButton!
    @IBOutlet weak var dotRadioButton: RadioButton!
    @IBOutlet weak var quicRadioButton: RadioButton!
    
    @IBOutlet weak var regularSeparator: UIView!
    @IBOutlet weak var dnsCryptSeparator: UIView!
    @IBOutlet weak var dohSeparator: UIView!
    @IBOutlet weak var dotSeparator: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var buttons: [RoundRectButton]!
    @IBOutlet var separators: [UIView]!
    @IBOutlet weak var scrollContentView: UIView!
    
    // MARK: - services
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - viewcontroller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func quicAction(_ sender: Any) {
        delegate?.protocolSelected(chosenProtocol: .doq)
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Private methods
    
    private func setupChecks() {
        
        guard let dnsProtocol = selectedProtocol else {
            return
        }
        
        regularRadioButton.isSelected = false
        dnsCryptRadioButton.isSelected = false
        dohRadioButton.isSelected = false
        dotRadioButton.isSelected = false
        quicRadioButton.isSelected = false
        
        switch dnsProtocol {
        case .dns:
            regularRadioButton.isSelected = true
        case .dnsCrypt:
            dnsCryptRadioButton.isSelected = true
        case .doh:
            dohRadioButton.isSelected = true
        case .dot:
            dotRadioButton.isSelected = true
        case .doq:
            quicRadioButton.isSelected = true
        }
    }
    
    private func setupAvailibleProtocols() {
        
        guard  let protocols = provider?.protocols else { return }
        
        regularHeightConstraint.constant = 0
        dnscryptHeightConstraint.constant = 0
        dohHeightConstraint.constant = 0
        dotHeightConstraint.constant = 0
        quicHeightConstraint.constant = 0
        
        regularSeparator.isHidden = true
        dnsCryptSeparator.isHidden = true
        dohSeparator.isHidden = true
        dotSeparator.isHidden = true
        
        let lastElementIndex = protocols.count - 1
        
        for (index, dnsProtocol) in protocols.enumerated() {
            switch dnsProtocol {
            case .dns:
                regularHeightConstraint.constant = cellHeight
                regularSeparator.isHidden = index == lastElementIndex
            case .dnsCrypt:
                dnscryptHeightConstraint.constant = cellHeight
                dnsCryptSeparator.isHidden = index == lastElementIndex
            case .doh:
                dohHeightConstraint.constant = cellHeight
                   dohSeparator.isHidden = index == lastElementIndex
            case .dot:
                dotHeightConstraint.constant = cellHeight
                    dotSeparator.isHidden = index == lastElementIndex
            case .doq:
                quicHeightConstraint.constant = cellHeight
            }
        }
    }
}

extension ChooseProtocolController: ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        titleLabel.textColor = theme.popupTitleTextColor
        theme.setupPopupButtons(buttons)
        theme.setupSeparators(separators)
    }
}
