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

protocol AddDomainToListDelegate: AnyObject {
    /**
     Adds domain or a rule to blacklist / whitelist

     - Parameters:
        - domain: the domain to add to list.
        - type: type of domain blacklist / whitelist.
     */
    func add(domain: String, by type: DnsLogButtonType)
}

protocol DnsRequestDetailsContainerControllerDelegate: AnyObject {
    func userStatusChanged()
}

final class DnsRequestDetailsContainerController: UIViewController, AddDomainToListDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: BottomShadowView!

    var model: DnsRequestDetailsViewModel!
    weak var delegate: DnsRequestDetailsContainerControllerDelegate?

    private var blockRequestControllerId = "BlockRequestControllerId"

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let domainConverter: DomainConverterProtocol = DomainConverter()
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsProtection: DnsProtectionProtocol = ServiceLocator.shared.getService()!

    private var advancedModeObserver: NotificationToken?

    private var detailsController: DnsRequestDetailsController?

    // MARK: - view controller life cycle

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DnsRequestDetailsController {
            destinationVC.model = model
            destinationVC.shadowView = shadowView
            destinationVC.containerController = self
            detailsController = destinationVC
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        advancedModeObserver = NotificationCenter.default.observe(name: .advancedModeChanged, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateButtons()
        })

        updateButtons()

        setupBackButton()
        updateTheme()
    }

    // MARK: - AddDomainToListDelegate method

    func add(domain: String, by type: DnsLogButtonType) {
        do {
            if type == .addDomainToAllowList {
                try model.addDomainToAllowlist(domain)
            } else if type == .addRuleToUserFlter {
                try model.addDomainToUserRules(domain)
            }
        }
        catch {
            self.showUnknownErrorAlert()
        }
        updateUserStatus()
    }

    // MARK: - private methods

    private func updateButtons() {
        shadowView.isHidden = !configuration.advancedMode

        if !configuration.advancedMode {
            shadowView.buttons = []
            return
        }

        let buttons = model.logRecord.getButtons().map{ [weak self] (type) -> BottomShadowButton in
            guard let self = self else { return BottomShadowButton() }
            let button = BottomShadowButton()
            let title = type.buttonTitle.uppercased()
            var color: UIColor!

            switch (type) {
            case .addRuleToUserFlter:
                color = UIColor.AdGuardColor.red
                button.action = {
                    self.presentBlockRequestController(with: self.model.logRecord.event.domain, type: type, delegate: self)
                }

            case .removeDomainFromWhitelist:
                color = UIColor.AdGuardColor.red
                button.action = {
                    do {
                        try self.model.removeFromAllowlist()
                    }
                    catch {
                        self.showUnknownErrorAlert()
                    }
                    self.updateUserStatus()
                }

            case .removeRuleFromUserFilter:
                color = UIColor.AdGuardColor.lightGreen1
                button.action = {
                    do {
                        try self.model.removeFromUserRules()
                    }
                    catch {
                        self.showUnknownErrorAlert()
                    }
                    self.updateUserStatus()
                }

            case .addDomainToAllowList:
                color = UIColor.AdGuardColor.lightGreen1
                button.action = {
                    self.presentBlockRequestController(with: self.model.logRecord.event.domain, type: type, delegate: self)
                }
            }

            button.title = title
            button.titleColor = color

            return button
        }

        shadowView.buttons = buttons
    }

    private func updateUserStatus() {
        self.updateButtons()
        detailsController?.updateStatusLabel()
        delegate?.userStatusChanged()
    }
}

extension DnsRequestDetailsContainerController: ThemableProtocol {
    func updateTheme() {
        theme.setupNavigationBar(navigationController?.navigationBar)
        view.backgroundColor = theme.backgroundColor
        shadowView.updateTheme()
    }
}
