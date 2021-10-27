//
//  MainController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 5/11/21.
//

import UIKit
import Network
import NetworkExtension
import CoreData
import WebKit
import AudioToolbox
import UserNotifications

class MainController:UIViewController{
    @IBOutlet weak var btn_vpn: UIButton!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let complexProtection: ComplexProtectionServiceProtocol = ServiceLocator.shared.getService()!
    private let nativeProviders: NativeProvidersServiceProtocol = ServiceLocator.shared.getService()!
    @IBAction func btn_active(_ sender: UIButton) {
        let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
        let userid = "12345678987"
        let upstream = DOMAIN_NORMAL + userid.lowercased()
        let dnsProvidersService: DnsProvidersServiceProtocol = ServiceLocator.shared.getService()!
        dnsProvidersService.addVisafeVPN(name: "Visafe", upstream: upstream) { [weak self] in
            vpnManager.updateSettings(completion: nil)
        }
        if complexProtection.systemProtectionEnabled{
            self.complexProtection.switchSystemProtection(state: false, for: self) { [weak self] _ in
                DispatchQueue.main.async {
                }
            }
        }
        else
        {
            self.complexProtection.switchSystemProtection(state: true, for: self) { [weak self] _ in
            DispatchQueue.main.async {
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
