import UIKit

extension UIViewController {
    func presentUpsellScreen() {
        let upsellVC = UpsellViewController(nibName: "UpsellViewController", bundle: nil)
        upsellVC.modalPresentationStyle = .overFullScreen
        self.present(upsellVC, animated: true)
    }
}
