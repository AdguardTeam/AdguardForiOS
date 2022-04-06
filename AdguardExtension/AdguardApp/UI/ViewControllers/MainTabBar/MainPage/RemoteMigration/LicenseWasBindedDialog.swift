import Foundation

/// Dialog that inform user about remote migration and sugest to proceed log in
final class LicenseWasBindedDialog : BottomAlertController {
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var positiveButton: UIButton!

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @IBAction func positiveButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            AppDelegate.shared.pushSignInController()
        }
    }

    private func configureUI() {
        positiveButton.applyStandardGreenStyle()
        titleLabel.text = String.localizedString("license_was_binded_dialog_title")
        descriptionLabel.text = String.localizedString("license_was_binded_dialog_description")
        positiveButton.setTitle(String.localizedString("license_was_binded_dialog_button_title"), for: .normal)

        updateTheme()
    }
}

extension LicenseWasBindedDialog : ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels([titleLabel, descriptionLabel])
    }
}
