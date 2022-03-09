//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import CoreServices
import SafariAdGuardSDK

/// This screen is the Action Extension itself. It contains UI elements for manipulating user rules data in place
final class ActionExtensionTableController: UITableViewController {

    // MARK: - UI Elements

    @IBOutlet weak var faviconImageView: UIImageView!
    @IBOutlet weak var domainLabel: ThemableLabel!
    @IBOutlet weak var protectionSwitch: UISwitch!
    @IBOutlet var themableLabels: [ThemableLabel]!

    var model: Model!

    // MARK: - Private variables

    private var newProtectionState: Bool = false
    private let toggleProtectionQueue = DispatchQueue(label: "ActionExtensionTableController.toggleProtectionQueue", qos: .utility)

    private let themeService = ServicesInitializer.shared.themeService
    private let configuration = ServicesInitializer.shared.configuration
    private let resources = ServicesInitializer.shared.resources
    private let safariProtection = ServicesInitializer.shared.safariProtection

    private let protectionStateRow = 0
    private let blockElementRow = 1
    private let reportProblemRow = 2

    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        newProtectionState = model.isSafariProtectionEnabled
        faviconImageView.image = model.icon
        domainLabel.text = model.domain
        protectionSwitch.isOn = model.isSafariProtectionEnabled
        updateTheme()
        checkContentBlockersState()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        faviconImageView.layer.cornerRadius = faviconImageView.frame.height / 2
        faviconImageView.layer.masksToBounds = true
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOSApplicationExtension 13.0, *) {
            guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else {
                return
            }
            configuration.systemAppearenceIsDark = systemStyleIsDark
            updateTheme()
        }
    }

    // MARK: - Actions

    @IBAction func protectionStateChanged(_ sender: UISwitch) {
        let newEnabled = sender.isOn
        changeProtectionState(to: newEnabled)
    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        let extensionItem = NSExtensionItem()
        let reload = newProtectionState != model.isSafariProtectionEnabled
        let itemProvider: NSItemProvider = NSItemProvider(
            item: [NSExtensionJavaScriptFinalizeArgumentKey: ["needReload": "\(reload)"]] as NSSecureCoding,
            typeIdentifier: String(kUTTypePropertyList)
        )

        extensionItem.attachments?.append(itemProvider)
        extensionContext?.completeRequest(returningItems: [extensionItem], completionHandler: nil)
    }

    // MARK: - Tableview delegates

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        themeService.setupTableCell(cell)
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        switch indexPath.row {
        case protectionStateRow:
            let newEnabled = !protectionSwitch.isOn
            protectionSwitch.setOn(newEnabled, animated: true)
            changeProtectionState(to: newEnabled)
        case blockElementRow: blockElement()
        case reportProblemRow: reportProblem()
        default: return
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return createInfoView()
    }

    // MARK: - Private methods

    private func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupLabels(themableLabels)
        themeService.setupTable(tableView)
        tableView.reloadData()
    }

    /// Changes current page protection state
    private func changeProtectionState(to enabled: Bool) {
        toggleProtectionQueue.async {
            // This closure will continue executing for 30 seconds even if user closes the extension
            ProcessInfo().performExpiringActivity(withReason: "Loading JSONs to CB") { [weak self] expired in
                guard let self = self, !expired, enabled != self.newProtectionState else { return }

                let helper = ActionExtensionUserRulesHelper(domain: self.model.domain, safariProtection: self.safariProtection)
                let allowlistIsInverted = self.resources.invertedWhitelist

                // When rule is in allowlist it means that protection won't be applied to current domain
                // If rule is in inverted allowlist that means that all other domains are in the allowlist

                let successfullyChangedState: Bool
                if allowlistIsInverted {
                    if enabled {
                        let (success, overlimit) = helper.addDomainToInvertedAllowlist()
                        successfullyChangedState = success
                        if overlimit { self.showOverLimitAlert() }
                    } else {
                        let success = helper.removeDomainFromInvertedAllowlist()
                        successfullyChangedState = success
                    }
                } else {
                    if enabled {
                        let success = helper.removeDomainFromAllowlist()
                        successfullyChangedState = success
                    } else {
                        let (success, overlimit) = helper.addDomainToAllowlist()
                        successfullyChangedState = success
                        if overlimit { self.showOverLimitAlert() }
                    }
                }
                // Set new state for protection
                if successfullyChangedState { self.newProtectionState = enabled }
            }
        }
    }

    /// Presents alert to notify user about overlimit
    private func showOverLimitAlert() {
        DispatchQueue.main.async { [weak self] in
            let title = String.localizedString("common_error_title")
            let message = String.localizedString("filter_rules_maximum")
            self?.presentSimpleAlert(title: title, message: message, onOkButtonTapped: nil)
        }
    }

    /// Calls JS script for precise element blocking on the current WEB page
    private func blockElement() {
        guard model.isJsInjectSupported else {
            let title = String.localizedString("common_error_title")
            let message = String.localizedString("assistant_launching_unable")
            presentSimpleAlert(title: title, message: message, onOkButtonTapped: nil)
            return
        }

        let extensionItem = NSExtensionItem()
        let settings = ["urlScheme": Bundle.main.appScheme]
        let itemProvider: NSItemProvider = NSItemProvider(
            item: [NSExtensionJavaScriptFinalizeArgumentKey: ["blockElement": NSNumber(value: 1), "settings": settings]] as NSSecureCoding,
            typeIdentifier: String(kUTTypePropertyList)
        )

        extensionItem.attachments = [itemProvider]
        extensionContext?.completeRequest(returningItems: [extensionItem], completionHandler: nil)
    }

    /// Constructs report URL and opens our special WEB page for reporting
    private func reportProblem() {
        let safariProtection = ServicesInitializer.shared.safariProtection
        let reporter = ActionExtensionWebReporter(url: model.url, safariProtection: safariProtection)
        let url = reporter.createUrl()
        openWithUrl(url)
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    /// Notify user if not all content blockers are enabled
    private func checkContentBlockersState() {
        if !configuration.allContentBlockersEnabled {
            let title = String.localizedString("common_warning_title")
            let message = String.localizedString("content_blocker_disabled_format")
            presentSimpleAlert(title: title, message: message, onOkButtonTapped: nil)
        }
    }

    /// This method is a hack for opening URL from extension
    private func openWithUrl(_ url: URL) {
        var responder: UIResponder? = self
        let selector = sel_registerName("openURL:")
        while responder != nil{
            if responder?.responds(to: selector) ?? false {
                responder?.perform(selector, with: url)
            }
            responder = responder?.next
        }
    }

    /// Info view with message that action extension is old feature
    private func createInfoView() -> UIView {
        let view = UIView()
        let containerView = UIView()
        let label = ThemableLabel()

        containerView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerView)
        containerView.addSubview(label)

        containerView.backgroundColor = themeService.selectedCellColor
        containerView.layer.cornerRadius = 4
        label.greyText = true
        label.lightGreyText = false
        label.font = .systemFont(ofSize: isIpadTrait ? 24.0 : 16.0)
        themeService.setupLabel(label)
        label.numberOfLines = 0

        if #available(iOS 15, *) {
            label.text = String.localizedString("action_extension_obsolete_info")
        } else {
            label.text = String.localizedString("action_extension_new_version_info")
        }

        label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12.0).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12.0).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12.0).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12.0).isActive = true

        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true

        return view
    }
}

// MARK: - ActionExtensionTableController + Model

extension ActionExtensionTableController {
    struct Model {
        let icon: UIImage?
        let url: URL
        let domain: String
        let isJsInjectSupported: Bool
        let isSafariProtectionEnabled: Bool

        init(context: Context, isSafariProtectionEnabled: Bool) {
            self.icon = context.icon
            self.url = context.url
            self.domain = context.domain
            self.isJsInjectSupported = context.isJsInjectSupported
            self.isSafariProtectionEnabled = isSafariProtectionEnabled
        }
    }
}
