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

class ListOfRulesController: UIViewController {

    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var listOfRulesContainer: UIView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var middleButton: UIButton!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    var model: ListOfRulesModelProtocol? = nil
    
    /* Services */
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    /* Segue identifiers */
    private let listOfRulesSegueId = "listOfRulesSegue"
    private let safariUserFilterSegueId = "safariUserFilterSegue"
    
    /* Variable to change state of table controller and text view */
    @objc var newRuleText: String?
    
    private var tableController: ListOfRulesTableController?
    private var textViewController: EditingUserFilterController?
    private var keyboardMover: KeyboardMover?
    
    private var isSafariUserFilterScreenShowed = false

    private var state: ControllerState {
        get {
            return model?.state ?? .normal
        }
        set {
            model?.state = newValue
            if model?.type == .safariUserfilter  {
                changeScreen()
            } else {
                tableController?.state = newValue
            }
            changeState()
        }
    }
    
    // MARK: - View Controller life cycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == listOfRulesSegueId {
            if let controller = segue.destination as? ListOfRulesTableController {
                controller.model = model
                model?.delegate = controller
                tableController = controller
            }
        } else if segue.identifier == safariUserFilterSegueId {
            if let controller = segue.destination as? EditingUserFilterController {
                controller.model = model
                textViewController = controller
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewContainer.isHidden = false
        listOfRulesContainer.isHidden = true
        
        if newRuleText != nil && newRuleText!.count > 0 {
            tableController?.addRule(rule: newRuleText!)
            showRuleAddedDialog()
        }
        
        setupBackButton(with: #selector(self.backButtonPressed(sender:)))
    
        let tabBar = tabBarController?.tabBar
        keyboardMover = KeyboardMover(bottomConstraint: bottomConstraint, view: view, tabBar: tabBar)
        
        navigationItem.rightBarButtonItems = [searchButton]
        
        changeRightButtton()
        changeMiddleButton()
        changeLeftButton()
        
        updateTheme()
    }
    
    // MARK: - Actions
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        if state == .normal {
            state = .editing
            navigationItem.rightBarButtonItems = []
        } else {
            state = .normal
            navigationItem.rightBarButtonItems = [searchButton]
        }
    }
    
    @IBAction func middleButtonAction(_ sender: UIButton) {
        if state == .editing {
            if model?.type == .safariUserfilter{
                saveAction()
            } else {
                selectAllAction()
            }
        } else {
            importAction()
        }
    }
    
    @IBAction func leftButtonAction(_ sender: UIButton) {
        if state == .editing {
            if model?.type == .safariUserfilter{
                clearAction()
            } else {
                deleteAction()
            }
        } else {
            exportAction(sender: sender)
        }
    }
    
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        changeNavigationItems(isHidden: true, items: [cancelButton])
        state = .searching
    }
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        changeNavigationItems(isHidden: false, items: [searchButton])
        state = .normal
    }
    
    // MARK: - Private methods -
    
    private func changeNavigationItems(isHidden: Bool, items:[UIBarButtonItem]) {
        navigationItem.setHidesBackButton(isHidden, animated: true)
        navigationItem.rightBarButtonItems = items
    }
    
    private func cancelByNormalState() {
        if state == .normal {
            navigationController?.popViewController(animated: true)
        } else {
            if let item = navigationItem.rightBarButtonItem {
                cancelButtonAction(item)
            } else {
                changeNavigationItems(isHidden: false, items: [searchButton])
                state = .normal
            }
        }
    }
    
    // MARK: - Update theme
    
    private func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        bottomBar.backgroundColor = theme.bottomBarBackgroundColor
        changeState()
    }
    
    // MARK: - Change main screen
    
    private func changeScreen(){
        switch state {
        case .editing:
            textViewController?.textView.text = model?.rules.map { $0.rule }.joined(separator: "\n")
            textViewController?.helperLabel.isHidden = !(textViewController?.textView.text == "")
            prepareForShowingSubscreens()
            textViewController?.textView.becomeFirstResponder()
        case .searching:
            tableController?.state = state
        case .normal:
            if !isSafariUserFilterScreenShowed {
                tableController?.state = state
            } else {
                prepareForShowingSubscreens()
            }
        }
    }
    
    private func prepareForShowingSubscreens() {
        tableViewContainer.isHidden = !tableViewContainer.isHidden
        listOfRulesContainer.isHidden = !listOfRulesContainer.isHidden
        isSafariUserFilterScreenShowed = !isSafariUserFilterScreenShowed
    }
    
    // MARK: - Change buttons titles, colors and actions
    
    private func changeLeftButton(){
        if state == .editing {
            leftButton.setTitle(model?.leftButtonTitle, for: .normal)
            leftButton.setTitleColor(theme.errorRedColor, for: .normal)
        } else {
            leftButton.setTitle(String.localizedString("export"), for: .normal)
            leftButton.setTitleColor(theme.lightGrayTextColor, for: .normal)
        }
    }
    
    private func changeMiddleButton(){
        if state == .editing {
            middleButton.setTitle(model?.middleButtonTitle, for: .normal)
            middleButton.setTitleColor(theme.lightGrayTextColor, for: .normal)
        } else {
            middleButton.setTitle(String.localizedString("import"), for: .normal)
            middleButton.setTitleColor(theme.lightGrayTextColor, for: .normal)
        }
    }
    
    private func changeRightButtton(){
        if state == .editing {
            rightButton.setTitle(ACLocalizedString("common_action_cancel", nil), for: .normal)
            rightButton.setTitleColor(theme.lightGrayTextColor, for: .normal)
        } else {
            let title = model?.type == .safariUserfilter ? ACLocalizedString("common_edit", nil) : ACLocalizedString("common_select", nil)
            rightButton.setTitle(title, for: .normal)
            rightButton.setTitleColor(theme.lightGrayTextColor, for: .normal)
            textViewController?.textView.resignFirstResponder()
        }
        
        rightButton.sizeToFit()
    }
    
    private func changeState(){
        
        if state == .searching {
            bottomBar.isHidden = true
            return
        } else {
            bottomBar.isHidden = false
        }
        
        leftButton.alpha = 0.0
        middleButton.alpha = 0.0
        rightButton.alpha = 0.0
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.changeLeftButton()
            self?.changeMiddleButton()
            self?.changeRightButtton()
        }) {[weak self] (success) in
            self?.leftButton.alpha = 1.0
            self?.middleButton.alpha = 1.0
            self?.rightButton.alpha = 1.0
        }
    }
    
    // MARK: - Buttons actions
    
    private func importAction(){
        model?.importList(parentController: self)
    }
    
    private func exportAction(sender: UIButton){
        model?.exportList(parentController: self, sourceView: sender, sourceRect: sender.frame)
    }
    
    private func selectAllAction(){
        model?.selectAllRules()
        tableController?.tableView.reloadData()
    }
    
    private func clearAction(){
        textViewController?.textView.text = ""
        textViewController?.helperLabel.isHidden = false
    }
    
    private func saveAction(){
        let string: String = textViewController?.textView.text ?? ""
        model?.processRulesFromString(string, errorHandler: {[weak self] (error) in
            guard let sSelf = self else { return }
            ACSSystemUtils.showSimpleAlert(for: sSelf, withTitle: nil, message: error)
        })
        
        changeNavigationItems(isHidden: false, items: [searchButton])
        state = .normal
    }
    
    private func deleteAction(){
        model?.deleteSelectedRules(completionHandler: { rulesWereDeleted in
            DispatchQueue.main.async { [weak self] in
                self?.tableController?.tableView.reloadData()
                if rulesWereDeleted { self?.cancelByNormalState() }
            }
            }, errorHandler: {[weak self] (error) in
                guard let sSelf = self else { return }
                ACSSystemUtils.showSimpleAlert(for: sSelf, withTitle: nil, message: error)
        })
    }
    
    /* Shows when rule from safsri is added */
    private func showRuleAddedDialog() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "RuleAddedController") as? RuleAddedController else { return }
        present(controller, animated: true, completion: nil)
    }
    
    @objc func backButtonPressed(sender: UIBarButtonItem){
       cancelByNormalState()
    }
}

extension ListOfRulesController: ThemableProtocol {
    func themeNeedUpdate() {
        updateTheme()
    }
}
