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
import SafariServices

final class EmailSignInController: UIViewController, UITextFieldDelegate {

    // MARK: - properties

    var licenseKey: String?
    var fromOnboarding = false

    private let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let notificationService: UserNotificationServiceProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!

    private var notificationObserver: Any?

    // MARK: - IB outlets
    @IBOutlet weak var nameEdit: AGTextField!
    @IBOutlet weak var loginButton: RoundRectButton!
    @IBOutlet weak var passwordEdit: AGTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet var themableLabels: [ThemableLabel]!

    @IBOutlet weak var lostPasswordButton: UIButton!

    // MARK: - private properties

    private let confirm2faSegue = "confirm2faSegue"

    private var keyboardMover: KeyboardMover!

    private var isKeyboardNextButtonEnabled = true


    // MARK: - VC lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // If there is no tab bar this mean that we trying to login from onboarding license screen and we must dismiss it after successful login
        fromOnboarding = self.tabBarController == nil

        setupBackButton()

        let tabBar = tabBarController?.tabBar
        keyboardMover = KeyboardMover(bottomConstraint: bottomConstraint, view: scrollView, tabBar: tabBar)

        // setup activity indicator in login button
        loginButton.indicatorStyle = .white

        // setup lost password button
        setupLostPasswordButton()
        passwordEdit.textFieldType = .secure
        nameEdit.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        updateLoginButton()

        notificationObserver = NotificationCenter.default.addObserver(forName: Notification.Name(PurchaseAssistant.kPurchaseServiceNotification),
                                                                      object: nil, queue: nil)
        { [weak self](notification) in
            if let info = notification.userInfo {
                self?.processNotification(info: info)
            }
        }
        updateTheme()

        loginButton.makeTitleTextCapitalized()
        loginButton.applyStandardGreenStyle()

        nameEdit.accessibilityLabel = String.localizedString("enter_email_voiceover")
        passwordEdit.accessibilityLabel = String.localizedString("enter_password_voiceover")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let licenseKey = licenseKey, !licenseKey.isEmpty {
            nameEdit.text = licenseKey
            login()
        } else {
            nameEdit.becomeFirstResponder()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == confirm2faSegue {
            guard let controller = segue.destination as? Confirm2FaController else { return }
            guard let name = nameEdit.text, let password = passwordEdit.text else { return }
            controller.credentials = (name, password)
        }
    }

    // MARK: - Actions
    @IBAction func loginAction(_ sender: Any) {
        login()
    }

    @IBAction func editingChanged(_ sender: Any) {
        updateLoginButton()
    }

    @IBAction func recoverAction(_ sender: Any) {
        UIApplication.shared.openAdguardUrl(action: "recovery_password", from: "login", buildVersion: productInfo.buildVersion())
    }

    // MARK: - text field delegate methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameEdit {
            passwordEdit.becomeFirstResponder()
        }
        else if (nameEdit.text?.count ?? 0) > 0 &&
            (passwordEdit.text?.count ?? 0) > 0 && isKeyboardNextButtonEnabled {
            isKeyboardNextButtonEnabled = false
            login()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if textField == nameEdit {
            nameEdit.rightView?.isHidden = updatedText.isEmpty
        }
        nameEdit.borderState = .enabled

        if textField == passwordEdit {
            passwordEdit.rightView?.isHidden = updatedText.isEmpty
        }
        passwordEdit.borderState = .enabled

        errorLabel.text = ""

        return true
    }

    // MARK: - private methods

    private func updateLoginButton() {
        loginButton.isEnabled = nameEdit.text?.count ?? 0 > 0
    }

    private func isLicenseKey(text: String)->Bool {
        return !text.isEmpty && text.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    private func login(){
        loginButton.startIndicator()
        loginButton.isEnabled = false
        isKeyboardNextButtonEnabled = false

        let name = nameEdit.text
        let password = passwordEdit.text

        if (name?.count ?? 0) > 0 &&
            (password?.count ?? 0) > 0 {
            purchaseService.login(name: name!, password: password!, code2fa: nil)
        }
        else if (name?.count ?? 0 > 0) && isLicenseKey(text: name!) {
            purchaseService.login(withLicenseKey: name!) {_ in }
        }
        else {
            let body = String.localizedString("login_error_message")
            notificationService.postNotificationInForeground(body: body, title: "")
            loginButton.stopIndicator()
            loginButton.isEnabled = true
        }
    }

    private func processNotification(info: [AnyHashable: Any]) {

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            // skip notification if this controler is not placed on top of navigation stack
            if self.navigationController?.viewControllers.last != self {
                return
            }

            self.loginButton.stopIndicator()
            self.loginButton.isEnabled = true
            self.isKeyboardNextButtonEnabled = true

            let type = info[PurchaseAssistant.kPSNotificationTypeKey] as? String
            let error = info[PurchaseAssistant.kPSNotificationErrorKey] as? NSError

            switch type {

            case PurchaseAssistant.kPSNotificationLoginSuccess:
                self.loginSuccess()
            case PurchaseAssistant.kPSNotificationLoginFailure:
                self.loginFailure(error)
            case PurchaseAssistant.kPSNotificationLoginPremiumExpired:
                self.premiumExpired()
            case PurchaseAssistant.kPSNotificationLoginNotPremiumAccount:
                self.notPremium()

            default:
                break
            }
        }
    }

    private func loginSuccess() {
        let message = String.localizedString("login_success_message")

        let isLoginingWithLicenseURL = !(licenseKey?.isEmpty ?? true)

        if !fromOnboarding || isLoginingWithLicenseURL {
            self.navigationController?.popToRootViewController(animated: false)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.dismissToMainPage(animated: true)
            notificationService.postNotificationInForeground(body: message, title: "")

        } else {
            let proController = self.navigationController?.viewControllers.first { $0 is GetProController } as? GetProController
            self.navigationController?.dismiss(animated: true) { [weak self] in
                self?.notificationService.postNotificationInForeground(body: message, title: "")
                proController?.getProControllerDelegate?.getProControllerClosed()
            }
        }
    }

    private func premiumExpired() {
        guard let controller = self.navigationController?.viewControllers.first(where: { $0 is GetProController }) else { return }
        let message = String.localizedString("login_premium_expired_message")
        self.navigationController?.popToViewController(controller, animated: true)
        notificationService.postNotificationInForeground(body: message, title: "")
    }

    private func notPremium() {
        guard let controller = self.navigationController?.viewControllers.first(where: { $0 is GetProController }) else { return }
        let message = String.localizedString("not_premium_message")
        self.navigationController?.popToViewController(controller, animated: true)
        notificationService.postNotificationInForeground(body: message, title: "")
    }

    private func loginFailure(_ error: NSError?) {
        let signInHelper = SignInFailureHandler(notificationService: notificationService)
        let messages = signInHelper.loginFailure(error, auth2Fa: { [unowned self] in
            self.performSegue(withIdentifier: self.confirm2faSegue, sender: self)
        })

        if let message = messages?.alertMessage {
            notificationService.postNotificationInForeground(body: message, title: "")
        }

        if let message = messages?.errorMessage {
            errorLabel.text = message
            nameEdit.borderState = .error
            passwordEdit.borderState = .error
        }
        else {
            errorLabel.text = ""
            nameEdit.borderState = .enabled
            passwordEdit.borderState = .enabled
        }
    }

    private func setupLostPasswordButton(){
        let title = String.localizedString("lost_password")
        let color = UIColor.AdGuardColor.lightGray3
        let nsRange = NSRange(location: 0, length: title.count)
        let font = lostPasswordButton.titleLabel?.font

        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        attributedString.addAttribute(.underlineColor, value: color, range: nsRange)
        attributedString.addAttribute(.font, value: font!, range: nsRange)

        lostPasswordButton.setAttributedTitle(attributedString, for: .normal)
    }
}

extension EmailSignInController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        nameEdit.updateTheme()
        passwordEdit.updateTheme()
        theme.setupTextField(nameEdit)
        theme.setupTextField(passwordEdit)
        theme.setupLabels(themableLabels)
    }
}
