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
 CustomAnimatedTransitioning is using to present View Controller as bottom aligned alert
 */
class CustomAnimatedTransitioning : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        
        transitionContext.containerView.addSubview(toView)
        
        transitionContext.containerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let fromPoint = CGPoint(x: transitionContext.containerView.frame.origin.x, y: transitionContext.containerView.frame.origin.y + 210)//transitionContext.containerView.frame.size.height)
        toView.frame = CGRect(origin: fromPoint, size: transitionContext.containerView.frame.size)
        UIView.animate(withDuration: 0.2) {
            toView.frame = transitionContext.containerView.frame
            transitionContext.completeTransition(true)
        }
    }
}
