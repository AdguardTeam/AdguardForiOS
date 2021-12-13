//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

class UpsellViewController: UIViewController {

    @IBOutlet weak var installButton: UIButton!

    private var gradient: CAGradientLayer?
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!

    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradient()

        installButton.makeTitleTextCapitalized()
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
        UIApplication.shared.openAdguardUrl(action: "adguard_vpn", from: "vpn_sale_screen", buildVersion: productInfo.buildVersion())
        dismiss(animated: true)
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
