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

class MainNavigationController: UINavigationController {
    
    var customStatusBarStyle: UIStatusBarStyle?
    
    private lazy var theme: ThemeServiceProtocol =  { ServiceLocator.shared.getService()! }()
   
    private let edgeSwipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomTransitioning()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        if customStatusBarStyle != nil {
            return customStatusBarStyle!
        }
        else {
            return theme.statusbarStyle()
        }
    }
    
    static private var coordinatorHelperKey = "UINavigationController.TransitionCoordinatorHelper"

    private var transitionCoordinatorHelper: CustomNavigationTransitionCoordinator? {
        return objc_getAssociatedObject(self, &MainNavigationController.coordinatorHelperKey) as? CustomNavigationTransitionCoordinator
    }

    func addGestureRecognizer(){
        let edgeSwipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        if view.gestureRecognizers?.isEmpty ?? false{
            view.addGestureRecognizer(edgeSwipeGestureRecognizer)
        }
    }
    
    func removeGestureRecognizer(){
        let gestures = view.gestureRecognizers ?? []
        for gesture in gestures {
            view.removeGestureRecognizer(gesture)
        }
    }
    
    private func addCustomTransitioning() {
        var object = objc_getAssociatedObject(self, &MainNavigationController.coordinatorHelperKey)

        guard object == nil else {
            return
        }

        object = CustomNavigationTransitionCoordinator()
        let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
        objc_setAssociatedObject(self, &MainNavigationController.coordinatorHelperKey, object, nonatomic)

        delegate = object as? CustomNavigationTransitionCoordinator
        
        let edgeSwipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        view.addGestureRecognizer(edgeSwipeGestureRecognizer)
    }

    @objc private func handleSwipe(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        guard let gestureRecognizerView = gestureRecognizer.view else {
            transitionCoordinatorHelper?.interactionController = nil
            return
        }
        
        let percent = gestureRecognizer.translation(in: gestureRecognizerView).x / gestureRecognizerView.bounds.size.width
        
        if gestureRecognizer.state == .ended {
            cancelTransition(gestureRecognizer: gestureRecognizer, percent: percent)
        }
        
        if gestureRecognizer.state == .began {
            transitionCoordinatorHelper?.interactionController = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            transitionCoordinatorHelper?.interactionController?.update(percent)
        } else if gestureRecognizer.state == .ended {
            cancelTransition(gestureRecognizer: gestureRecognizer, percent: percent)
        }
    }
    
    private func cancelTransition(gestureRecognizer: UIPanGestureRecognizer, percent: CGFloat){
        // 30% of screen is needed to make transition finish
        if percent > 0.3 && gestureRecognizer.state != .cancelled {
            transitionCoordinatorHelper?.interactionController?.finish()
        } else {
            transitionCoordinatorHelper?.interactionController?.cancel()
        }
        transitionCoordinatorHelper?.interactionController = nil
    }
}
