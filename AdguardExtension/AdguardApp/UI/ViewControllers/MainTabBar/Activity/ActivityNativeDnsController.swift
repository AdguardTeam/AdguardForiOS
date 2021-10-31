///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///

import UIKit
import DnsAdGuardSDK

final class ActivityNativeDnsController: UIViewController {

    @IBOutlet weak var dnsStatusLabel: ThemableLabel!
    @IBOutlet weak var dnsNameLabel: ThemableLabel!
    @IBOutlet weak var dnsProtocolLabel: ThemableLabel!
    @IBOutlet weak var implementationButton: UIButton!

    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!

    // MARK: - services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let nativeDnsManager: NativeDnsSettingsManagerProtocol = ServiceLocator.shared.getService()!
    private let dnsProvidersManager: DnsProvidersManagerProtocol = ServiceLocator.shared.getService()!

    // MARK: - observers
    private var currentDnsServerObserver: NotificationToken?
    private var systemProtectionChangeObserver: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        implementationButton.makeTitleTextCapitalized()
        implementationButton.applyStandardGreenStyle()
        updateTheme()
        setupLabels()
        addObservers()
    }

    @IBAction func implementationButtonTapped(_ sender: UIButton) {
        AppDelegate.shared.presentDnsSettingsController()
    }

    private func setupLabels() {
        dnsStatusLabel.text = nativeDnsManager.dnsConfigIsEnabled ? String.localizedString("on_state") : String.localizedString("off_state")
        dnsNameLabel.text = dnsProvidersManager.activeDnsProvider.name
        dnsProtocolLabel.text = dnsProvidersManager.activeDnsServer.type.localizedName
    }

    private func addObservers() {

        currentDnsServerObserver = NotificationCenter.default.observe(name: .currentDnsServerChanged, object: nil, queue: .main) { [weak self] _ in
            self?.setupLabels()
        }

        systemProtectionChangeObserver = NotificationCenter.default.observe(name: ComplexProtectionService.systemProtectionChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.setupLabels()
        }
    }
}

extension ActivityNativeDnsController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupSeparators(separators)
    }
}
