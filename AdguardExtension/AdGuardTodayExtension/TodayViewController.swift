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
import NotificationCenter
import NetworkExtension

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var safariSwitchOutlet: UISwitch!
    @IBOutlet weak var systemSwitchOutlet: UISwitch!
    
    @IBOutlet weak var safariImageView: AdguardImageView!
    @IBOutlet weak var systemImageView: AdguardImageView!
    
    @IBOutlet weak var safariTitleLabel: UILabel!{
        didSet{
            safariTitleLabel.textColor = .widgetTitleColor
        }
    }
    
    @IBOutlet weak var safariTextLabel: UILabel!{
        didSet{
            safariTextLabel.textColor = .widgetTextColor
        }
    }
    
    @IBOutlet weak var systemTitleLabel: UILabel!{
        didSet{
            systemTitleLabel.textColor = .widgetTitleColor
        }
    }
    
    @IBOutlet weak var systemTextLabel: UILabel!{
        didSet{
            systemTextLabel.textColor = .widgetTextColor
        }
    }
    
    @IBOutlet weak var allTimeStaisticsLabel: UILabel!{
        didSet{
            allTimeStaisticsLabel.textColor = .widgetTitleColor
        }
    }
    
    @IBOutlet weak var requestsLabel: UILabel!{
        didSet{
            requestsLabel.textColor = .widgetTitleColor
        }
    }
    
    @IBOutlet weak var blockedLabel: UILabel!{
        didSet{
            blockedLabel.textColor = .widgetTitleColor
        }
    }
    
    @IBOutlet weak var countersLabel: UILabel!{
        didSet{
            countersLabel.textColor = .widgetTitleColor
        }
    }
    
    @IBOutlet var labels: [UILabel]!{
        didSet{
            labels.forEach({ $0.textColor = .widgetTextColor })
        }
    }

    private let resources: APSharedResources = APSharedResources()
    private var safariService: SafariServiceProtocol?

    private var openSystemProtectionUrl = AE_URLSCHEME + "://systemProtection/"
    
    // MARK: View Controller lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        safariService = SafariService(resources: resources)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        height.constant = extensionContext?.widgetMaximumSize(for: .compact).height ?? 110.0
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        updateWidgetSafari()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWidgetSystem()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        updateWidgetSafari()
        updateWidgetSystem()
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    
        if (activeDisplayMode == .compact) {
            preferredContentSize = maxSize
        }
        else {
            let height:CGFloat = 215.0
            preferredContentSize = CGSize(width: maxSize.width, height: height)
        }
    }

    @IBAction func safariSwitch(_ sender: UISwitch) {
        let enabled = sender.isOn
        resources.safariProtectionEnabled = enabled
        
        safariService?.invalidateBlockingJsons(completion: { (error) in
            if error != nil {
                DDLogError("Error invalidating json from Today Extension")
            } else {
                DDLogInfo("Successfull invalidating of json from Today Extension")
            }
        })
        
        updateWidgetSafari()
    }
    
    @IBAction func systemSwitch(_ sender: UISwitch) {
        let enabled = sender.isOn
        openSystemProtectionUrl += enabled ? "on" : "off"
        
        systemImageView.enabled = enabled
        systemSwitchOutlet.isOn = enabled
        
        openMainApp()
    }
    
    // MARK: Private methods
    
    private func updateWidgetSafari(){
        let safariEnabled = resources.safariProtectionEnabled
        
        safariImageView.enabled = safariEnabled
        safariSwitchOutlet.isOn = safariEnabled
    }
    
    private func updateWidgetSystem(){
        NETunnelProviderManager.loadAllFromPreferences {[weak self] (managers, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.systemSwitchOutlet.isOn = false
                self.systemImageView.enabled = false
                
                DDLogError("(Today Extension) Error loading vpn configuration: \(String(describing: error?.localizedDescription))")
            } else {
                let manager = managers?.first
                let vpnEnabled = manager?.isEnabled ?? false
                
                self.systemSwitchOutlet.isOn = vpnEnabled
                self.systemImageView.enabled = vpnEnabled
            }
        }
    }
    
    private func openMainApp(){
        if let url = URL(string: openSystemProtectionUrl){
            extensionContext?.open(url, completionHandler: { (success) in
                if !success {
                    DDLogError("Error redirecting to app from Today Extension")
                }
            })
        } else {
            DDLogError("Error redirecting to app from Today Extension")
        }
    }
}
