import UIKit

/// Dialog that informs a user that old app can be deleted
final class CanDeleteAppDialog : BottomAlertController {
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var positiveButton: UIButton!

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @IBAction func positiveButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    private func configureUI() {
        positiveButton.applyStandardGreenStyle()
        titleLabel.text = String.localizedString("can_delete_app_dialog_title")
        positiveButton.setTitle(String.localizedString("can_delete_app_dialog_button_title"), for: .normal)

        updateTheme()
    }
}

extension CanDeleteAppDialog : ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels([titleLabel])
    }
}
