import UIKit

class AdGuardFoundDialog : BottomAlertController {
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

    }

    @IBAction func neutralButtonTapped(_ sender: UIButton) {

    }
}

extension AdGuardFoundDialog : ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels([titleLabel, descriptionLabel])
    }
}
