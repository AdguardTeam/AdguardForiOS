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

import DnsAdGuardSDK

/// Protocol for delegate
protocol NewDnsServerControllerDelegate: AnyObject {
    func customProviderUpdated()
}

/// Enum with controller states
enum DnsServerControllerType {
    case add, edit
}

/// Controller that provide managing custom providers
final class NewDnsServerController: BottomAlertController {

    struct CustomDnsProviderInfo {
        let name: String
        let upstream: String
        let selectAsCurrent: Bool
        let provider: CustomDnsProviderProtocol?
    }

    // MARK: - Public properties

    var controllerType: DnsServerControllerType = .add
    var dnsProviderManager: DnsProvidersManagerProtocol!
    var customDnsProvider: CustomDnsProviderProtocol?
    var openUrl: String?

    weak var delegate: NewDnsServerControllerDelegate?

    // MARK: - IB Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var themableLabels: [ThemableLabel]!

    @IBOutlet weak var saveOrAddButton: RoundRectButton!
    @IBOutlet weak var cancelOrDeleteButton: RoundRectButton!

    @IBOutlet weak var nameField: AGTextField!
    @IBOutlet weak var upstreamsField: AGTextField!

    @IBOutlet weak var scrollContentView: UIView!

    // MARK: - Services

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let dnsConfigAssistant: DnsConfigManagerAssistantProtocol = ServiceLocator.shared.getService()!

    // MARK: - Private properties

    private let textFieldCharectersLimit = 50
    private lazy var model: NewDnsServerModel = {
        return NewDnsServerModel(dnsProvidersManager: dnsProviderManager, dnsConfigAssistant: dnsConfigAssistant, provider: customDnsProvider)
    }()

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        upstreamsField.delegate = self

        if let openUrl = openUrl {
            // Native DNS implementation doesn't support port syntax
            upstreamsField.text = resources.dnsImplementation == .adGuard ? openUrl : openUrl.discardPortFromIpAddress()
        } else {
            nameField.text = model.providerName
            upstreamsField.text = model.providerUpstream
        }

        nameField.becomeFirstResponder()
        updateSaveButton(upstreamsField.text ?? "")
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

    // MARK: - textfield delegate methods

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if textField === nameField {
            nameField.borderState = .enabled
            nameField.rightView?.isHidden = updatedText.isEmpty
        } else {
            upstreamsField.borderState = isCorrectDns(updatedText) || updatedText.isEmpty ? .enabled : .error
            upstreamsField.rightView?.isHidden = updatedText.isEmpty
        }
        updateSaveButton(updatedText)

        if updatedText.count >= textFieldCharectersLimit, textField === nameField {
            textField.text = String(updatedText.prefix(textFieldCharectersLimit))
            return false
        }

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? AGTextField else {
            return
        }
        textField.rightView?.isHidden = (textField.text ?? "").isEmpty
        textField.borderState = .enabled
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = textField as? AGTextField else {
            return
        }
        textField.rightView?.isHidden = (textField.text ?? "").isEmpty
        textField.borderState = .disabled
    }

    // MARK: - Private methods
    private func showWrongProtocolAlert(dnsProtocol: DnsProtocol) {
        let title = String.localizedString("invalid_dns_protocol_title")
        let messageFormat = String.localizedString("invalid_dns_protocol_message")
        let dnsProtocolString = dnsProtocol.localizedName
        let message = String(format: messageFormat, dnsProtocolString)
        presentSimpleAlert(title: title, message: message)
    }

    private func isCorrectDns(_ dns: String) -> Bool {
        let correctDns = dns.isValidUpstream()
        return correctDns
    }

    private func updateSaveButton(_ dns: String) {
        let dnsName = nameField.text ?? ""
        let enabled = dnsName.trimmingCharacters(in: .whitespaces).count > 0 && isCorrectDns(dns)
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

        saveOrAddButton.makeTitleTextCapitalized()
        cancelOrDeleteButton.makeTitleTextCapitalized()

        saveOrAddButton.applyStandardGreenStyle()
        cancelOrDeleteButton.applyStandardOpaqueStyle(color: cancelOrDeleteButtonColor)
    }

    // MARK: - Button actions

    private func saveAction() {
        saveOrAddButton.isEnabled = false
        saveOrAddButton.startIndicator()

        let name = self.nameField.text ?? ""
        let upstream = self.upstreamsField.text ?? ""

        guard let provider = self.model.provider else { return }

        do {
            try self.model.updateCustomProvider(newName: name, newUpstream: upstream, provider: provider)
            self.dismiss(animated: true)
            self.delegate?.customProviderUpdated()
        } catch {
            if let error = error as? CustomDnsProvidersStorageError {
                self.processError(error: error)
            } else {
                self.showUnknownErrorAlert()
            }
        }

        saveOrAddButton.isEnabled = true
        saveOrAddButton.stopIndicator()
    }

    private func addAction() {
        saveOrAddButton.isEnabled = false
        saveOrAddButton.startIndicator()
        let upstream = self.upstreamsField.text ?? ""

        do {
            try self.model.addCustomProvider(name: self.nameField.text ?? "", upstream: upstream)
            self.delegate?.customProviderUpdated()
            self.dismiss(animated: true)
        } catch {
            if let error = error as? CustomDnsProvidersStorageError {
                self.processError(error: error)
            } else {
                self.showUnknownErrorAlert()
            }
        }

        saveOrAddButton.isEnabled = true
        saveOrAddButton.stopIndicator()
    }

    private func deleteAction() {
        saveOrAddButton.isEnabled = false
        saveOrAddButton.startIndicator()

        guard let provider = model.provider else { return }
        do {
            try self.model.removeCustomProvider(provider: provider)
            self.delegate?.customProviderUpdated()
            self.dismiss(animated: true)
        } catch {
            if let error = error as? CustomDnsProvidersStorageError {
                processError(error: error)
            } else {
                showUnknownErrorAlert()
            }
        }

        saveOrAddButton.isEnabled = true
        saveOrAddButton.stopIndicator()
    }

    private func processError(error: CustomDnsProvidersStorageError) {
        switch error {
        case .providerAbsent(let providerId): break
            //TODO: Show alert
        case .invalidUpstream(let upstream):
            presentSimpleAlert(title: String.localizedString("common_error_title"), message: String.localizedString("invalid_upstream_message"))
        case .differentDnsProtocols(let upstreams): break
            //TODO: Show alert
        case .emptyUpstreams: break
            //TODO: Show alert
        case .notSupportedProtocol(let dnsProtocol, _):
            showWrongProtocolAlert(dnsProtocol: dnsProtocol)
        }
        upstreamsField.borderState = .error
    }
}

// MARK: - NewDnsServerController + ThemableProtocol

extension NewDnsServerController: ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        titleLabel.textColor = theme.popupTitleTextColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextField(nameField)
        theme.setupTextField(upstreamsField)
        saveOrAddButton.indicatorStyle = theme.indicatorStyle
        nameField.updateTheme()
        upstreamsField.updateTheme()
    }
}
