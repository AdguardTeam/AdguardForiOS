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

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var bottomView: UIView?

    private var bottomViewLeftAnchor: NSLayoutConstraint?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        changeLeftAnchor(for: item)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createSelectionIndicator()
        guard let item = tabBar.selectedItem else { return }
        changeLeftAnchor(for: item)
    }
    
    private func changeLeftAnchor(for item: UITabBarItem){
        let numberOfItems = CGFloat(tabBar.items!.count)
        let width: CGFloat = tabBar.frame.width / numberOfItems
        
        let selectedItem = tabBar.items?.index(of: item) ?? 0
        
        bottomViewLeftAnchor?.constant = width / 4 + CGFloat(selectedItem) * width
        
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.tabBar.layoutIfNeeded()
        }
    }
    
    private func createSelectionIndicator() {
        var bottomInset: CGFloat = 0.0
        
        if #available(iOS 11.0, *) {
            bottomInset = tabBar.safeAreaInsets.bottom
        }
        
        if bottomView != nil || bottomInset != 0.0 {
            return
        }
        
        bottomView = UIView()
        bottomView?.isUserInteractionEnabled = false
        bottomView?.translatesAutoresizingMaskIntoConstraints = false
        bottomView?.backgroundColor = UIColor(hexString: "#67b279")
        tabBar.addSubview(bottomView ?? UIView())
        
        let numberOfItems = CGFloat(tabBar.items!.count)
        let lineHeight: CGFloat = 4.0
        let width: CGFloat = tabBar.frame.width / numberOfItems
        
        let mult = 1 / (numberOfItems * 2)
        
        bottomView?.heightAnchor.constraint(equalToConstant: lineHeight).isActive = true
        bottomView?.widthAnchor.constraint(equalTo: tabBar.widthAnchor, multiplier: mult).isActive = true
        bottomViewLeftAnchor = bottomView?.leftAnchor.constraint(equalTo: tabBar.leftAnchor, constant: width / 4)
        bottomViewLeftAnchor?.isActive = true
        bottomView?.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor).isActive = true
        
        let bounds = CGRect(x: 0.0, y: 0.0, width: width / 2, height: lineHeight)
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topLeft , .topRight],
            cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath1.cgPath
        bottomView?.layer.mask = maskLayer
    }

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let fromVCIndex = tabBarController.viewControllers?.index(of: fromVC),
            let toVCIndex = tabBarController.viewControllers?.index(of: toVC) else {
                return nil
        }
        let edge: UIRectEdge = fromVCIndex > toVCIndex ? .right : .left
        
        return CustomNavigationTransitionAnimator(presenting: edge == .left)
    }
}

extension UITabBar {
    override open var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UITraitCollection(horizontalSizeClass: .compact)
        }
        return super.traitCollection
    }
}

