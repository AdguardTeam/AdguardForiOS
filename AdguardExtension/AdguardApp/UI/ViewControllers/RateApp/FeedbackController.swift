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

class FeedbackController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var feedBackTextViewPlaceholder: UILabel!
    @IBOutlet weak var sendButton: RoundRectButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    
    // FUTURE FLAG FOR DIFFERENT FEEDBACK TYPES
    var simpleFeedback = true
    
    private let httpRequestService: HttpRequestServiceProtocol = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let keyChainService: KeychainServiceProtocol = ServiceLocator.shared.getService()!
    private let support: AESSupportProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private var themeToken: NotificationToken?
    
    private var keyboardMover: KeyboardMover?
    
    private let showCompletionSuccessSegue = "showCompletionSuccess"
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardMover = KeyboardMover(bottomConstraint: bottomConstraint, view: scrollView, tabBar: tabBarController?.tabBar)
    
        updateTheme()
        setupBackButton()
        sendButton.makeTitleTextUppercased()
        
        sendButton.indicatorStyle = .white
        feedbackTextView.textContainer.lineFragmentPadding = 0
        feedbackTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        feedbackTextView.becomeFirstResponder()
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sendButton.layoutIfNeeded()
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
    }
    
    // MARK: - Actions
    @IBAction func crossTapped(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonTapped(_ sender: RoundRectButton) {
        sendButton.startIndicator()
                
        let feedback = createFeedback()
        
        if feedback.description?.isEmpty ?? true {
            sendButton.stopIndicator()
            return
        }
        
        if !isValidEmail(feedback.email ?? "") && !(emailTextField.text == nil || emailTextField.text == "") {
            emailTextField.textColor = theme.errorRedColor
            separatorView.backgroundColor = theme.errorRedColor
            sendButton.stopIndicator()
            return
        }
        
        httpRequestService.sendFeedback(feedback) {[weak self] (success) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if !success {
                    ACSSystemUtils.showSimpleAlert(for: self, withTitle: String.localizedString("feedback_sending_failed_title") , message: String.localizedString("feedback_sending_failed_message"))
                } else {
                    self.configuration.appRated = true
                    self.performSegue(withIdentifier: self.showCompletionSuccessSegue, sender: self)
                }
                self.sendButton.stopIndicator()
            }
        }
    }
    
    // MARK: - TextView delegate method
    
    func textViewDidChange(_ textView: UITextView) {
        feedBackTextViewPlaceholder.isHidden = !textView.text.isEmpty
        sendButton.isEnabled = !textView.text.isEmpty
    }
    
    // MARK: - TextField delegate method
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        feedbackTextView.becomeFirstResponder()
        return true
    }
    
    @IBAction func textFieldTextChanged(_ sender: UITextField) {
        emailTextField.textColor = theme.textFieldTextColor
        separatorView.backgroundColor = theme.separatorColor
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.popupBackgroundColor
        scrollView.backgroundColor = theme.popupBackgroundColor
        feedBackTextViewPlaceholder.textColor = theme.placeholderTextColor
        separatorView.backgroundColor = theme.separatorColor
        theme.setupTextField(emailTextField)
        theme.setupTextView(feedbackTextView)
        theme.setupLabel(titleLabel)
    }
    
    private func createFeedback() -> FeedBackProtocol {
        let appId = keyChainService.appId
        let version = ADProductInfo.buildVersion()
        let email = emailTextField.text
        let language = ADLocales.lang()
        // METHOD TYPE
        let subject = "Feedback"
        let description = feedbackTextView.text
        let applicationState = support.applicationState()
        
        let feedback: FeedBackProtocol = FeedBack(applicationId: appId, version: version, email: email, language: language, subject: subject, description: description, applicationState: applicationState)
        return feedback
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
