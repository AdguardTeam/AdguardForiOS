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

protocol BlockedResponseTtlDelegate: class {
    func setTtlDescription(ttl: String)
}

class BlockedResponseTtlController: BottomAlertController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: RoundRectButton!
    @IBOutlet weak var cancelButton: RoundRectButton!
    @IBOutlet weak var ttlTextField: UITextField!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var textViewUnderline: TextFieldIndicatorView!

    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    
    private var notificationToken: NotificationToken?
    
    weak var delegate: BlockedResponseTtlDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        ttlTextField.text = String(resources.blockedResponseTtlSecs)
        ttlTextField.keyboardType = .numberPad
        ttlTextField.becomeFirstResponder()
        
        updateSaveButton()
        updateTheme()
        
        saveButton.makeTitleTextUppercased()
        cancelButton.makeTitleTextUppercased()
        saveButton.applyStandardGreenStyle()
        cancelButton.applyStandardOpaqueStyle(color: UIColor.AdGuardColor.gray)
    }
    
    // MARK: - Actions
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let text = ttlTextField.text, !text.isEmpty else { return }
        guard let numeric = Int(text), numeric >= 0 else { return }
        resources.blockedResponseTtlSecs = numeric
        vpnManager.updateSettings(completion: nil)
        delegate?.setTtlDescription(ttl: String(numeric))
        dismiss(animated: true)
    }
    
    
    @IBAction func ttlChangedAction(_ sender: UITextField) {
        updateSaveButton()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textViewUnderline.state = .enabled
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textViewUnderline.state = .disabled
    }
    

    // MARK: - Private methods
    
    private func updateTheme() {
        titleLabel.textColor = theme.popupTitleTextColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextField(ttlTextField)
        saveButton?.indicatorStyle = theme.indicatorStyle
        theme.setupSeparators(separators)
    }
    
    private func updateSaveButton() {
        let ttl = ttlTextField.text ?? ""
        guard !ttl.isEmpty && Int(ttl) != nil else { saveButton.isEnabled = false; return }
        saveButton?.isEnabled = true
    }
}
