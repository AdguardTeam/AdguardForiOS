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
import SafariAdGuardSDK

final class AddCustomFilterController: BottomAlertController {
    
    var type: NewFilterType = .safariCustom
    var openUrl: String?
    var openTitle: String?
    weak var delegate: NewCustomFilterDetailsControllerDelegate?
    
    private let detailsSegueId = "showFilterDetailsSegue"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: RoundRectButton!
    @IBOutlet weak var cancelButton: RoundRectButton!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var textViewUnderline: TextFieldIndicatorView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeObserver: NotificationToken?
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        nextButton.applyStandardGreenStyle()
        cancelButton.applyStandardOpaqueStyle()

        if openUrl != nil {
            urlTextField.text = openUrl
            continueAction(self)
        }
        else {
            urlTextField.becomeFirstResponder()
        }
        
        ruleTextChanged(urlTextField)
        updateTheme()
        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    @IBAction func ruleTextChanged(_ sender: UITextField) {
        let enabled = sender.text != "" && sender.text != nil
        nextButton.isEnabled = enabled
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textViewUnderline.state = .enabled
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textViewUnderline.state = .disabled
    }
    
    // MARK: - Actions
    
    @IBAction func continueAction(_ sender: Any) {
        nextButton.startIndicator()
        nextButton.isEnabled = false
        
        guard let urlString = urlTextField?.text else {
            nextButton.isEnabled = true
            nextButton.stopIndicator()
            return
        }
        guard let url = URL(string: urlString) else {
            nextButton.isEnabled = true
            nextButton.stopIndicator()
            return
        }
        
        let parser = CustomFilterMetaParser()
        do {
            let meta = try parser.getMetaFrom(url: url, for: .safari)
            presentNewCustomFilterDetailsController(meta)
        } catch {
            presentSimpleAlert(title: nil, message: error.localizedDescription, onOkButtonTapped: nil)
        }
        nextButton.isEnabled = true
        nextButton.stopIndicator()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - private method
    
    private func presentNewCustomFilterDetailsController(_ meta: ExtendedCustomFilterMetaProtocol) {
        let presenter = presentingViewController
        dismiss(animated: true) { [weak self] in
            guard let self = self,
                  let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewCustomFilterDetailsController") as? NewCustomFilterDetailsController
            else { return }
            
            controller.delegate = self.delegate
            let model = NewCustomFilterModel(
                filterName: meta.name ?? "",
                filterType: .safariCustom,
                meta: meta
            )
            controller.newFilterModel = model
            presenter?.present(controller, animated: true, completion: nil)
        }
    }
}

enum NewFilterType {
    case safariCustom, dnsCustom
}

extension AddCustomFilterController: ThemableProtocol {
    func updateTheme() {
        titleLabel.textColor = theme.popupTitleTextColor
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextField(urlTextField)
        nextButton.indicatorStyle = theme.indicatorStyle
    }
}
