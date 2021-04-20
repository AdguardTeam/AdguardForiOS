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

final class NativeImplementationView: MainPageCompactView {
    
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
    
    // MARK: - Initializer
    
    override init() {
        super.init()
        processDnsStatus()
        processDnsServer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        processDnsStatus()
        processDnsServer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        processDnsStatus()
        processDnsServer()
    }
    
    // MARK: - Public methods
    
    override func updateTheme(_ themeService: ThemeServiceProtocol) {
        super.updateTheme(themeService)
        processDnsStatus()
    }
    
    // MARK: - Private methods
    
    private func processDnsStatus() {
        let format = String.localizedString(dnsIsWorking ? "native_dns_working" : "native_dns_not_working")
        let colorHex = dnsIsWorking ? UIColor.AdGuardColor.lightGreen2.hex() : UIColor.AdGuardColor.yellow2.hex()
        let status = String(format: format, colorHex)
        let fontSize = titleLabel.font.pointSize
        let fontColor = titleLabel.textColor ?? .clear
        titleLabel.attributedText = NSMutableAttributedString.fromHtml(status, fontSize: fontSize, color: fontColor, attachmentImage: nil, textAlignment: .center)
    }
    
    private func processDnsServer() {
        let format = String.localizedString("dns_server_info_format")
        descriptionLabel.text = String(format: format, dnsProviderName, dnsProtocol)
    }
}