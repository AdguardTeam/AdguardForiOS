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

final class BugReportController: UIViewController {

    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!

    @IBOutlet weak var emailAddressTextField: AGTextField!
    @IBOutlet weak var emailErrorLabel: UILabel!

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var textViewPlaceholder: UILabel!
    @IBOutlet weak var descriptionTextViewIndicatorView: TextFieldIndicatorView!

    @IBOutlet weak var detailedInfoButton: UIButton!

    @IBOutlet weak var sendButton: RoundRectButton!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet var themableLabels: [ThemableLabel]!

    private var keyboardMover: KeyboardMover?

    // Services
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let supportService: SupportServiceProtocol = ServiceLocator.shared.getService()!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddressTextField.delegate = self

        keyboardMover = KeyboardMover(bottomConstraint: scrollViewBottomConstraint, view: scrollView, tabBar: tabBarController?.tabBar)

        setupToHideKeyboardOnTapOnView(ignoringViews: [emailAddressTextField, emailAddressTextField.rightView, sendButton].compactMap { $0 }) // Tap anywhere to hide keyboard
        setupTextView()

        updateTheme()
        setupBackButton()

        sendButton.applyStandardGreenStyle()
        sendButton.setBackgroundColor()
        sendButton.isEnabled = false

        detailedInfoButton.isSelected = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailAddressTextField.becomeFirstResponder()
    }

    // MARK: - Actions

    @IBAction func detailedInfoButtonTapped(_ sender: UIButton) {
        detailedInfoButton.isSelected = !detailedInfoButton.isSelected
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        sendButton.startIndicator()
        sendButton.isEnabled = false

        let email = (emailAddressTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let isValidEmail = email.isValidEmail() || email.isEmpty

        let description = descriptionTextView.text ?? ""
        let isValidDescription = !description.isEmpty

        if !isValidEmail {
            emailAddressTextField.borderState = .error
            emailErrorLabel.isHidden = false
        }

        if !isValidDescription {
            descriptionTextViewIndicatorView.state = .error
        }

        guard isValidEmail && isValidDescription else {
            DDLogDebug("Mail: \(email); description: \(description)")
            sendButton.stopIndicator()
            sendButton.isEnabled = true
            return
        }

        let shouldSendLogs = detailedInfoButton.isSelected

        supportService.sendFeedback(email, description: description, sendLogs: shouldSendLogs) { logsSentSuccessfully in
            DispatchQueue.main.async { [weak self] in
                self?.sendButton.stopIndicator()
                self?.sendButton.isEnabled = true

                if logsSentSuccessfully {
                    self?.showBugReportSuccessAlert()
                } else {
                    self?.showBugReportFailedAlert()
                }
            }
        }
    }

    // MARK: - Private methods

    private func setupTextView() {
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0.0
        showTextViewPlaceholder()
    }

    private func showTextViewPlaceholder() {
        textViewPlaceholder.isHidden = false
    }

    private func hideTextViewPlaceholder() {
        textViewPlaceholder.isHidden = true
    }

    private func showBugReportFailedAlert() {
        let message = String.localizedString("bug_report_failed_message")
        ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: message)
    }

    private func showBugReportSuccessAlert() {
        let message = String.localizedString("bug_report_successed_message")
        ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: message) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - BugReportController + UITextFieldDelegate

extension BugReportController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string).trimmingCharacters(in: .whitespacesAndNewlines)

        emailAddressTextField.borderState = .enabled
        emailAddressTextField.rightView?.isHidden = updatedText.isEmpty
        sendButton.isEnabled = !updatedText.isEmpty && updatedText.isValidEmail()
        emailErrorLabel.isHidden = true
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailAddressTextField.rightView?.isHidden = (textField.text ?? "").isEmpty
        emailAddressTextField.borderState = .enabled
        emailErrorLabel.isHidden = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let email = textField.text ?? ""
        let isValidEmail = email.isValidEmail() || email.isEmpty
        emailAddressTextField.rightView?.isHidden = email.isEmpty
        emailAddressTextField.borderState = isValidEmail ? .disabled : .error
        emailErrorLabel.isHidden = isValidEmail
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let email = textField.text ?? ""
        if email.isEmpty {
            emailAddressTextField.borderState = .disabled
            emailErrorLabel.isHidden = true
            textField.resignFirstResponder()
        } else if email.isValidEmail() {
            descriptionTextView.becomeFirstResponder()
            emailAddressTextField.borderState = .disabled
        } else {
            emailAddressTextField.borderState = .error
            emailErrorLabel.isHidden = false
            textField.resignFirstResponder()
        }
        return true
    }
}

extension BugReportController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        descriptionTextViewIndicatorView.state = .enabled
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionTextViewIndicatorView.state = .enabled
        if textView.text.isEmpty {
            hideTextViewPlaceholder()
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        descriptionTextViewIndicatorView.state = .disabled
        if textView.text.isEmpty {
            showTextViewPlaceholder()
        }
    }
}

extension BugReportController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupLabels(themableLabels)
        themeService.setupNavigationBar(navigationController?.navigationBar)
        themeService.setupTextField(emailAddressTextField)
        themeService.setupTextView(descriptionTextView)
        textViewPlaceholder.textColor = themeService.placeholderTextColor
        emailAddressTextField.updateTheme()
    }
}
