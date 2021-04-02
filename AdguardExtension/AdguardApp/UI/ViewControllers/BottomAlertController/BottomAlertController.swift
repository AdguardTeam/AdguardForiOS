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

class KeyboardMover {
    
    private weak var constraint: NSLayoutConstraint!
    private weak var view: UIView!
    private var initialValue: CGFloat!
    private var tabBar: UITabBar?
    
    init(bottomConstraint: NSLayoutConstraint, view: UIView, tabBar: UITabBar?) {
        self.constraint = bottomConstraint
        self.view = view
        self.initialValue = bottomConstraint.constant
        self.tabBar = tabBar
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
                
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let belongsToApp = userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? Bool else { return }
            
        let keyboardHeight = keyboardFrame.height
        let stateIsActive = UIApplication.shared.applicationState == .active
        let tabBarHeight = tabBar?.frame.height ?? 0.0
        
        if belongsToApp && stateIsActive {
            constraint.constant = keyboardHeight - tabBarHeight + initialValue
        }
            
        UIView.animate(withDuration: 0.5,
                        animations: { self.view.layoutIfNeeded() },
                        completion: nil)
    }
        
    @objc
    func keyboardWillHide(notification: NSNotification) {
        constraint.constant = initialValue
        UIView.animate(withDuration: 0.5,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
}

class BottomAlertController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    private var keyboardMover: KeyboardMover!
    
    private var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    private var bottomSpaceBeforePullUp: CGFloat = 0.0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeRoundCorners()
        subscribeToThemeNotification()
        updateTheme()
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.bottomViewPulled(_:)))
        contentView.addGestureRecognizer(gestureRecognizer)

        let tabBar = tabBarController?.tabBar
        keyboardMover = KeyboardMover(bottomConstraint: keyboardHeightLayoutConstraint, view: view, tabBar: tabBar)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.view != contentView {
            dismiss(animated: true, completion: nil)
        }
        else {
            super.touchesBegan(touches, with: event)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func bottomViewPulled(_ sender: UIPanGestureRecognizer) {
        processPanGesture(sender)
    }
    
    // MARK: - Private methods
    
    private func makeRoundCorners(){
        let corners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        let radius: CGFloat = 24.0
        
        contentView.layer.cornerRadius = radius
        contentView.layer.maskedCorners = corners
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 3
        contentView.layer.shadowOpacity = 1
    }
    
    private func processPanGesture(_ recognizer: UIPanGestureRecognizer) {
        view.endEditing(true) // Hide keyboard when gesture recognized
        
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        if recognizer.state == .began {
            bottomSpaceBeforePullUp = keyboardHeightLayoutConstraint.constant
        }
        
        let resultSpace = bottomSpaceBeforePullUp - translation.y
        if resultSpace > 0 { return }
        
        keyboardHeightLayoutConstraint.constant = resultSpace
        view.layoutIfNeeded()
        
        let percent = 1.0 + resultSpace / contentView.frame.height
        view.backgroundColor = UIColor.AdGuardColor.darkBackground.withAlphaComponent(0.5 * percent)
        
        if recognizer.state == .ended {
            if velocity.y < 0 {
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.keyboardHeightLayoutConstraint.constant = 0.0
                    self?.view.layoutIfNeeded()
                }
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension BottomAlertController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomAlertPresentingTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomAlertDismissingTransition(bottomConstraint: keyboardHeightLayoutConstraint)
    }
}
