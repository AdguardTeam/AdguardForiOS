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
import UIKit

extension UIButton {
    /**
     Makes button's title uppercased for paticular state (default is normal)
     */
    func makeTitleTextUppercased(for state: UIControl.State = .normal){
        let buttonTitle = title(for: state)
        setTitle(buttonTitle?.uppercased(), for: state)
    }
    
    /*
     Makes button look like standard AdGuard green button
     with green background, no border and white text
     */
    func applyStandardGreenStyle() {
        let greenColor = UIColor.AdGuardColor.green
        self.layer.cornerRadius = 8.0
        self.backgroundColor = greenColor
        self.setTitleColor(.white, for: .normal)
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    /*
     Makes button look like standard AdGuard VPN green button
     with green background, no border and white text
     */
    func applyStandardAdGuardVPNGreenStyle() {
        let greenColor = UIColor.AdGuardVpnColor.green
        self.layer.cornerRadius = 8.0
        self.backgroundColor = greenColor
        self.setTitleColor(.white, for: .normal)
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    /*
     Makes button look like standard AdGuard button
     with opaque background, green borders and text
     */
    func applyStandardOpaqueStyle() {
        let greenColor = UIColor.AdGuardColor.green
        self.layer.cornerRadius = 8.0
        self.backgroundColor = .clear
        self.setTitleColor(greenColor, for: .normal)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = greenColor.cgColor
    }
    
    /*
     Makes button look like standard AdGuard Sign in button
     */
    func applyRoundRectStyle(color: CGColor) {
        self.layer.cornerRadius = self.frame.height / 4
        self.layer.borderWidth = 1.5
        self.layer.borderColor = color
    }
}
