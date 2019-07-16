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

class DnsProvidersContainerController: UIViewController, UIViewControllerTransitioningDelegate {
    
    // MARK: - public fields
    
    var provider: DnsProviderInfo?
    
    // MARK: - IB Outlets
    @IBOutlet weak var addProviderButton: RoundRectButton!
    
    @IBOutlet weak var buttonBottomSeparator: UIView!
    @IBOutlet weak var buttonTopSeparator: UIView!
    // MARK: - services
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: Notification.Name(ConfigurationService.themeChangeNotification), object: nil)
        
        updateTheme()
    }
    
    // MARK: - Actions
    
    @IBAction func addProviderAction(_ sender: Any) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "NewDnsServerController") as? NewDnsServerController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    func editProvider(_ provider: DnsProviderInfo) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "EditDnsServerController") as? NewDnsServerController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.provider = provider
        
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Presentation delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    // MARK: - private methods
    
    @objc private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        addProviderButton.customBackgroundColor = theme.popupBackgroundColor
        
        buttonTopSeparator.backgroundColor = theme.separatorColor
        buttonBottomSeparator.backgroundColor = theme.separatorColor
    }
    
}
