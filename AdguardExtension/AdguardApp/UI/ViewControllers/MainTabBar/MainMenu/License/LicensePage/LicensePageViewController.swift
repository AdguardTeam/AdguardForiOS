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
import SafariServices

protocol LicensePageViewControllerDelegate: AnyObject {
    func controllerDismissed()
}

/// This controller is responsible for managing free and premium view depending on the license status
final class LicensePageViewController: UIViewController {
    private let deleteAccountAlertControllerIdentifier = "DeleteAccountBottomAlertController"

    private enum LicenseState {
        case free
        case premium
    }

    // MARK: - Public properties

    weak var delegate: LicensePageViewControllerDelegate?
    var showExitButton = false

    // MARK: - Private properties

    private var state: LicenseState {
        return configuration.proStatus ? .premium : .free
    }

    /* View models */
    private var freeModel: FreeLicenseStateTableViewModelProtocol?

    /* Services */
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!

    /* Segue identifiers */
    let loginSegueId = "loginSegueId"

    private var proStatusObserver: NotificationToken?
    private var onSettingsImportDidEndObserver: NotificationToken?
    private var onSettingsResetObserver: NotificationToken?

    // MARK: - Public methods

    override func loadView() {
        setupView()
        setupNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTheme()
        title = Bundle.main.applicationName
        
        if showExitButton {
            navigationItem.leftBarButtonItems = [makeExitButton()]
        } else {
            setupBackButton()
        }

        proStatusObserver = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
            self?.setupView()
            self?.setupNavigationBar()
            self?.setNavBarColor()
        }

        let payload = { [weak self] in
            guard let self = self,
                  self.state == .premium,
                  let stateView = self.view as? PremiumLicenseStateView
            else { return }

            stateView.models = PremiumFeature.allCases.compactMap {
                if self.resources.disableSecurityRelatedFeatures && $0 == .securityFilters { return nil  }

                return PremiumFeatureViewModel(icon: $0.icon, featureName: $0.localizedName, featureDescription: $0.localizedDescr)
            }

            stateView.updateTheme()
        }

        onSettingsImportDidEndObserver = NotificationCenter.default.observe(name: .settingsImportDidEnd, object: nil, queue: .main) { _ in payload() }

        onSettingsResetObserver = NotificationCenter.default.observe(name: .resetSettings, object: nil, queue: .main) { _ in payload() }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarColor()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        themeService.setupNavigationBar(navigationController?.navigationBar)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollection.onSizeClassChange(previousTraitCollection) {
            setNavBarColor()
        }
    }

    // MARK: - Private methods

    private func setupView() {
        switch state {
        case .free:
            freeModel = FreeLicenseStateTableViewModel(purchaseService: purchaseService, productInfo: productInfo)
            freeModel?.presentor = self
            let freeView = FreeLicenseStateTableView(model: freeModel!, themeService: themeService)
            freeView.updateTheme()
            self.view = freeView
        case .premium:
            freeModel = nil
            let premiumView = PremiumLicenseStateView()
            premiumView.models = PremiumFeature.allCases.compactMap {
                if resources.disableSecurityRelatedFeatures && $0 == .securityFilters { return nil  }

                return PremiumFeatureViewModel(icon: $0.icon, featureName: $0.localizedName, featureDescription: $0.localizedDescr)
            }
            premiumView.delegate = self
            premiumView.updateTheme()
            self.view = premiumView
        }
    }

    private func setupNavigationBar() {
        switch state {
        case .free:
            navigationItem.rightBarButtonItems = [makeLoginButton()]
        case .premium:
            if purchaseService.purchasedThroughLogin {
                navigationItem.rightBarButtonItems = [generateBarButtonItem()]
            } else {
                navigationItem.rightBarButtonItems = []
            }
            if let view = view as? PremiumLicenseStateView {
                view.setAccountButtonHidden(!purchaseService.purchasedThroughLogin)
            }
        }
    }

    private func makeLoginButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: String.localizedString("common_login"), style: .plain, target: self, action: #selector(loginButtonTapped))
        button.tintColor = UIColor.AdGuardColor.lightGreen1
        return button
    }

    @available(iOS 14.0, *)
    private func createMenu() -> UIMenu {
        let logoutAction = UIAction(
            title: String.localizedString("common_logout"),
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            attributes: .destructive
        ) { [weak self] _ in
            self?.logoutButtonTapped()
        }

        let deleteAccountAction = UIAction(
            title: String.localizedString("license_delete_account_title"),
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { [weak self] _ in
            self?.deleteAccountButtonTapped()
        }

        return UIMenu(children: [logoutAction, deleteAccountAction])
    }

    private func generateBarButtonItem() -> UIBarButtonItem {
        let image = UIImage(named: "edit")

        if #available(iOS 14.0, *) {
            let button = UIBarButtonItem(image: image, menu: createMenu())
            return button
        } else {
            return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(accountActionsButtonTapped(_:)))
        }
    }

    private func makeExitButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(exitButtonTapped))
        return button
    }

    @objc private final func loginButtonTapped() {
        performSegue(withIdentifier: loginSegueId, sender: self)
    }

    @objc private final func accountActionsButtonTapped(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .deviceAlertStyle)

        let logoutAction = UIAlertAction(title: String.localizedString("common_logout"), style: .destructive) { [weak self] _ in
            self?.logoutButtonTapped()
        }
        actionSheet.addAction(logoutAction)

        let deleteAccountAction = UIAlertAction(title: String.localizedString("license_delete_account_title"), style: .destructive) { [weak self] _ in
            self?.deleteAccountButtonTapped()
        }
        actionSheet.addAction(deleteAccountAction)

        let cancelAction = UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)

        if let popoverPresentationController = actionSheet.popoverPresentationController {
            popoverPresentationController.barButtonItem = sender
        }

        present(actionSheet, animated: true)
    }

    @objc private final func logoutButtonTapped() {
        let alert = UIAlertController(title: nil, message: String.localizedString("confirm_logout_text"), preferredStyle: .deviceAlertStyle)

        let cancelAction = UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let okAction = UIAlertAction(title: String.localizedString("common_action_yes"), style: .destructive) { [weak self] _ in
            self?.performLogoutAndRefreshUI()
        }
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
    }

    @objc private final func deleteAccountButtonTapped() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: deleteAccountAlertControllerIdentifier) as? DeleteAccountBottomAlertController else {
            return
        }

        controller.onDeleteAccount = { [weak self] in
            self?.openDeleteAccountPage()
        }
        present(controller, animated: true)
    }

    @objc private final func exitButtonTapped() {
        navigationController?.dismiss(animated: true) {[weak self] in
            self?.delegate?.controllerDismissed()
        }
    }

    private func setNavBarColor() {
        if state == .free {
            let color = themeService.getLicensePageTraitSpecificColor(traitCollection.isIpadTraitCollection)
            themeService.setupNavigationBar(navigationController?.navigationBar, backgroundColor: color)
        } else {
            themeService.setupNavigationBar(navigationController?.navigationBar)
        }
    }

    private func performLogoutAndRefreshUI() {
        guard purchaseService.logout() else { return }

        setupView()
        setupNavigationBar()
        setNavBarColor()
    }

    private func openDeleteAccountPage() {
        let accountAction = "delete_account"
        let from = "license"
        let urlString = UIApplication.shared.adguardUrl(action: accountAction, from: from, buildVersion: productInfo.buildVersion())

        guard let url = URL(string: urlString) else { return }
        presentSafariViewController(url: url, logoutAfterPresentation: true)
    }

    private func openMyAccountPage() {
        let accountAction = "account"
        let from = "license"
        let urlString = UIApplication.shared.adguardUrl(action: accountAction, from: from, buildVersion: productInfo.buildVersion())

        guard let url = URL(string: urlString) else { return }
        presentSafariViewController(url: url)
    }

    private func presentSafariViewController(url: URL, logoutAfterPresentation: Bool = false) {
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true) { [weak self] in
            guard logoutAfterPresentation else { return }
            self?.performLogoutAndRefreshUI()
        }
    }
}

// MARK: - LicensePageViewController + FreeLicenseStateTableViewPresentor

extension LicensePageViewController: FreeLicenseStateTableViewPresentor {
    func showError(title: String?, message: String?) {
        presentSimpleAlert(title: title, message: message)
    }

    func showPurchaseOptions(options: [(id: String, title: String)]) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .deviceAlertStyle)

        options.forEach { option in
            let action = UIAlertAction(title: option.title, style: .default) { [weak self] _ in
                self?.freeModel?.selectProduct(with: option.id)
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }

    func showAlertAndDismiss(title: String?, message: String?) {
        presentSimpleAlert(title: title, message: message) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    func purchaseStatusChanged() {
        setupNavigationBar()
    }
}

// MARK: - LicensePageViewController + PremiumLicenseStateViewDelegate

extension LicensePageViewController: PremiumLicenseStateViewDelegate {
    func goToMyAccount() {
        openMyAccountPage()
    }
}

// MARK: - LicensePageViewController + ThemableProtocol

extension LicensePageViewController: ThemableProtocol {
    func updateTheme() {
        if let tableView = view as? FreeLicenseStateTableView {
            tableView.updateTheme()
        }
        else if let view = view as? PremiumLicenseStateView {
            view.updateTheme()
        }
        setNavBarColor()
    }
}

final class DeleteAccountBottomAlertController: BottomAlertController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var deleteAccountButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!

    var onDeleteAccount: (() -> Void)?

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = String.localizedString("license_delete_account_title")
        deleteAccountButton.setTitle(String.localizedString("license_delete_account_title"), for: .normal)
        cancelButton.setTitle(String.localizedString("common_action_cancel"), for: .normal)

        deleteAccountButton.applyStandardGreenStyle()
        deleteAccountButton.backgroundColor = UIColor.AdGuardColor.red

        cancelButton.applyStandardOpaqueStyle()

        setupDescriptionLabel()
        updateTheme()
    }

    private func setupDescriptionLabel() {
        let text = String.localizedString("delete_account_description_format")
        descriptionLabel.setAttributedTitle(text, fontSize: descriptionLabel.font!.pointSize, color: themeService.popupTitleTextColor, textAlignment: .center)
    }

    @IBAction private func cancelTapped() {
        dismiss(animated: true)
    }

    @IBAction private func deleteAccountTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onDeleteAccount?()
        }
    }
}

extension DeleteAccountBottomAlertController: ThemableProtocol {
    func updateTheme() {
        titleLabel.textColor = themeService.popupTitleTextColor
        contentView.backgroundColor = themeService.popupBackgroundColor
        setupDescriptionLabel()
    }
}
