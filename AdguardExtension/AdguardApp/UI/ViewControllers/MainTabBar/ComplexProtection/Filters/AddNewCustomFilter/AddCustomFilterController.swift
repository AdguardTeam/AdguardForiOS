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
import SharedAdGuardSDK
import DnsAdGuardSDK
import SafariAdGuardSDK

enum NewFilterType {
    case safariCustom, dnsCustom
}

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(AddCustomFilterController.self)

final class AddCustomFilterController: BottomAlertController {

    var type: NewFilterType = .safariCustom
    var openUrl: String?
    var openTitle: String?
    weak var delegate: NewCustomFilterDetailsControllerDelegate?

    private let detailsSegueId = "showFilterDetailsSegue"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: RoundRectButton!
    @IBOutlet weak var cancelButton: RoundRectButton!
    @IBOutlet weak var urlTextField: AGTextField!

    @IBOutlet var themableLabels: [ThemableLabel]!

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsFilters: DnsProtectionProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!

    private var enteredUrl: String { urlTextField?.text ?? "" }

    // MARK: - View Controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        urlTextField.delegate = self
        urlTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)

        nextButton.makeTitleTextCapitalized()
        cancelButton.makeTitleTextCapitalized()

        nextButton.applyStandardGreenStyle()
        cancelButton.applyStandardOpaqueStyle()
        nextButton.setBackgroundColor()

        if openUrl != nil {
            urlTextField.text = openUrl
            continueAction(self)
        }
        else {
            urlTextField.becomeFirstResponder()
        }
        updateTheme()
        updateNextButton()
    }

    // MARK: - UITextFieldDelegate

    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlTextField.borderState = .disabled
        urlTextField.resignFirstResponder()
        return true
    }

    // MARK: - Actions

    @IBAction func continueAction(_ sender: Any) {
        let urlString = enteredUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !urlString.isEmpty else {
            return
        }

        nextButton.startIndicator()
        nextButton.isEnabled = false

        if isfilterExist(url: urlString) {
            nextButton.isEnabled = true
            nextButton.stopIndicator()

            presentSimpleAlert(title: nil, message: String.localizedString("filter_exists") , onOkButtonTapped: nil)

            return
        }

        guard let url = URL(string: urlString) else {
            nextButton.isEnabled = true
            nextButton.stopIndicator()
            return
        }

        parse(url: url) { [weak self] in
            self?.nextButton.isEnabled = true
            self?.nextButton.stopIndicator()
        }
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }

    // MARK: - private method

    private func presentNewCustomFilterDetailsController(_ meta: ExtendedCustomFilterMetaProtocol) {
        let presenter = presentingViewController
        dismiss(animated: true) { [weak self] in
            guard let self = self,
                  let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewCustomFilterDetailsController") as? NewCustomFilterDetailsController
            else { return }

            controller.delegate = self.delegate
            let model = NewCustomFilterModel(
                filterName: meta.name ?? "",
                filterType: .safariCustom,
                meta: meta
            )
            controller.newFilterModel = model
            presenter?.present(controller, animated: true, completion: nil)
        }
    }

    private func parse(url: URL, completion: @escaping () -> Void) {
        DispatchQueue(label: "AdGuardApp.AddNewCustomFilterQueue").async { [weak self] in
            let parser = CustomFilterMetaParser()
            do {
                let meta = try parser.getMetaFrom(url: url, for: .safari)
                LOG.info("parse URL; Successfully get meta from url: \(url)")
                DispatchQueue.main.async {
                    completion()
                    self?.presentNewCustomFilterDetailsController(meta)
                }
            } catch {
                LOG.error("parse URL; Failed to get meta from url: \(url); Error: \(error)")
                DispatchQueue.main.async {
                    completion()
                    let errorMessage = String.localizedString("add_custom_filter_error_message")
                    self?.presentSimpleAlert(title: nil, message: errorMessage, onOkButtonTapped: nil)
                }
            }
        }
    }

    private func isfilterExist(url: String) -> Bool {
        switch type {
        case .safariCustom:
            let customFilters = safariProtection.groups.first { $0.groupId == SafariGroup.GroupType.custom.id }?.filters
            return customFilters?.contains { $0.filterDownloadPage == url } ?? false
        case .dnsCustom:
            return dnsFilters.filters.contains { $0.subscriptionUrl.absoluteString == url }
        }
    }

    @objc private final func textFieldEditingChanged(_ sender: UITextField) {
        updateNextButton()
        urlTextField.rightView?.isHidden = enteredUrl.isEmpty
    }

    private func updateNextButton() {
        let url = enteredUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        nextButton.isEnabled = !url.isEmpty
    }
}

// MARK: - AddCustomFilterController + ThemableProtocol

extension AddCustomFilterController: ThemableProtocol {
    func updateTheme() {
        titleLabel.textColor = theme.popupTitleTextColor
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextField(urlTextField)
        nextButton.indicatorStyle = theme.indicatorStyle
        urlTextField.updateTheme()
    }
}
