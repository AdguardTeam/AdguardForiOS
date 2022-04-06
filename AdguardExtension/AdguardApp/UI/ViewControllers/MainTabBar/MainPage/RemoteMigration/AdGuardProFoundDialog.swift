import UIKit

/// ASL account dialog
final class AdGuardProFoundDialog: BottomAlertController {
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseService = ServiceLocator.shared.getService()!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = String.localizedString("adguard_pro_found_title")
        descriptionLabel.text = String.localizedString("adguard_pro_found_description")
        primaryButton.setTitle(String.localizedString("adguard_pro_found_primary_button_title"), for: .normal)

        primaryButton.applyStandardGreenStyle()
        updateTheme()
    }


    @IBAction func primaryButtonTapped(_ sender: UIButton) {
        // FIXME: Subscribe user with in app lifetime purchase for zero price
    }
}

extension AdGuardProFoundDialog: ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels([titleLabel, descriptionLabel])
    }
}
