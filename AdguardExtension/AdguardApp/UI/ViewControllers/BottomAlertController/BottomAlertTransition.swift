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

class BottomAlertPresentingTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    
    init(duration: TimeInterval = 0.5) {
        self.duration = duration
        super.init()
    }
    
    private let targetColor = UIColor.AdGuardColor.backgroundColor.withAlphaComponent(0.5)
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVc = transitionContext.viewController(forKey: .to) as? BottomAlertController,
            let bottomConstraint = toVc.keyboardHeightLayoutConstraint,
            let toView = toVc.view
        else {
            DDLogError("Animation without Content view")
            return
        }
    
        /*
         We need to hide view and layout it
         Otherwise it will layout it while appearing
        */
        bottomConstraint.constant = -toView.frame.height
        toView.layoutIfNeeded()
        bottomConstraint.constant = 0.0
               
        transitionContext.containerView.addSubview(toView)
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self else { return }
            toView.backgroundColor = self.targetColor
            toView.layoutIfNeeded()
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class BottomAlertDismissingTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    private let bottomConstraint: NSLayoutConstraint!
    
    init(duration: TimeInterval = 0.5, bottomConstraint: NSLayoutConstraint!) {
        self.duration = duration
        self.bottomConstraint = bottomConstraint
        super.init()
    }
    
    private let targetColor = UIColor.clear
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)

        guard let contentView = fromView?.subviews.first else {
            return
        }
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: { [weak self] in
            fromView?.backgroundColor = self?.targetColor
            self?.bottomConstraint.constant = -contentView.frame.height
            fromView?.layoutIfNeeded()
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
