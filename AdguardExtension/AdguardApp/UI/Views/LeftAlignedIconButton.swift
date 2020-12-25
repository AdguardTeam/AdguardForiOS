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

class LeftAlignedIconButton: ThemableButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .left
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth / 2, bottom: 0, right: 0)
    }
    
    override var isHighlighted: Bool {
        didSet {
            guard oldValue != self.isHighlighted else { return }
            UIView.animate(withDuration: 0.10, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.alpha = self.isHighlighted ? 0.5 : 1
            }, completion: nil)
        }
    }
}
