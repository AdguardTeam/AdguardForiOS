import UIKit

class UpsellViewController: UIViewController {
    
    @IBOutlet weak var installButton: UIButton!
    
    private var gradient: CAGradientLayer?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradient()
        
        installButton.makeTitleTextUppercased()
        installButton.applyStandardAdGuardVPNGreenStyle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient?.frame = view.bounds
    }
    
    @IBAction func crossTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func installButtonTapped(_ sender: UIButton) {
        UIApplication.openAdGuardVpnAppStorePage()
    }
    
    // MARK: - Private methods
    
    private func applyGradient() {
        let gradientLayer = CAGradientLayer()
        let color1 = UIColor(hexString: "#464558").cgColor
        let color2 = UIColor(hexString: "#2d2c3a").cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1.0]
        gradient = gradientLayer
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
