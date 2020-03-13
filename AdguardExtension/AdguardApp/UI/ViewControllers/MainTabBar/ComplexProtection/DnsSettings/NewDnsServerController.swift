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


class NewDnsServerController: BottomAlertController {
    
    var provider: DnsProviderInfo?
    
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
    
    // MARK: - services
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    let dnsProvidersService: DnsProvidersService =  ServiceLocator.shared.getService()!
    
    // MARK: - view controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        if provider != nil {
            nameField.text = provider?.name
            upstreamsField.text = provider?.servers?.first?.upstreams.first ?? ""
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
            let newProvider = self.dnsProvidersService.addProvider(name: self.nameField.text ?? "", upstreams: [self.upstreamsField.text ?? ""])
            self.dnsProvidersService.activeDnsServer = newProvider.servers?.first
            self.vpnManager.updateSettings(completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        guard let provider = self.provider else { return }
        
        dnsProvidersService.deleteProvider(provider)
        
        if dnsProvidersService.isActiveProvider(provider) {
            dnsProvidersService.activeDnsServer = nil
            vpnManager.updateSettings(completion: nil)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        checkUpstream { [weak self] in
            guard let self = self else { return }
            if self.provider == nil || self.provider?.servers?.first == nil { return }
            self.provider!.name = self.nameField.text ?? ""
            self.provider!.servers?.first!.upstreams = [self.upstreamsField.text ?? ""]
            self.provider!.servers?.first!.name = self.provider!.name
            self.dnsProvidersService.updateProvider(self.provider!)
            
            if self.dnsProvidersService.isActiveProvider(self.provider!) {
                self.dnsProvidersService.activeDnsServer = self.provider?.servers?.first
                self.vpnManager.updateSettings(completion: nil)
            }
            
            self.dismiss(animated: true, completion: nil)
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
        
        let upstream = AGDnsUpstream(address: self.upstreamsField.text, bootstrap: bootstrap, timeoutMs: 2000, serverIp: nil)
        
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
        let correctDns = dnsUrl.checkIfValidDnsServer()
        let enabled = dnsName.count > 0 && correctDns
        
        if !correctDns {
            dnsSeparator.backgroundColor = UIColor(hexString: "#df3812")
        } else {
            dnsSeparator.backgroundColor = UIColor.lightGray
        }
        
        addButton?.isEnabled = enabled
        saveButton?.isEnabled = enabled
    }
}
