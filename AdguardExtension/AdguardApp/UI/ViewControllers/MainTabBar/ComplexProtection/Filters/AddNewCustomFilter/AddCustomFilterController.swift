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

class AddCustomFilterController: BottomAlertController {
    
    var type: NewFilterType = .safariCustom
    
    private let detailsSegueId = "showFilterDetailsSegue"
    
    @IBOutlet weak var nextButton: RoundRectButton!
    @IBOutlet weak var cancelButton: RoundRectButton!
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let networking: ACNNetworking = ServiceLocator.shared.getService()!
    
    private var filter : AASCustomFilterParserResult?
    var delegate: NewCustomFilterDetailsDelegate?
    
    private var notificationToken: NotificationToken?
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        nextButton.makeTitleTextUppercased()
        cancelButton.makeTitleTextUppercased()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        urlTextField.becomeFirstResponder()
        updateTheme()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailsSegueId {
            if let controller = segue.destination as? NewCustomFilterDetailsController {
                controller.type = type
                controller.filter = filter
                controller.delegate = delegate
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.view != contentView {
            navigationController?.dismiss(animated: true, completion: nil)
        }
        else {
            super.touchesBegan(touches, with: event)
        }
    }
    
    @IBAction func ruleTextChanged(_ sender: UITextField) {
        let enabled = sender.text != "" && sender.text != nil
        nextButton.isEnabled = enabled
    }
    
    
    // MARK: - Actions
    
    @IBAction func continueAction(_ sender: Any) {
        
        nextButton.startIndicator()
        nextButton.isUserInteractionEnabled = false
        guard let urlString = urlTextField?.text else {
            nextButton.isUserInteractionEnabled = true
            nextButton.stopIndicator()
            return
        }
        guard let url = URL(string: urlString) else {
            nextButton.isUserInteractionEnabled = true
            nextButton.stopIndicator()
            return
        }
        let parser = AASFilterSubscriptionParser()
        parser.parse(from: url, networking: networking) { [weak self]  (result, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let parserError = error {
                    ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: parserError.localizedDescription)
                    self.nextButton.isUserInteractionEnabled = true
                    self.nextButton.stopIndicator()
                    return
                }

                if let parserResult = result {
                    self.filter = parserResult
                    self.performSegue(withIdentifier: self.detailsSegueId, sender: self)
                    self.nextButton.isUserInteractionEnabled = true
                    self.nextButton.stopIndicator()
                    return
                }
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - private method
    
    private func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextField(urlTextField)
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
