import UIKit

/// Dialog that informs a user that old AdGuardPRO app was detected on device
final class AdGuardProFoundDialog: BottomAlertController {
    @IBOutlet weak var primaryButton: RoundRectButton!
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!

    private var purchaseStatusObserver: NotificationToken?

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!

    deinit {
        purchaseStatusObserver = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = String.localizedString("adguard_pro_found_title")
        descriptionLabel.text = String.localizedString("adguard_pro_found_description")
        primaryButton.setTitle(String.localizedString("adguard_pro_found_primary_button_title"), for: .normal)

        subscribeToNotification()

        primaryButton.applyStandardGreenStyle()
        updateTheme()
    }

    @IBAction func primaryButtonTapped(_ sender: UIButton) {
        // FIXME: Uncomment when ready to test in-app purchase
//        presentLoadingAlertAbovePresented()
//        purchaseService.requestNonConsumableFreePurchase()

    }

    private func subscribeToNotification() {
        purchaseStatusObserver = NotificationCenter.default.observe(name: Notification.Name(PurchaseAssistant.kPurchaseServiceNotification), object: nil, queue: .main) { [weak self] note in
            if let info = note.userInfo {
                self?.processNotification(info: info)
            }
        }
    }

    private func processNotification(info: [AnyHashable: Any]) {
        let type = info[PurchaseAssistant.kPSNotificationTypeKey] as? String

        switch type {
            case PurchaseAssistant.kPSNotificationPurchaseSuccess:
                dismissAllAndPresent(message: String.localizedString("purchase_success_message"))
            case PurchaseAssistant.kPSNotificationPurchaseFailure:
                dismissLoadingAlertAndPresent(message: String.localizedString("purchase_failure_message"))
            case PurchaseAssistant.kPSNotificationCanceled:
                dismissLoadingAlertIfNeeded { self.dismiss(animated: true) }
            default:
                dismissLoadingAlertIfNeeded { self.dismiss(animated: true) }
        }
    }

    private func dismissLoadingAlertAndPresent(message: String) {
        dismissLoadingAlertIfNeeded { [self] in
            presentSimpleAlert(title: nil, message: message)
        }
    }

    private func dismissAllAndPresent(message: String) {
        let presentOn = presentingViewController
        dismissLoadingAlertIfNeeded { [self] in
            dismiss(animated: true) {
                presentSimpleAlert(title: nil, message: message, presentOn: presentOn)
            }
        }
    }
}

extension AdGuardProFoundDialog: ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels([titleLabel, descriptionLabel])
    }
}
