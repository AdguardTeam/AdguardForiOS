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

class ComplexProtectionSwitch: UIControl {
    
    var isOn = false {
        didSet{
            setOn(on: isOn)
        }
    }
    
    // MARK: - Private variables
    
    private let onColor = UIColor(hexString: "#67b279")
    private let offColor = UIColor(hexString: "#df3812")
    private let thumbColor = UIColor.white
    
    private let thumbShadowColor = UIColor.black
    private let thumbShadowOppacity: Float = 0.23
    
    private let innerShadowView = UIView()
    
    private let width: CGFloat = 80.0
    private let height: CGFloat = 30.0
    private let thumbSide: CGFloat = 50.0
    private let thumbImageSide: CGFloat = 24.0
    
    private var onPoint: CGFloat = 0.0
    private var offPoint: CGFloat = 0.0

    private let onImage: UIImage? = UIImage(named: "switch_on")
    private let offImage: UIImage? = UIImage(named: "switch_off")
    
    private let thumbView = UIView()
    private let thumbImageView = UIImageView()
    
    private var isAnimating = false
    
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    
    // MARK: - UIControl Delegate method
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        animate(on: !isOn)
        return true
    }
    
    // MARK: - private methods
    
    private func customInit(){
        frame.size = CGSize(width: width, height: height)
        backgroundColor = offColor
        layer.cornerRadius = height / 2
        
        innerShadowView.isUserInteractionEnabled = false
        innerShadowView.frame = bounds
        innerShadowView.layer.cornerRadius = height / 2
        innerShadowView.layer.borderWidth = 1.0
        innerShadowView.layer.borderColor = UIColor(hexString: "#1f1f1f").withAlphaComponent(0.2).cgColor
                        
        thumbView.frame.size = CGSize(width: thumbSide, height: thumbSide)
        thumbView.center = CGPoint(x: bounds.minX + thumbSide / 2, y: bounds.midY)
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = thumbSide / 2
        
        thumbView.layer.shadowColor = thumbShadowColor.cgColor
        thumbView.layer.shadowOpacity = thumbShadowOppacity
        thumbView.layer.shadowOffset = .zero
        thumbView.layer.shadowRadius = 5
        
        thumbView.isUserInteractionEnabled = false
        
        onPoint = bounds.maxX - thumbSide / 2
        offPoint = bounds.minX + thumbSide / 2
        
        thumbImageView.frame.size = CGSize(width: thumbImageSide, height: thumbImageSide)
        thumbImageView.image = offImage
        thumbImageView.center = CGPoint(x: bounds.minX + thumbSide / 2, y: bounds.midY + 10.0)
        
        thumbView.addSubview(thumbImageView)
        addSubview(innerShadowView)
        addSubview(thumbView)
    }
    
    private func setOn(on:Bool) {
        animate(on: on)
    }
    
    private func animate(on:Bool) {
        if isAnimating { return }
        
        self.isAnimating = true
        
        isOn = on != isOn ? on : isOn
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction], animations: {[weak self] in
            guard let self = self else { return }
            
            self.thumbView.center.x = self.isOn ? self.onPoint : self.offPoint
            self.backgroundColor = self.isOn ? self.onColor : self.offColor
            self.thumbImageView.image = self.isOn ? self.onImage : self.offImage
        }, completion: {[weak self] _ in
            guard let self = self else { return }
            self.isAnimating = false
            self.sendActions(for: UIControl.Event.valueChanged)
        })
    }
}
