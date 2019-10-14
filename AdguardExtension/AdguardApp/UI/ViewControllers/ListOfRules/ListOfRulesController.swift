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

class ListOfRulesController : UIViewController, UIViewControllerTransitioningDelegate, UITextViewDelegate {
    
    @IBOutlet var helperLabel: ThemableLabel!

    @objc var newRuleText: String?
    
    let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    
    lazy var inverted: Bool = { self.resources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist) }()
    
    var tableController : ListOfRulesTableController?
    
    var model: ListOfRulesModel?
    
    private var textViewIsEditing = false
    
    
    // MARK: IB outlets
    
    @IBOutlet weak var rightButtonView: UIView!
    @IBOutlet weak var leftButtonStack: UIStackView!

    @IBOutlet var editButton: RoundRectButton!
    @IBOutlet var exportButton: UIButton!
    @IBOutlet var importButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: RoundRectButton!
    @IBOutlet var clearButton: RoundRectButton!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet var bottomBarButtons: [RoundRectButton]!
    @IBOutlet weak var bottomBarSeparator: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var rigthButtonViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private let buttonSpacing: CGFloat = 8.0
    
    enum BootomBarState {
        case normal
        case edit
    }
    
    private var barState: BootomBarState = .normal
    
    private var keyboardMover: KeyboardMover?
    
    // MARK: - Viecontroller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardMover = KeyboardMover(bottomConstraint: bottomConstraint, view: view)
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        if newRuleText != nil && newRuleText!.count > 0 {
            tableController?.addRule(rule: newRuleText!)
            showRuleAddedDialog()
        }
        
        navigationItem.title = model?.title
        helperLabel.text = model?.helperLabelText
        
        exportButton.isHidden = model?.listType == .wifiExceptions
        importButton.isHidden = model?.listType == .wifiExceptions
        
        editMode(false)
        
        textView.font = UIFont(name: "PTMono-Regular", size: 15.0)
        textView.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        textView.textContainer.lineFragmentPadding = 0.0
        
        setupBackButton()
        updateTheme()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userFilterTableSegue" {
            let controller = segue.destination as! ListOfRulesTableController
            controller.model = model
            tableController = controller
            
            importButton.setTitle(model?.importTitle, for: .normal)
            exportButton.setTitle(model?.exportTitle, for: .normal)
            updateBottomBar()
        }
    }

    // MARK: - Actions

    @IBAction func editAction(_ sender: Any) {
        textView.text = model?.listOfRules.map { $0.rule }.joined(separator: "\n")
        editMode(true)
        barState = .edit
        updateBottomBar()
    }
    
    @IBAction func exportAction(_ sender: UIView) {
        model?.exportList(parentController: self, sourceView: sender, sourceRect: sender.bounds)
    }
    
    @IBAction func importAction(_ sender: Any) {
        model?.importList(parentController: self)
    }
    
    @IBAction func cancelSelectionAction(_ sender: Any) {
        cancelAction()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        model?.importRules(textView.text) { (error) in
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: error)
        }
        editMode(false)
        barState = .normal
        updateBottomBar()
        textView.resignFirstResponder()
        tableController?.tableView.reloadData()
    }
    
    @IBAction func clearAction(_ sender: Any) {
        textView.text = ""
    }
    
    // MARK: - Presentation delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    // MARK: - TextView delegate methods
    
    func textViewDidChange(_ textView: UITextView) {
        helperLabel.isHidden = !(textView.text.count == 0 && textViewIsEditing)
    }
    
    
    // MARK: - private methods
    private func cancelAction(){
        tableController?.setCustomEditing(false)
        barState = .normal
        model?.selectAllRules(false)
        updateBottomBar()
        editMode(false)
        textView.resignFirstResponder()
    }
    
    private func updateBottomBar() {
        for subview in rightButtonView.subviews {
            subview.removeFromSuperview()
        }
        
        leftButtonStack.arrangedSubviews.forEach { (view) in
            leftButtonStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        var rightButton = cancelButton!
        switch barState {
        case .normal:
            rightButton = editButton
            
            leftButtonStack.addArrangedSubview(exportButton)
            leftButtonStack.addArrangedSubview(importButton)
        case .edit:
            rightButton = cancelButton
            leftButtonStack.addArrangedSubview(saveButton)
            leftButtonStack.addArrangedSubview(clearButton)
        }
        
        rightButtonView.addSubview(rightButton)
        
        rightButton.sizeToFit()
        rigthButtonViewWidthConstraint.constant = rightButton.frame.size.width
        bottomBar.layoutSubviews()
        rightButton.frame = rightButtonView.bounds
    }
    
    private func updateTheme() {
        bottomBar.backgroundColor = theme.bottomBarBackgroundColor
        view.backgroundColor = theme.backgroundColor
        theme.setupPopupButtons(bottomBarButtons)
        bottomBarSeparator.backgroundColor = theme.separatorColor
        theme.setupTextView(textView)
        theme.setupLabel(helperLabel)
        textView.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
    }

    private func showRuleAddedDialog() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "RuleAddedController") as? RuleAddedController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    private func editMode(_ edit: Bool) {
        textViewIsEditing = edit
        helperLabel.isHidden = !(textView.text.count == 0 && textViewIsEditing)
        textView.isHidden = !edit
        if edit {
            textView.becomeFirstResponder()
            navigationItem.rightBarButtonItems = []
        }
        else {
            tableController?.updateNavBarButtons()
        }
    }
}
