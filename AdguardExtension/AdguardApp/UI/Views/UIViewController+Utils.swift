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

extension UIViewController {
    
    func showVideoTutorial(){
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
            if let controller = storyboard.instantiateViewController(withIdentifier: "TutorialController") as? AEUIPlayerViewController{
                self?.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func presentBlockRequestController(with domain: String, type: DnsLogButtonType, delegate: AddDomainToListDelegate?){
        DispatchQueue.main.async { [weak self] in
            let activityStoryBoard = UIStoryboard(name: "Activity", bundle: nil)
            guard let controller = activityStoryBoard.instantiateViewController(withIdentifier: "BlockRequestControllerId") as? BlockRequestController else { return }
            
            controller.fullDomain = domain
            controller.type = type
            controller.delegate = delegate
            
            self?.present(controller, animated: true, completion: nil)
        }
    }
    
    func presentEditBlockRequestController(with domain: String, originalDomain: String, type: DnsLogButtonType, delegate: AddDomainToListDelegate?) {
        DispatchQueue.main.async { [weak self] in
            let activityStoryBoard = UIStoryboard(name: "Activity", bundle: nil)
            guard let controller = activityStoryBoard.instantiateViewController(withIdentifier: "EditBlockRequestController") as? EditBlockRequestController else { return }
            
            controller.type = type
            controller.domain = domain
            controller.originalDomain = originalDomain
            controller.delegate = delegate
            self?.present(controller, animated: true, completion: nil)
        }
    }
    
    func setupBackButton(with action: Selector? = nil) {
        let imgBackArrow = UIImage(named: "arrow_right")?.withHorizontallyFlippedOrientation() ?? UIImage()
        
        let selector: Selector?
        
        if action == nil {
            selector = #selector(self.standardAction(sender:))
        } else {
            selector = action
        }
                
        let barButtonItem = UIBarButtonItem(title: "     ", style: .plain, target: self, action: selector)
        barButtonItem.image = imgBackArrow
        
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc private func standardAction(sender: UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }
    
    func animateShowingTitleInNavBar(_ title: String?) {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.3
        fadeTextAnimation.type = .fade

        navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
        navigationItem.title = title
    }
    
    func animateHidingTitleInNavBar() {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.3
        fadeTextAnimation.type = .fade

        navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
        navigationItem.title = ""
    }
}
