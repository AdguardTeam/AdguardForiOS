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

protocol UpstreamsControllerDelegate: class {
    func updateDescriptionLabel(type: UpstreamType, text: String)
}

class UpstreamsController: BottomAlertController {
    @IBOutlet weak var upstreamTypeLabel: ThemableLabel!
    @IBOutlet weak var textFieldDesciptionLabel: ThemableLabel!
    @IBOutlet weak var saveButton: RoundRectButton!
    @IBOutlet weak var cancelButton: RoundRectButton!
    @IBOutlet weak var upstreamsTextField: UITextField!
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    
    private var notificationToken: NotificationToken?
    
    var upstreamType: UpstreamType!
    weak var delegate: UpstreamsControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        prepareUpstreamTextField()
        prepareTextFieldDescription()
        
        upstreamsTextField.becomeFirstResponder()
        
        updateTheme()
        
        cancelButton?.makeTitleTextUppercased()
        saveButton?.makeTitleTextUppercased()
        cancelButton.applyStandardOpaqueStyle(color: .gray)
        saveButton.applyStandardGreenStyle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.view != contentView {
            dismiss(animated: true)
        }
        else {
            super.touchesBegan(touches, with: event)
        }
    }
    
    
    // MARK: - Actions
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let text = upstreamsTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let type = upstreamType else { return }
        
        if type == .fallback, text == "none" {
            applyChanges(addresses: [text])
            return
        }
        
        let addresses = transformToArray(address: text)
        let validAddresses = addresses.filter { ACNUrlUtils.isIPv4($0) || ACNUrlUtils.isIPv6($0) }
        
        if validAddresses.count != addresses.count && !text.isEmpty {
            DDLogError("(UppstreamsController) saveAction error - invalid addresses)")
            let messsage = type == .customAddress ? String.localizedString("invalid_ip_message") : String.localizedString("invalid_upstream_message")
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: String.localizedString("common_error_title"), message: messsage)
            return
        }
        
        switch type {
        case .customAddress:
            applyChanges(addresses: validAddresses)
        case .bootstrap, .fallback:
            checkUpstream(upstreams: validAddresses) { [weak self] in
                DispatchQueue.main.async {
                    self?.applyChanges(addresses: validAddresses)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func updateTheme() {
        upstreamTypeLabel.textColor = theme.popupTitleTextColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextField(upstreamsTextField)
        saveButton?.indicatorStyle = theme.indicatorStyle
        for separator in separators {
            separator.backgroundColor = theme.separatorColor
        }
    }
    
    private func prepareUpstreamTextField() {
        switch upstreamType {
        case .bootstrap:
            let bootstrapString = resources.customBootstrapServers?.joined(separator: ", ")
            upstreamsTextField.text = bootstrapString
            
        case .fallback:
            let fallbackString = resources.customFallbackServers?.joined(separator: ", ")
            upstreamsTextField.text = fallbackString
            
        case .customAddress:
            let ipAddress = resources.customBlockingIp?.joined(separator: ", ")
            upstreamsTextField.text = ipAddress
        default:
            break
        }
    }
    
    private func prepareTextFieldDescription() {
        switch upstreamType {
        case .bootstrap:
            upstreamTypeLabel.text = String.localizedString("upstreams_bootstraps_title")
            textFieldDesciptionLabel.text = String.localizedString("upstreams_bootstraps_description")
        case .fallback:
            upstreamTypeLabel.text = String.localizedString("upstreams_fallbacks_title")
            textFieldDesciptionLabel.text = String.localizedString("upstreams_description")
        case .customAddress:
            upstreamTypeLabel.text = String.localizedString("upstreams_custom_address_title")
            textFieldDesciptionLabel.text = String.localizedString("upstreams_custom_address_description")
        default:
            break
        }
    }
    
    private func transformToArray(address: String) -> [String] {
        let trimmedAddresses = address.trimmingCharacters(in: .whitespaces)
        let ipAddresses = trimmedAddresses.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        return ipAddresses
    }
    
    private func applyChanges(addresses: [String]) {
        saveUpstreams(upstreams: addresses)
        vpnManager.updateSettings(completion: nil)
        dismiss(animated: true)
    }
    
    private func saveUpstreams(upstreams: [String]) {
        let address: [String]? = upstreams.isEmpty ? nil : upstreams
        let text = upstreams.joined(separator: ", ")
        
        switch upstreamType {
        case .bootstrap:
            resources.customBootstrapServers = address
            delegate?.updateDescriptionLabel(type: .bootstrap, text: text)
        case .fallback:
            resources.customFallbackServers = address
            delegate?.updateDescriptionLabel(type: .fallback, text: text)
        case .customAddress:
            resources.customBlockingIp = address
            delegate?.updateDescriptionLabel(type: .customAddress, text: text)
        default:
            break
        }
    }
    
    private func checkUpstream(upstreams: [String] ,success:@escaping ()->Void) {
        saveButton?.isEnabled = false
        saveButton?.startIndicator()
        
        var bootstrap:[String] = []
        
        ACNIPUtils.enumerateSystemDns { (ip, _, _, _) in
            bootstrap.append(ip ?? "")
        }
        let upstreams = upstreams.map {
            AGDnsUpstream(address: $0, bootstrap: bootstrap, timeoutMs: 2000, serverIp: Data(), id: 0, outboundInterfaceName: nil)
        }
        
        DispatchQueue(label: "save dns upstreams queue").async { [weak self] in
            guard let self = self else { return }
            
            let errors = upstreams.compactMap {
                AGDnsUtils.test($0)
            }
            
            DispatchQueue.main.async {
                
                self.saveButton?.isEnabled = true
                self.saveButton?.stopIndicator()
                
                if errors.isEmpty {
                    success()
                }
                else {
                    let message = errors.first
                    DDLogError("(UppstreamsController) saveAction error - \(message?.localizedDescription ?? "nil" )")
                    ACSSystemUtils.showSimpleAlert(for: self, withTitle: String.localizedString("common_error_title"), message: String.localizedString("invalid_upstream_message"))
                }
            }
        }
    }
}
