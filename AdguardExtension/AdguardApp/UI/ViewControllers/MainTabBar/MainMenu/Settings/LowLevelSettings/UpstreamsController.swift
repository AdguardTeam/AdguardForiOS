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

enum UpstreamType {
    case Bootstrap
    case Fallback
    case CustomAddress
}

protocol UpstreamsControllerDelegate: class {
    func updateCustomAddressDescriptionLabel(text: String)
    func updateFallbacksDescriptionLabel(text: String)
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
        guard let text = upstreamsTextField.text else { return }
        
        let upstreams = transformToArray(address: text)
        
        
        checkUpstream(upstreams: upstreams) { [weak self] in
            self?.saveUpstream(text: text)
            self?.vpnManager.updateSettings(completion: nil)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Private methods
    
    private func updateTheme() {
        scrollContentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextField(upstreamsTextField)
        saveButton?.indicatorStyle = theme.indicatorStyle
        for separator in separators {
            separator.backgroundColor = theme.separatorColor
        }
    }
    
    private func prepareUpstreamTextField() {
        
        switch upstreamType {
        case .Bootstrap:
            let bootstrapString = resources.customBootstrapServers?.joined(separator: ", ")
            upstreamsTextField.text = bootstrapString
            
        case .Fallback:
            let fallbackString = resources.customFallbackServers?.joined(separator: ", ")
            upstreamsTextField.text = fallbackString
            
        case .CustomAddress:
            let ipAddress = resources.customBlockingIp?.joined(separator: ", ")
            upstreamsTextField.text = ipAddress
        default:
            break
        }
    }
    
    private func prepareTextFieldDescription() {
        switch upstreamType {
        case .Bootstrap:
            upstreamTypeLabel.text = "Bootstraps"
            textFieldDesciptionLabel.text = "Bootstraps IP address"
            
        case .Fallback:
            upstreamTypeLabel.text = "Fallbacks"
            textFieldDesciptionLabel.text = "Upstream address"
        case .CustomAddress:
            upstreamTypeLabel.text = "Upstreams"
            textFieldDesciptionLabel.text = "Upstream address"
        default:
            break
        }
    }
    
    private func transformToArray(address: String) -> [String] {
        let trimmedAddress = address.trimmingCharacters(in: .whitespaces)
        let ipAddress = trimmedAddress.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        return ipAddress
    }
    
    private func saveUpstream(text: String) {
        var address: [String]?
        if text.count > 0 {
            address = transformToArray(address: text)
        }
        switch upstreamType {
        case .Bootstrap:
            resources.customBootstrapServers = address
        case .Fallback:
            resources.customFallbackServers = address
            delegate?.updateFallbacksDescriptionLabel(text: text)
        case .CustomAddress:
            resources.customBlockingIp = address
            delegate?.updateCustomAddressDescriptionLabel(text: text)
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
