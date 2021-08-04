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

enum DnsServerControllerType {
    case add, edit
}

class NewDnsServerController: BottomAlertController {
    
    var controllerType: DnsServerControllerType = .add
    var provider: DnsProviderInfo?
    var openUrl: String?
    
    weak var delegate: NewDnsServerControllerDelegate?
    
    // MARK: - IB Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    @IBOutlet weak var saveOrAddButton: RoundRectButton!
    @IBOutlet weak var cancelOrDeleteButton: RoundRectButton!
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var upstreamsField: UITextField!
    
    @IBOutlet weak var nameFieldSeparator: TextFieldIndicatorView!
    @IBOutlet weak var dnsSeparator: TextFieldIndicatorView!
    
    @IBOutlet weak var scrollContentView: UIView!
    
    private let textFieldCharectersLimit = 50
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    private let dnsProvidersService: DnsProvidersServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - view controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if provider != nil {
            nameField.text = String(provider?.name.prefix(textFieldCharectersLimit) ?? "")
            upstreamsField.text = provider?.servers?.first?.upstreams.first ?? ""
        }
        else if openUrl != nil {
            if resources.dnsImplementation == .adGuard {
                upstreamsField.text = openUrl
            } else {
                // Native DNS implementation doesn't support port syntax
                upstreamsField.text = openUrl?.discardPortFromIpAddress()
            }
        }
        
        nameField.becomeFirstResponder()
        updateSaveButton()
        updateTheme()
        configureAlertTitles()
    }
    
    // MARK: - IBActions
    @IBAction func saveOrAddAction(_  sender: Any) {
        switch controllerType {
            case .add:
                addAction()
            case .edit:
                saveAction()
        }
    }
    
    @IBAction func cancelOrDeleteAction(_ sender: Any) {
        switch controllerType {
        case .add:
            dismiss(animated: true)
        case .edit:
            deleteAction()
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
        
        saveOrAddButton.isEnabled = false
        saveOrAddButton.startIndicator()
        
        // TODO: - Make it in a proper way after refactoring
        
        var bootstraps: [String] = []
        
        ACNIPUtils.enumerateSystemDns { (ip, _, _, _) in
            bootstraps.append(ip ?? "")
        }
        
        // If our Tunnel appears in system bootstraps we should remove it
        let tunnelIpV4 = "198.18.0.1"
        let tunnelIpV6 = "2001:ad00:ad00::ad00"
        bootstraps.removeAll(where: { $0 == tunnelIpV4 || $0 == tunnelIpV6 })
        
        // If bootstraps are empty after removing our tunnel
        // Than we add AdGuard Non-filtering DNS
        if bootstraps.isEmpty {
            bootstraps.append("94.140.14.140")
            bootstraps.append("94.140.14.141")
            bootstraps.append("2a10:50c0::1:ff")
            bootstraps.append("2a10:50c0::2:ff")
        }
        
        let upstream = AGDnsUpstream(address: self.upstreamsField.text, bootstrap: bootstraps, timeoutMs: 2000, serverIp: Data(), id: 0, outboundInterfaceName: nil)
        
        DispatchQueue(label: "save dns queue").async { [weak self] in
            guard let self = self else { return }
            
            let isIpv6Available = ACNIPUtils.isIpv6Available()
            
            DDLogInfo("(NewDnsServerController) test upstream: \(upstream?.address ?? "nil") bootstrap: \(upstream?.bootstrap ?? []) ipv6: \(isIpv6Available)")
            
            let error = AGDnsUtils.test(upstream, ipv6Available: isIpv6Available)
            
            DispatchQueue.main.async {
                
                self.saveOrAddButton.isEnabled = true
                self.saveOrAddButton.stopIndicator()
                
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === nameField {
            nameFieldSeparator.state = .enabled
        } else {
            dnsSeparator.state = .enabled
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === nameField {
            nameFieldSeparator.state = .disabled
        } else {
            dnsSeparator.state = .disabled
        }
    }

    
    // MARK: - private methods
    
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
        saveOrAddButton.isEnabled = enabled
    }
    
    private func configureAlertTitles() {
        let alertTitle: String
        let saveOrAddButtonTitle: String
        let cancelOrDeleteButtonTitle: String
        let cancelOrDeleteButtonColor: UIColor
        switch controllerType {
        case .add:
            saveOrAddButtonTitle = String.localizedString("save_and_select_button_title")
            cancelOrDeleteButtonTitle = String.localizedString("cancel_button_title")
            cancelOrDeleteButtonColor = UIColor.AdGuardColor.lightGray4
            alertTitle = String.localizedString("add_dns_server_alert_title")
        case .edit:
            saveOrAddButtonTitle = String.localizedString("save_button_title")
            cancelOrDeleteButtonTitle = String.localizedString("delete_button_title")
            cancelOrDeleteButtonColor = UIColor.AdGuardColor.red
            alertTitle = String.localizedString("edit_dns_server_alert_title")
        }
        
        titleLabel.text = alertTitle
        saveOrAddButton.setTitle(saveOrAddButtonTitle, for: .normal)
        cancelOrDeleteButton.setTitle(cancelOrDeleteButtonTitle, for: .normal)
        saveOrAddButton.makeTitleTextUppercased()
        cancelOrDeleteButton.makeTitleTextUppercased()
        
        saveOrAddButton.applyStandardGreenStyle()
        cancelOrDeleteButton.applyStandardOpaqueStyle(color: cancelOrDeleteButtonColor)

    }
    
    
    //MARK: Button actions
    
    private func saveAction() {
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
    
    private func deleteAction() {
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
    
    private func addAction() {
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
}

extension NewDnsServerController: ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        titleLabel.textColor = theme.popupTitleTextColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextField(nameField)
        theme.setupTextField(upstreamsField)
        saveOrAddButton.indicatorStyle = theme.indicatorStyle
    }
}
