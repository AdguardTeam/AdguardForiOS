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

class SwipeInteractor: UIPercentDrivenInteractiveTransition {

    private weak var transitionContext: UIViewControllerContextTransitioning?
    private var gestureRecognizer: UIPanGestureRecognizer
    private var edge: UIRectEdge
    private var initialLocationInContainerView = CGPoint()
    private var initialTranslationInContainerView = CGPoint()
    
    private let xVelocityForComplete: CGFloat = 200.0
    private let xVelocityForCancel: CGFloat = 30.0
    
    init(gestureRecognizer: UIPanGestureRecognizer, edge: UIRectEdge) {
        self.gestureRecognizer = gestureRecognizer
        self.edge = edge
        super.init()
        
        gestureRecognizer.addTarget(self, action: #selector(gestureRecognizeDidUpdate(_:)))
    }

    deinit {
        gestureRecognizer.removeTarget(self, action: #selector(gestureRecognizeDidUpdate(_:)))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        initialLocationInContainerView = gestureRecognizer.location(in: transitionContext.containerView)
        initialTranslationInContainerView = gestureRecognizer.translation(in: transitionContext.containerView)
        
        super.startInteractiveTransition(transitionContext)
    }
    
    private func percentForGesture(_ gesture: UIPanGestureRecognizer) -> CGFloat {
        let transitionContainerView = transitionContext?.containerView
        
        let translationInContainerView = gesture.translation(in: transitionContainerView)
        
        if translationInContainerView.x > 0.0 && initialTranslationInContainerView.x < 0.0 ||
            translationInContainerView.x < 0.0 && initialTranslationInContainerView.x > 0.0 {
            return -1.0
        }

        return abs(translationInContainerView.x) / (transitionContainerView?.bounds ?? CGRect()).width
    }
    
    @objc private func gestureRecognizeDidUpdate(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
            case .began:
                break
            case .changed:
                if percentForGesture(gestureRecognizer) < 0.0 {
                    cancel()
                    gestureRecognizer.removeTarget(self, action: #selector(gestureRecognizeDidUpdate(_:)))
                } else {
                    update(percentForGesture(gestureRecognizer))
                }
            case .ended:
                let transitionContainerView = transitionContext?.containerView
                let velocityInContainerView = gestureRecognizer.velocity(in: transitionContainerView)
                let shouldComplete: Bool
                switch edge {
                case .left:
                    shouldComplete = (percentForGesture(gestureRecognizer) >= 0.4 && velocityInContainerView.x < xVelocityForCancel) || velocityInContainerView.x < -xVelocityForComplete
                case .right:
                    shouldComplete = (percentForGesture(gestureRecognizer) >= 0.4 && velocityInContainerView.x > -xVelocityForCancel) || velocityInContainerView.x > xVelocityForComplete
                default:
                    return
                }

                if shouldComplete {
                    finish()
                } else {
                    cancel()
                }
            default:
                cancel()
        }
    }

}
