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

class VpnService: VpnServiceProtocol {
    
    var notifier: VpnServiceNotifierDelegate?
    
    var vpnEnabled: Bool {
        get {
            return vpnManager.enabled && vpnManager.vpnInstalled
        }
    }
    
    var currentServerName: String {
        get {
            return getServerName()
        }
    }

    private let vpnManager: APVPNManager
    
    // MARK: - Observers
    
    private var tunnelModeObserver: NSKeyValueObservation?
    private var vpnConfigurationObserver: NotificationToken?
    
    
    init(vpnManager: APVPNManager) {
        self.vpnManager = vpnManager
        
        addObservers()
    }
    
    func turnSystemProtection(to state: Bool, with vc: UIViewController?, completion: @escaping () -> ()) {
        
        let vpnTurner: ()->() = {[weak self] in
            guard let self = self else { return }
            
            if state && !self.vpnManager.vpnInstalled {
                if let VC = vc {
                    self.showConfirmVpnAlert(for: VC, enabled: state)
                }
            }else {
                self.vpnManager.enabled = state
            }
            self.vpnManager.delayedTurn = nil
            completion()
        }
               
        if vpnManager.managerWasLoaded {
            vpnTurner()
        } else {
            vpnManager.delayedTurn = vpnTurner
        }
    }
    
    // MARK: - Private methods
    
    private func addObservers(){
        tunnelModeObserver = vpnManager.observe(\.tunnelMode) { [weak self] (mode, change) in
            guard let self = self else { return }
            self.notifier?.tunnelModeChanged()
        }
        
        vpnConfigurationObserver = NotificationCenter.default.observe(name: NSNotification.Name.APVpnChanged, object: nil, queue: nil) {
            [weak self] (notification) in
            guard let self = self else { return }
            
            self.notifier?.vpnConfigurationChanged(with: self.vpnManager.lastError)
        }
    }
    
    private func getServerName() -> String {
        if vpnManager.isCustomServerActive() {
            return vpnManager.activeDnsServer!.name
        }
        else if vpnManager.activeDnsServer?.dnsProtocol == nil {
            return ACLocalizedString("system_dns_server", nil)
        }
        else {
            let server = vpnManager.activeDnsProvider?.name ?? vpnManager.activeDnsServer?.name ?? ""
            let protocolName = ACLocalizedString(DnsProtocol.stringIdByProtocol[vpnManager.activeDnsServer!.dnsProtocol], nil)
            return "\(server) (\(protocolName))"
        }
    }
    
    private func showConfirmVpnAlert(for vc: UIViewController, enabled: Bool){
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            
            let title: String = ACLocalizedString("vpn_confirm_title", nil)
            let message: String = ACLocalizedString("vpn_confirm_message", nil)
            let okTitle: String = ACLocalizedString("common_action_ok", nil)
            let cancelTitle: String = ACLocalizedString("common_action_cancel", nil)
            let privacyTitle: String = ACLocalizedString("privacy_policy_action", nil)
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: okTitle, style: .default) {(alert) in
                self.vpnManager.enabled = enabled
            }
            
            
            let privacyAction = UIAlertAction(title: privacyTitle, style: .default) { [weak self] (alert) in
                guard let self = self else { return }
                UIApplication.shared.openAdguardUrl(action: "privacy", from: "DnsSettingsController")
                self.notifier?.cancelledAddingVpnConfiguration()
                self.vpnManager.enabled = false
            }
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) {[weak self] (alert) in
                guard let self = self else { return }
                self.notifier?.cancelledAddingVpnConfiguration()
                self.vpnManager.enabled = false
            }
            
            alert.addAction(okAction)
            alert.addAction(privacyAction)
            alert.addAction(cancelAction)
            
            alert.preferredAction = okAction
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
