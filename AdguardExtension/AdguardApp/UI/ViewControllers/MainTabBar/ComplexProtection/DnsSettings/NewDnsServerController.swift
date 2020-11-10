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

protocol NewDnsServerControllerDelegate: class {
    func providerAdded()
    func providerDeleted()
    func providerChanged()
}

class NewDnsServerController: BottomAlertController {
    
    var provider: DnsProviderInfo?
    var openUrl: String?
    
    weak var delegate: NewDnsServerControllerDelegate?
    
    // MARK: - IB Outlets
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    @IBOutlet weak var addButton: RoundRectButton?
    @IBOutlet weak var cancelButton: RoundRectButton?
    @IBOutlet weak var deleteButton: RoundRectButton?
    @IBOutlet weak var saveButton: RoundRectButton?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var upstreamsField: UITextField!
    
    @IBOutlet weak var dnsSeparator: UIView!
    
    @IBOutlet var separators: [UIView]!
    @IBOutlet weak var scrollContentView: UIView!
    
    private var notificationToken: NotificationToken?
    
    private let textFieldCharectersLimit = 50
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    private let dnsProvidersService: DnsProvidersServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - view controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        if provider != nil {
            nameField.text = String(provider?.name.prefix(textFieldCharectersLimit) ?? "")
            upstreamsField.text = provider?.servers?.first?.upstreams.first ?? ""
        }
        else if openUrl != nil {
            upstreamsField.text = openUrl
        }
        
        nameField.becomeFirstResponder()
        updateSaveButton()
        updateTheme()
        
        addButton?.makeTitleTextUppercased()
        cancelButton?.makeTitleTextUppercased()
        deleteButton?.makeTitleTextUppercased()
        saveButton?.makeTitleTextUppercased()
    }
    
    // MARK: - Actions
    
    @IBAction func addAction(_ sender: Any) {
        checkUpstream { [weak self] in
            guard let self = self else { return }
            
            let upstream = self.upstreamsField.text ?? ""
            let isValidProtocol = self.checkForValidNativeImplementationProtocol(upstream: upstream)
            
            if !isValidProtocol {
                return
            }
            
            self.dnsProvidersService.addCustomProvider(name: self.nameField.text ?? "", upstream: upstream) { [weak self] in
                self?.vpnManager.updateSettings(completion: nil)
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.providerAdded()
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        guard let provider = self.provider else { return }
        
        dnsProvidersService.deleteProvider(provider) { [weak self] in
            guard let self = self else { return }
            if self.dnsProvidersService.isActiveProvider(provider) {
                self.dnsProvidersService.activeDnsServer = nil
                self.vpnManager.updateSettings(completion: nil)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.providerDeleted()
                self?.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        checkUpstream { [weak self] in
            guard let self = self else { return }
            
            guard let provider = self.provider, let server = self.provider?.servers?.first else { return }
            
            let upstream = self.upstreamsField.text ?? ""
            provider.name = self.nameField.text ?? ""
            server.upstreams = [upstream]
            server.name = self.provider!.name
            server.dnsProtocol = DnsProtocol.getProtocolByUpstream(upstream)
            
            let isValidProtocol = self.checkForValidNativeImplementationProtocol(upstream: upstream)
            
            if !isValidProtocol {
                return
            }
            
            self.dnsProvidersService.updateProvider(provider) { [weak self] in
                guard let self = self else { return }
                
                if self.dnsProvidersService.isActiveProvider(provider) {
                    self.dnsProvidersService.activeDnsServer = provider.servers?.first
                    self.vpnManager.updateSettings(completion: nil)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.providerChanged()
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func checkForValidNativeImplementationProtocol(upstream: String) -> Bool {
        if resources.dnsImplementation == .adGuard { return true }
        
        let dnsProtocol = DnsProtocol.getProtocolByUpstream(upstream)
        if NativeProvidersService.supportedProtocols.contains(dnsProtocol) {
            return true
        } else {
            let title = String.localizedString("invalid_dns_protocol_title")
            let messageFormat = String.localizedString("invalid_dns_protocol_message")
            let dnsProtocolString = String.localizedString(DnsProtocol.stringIdByProtocol[dnsProtocol]!)
            let message = String(format: messageFormat, dnsProtocolString)
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: title, message: message)
            return false
        }
    }
    
    private func checkUpstream(success:@escaping ()->Void) {
        
        addButton?.isEnabled = false
        addButton?.startIndicator()
        saveButton?.isEnabled = false
        saveButton?.startIndicator()
        
        var bootstrap:[String] = []
        
        ACNIPUtils.enumerateSystemDns { (ip, _, _, _) in
            bootstrap.append(ip ?? "")
        }
        
        let upstream = AGDnsUpstream(address: self.upstreamsField.text, bootstrap: bootstrap, timeoutMs: 2000, serverIp: Data(), id: 0, outboundInterfaceName: nil)
        
        DispatchQueue(label: "save dns queue").async { [weak self] in
            guard let self = self else { return }
            
            let error = AGDnsUtils.test(upstream)
            
            DispatchQueue.main.async {
                
                self.addButton?.isEnabled = true
                self.addButton?.stopIndicator()
                self.saveButton?.isEnabled = true
                self.saveButton?.stopIndicator()
                
                if error == nil {
                    success()
                }
                else {
                    DDLogError("(NewDnsServerController) saveAction error - \(error!)")
                    ACSSystemUtils.showSimpleAlert(for: self, withTitle: String.localizedString("common_error_title"), message: String.localizedString("invalid_upstream_message"))
                }
            }
        }
    }
    
    // MARK: - textfield delegate methods
    
    @IBAction func editingChanged(_ sender: Any) {
        updateSaveButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != nameField { return true }
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if  updatedText.count >= textFieldCharectersLimit {
            textField.text = String(updatedText.prefix(textFieldCharectersLimit))
            return false
        }
        return true
    }

    
    // MARK: - private methods
    
    private func updateTheme() {
        scrollContentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextField(nameField)
        theme.setupTextField(upstreamsField)
        addButton?.indicatorStyle = theme.indicatorStyle
        saveButton?.indicatorStyle = theme.indicatorStyle
        for separator in separators {
            separator.backgroundColor = theme.separatorColor
        }
    }
    
    private func updateSaveButton() {
        let dnsName = nameField.text ?? ""
        let dnsUrl = upstreamsField.text ?? ""
        let correctDns = dnsUrl.isValidUpstream()
        let enabled = dnsName.count > 0 && correctDns
        
        if !correctDns && !dnsUrl.isEmpty {
            dnsSeparator.backgroundColor = UIColor(hexString: "#df3812")
        } else {
            dnsSeparator.backgroundColor = UIColor.lightGray
        }
        
        addButton?.isEnabled = enabled
        saveButton?.isEnabled = enabled
    }
}
