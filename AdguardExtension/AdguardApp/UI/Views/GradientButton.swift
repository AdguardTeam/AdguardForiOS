/**
   This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
   Copyright © Adguard Software Limited. All rights reserved.

   Adguard for iOS is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Adguard for iOS is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

class GradientButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    /**
     Applies gradient to UIButton
     First color: #45b3a4
     Second color: #67b279
     */
    private lazy var gradientLayer: CAGradientLayer = {
        let sublayer = CAGradientLayer()
        sublayer.frame = self.bounds
        sublayer.colors = [UIColor(hexString: "#45b3a4").cgColor, UIColor(hexString: "#67b279").cgColor]
        sublayer.startPoint = CGPoint(x: 0, y: 0.5)
        sublayer.endPoint = CGPoint(x: 1, y: 0.5)
        sublayer.cornerRadius = self.layer.cornerRadius
        layer.insertSublayer(sublayer, at: 0)
        return sublayer
    }()
}
