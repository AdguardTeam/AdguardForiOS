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
import SafariAdGuardSDK

class AddCustomFilterController: BottomAlertController {
    
    var type: NewFilterType = .safariCustom
    var openUrl: String?
    var openTitle: String?
    
    private let detailsSegueId = "showFilterDetailsSegue"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: RoundRectButton!
    @IBOutlet weak var cancelButton: RoundRectButton!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var textViewUnderline: TextFieldIndicatorView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let networking: ACNNetworking = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    
    private var filter : ExtendedCustomFilterMetaProtocol?
    var delegate: AddNewFilterDelegate?
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        nextButton.makeTitleTextUppercased()
        cancelButton.makeTitleTextUppercased()
        nextButton.applyStandardGreenStyle()
        cancelButton.applyStandardOpaqueStyle()

        if openUrl != nil {
            urlTextField.text = openUrl
            continueAction(self)
        }
        else {
            urlTextField.becomeFirstResponder()
        }
        
        updateTheme()
        ruleTextChanged(urlTextField)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        // todo: add this functionality to sdk
//        let parser = AASFilterSubscriptionParser()
//        parser.parse(from: url, networking: networking) { [weak self]  (result, error) in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                if let parserError = error {
//                    ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: parserError.localizedDescription)
//                    self.nextButton.isEnabled = true
//                    self.nextButton.stopIndicator()
//                    return
//                }
//
//                if let parserResult = result {
//                    self.filter = parserResult
//                    self.nextButton.isEnabled = true
//                    self.nextButton.stopIndicator()
//                    self.presentNewCustomFilterDetailsController()
//                    return
//                }
//            }
//        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - private method
    
    private func presentNewCustomFilterDetailsController() {
        let presenter = presentingViewController
        dismiss(animated: true) {[weak self] in
            guard let self = self else { return }
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewCustomFilterDetailsController") as? NewCustomFilterDetailsController else { return }
            controller.filterType = self.type
            controller.filter = self.filter
            controller.addDelegate = self.delegate
            
            if let title = self.openTitle {
                // TODO
                //controller.filter?.name = title
            }
            
            presenter?.present(controller, animated: true, completion: nil)
        }
        
    }
}

enum NewFilterType {
    case safariCustom, dnsCustom
    
    func getTitleText() -> String {
        switch self {
        case .safariCustom:
            return String.localizedString("new_filter_title")
        case .dnsCustom:
            return String.localizedString("new_dns_filter_title")
        }
    }
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
