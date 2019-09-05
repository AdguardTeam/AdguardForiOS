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


class Confirm2FaController : UIViewController {
    
    // MARK: - public properties
    
    var credentials: (name: String, password: String)?
    
    // MARK: - services
    
    private let purchaseService: PurchaseService = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - IB outlets
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var codeLine: UIView!
    @IBOutlet weak var confirmButton: RoundRectButton!
    
    // MARK: - private properties
    
    var notificationHandler: LoginNotificationHandler?
 
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        
        notificationHandler = LoginNotificationHandler(parentController: self) { [weak self] in
            guard let sSelf = self else { return }
            var toController: UIViewController?
            for controller in sSelf.navigationController!.viewControllers {
                if controller.isKind(of: LoginController.self) || controller.isKind(of: Confirm2FaController.self) {
                    break;
                }
                toController = controller
            }
            
            if toController != nil {
                self?.navigationController?.popToViewController(toController!, animated: true)
            }
        }
        
        updateUI()
        updateTheme()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        super.viewDidLoad()
    }
    
    // MARK: - actions
    @IBAction func confirmAction(_ sender: Any) {
        if credentials != nil {
            purchaseService.login(name: credentials!.name, password: credentials!.password, code2fa: codeTextField.text)
        }
    }
    
    // MARK: - private methods
    
    func updateUI() {
        confirmButton.isEnabled = codeTextField.text?.count ?? 0 > 0
    }
    
    func updateTheme() {
        theme.setupLabels(themableLabels)
        theme.setupTextField(codeTextField)
        theme.setupSeparator(codeLine)
        view.backgroundColor = theme.backgroundColor
    }
}
