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

import UIKit

final class NativeImplementationView: UIView {
    
    // MARK: - Public properties
    
    var dnsIsWorking = false {
        didSet {
            if oldValue != dnsIsWorking {
                processDnsStatus()
            }
        }
    }
    
    var dnsProviderName: String = "" {
        didSet {
            if oldValue != dnsProviderName {
                processDnsServer()
            }
        }
    }
    
    var dnsProtocol: String = "" {
        didSet {
            if oldValue != dnsProtocol {
                processDnsServer()
            }
        }
    }
    
    // MARK: - UI Elements
    
    private lazy var statusLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 24.0 : 16.0, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var serverLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.lightGreyText = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 20.0 : 14.0, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - NativeImplementationView initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        addSubview(statusLabel)
        addSubview(serverLabel)
        
        statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        statusLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        serverLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        serverLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        serverLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 4.0).isActive = true
        serverLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        
        processDnsStatus()
        processDnsServer()
    }
    
    // MARK: - Public methods
    
    func updateTheme(_ themeService: ThemeServiceProtocol) {
        backgroundColor = themeService.backgroundColor
        themeService.setupLabels([statusLabel, serverLabel])
        processDnsStatus()
    }
    
    // MARK: - Private methods
    
    private func processDnsStatus() {
        let format = String.localizedString(dnsIsWorking ? "native_dns_working" : "native_dns_not_working")
        let colorHex = dnsIsWorking ? UIColor.AdGuardColor.lightGreen2.hex() : UIColor.AdGuardColor.yellow2.hex()
        let status = String(format: format, colorHex)
        let fontSize = statusLabel.font.pointSize
        let fontColor = statusLabel.textColor ?? .clear
        statusLabel.attributedText = NSMutableAttributedString.fromHtml(status, fontSize: fontSize, color: fontColor, attachmentImage: nil, textAlignment: .center)
    }
    
    private func processDnsServer() {
        let format = String.localizedString("dns_server_info_format")
        serverLabel.text = String(format: format, dnsProviderName, dnsProtocol)
    }
}
