import UIKit

/// Dialog that informs a user that old AdGuard app was detected
final class AdGuardFoundDialog : BottomAlertController {
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = String.localizedString("adguard_found_title")
        descriptionLabel.text = String.localizedString("adguard_found_description")
        primaryButton.setTitle(String.localizedString("adguard_found_primary_button_title"), for: .normal)
        neutralButton.setTitle(String.localizedString("adguard_found_neutral_button_title"), for: .normal)

        primaryButton.applyStandardGreenStyle()
        neutralButton.applyStandardOpaqueStyle()

        updateTheme()
    }

    @IBAction func primaryButtonTapped(_ sender: UIButton) {
        let vc = createMainPageDialog("LicenseWasBindedDialog")
        presentDialog(vc)
    }

    @IBAction func neutralButtonTapped(_ sender: UIButton) {
        let vc = createMainPageDialog("CanDeleteAppDialog")
        presentDialog(vc)
    }

    private func createMainPageDialog(_ controllerIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: controllerIdentifier)
        return vc
    }

    private func presentDialog(_ dialog: UIViewController) {
        let parent = self.presentingViewController
        self.dismiss(animated: true) {
            parent?.present(dialog, animated: true)
        }
    }
}

extension AdGuardFoundDialog : ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels([titleLabel, descriptionLabel])
    }
}
