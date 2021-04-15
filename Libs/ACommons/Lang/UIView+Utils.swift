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

extension UIView {
    // Use to animate image rotation
    // if isNedeed = true -> rotates
    // if isNedeed = false -> stops to rotate
    public func rotateImage(isNedeed: Bool){
        switch isNedeed {
        case true:
            let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber(value: .pi * 2.0)
            rotationAnimation.duration = 0.9;
            rotationAnimation.isCumulative = true;
            rotationAnimation.repeatCount = .infinity;
            rotationAnimation.isRemovedOnCompletion = false;
            layer.add(rotationAnimation, forKey: "rotationAnimation")
        default:
            layer.removeAnimation(forKey: "rotationAnimation")
        }
    }
    
    func removeAllSubviews() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func fadeIn(_ duration: TimeInterval = 0.3, _ delay: TimeInterval = 0.0, onCompletion: (() -> Void)? = nil) {
        self.isHidden = false
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: [.curveEaseIn],
                       animations: { self.alpha = 1 },
                       completion: { _ in
                            onCompletion?()
                       }
        )
    }

    func fadeOut(_ duration: TimeInterval = 0.3, _ delay: TimeInterval = 0.0, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: [.beginFromCurrentState, .curveEaseIn],
                       animations: { self.alpha = 0 },
                       completion: { _ in
                           self.isHidden = true
                           onCompletion?()
                       }
        )
    }
    
    /* Finds the view controller responsible for a view */
    var responsibleViewController: UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.responsibleViewController
        } else {
            return nil
        }
    }
}
