import UIKit
import SafariServices

/// Dialog that provides a remote migration to new AdGuard App
final class RemoteMigrationDialog : BottomAlertController {

    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var acceptButton: RoundRectButton!
    @IBOutlet weak var detailsButton: UIButton!

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
    private let keychainService: KeychainServiceProtocol = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
    private let httpRequestService: HttpRequestServiceProtocol = ServiceLocator.shared.getService()!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        titleLabel.text = String.localizedString("remote_migration_dialog_title")
        descriptionLabel.text = String.localizedString("remote_migration_dialog_description")
    }

    private func configureUI() {
        acceptButton.applyStandardGreenStyle()
        detailsButton.applyStandardOpaqueStyle()

        acceptButton.setTitle(String.localizedString("remote_migration_dialog_accept_button_title"), for: .normal)
        detailsButton.setTitle(String.localizedString("remote_migration_dialog_details_button_title"), for: .normal)

        acceptButton.makeTitleTextCapitalized()
        detailsButton.makeTitleTextCapitalized()
        updateTheme()
    }

    @IBAction
    private func onAcceptTapped(_ sender: UIButton) {
        processMigration()
    }

    @IBAction
    private func onDetailsTapped(_ sender: UIButton) {
        UIApplication.shared.openAdguardUrl(action: "about_migration", from: "RemoteMigrationDialog", buildVersion: productInfo.buildVersion())
        dismiss(animated: true)
    }

    private func processMigration() {
        guard let appId = keychainService.appId,
              let buildVersion = productInfo.buildVersion()
            else { return }

        if purchaseService.purchasedThroughInApp {
            // Initiate remote migration for in-app purchased app
            initRemoteMigrationWithInAppPurchase(appId: appId, buildVersion: buildVersion)
        } else if purchaseService.purchasedThroughLogin {
            // Initiate remote migration for app with license key
            initRemoteMigrationWithLicenseKey(appId: appId, buildVersion: buildVersion)
        } else {
            // Initiate remote migration for FREE or AdGuard Pro app.
            // AdGuard Pro doesn't have license key so we need to set app_type for TDS link with value `ADGUARD_FOR_IOS_PRO`
            initRemoteMigrationWithoutLicenseKey(appId: appId, buildVersion: buildVersion)
        }
    }

    private func initRemoteMigrationWithInAppPurchase(appId: String, buildVersion: String) {
        guard let receipt = purchaseService.getInAppPurchaseReceiptBase64() else {
            DDLogError("(RemoteMigrationDialog) - Base64 receipt missing")
            return
        }

        acceptButton.startIndicator()

        // For in-app purchases we need to send hash value of in-app purchase receipt received from our backed to TDS
        DDLogInfo("(RemoteMigrationDialog) - Start getting in-app purchase receipt hash value from our backend")
        httpRequestService.getInAppPurchaseReceiptHash(appId, inAppPurchaseBase64Receipt: receipt) { result in
            DispatchQueue.main.async { [weak self] in
                self?.acceptButton.stopIndicator()
                self?.processRequest(appId: appId, buildVersion: buildVersion, result: result)
            }
        }
    }

    private func initRemoteMigrationWithLicenseKey(appId: String, buildVersion: String) {
        guard let licenseKey = purchaseService.licenseKey,
              let url = getTDSUrl(with: appId, buildVersion, licenseKey) else {
            DDLogError("(RemoteMigrationDialog) - Missing TDS url for license key purchase migration")
            return
        }

        prepareForPresent(url: url)
    }

    private func initRemoteMigrationWithoutLicenseKey(appId: String, buildVersion: String) {
        guard let url = getTDSUrl(with: appId, buildVersion, nil) else {
            DDLogError("(RemoteMigrationDialog) - Missing TDS url for FREE or AdGuard Pro app migration")
            return
        }

        prepareForPresent(url: url)
    }

    private func processRequest(appId: String, buildVersion: String, result: Result<String, Error>) {
        switch result {
            case .success(let hash):
                DDLogInfo("(RemoteMigrationDialog) - Successfully get in-app purchase receipt hash value from our backend")
                processReceiptHash(appId: appId, buildVersion: buildVersion, hash: hash)
            case .failure(let error):
                DDLogError("(RemoteMigrationDialog) - Failure to get in-app purchase receipt hash value from our backend. Error: \(error)")
                showUnknownErrorAlert()
        }
    }

    private func processReceiptHash(appId: String, buildVersion: String, hash: String) {
        guard let url = getTDSUrl(with: appId, buildVersion, hash) else {
            DDLogError("(RemoteMigrationDialog) - Missing TDS url for in-app purchase migration")
            return
        }

        prepareForPresent(url: url)
    }

    private func prepareForPresent(url: URL) {
        let sfSafariViewController = SFSafariViewController(url: url)
        sfSafariViewController.delegate = self
        present(sfSafariViewController, animated: true)
    }

    private func getTDSUrl(with appId: String, _ buildVersion: String, _ license: String?) -> URL? {
        let urlInfo = RemoteMigrationOpenUrlInfo(
            action: "remote_migration",
            from: "\(RemoteMigrationDialog.self)",
            buildVersion: buildVersion,
            appId: appId,
            appType: LoginService.APP_TYPE_VALUE,
            license: license
        )

        return urlInfo.getUrlWithQueryItems()
    }
}

extension RemoteMigrationDialog : ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels([titleLabel, descriptionLabel])
    }
}

extension RemoteMigrationDialog : SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true) { [weak self] in
            self?.onDismissCompletion?()
        }
    }
}
