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
    var openUpstream: String?
    var openTitle: String?

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

    private let dnsCheckQueue = DispatchQueue(label: "NewDnsServerController.dnsCheckQueue")

    private var name: String { nameField.text ?? "" }
    private var upstream: String { upstreamsField.text ?? "" }

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        upstreamsField.delegate = self

        nameField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        upstreamsField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)

        if let openUpstream = openUpstream {
            // Native DNS implementation doesn't support port syntax
            upstreamsField.text = resources.dnsImplementation == .adGuard ? openUpstream : openUpstream.discardPortFromIpAddress()
        } else {
            upstreamsField.text = model.providerUpstream
        }

        if let openTitle = openTitle {
            nameField.text = openTitle
        } else {
            nameField.text = model.providerName
        }

        nameField.becomeFirstResponder()
        updateTheme()
        configureAlertTitles()

        saveOrAddButton.setBackgroundColor()
        saveOrAddButton.needsToDisplayIndicator = true

        updateSaveButton(for: name, upstream: upstream)
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
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count >= textFieldCharectersLimit, textField === nameField {
            textField.text = String(updatedText.prefix(textFieldCharectersLimit))
            return false
        }
        return true
    }

    // MARK: - Private methods
    private func showWrongProtocolAlert(dnsProtocol: DnsProtocol) {
        let title = String.localizedString("invalid_dns_protocol_title")
        let messageFormat = String.localizedString("invalid_dns_protocol_message")
        let dnsProtocolString = dnsProtocol.localizedName
        let message = String(format: messageFormat, dnsProtocolString)
        presentSimpleAlert(title: title, message: message)
    }

    private func showServerExistsAlert() {
        let message = String.localizedString("custom_dns_server_exists")
        let title = String.localizedString("common_error_title")
        presentSimpleAlert(title: title, message: message)
    }

    private func isCorrectDns(_ dns: String) -> Bool {
        let correctDns = dns.trimmingCharacters(in: .whitespacesAndNewlines).isValidUpstream()
        return correctDns
    }

    private func updateSaveButton(for name: String, upstream: String) {
        let nameIsCorrect = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let upstreamIsCorrect = !upstream.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isCorrectDns(upstream)
        saveOrAddButton.isEnabled = nameIsCorrect && upstreamIsCorrect
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
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let upstream = upstream.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !name.isEmpty && !upstream.isEmpty else {
            return
        }

        saveOrAddButton.isEnabled = false
        saveOrAddButton.startIndicator()

        dnsCheckQueue.async { [weak self] in
            guard
                let self = self,
                let provider = self.model.provider
            else {
                return
            }

            do {
                try self.model.updateCustomProvider(newName: name, newUpstream: upstream, provider: provider)
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true)
                    self?.delegate?.customProviderUpdated()
                }
            } catch let error as CustomDnsProvidersStorageError  {
                DispatchQueue.main.async { [weak self] in
                    self?.processError(error: error)
                }
            }
            catch let error as DnsProvidersManager.DnsProviderError {
                DispatchQueue.main.async { [weak self] in
                    self?.processError(error: error)
                }
            }
            catch {
                DispatchQueue.main.async { [weak self] in
                    self?.showUnknownErrorAlert()
                }
            }

            DispatchQueue.main.async { [weak self] in
                self?.saveOrAddButton.isEnabled = true
                self?.saveOrAddButton.stopIndicator()
            }
        }
    }

    private func addAction() {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let upstream = upstream.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !name.isEmpty && !upstream.isEmpty else {
            return
        }

        saveOrAddButton.isEnabled = false
        saveOrAddButton.startIndicator()

        dnsCheckQueue.async { [weak self] in
            guard let self = self else { return }

            do {
                try self.model.addCustomProvider(name: name, upstream: upstream)
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.customProviderUpdated()
                    self?.dismiss(animated: true)
                }
            } catch let error as CustomDnsProvidersStorageError  {
                DispatchQueue.main.async { [weak self] in
                    self?.processError(error: error)
                }
            }
            catch let error as DnsProvidersManager.DnsProviderError {
                DispatchQueue.main.async { [weak self] in
                    self?.processError(error: error)
                }
            }
            catch {
                DispatchQueue.main.async { [weak self] in
                    self?.showUnknownErrorAlert()
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.saveOrAddButton.isEnabled = true
                self?.saveOrAddButton.stopIndicator()
            }
        }
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

    private func processError(error: DnsProvidersManager.DnsProviderError) {
        switch error {
        case .dnsProviderExists(_):
            showServerExistsAlert()
            upstreamsField.borderState = .error
        default:
            showUnknownErrorAlert()
        }
    }

    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        if sender === nameField {
            nameField.borderState = .enabled
            nameField.rightView?.isHidden = name.isEmpty
        } else {
            upstreamsField.borderState = isCorrectDns(upstream) || upstream.isEmpty ? .enabled : .error
            upstreamsField.rightView?.isHidden = upstream.isEmpty
        }
        updateSaveButton(for: name, upstream: upstream)
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
