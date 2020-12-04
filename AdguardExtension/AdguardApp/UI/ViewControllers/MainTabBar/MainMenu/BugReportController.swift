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

class BugReportController: UIViewController {
    
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var emailTextFieldIndicatorView: TextFieldIndicatorView!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var textViewPlaceholder: UILabel!
    @IBOutlet weak var descriptionTextViewIndicatorView: TextFieldIndicatorView!
    
    @IBOutlet weak var detailedInfoView: UIView!
    @IBOutlet weak var detailedInfoButton: UIButton!
    @IBOutlet weak var detailedInfoViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var optionalSpace: NSLayoutConstraint!
    
    @IBOutlet weak var sendButton: RoundRectButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private var keyboardMover: KeyboardMover?
    
    // Services
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let supportService: SupportServiceProtocol = ServiceLocator.shared.getService()!
    
    private var themeToken: NotificationToken?
    
    var reportType: ReportType = .bugReport
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardMover = KeyboardMover(bottomConstraint: scrollViewBottomConstraint, view: scrollView, tabBar: tabBarController?.tabBar)
        
        setupToHideKeyboardOnTapOnView() // Tap anywhere to hide keyboard
        setupTextView()
        processReportType()
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: .main) {[weak self] _ in
            self?.updateTheme()
        }
        updateTheme()
        setupBackButton()
    }
    
    // MARK: - Actions
    
    @IBAction func detailedInfoButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        sendButton.startIndicator()
        
        let email = emailAddressTextField.text ?? ""
        let isValidEmail = email.isValidEmail() || email.isEmpty
        
        let description = descriptionTextView.text ?? ""
        let isValidDescription = !description.isEmpty
        
        if !isValidEmail {
            emailTextFieldIndicatorView.state = .error
            emailErrorLabel.isHidden = false
        }
        
        if !isValidDescription {
            descriptionTextViewIndicatorView.state = .error
        }
        
        guard isValidEmail && isValidDescription else {
            DDLogDebug("Mail: \(email); description: \(description)")
            sendButton.stopIndicator()
            return
        }
        
        let shouldSendLogs = detailedInfoButton.isSelected
        
        supportService.sendFeedback(email, description: description, reportType: reportType, sendLogs: shouldSendLogs) { logsSentSuccessfully in
            DispatchQueue.main.async { [weak self] in
                self?.sendButton.stopIndicator()
                
                if logsSentSuccessfully {
                    self?.showBugReportSuccessAlert()
                } else {
                    self?.showBugReportFailedAlert()
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func processReportType() {
        titleLabel.text = reportType == .bugReport ? String.localizedString("bug_report_title") : String.localizedString("leave_feedback_title")
        
        if reportType == .bugReport {
            descriptionLabel.text = String.localizedString("bug_report_description")
        } else {
            let feedbackFormat = String.localizedString("leave_feedback_description_format")
            let appName = Bundle.main.applicationName
            descriptionLabel.text = String(format: feedbackFormat, appName)
        }
        
        sendButton.setTitle(reportType == .bugReport ? String.localizedString("bug_report_button_title") : String.localizedString("leave_feedback_button_title"), for: .normal)

        sendButton.makeTitleTextUppercased()
        sendButton.applyStandardGreenStyle()
        
        detailedInfoButton.isSelected = reportType == .bugReport
        
        detailedInfoView.isHidden = reportType == .feedback
        
        detailedInfoViewHeight.isActive = reportType == .feedback
        optionalSpace.constant = reportType == .bugReport ? 32.0 : 0.0
    }
    
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
    
    private func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupLabels(themableLabels)
        themeService.setupNavigationBar(navigationController?.navigationBar)
        themeService.setupTextField(emailAddressTextField)
        themeService.setupTextView(descriptionTextView)
        textViewPlaceholder.textColor = themeService.placeholderTextColor
    }
}

extension BugReportController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        emailTextFieldIndicatorView.state = .enabled
        emailErrorLabel.isHidden = true
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailTextFieldIndicatorView.state = .enabled
        emailErrorLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let email = textField.text ?? ""
        let isValidEmail = email.isValidEmail() || email.isEmpty
        emailTextFieldIndicatorView.state = isValidEmail ? .disabled : .error
        emailErrorLabel.isHidden = isValidEmail
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isValidEmail() == true {
            descriptionTextView.becomeFirstResponder()
        } else {
            emailTextFieldIndicatorView.state = .error
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
