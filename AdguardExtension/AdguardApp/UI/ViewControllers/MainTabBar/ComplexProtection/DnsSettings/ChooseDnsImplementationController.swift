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

protocol ChooseDnsImplementationControllerDelegate: class {
    func currentImplementationChanged()
}

class ChooseDnsImplementationController: BottomAlertController {

    @IBOutlet weak var adGuardButton: UIButton!
    @IBOutlet weak var nativeButton: UIButton!
    
    @IBOutlet weak var separator: UIView!
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var popupButtons: [RoundRectButton]!
    
    weak var delegate: ChooseDnsImplementationControllerDelegate?
    
    // MARK: - Observers
    private var themeObserver: NotificationToken?
    
    // MARK: - services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let nativeProviders: NativeProvidersServiceProtocol = ServiceLocator.shared.getService()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processCurrentImplementation()
        updateTheme()
        
        themeObserver = NotificationCenter.default.observe(name: NSNotification.Name(ConfigurationService.themeChangeNotification), object: nil, queue: .main) {[weak self] (notification) in
            self?.updateTheme()
        }
    }
    
    // MARK: - Private methods
    
    @IBAction func adGuardSelected(_ sender: UIButton) {
        resources.dnsImplementation = .adGuard
        delegate?.currentImplementationChanged()
        processCurrentImplementation()
        if #available(iOS 14.0, *) {
            nativeProviders.removeDnsManager { _ in }
        }
        dismiss(animated: true)
    }
    
    @IBAction func nativeSelected(_ sender: UIButton) {
        resources.dnsImplementation = .native
        delegate?.currentImplementationChanged()
        processCurrentImplementation()
        dismiss(animated: true)
    }
    
    // MARK: - Private methods

    private func updateTheme() {
        contentView.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupSeparator(separator)
        theme.setupPopupButtons(popupButtons)
    }
    
    private func processCurrentImplementation() {
        let implementation = resources.dnsImplementation
        
        adGuardButton.isSelected = implementation == .adGuard
        nativeButton.isSelected = implementation == .native
    }
}
