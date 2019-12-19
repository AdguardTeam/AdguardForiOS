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

import UIKit

class GetProDialogView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
                
        let cornerRadius: CGFloat = traitCollection.horizontalSizeClass == .regular ? 15.0 : 10.0
        let inset: CGFloat = traitCollection.horizontalSizeClass == .regular ? 32.0 : 16.0
        
        let newRect = CGRect(x: rect.minX + inset, y: rect.minY, width: rect.width - inset, height: rect.height)
        
        let inset2: CGFloat = newRect.height / 3
        
        let color = UIColor(hexString: "#f3f3f3")
        let bezierPath = UIBezierPath(roundedRect: newRect, cornerRadius: cornerRadius)
        
        let point1 = CGPoint(x: newRect.minX, y: newRect.minY + inset2)
        bezierPath.move(to: point1)
        
        let point2 = CGPoint(x: rect.minX, y: point1.y + inset2 / 2 )
        bezierPath.addLine(to: point2)
        
        let point3 = CGPoint(x: newRect.minX, y: point2.y + inset2 / 2)
        bezierPath.addLine(to: point3)
        
        color.setFill()
        bezierPath.fill()
        
        let mask = CAShapeLayer()
        mask.path = bezierPath.cgPath
        self.layer.mask = mask
    }

}
