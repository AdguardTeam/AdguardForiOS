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

/**
 Make class expandable if needed
 */
class GradientLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        super.drawText(in: rect.inset(by: insets))
    }
}

class GradientButton: UIButton {
    
    private var backLabel: UILabel?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backLabel = createBackLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        backLabel?.text = title?.uppercased()
        layoutIfNeeded()
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
    
    private func createBackLabel() -> UILabel {
        let label = GradientLabel()
        label.textColor = .white
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        label.font = titleLabel?.font
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.01
        label.lineBreakMode = .byClipping
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        return label
    }
}
