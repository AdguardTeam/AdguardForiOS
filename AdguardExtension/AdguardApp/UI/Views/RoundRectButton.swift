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

class RoundRectButton: UIButton {
    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var customBackgroundColor: UIColor? {
        didSet{
            updateBackground()
        }
    }
    
    @IBInspectable var customHighlightedBackgroundColor: UIColor? {
        didSet{
            updateBackground()
        }
    }
    
    @IBInspectable var customDisabledBackgroundColor: UIColor? {
        didSet{
            updateBackground()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override var isHighlighted: Bool {
        didSet{
            updateBackground()
        }
    }
    
    override var isSelected: Bool {
        didSet{
            updateBackground()
        }
    }
    
    override var isEnabled: Bool {
        didSet{
            updateBackground()
        }
    }
    
    private func updateBackground() {
        if !isEnabled,
            let disabledColor = customDisabledBackgroundColor {
            self.backgroundColor = disabledColor
        }
        else if isHighlighted,
            let highlightedColor = customHighlightedBackgroundColor {
            self.backgroundColor = highlightedColor
        }
        else if let backgroundColor = customBackgroundColor {
            self.backgroundColor = backgroundColor
        }
        else {
            self.backgroundColor = nil
        }
    }
    
    // increase touch area
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newArea = CGRect(x: self.bounds.origin.x - 10, y: self.bounds.origin.y - 10, width: self.bounds.size.width + 20, height: self.bounds.size.height + 20)
        return newArea.contains(point)
    }
}
