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

class SwipeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning{

    var animationDuration: TimeInterval
    var targetEdge: UIRectEdge

    init(animationDuration: TimeInterval = 0.33, targetEdge: UIRectEdge = .right) {
        self.animationDuration = animationDuration
        self.targetEdge = targetEdge
        super.init()
    }

    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated == true) ? animationDuration : 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let screenWidth = UIScreen.main.bounds.size.width
        let containerView = transitionContext.containerView

        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!

        let fromRight = targetEdge == .right

        containerView.addSubview(toView)
        fromView.frame.origin.x = 0
        toView.frame.origin.x = fromRight ? -screenWidth : screenWidth
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        fromView.frame.origin.x = fromRight ? screenWidth : -screenWidth
                        toView.frame.origin.x = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
