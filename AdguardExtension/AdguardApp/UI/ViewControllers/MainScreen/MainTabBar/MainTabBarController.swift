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

class MainTabBarController: UITabBarController {
    private(set) var swipeAnimatedTransitioning = SwipeTransitionAnimator()
    private(set) var tapAnimatedTransitioning = SwipeTransitionAnimator()
    private var currentAnimatedTransitioningType = SwipeTransitionAnimator()
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    private let bottomView = UIView()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    private func customInit() {
        delegate = self
        currentAnimatedTransitioningType = tapAnimatedTransitioning
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerDidPan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)

        // bottom view setups
        bottomView.backgroundColor = UIColor(hexString: "#67b279")
        bottomView.frame.size = CGSize(width: tabBar.itemWidth, height: 4.0)
        tabBar.addSubview(bottomView)
    }
    
    @objc private func panGestureRecognizerDidPan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            currentAnimatedTransitioningType = tapAnimatedTransitioning
        }

        if transitionCoordinator != nil {
            return
        }
        
        if sender.state == .began {
            currentAnimatedTransitioningType = swipeAnimatedTransitioning
        }

        if sender.state == .began || sender.state == .changed {
            beginInteractiveTransitionIfPossible(sender)
        }
    }
    
    private func beginInteractiveTransitionIfPossible(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if translation.x > 0.0 && selectedIndex > 0 {
            selectedIndex -= 1
        } else if translation.x < 0.0 && selectedIndex + 1 < viewControllers?.count ?? 0 {
            selectedIndex += 1
        } else {
            if !translation.equalTo(CGPoint.zero) {
                // There is not a view controller to transition to, force the
                // gesture recognizer to fail.
                sender.isEnabled = false
                sender.isEnabled = true
            }
        }
        
        transitionCoordinator?.animate(alongsideTransition: nil) { [unowned self] context in
            if context.isCancelled && sender.state == .changed {
                self.beginInteractiveTransitionIfPossible(sender)
            }
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let fromVCIndex = tabBarController.viewControllers?.index(of: fromVC),
            let toVCIndex = tabBarController.viewControllers?.index(of: toVC) else {
                return nil
        }
        let edge: UIRectEdge = fromVCIndex > toVCIndex ? .right : .left
        
        currentAnimatedTransitioningType.targetEdge = edge
        return currentAnimatedTransitioningType
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if panGestureRecognizer.state == .began || panGestureRecognizer.state == .changed {
            return SwipeInteractor(gestureRecognizer: panGestureRecognizer, edge: currentAnimatedTransitioningType.targetEdge)
        } else {
            return nil
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return transitionCoordinator == nil
    }
}
