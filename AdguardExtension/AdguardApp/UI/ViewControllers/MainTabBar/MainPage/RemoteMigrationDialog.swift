import UIKit
import SafariServices

// TODO: Adopt this controller to other type of remote migration dialogs. maybe need to implement custom init to base class `BottomAlertController`.

final class RemoteMigrationDialog : BottomAlertController {

    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!

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
        let url = URL(string: "https://adguard.com") // FIXME: Add correct URL
        let sfSafariViewController = SFSafariViewController(url: url!)
        sfSafariViewController.delegate = self
        let parent = self.presentingViewController
        present(sfSafariViewController, animated: true)
    }

    @IBAction
    private func onDetailsTapped(_ sender: UIButton) {
        // FIXME: Redirect to about remote migration page
        UIApplication.shared.openAdguardUrl(action: "", from: "", buildVersion: "")
        dismiss(animated: true) { [weak self] in
            self?.onDismissCompletion?()
        }
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
