import UIKit
import SafariServices

// TODO: Adopt this controller to other type of remote migration dialogs. maybe need to implement custom init to base class `BottomAlertController`.

final class RemoteMigrationDialog : BottomAlertController {

    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
    private let keychainService: KeychainServiceProtocol = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!

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
        guard let appId = keychainService.appId,
              let buildVersion = productInfo.buildVersion()
            else { return }


        guard let url = RemoteMigrationOpenUrlInfo(
            action: "remote_migration",
            from: "\(RemoteMigrationDialog.self)",
            buildVersion: buildVersion,
            appId: appId,
            appName: LoginService.APP_NAME_VALUE,
            license: purchaseService.licenseKey,
            receipt: purchaseService.getInAppPurchaseReceiptBase64()
        ).getUrlWithQueryItems() else { return }


        let sfSafariViewController = SFSafariViewController(url: url)
        sfSafariViewController.delegate = self
        present(sfSafariViewController, animated: true)
    }

    @IBAction
    private func onDetailsTapped(_ sender: UIButton) {
        // FIXME: Redirect to about remote migration page
        UIApplication.shared.openAdguardUrl(action: "about_migration", from: "RemoteMigrationDialog", buildVersion: productInfo.buildVersion())
        dismiss(animated: true)
    }
}

extension RemoteMigrationDialog : ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels([titleLabel, descriptionLabel])
    }
}

extension RemoteMigrationDialog: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true) { [weak self] in
            self?.onDismissCompletion?()
        }
    }
}
