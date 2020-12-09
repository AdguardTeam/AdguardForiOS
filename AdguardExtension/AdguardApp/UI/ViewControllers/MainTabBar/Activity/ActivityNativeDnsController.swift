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

class ActivityNativeDnsController: UIViewController {

    @IBOutlet weak var dnsStatusLabel: ThemableLabel!
    @IBOutlet weak var dnsNameLabel: ThemableLabel!
    @IBOutlet weak var dnsProtocolLabel: ThemableLabel!
    @IBOutlet weak var implementationButton: UIButton!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    
    // MARK: - services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let nativeProviders: NativeProvidersServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - observers
    private var themeObserver: NotificationToken?
    private var currentDnsServerObserver: NotificationToken?
    private var systemProtectionChangeObserver: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        implementationButton.makeTitleTextUppercased()
        implementationButton.applyStandardGreenStyle()
        updateTheme()
        setupLabels()
        addObservers()
    }
    
    @IBAction func implementationButtonTapped(_ sender: UIButton) {
        _ = AppDelegate.shared.presentDnsSettingsController()
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupSeparators(separators)
    }
    
    private func setupLabels() {
        dnsStatusLabel.text = nativeProviders.managerIsEnabled ? String.localizedString("on_state") : String.localizedString("off_state")
        dnsNameLabel.text = nativeProviders.currentProvider?.name
        
        if let dnsProtocol = nativeProviders.currentServer?.dnsProtocol {
            let stringId = DnsProtocol.stringIdByProtocol[dnsProtocol] ?? ""
            dnsProtocolLabel.text = String.localizedString(stringId)
        }
    }
    
    private func addObservers() {
        themeObserver = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        currentDnsServerObserver = NotificationCenter.default.observe(name: .currentDnsServerChanged, object: nil, queue: .main) { [weak self] _ in
            self?.setupLabels()
        }
        
        systemProtectionChangeObserver = NotificationCenter.default.observe(name: ComplexProtectionService.systemProtectionChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.setupLabels()
        }
    }
}
