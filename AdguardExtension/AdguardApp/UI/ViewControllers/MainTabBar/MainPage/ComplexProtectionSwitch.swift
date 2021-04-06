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

protocol ComplexSwitchDelegate {
    func beginTracking()
}

class ComplexProtectionSwitch: UIControl {
    
    private(set) var isOn = false
    
    var delegate: ComplexSwitchDelegate?
    
    private var initialSwitchState = false
    
    // MARK: - Private variables
    
    private let onColor = UIColor.AdGuardColor.lightGreen1
    private let offColor = UIColor(hexString: "#df3812")
    private let thumbColor = UIColor.white
    
    private let thumbShadowColor = UIColor.black
    private let thumbShadowOppacity: Float = 0.23
    
    private let innerShadowView = UIView()
    
    private var width: CGFloat {
        get {
            return frame.width
        }
    }
    private var height: CGFloat {
        get {
            return frame.height
        }
    }
    
    private var thumbSide: CGFloat {
        get{
            return height * 5 / 3
        }
    }
    private var thumbImageSide: CGFloat {
        get {
            return thumbSide / 2
        }
    }
    
    private var onPoint: CGFloat = 0.0
    private var offPoint: CGFloat = 0.0

    private let onImage: UIImage? = UIImage(named: "switch_on")
    private let offImage: UIImage? = UIImage(named: "switch_off")
    
    private let thumbView = UIView()
    private let thumbImageView = UIImageView()
    
    private var isAnimating = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    override func layoutSubviews() {
        layoutSwitch()
    }
    
    // MARK: - Public method
    
    func setOn(on: Bool){
        isOn = on
        animate(on: on) {[weak self] in
            
        }
    }
    
    // MARK: - UIControl Delegate method
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        initialSwitchState = isOn
        
        delegate?.beginTracking()
        
        let color = isOn ? onColor.cgColor : offColor.cgColor
        
        thumbView.layer.shadowRadius = 10
        thumbView.layer.shadowOpacity = 1.0
        thumbView.layer.shadowColor = color
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let color = isOn ? onColor.cgColor : offColor.cgColor
        thumbView.layer.shadowColor = color
        
        let x = touch.location(in: self).x
        
        if x > width / 2 {
            animate(on: true){ [weak self] in
                self?.isOn = true
            }
        } else {
            animate(on: false){ [weak self] in
                self?.isOn = false
            }
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        if touch?.tapCount ?? 0 > 0 {
            self.generator.impactOccurred()
            animate(on: !isOn){ [weak self] in
                guard let self = self else { return }
                self.isOn = !self.isOn
                self.sendActions(for: UIControl.Event.valueChanged)
            }
            setNeutralShadows()
            return
        }
        
        let x = touch?.location(in: self).x ?? 0.0
        
        if x > width / 2 {
            self.generator.impactOccurred()
            animate(on: true){ [weak self] in
                guard let self = self else { return }
                self.isOn = true
                if self.initialSwitchState != self.isOn {
                    self.sendActions(for: UIControl.Event.valueChanged)
                }
            }
        } else {
            self.generator.impactOccurred()
            animate(on: false){ [weak self] in
                guard let self = self else { return }
                self.isOn = false
                if self.initialSwitchState != self.isOn {
                    self.sendActions(for: UIControl.Event.valueChanged)
                }
            }
        }
        
        setNeutralShadows()
    }
    
    // MARK: - private methods
    
    /**
     This method is called from "layoutSubviews"
     */
    private func layoutSwitch(){
        frame.size = CGSize(width: width, height: height)
        layer.cornerRadius = height / 2
        
        innerShadowView.frame = bounds
        innerShadowView.layer.cornerRadius = height / 2
                        
        thumbView.frame.size = CGSize(width: thumbSide, height: thumbSide)
        thumbView.center = CGPoint(x: bounds.minX + thumbSide / 2, y: bounds.midY)
        thumbView.layer.cornerRadius = thumbSide / 2
    
        thumbImageView.frame.size = CGSize(width: thumbImageSide, height: thumbImageSide)
        thumbImageView.center = CGPoint(x: thumbView.bounds.midX, y: thumbView.bounds.midY)
        
        onPoint = bounds.maxX - thumbSide / 2
        offPoint = bounds.minX + thumbSide / 2
        
        switchAnimation(on: isOn)
    }
    
    /**
     This method is called from initializators
     */
    private func customInit(){
        backgroundColor = offColor
        
        innerShadowView.isUserInteractionEnabled = false
        innerShadowView.layer.borderWidth = 3.0
        innerShadowView.layer.borderColor = UIColor(hexString: "#1f1f1f").withAlphaComponent(0.05).cgColor
        
        thumbView.backgroundColor = thumbColor
        setNeutralShadows()
        thumbView.layer.shadowOffset = .zero
        thumbView.isUserInteractionEnabled = false
                
        thumbImageView.image = offImage
        
        thumbView.addSubview(thumbImageView)
        addSubview(innerShadowView)
        addSubview(thumbView)
    }

    /**
     Animates switch position
     */
    private func animate(on:Bool, completion:@escaping () -> ()) {
        
        if isAnimating && isOn == on {
            completion()
            return
        }
        
        self.isAnimating = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction], animations: {[weak self] in
            guard let self = self else { return }
            self.switchAnimation(on: on)
        }, completion: {[weak self] _ in
            guard let self = self else { return }
            self.isAnimating = false
            completion()
        })
    }
    
    /**
     Switch position changes that are animated in "animate" function
     */
    private func switchAnimation(on: Bool){
        thumbView.center.x = on ? onPoint : offPoint
        backgroundColor = on ? onColor : offColor
        thumbImageView.image = on ? onImage : offImage
    }
    
    /**
     Sets neutral shadows for thumbView
     */
    private func setNeutralShadows(){
        thumbView.layer.shadowColor = thumbShadowColor.cgColor
        thumbView.layer.shadowOpacity = thumbShadowOppacity
        thumbView.layer.shadowRadius = 5
    }
}
