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
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.numberOfLines = 2
        self.titleLabel?.lineBreakMode = .byWordWrapping
        setConstraints(imageViewOffset: 20)
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            guard oldValue != self.isHighlighted else { return }
            UIView.animate(withDuration: 0.10, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.alpha = self.isHighlighted ? 0.5 : 1
            }, completion: nil)
        }
    }
    
    private func  setConstraints(imageViewOffset: CGFloat) {
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: imageViewOffset).isActive = true
        self.imageView?.widthAnchor.constraint(equalToConstant: self.imageView?.frame.width ?? 0.0).isActive = true
        
        self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
        self.titleLabel?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
     }
}
