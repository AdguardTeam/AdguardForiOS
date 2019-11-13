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
    
    let detailsSegueId = "showFilterDetailsSegue"
    
    @IBOutlet weak var nextButton: RoundRectButton!
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    let networking: ACNNetworking = ServiceLocator.shared.getService()!
    
    var filter : AASCustomFilterParserResult?
    var delegate: NewCustomFilterDetailsDelegate?
    
    private var notificationToken: NotificationToken?
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        
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
            let controller = segue.destination as! NewCustomFilterDetailsController
            controller.filter = filter
            controller.delegate = delegate
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
        nextButton.isEnabled = sender.text != "" && sender.text != nil
    }
    
    
    // MARK: - Actions
    
    @IBAction func continueAction(_ sender: Any) {
        
        guard let urlString = urlTextField?.text else { return }
        guard let url = URL(string: urlString) else { return }
        let parser = AASFilterSubscriptionParser(networking: networking)
        parser.parse(from: url) { [weak self]  (result, error) in
            DispatchQueue.main.async {
                guard let strongSelf = self else {return}
                if let parserError = error {
                    ACSSystemUtils.showSimpleAlert(for: strongSelf, withTitle: nil, message: parserError.localizedDescription)
                    return
                }

                if let parserResult = result {
                    DispatchQueue.main.async {
                        strongSelf.filter = parserResult
                        strongSelf.performSegue(withIdentifier: strongSelf.detailsSegueId, sender: strongSelf)
                    }
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
