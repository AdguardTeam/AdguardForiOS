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

// MARK: - custom cells
class NewRuleCell: UITableViewCell {
    @IBOutlet weak var addLabel: UILabel!
}

class RuleCell: UITableViewCell {
    @IBOutlet weak var ruleLabel: ThemableLabel!
    @IBOutlet var themableLabels: [ThemableLabel]!
}

class HelpCell : UITableViewCell {
    
    @IBOutlet weak var helpTextView: UITextView!
}

class FilterEnabledCell: UITableViewCell {
    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var enabledLabel: ThemableLabel!
}

// MARK: - UserFilterTableController
class ListOfRulesTableController: UITableViewController, UISearchBarDelegate, UIViewControllerTransitioningDelegate, AddRuleControllerDelegate, ImportRulesControllerDelegate, RuleDetailsControllerDelegate {
    
    //var model: UserFilterViewModel!
    var model: ListOfRulesModel?
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let aeService: AEServiceProtocol = ServiceLocator.shared.getService()!
    private let fileShare = FileShareService()
    private let networking: ACNNetworking = ServiceLocator.shared.getService()!
    
    // forward url params
    private let filterRulesAction = "filter_rules"
    private let openUrlFrom = "user_filter"
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var searchButtonView: UIView!
    @IBOutlet var plusButtonView: UIView!
    @IBOutlet weak var headerTextView: UITextView!
    
    var enabledSwitch: UISwitch!
    var observation: NSKeyValueObservation?
    
    private var isCustomEditing = false
    
    private let enabledSection = 0
    private let helpSection = 1
    private let rulesSection = 2
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        searchButton.customView = searchButtonView
        addButton.customView = plusButtonView
            
        updateUI()
        
        observation = model?.observe(\.listOfRules) {[weak self](_, _) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    deinit {
        observation = nil
    }
    
    // MARK: - public methds
    
    func setCustomEditing(_ editing: Bool) {
        
        isCustomEditing = editing
        tableView.allowsMultipleSelection = editing
        
        tableView.reloadData()
    }
    
    // MARK: - UITableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == rulesSection {
            return model?.listOfRules.count ?? 0
        }
        else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case enabledSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EnabledCellID") as! FilterEnabledCell
            enabledSwitch = cell.enabledSwitch
            let listEnabled = model?.listOfRulesEnabled ?? false
            cell.enabledLabel.text = listEnabled ? ACLocalizedString("on_state", nil) : ACLocalizedString("off_state", nil)
            theme.setupLabel(cell.enabledLabel)
            theme.setupSwitch(cell.enabledSwitch)
            enabledSwitch.isOn = listEnabled
            enabledSwitch?.addTarget(self, action: #selector(toggleEnabled(_:)), for: .valueChanged)
            return cell
            
        case helpSection:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCellID") as! HelpCell
            
            switch (model!.listType) {
            case (.safariUserFilter):
                let htmlStringFormat = model?.descriptionTitle ?? ""
                let urlString = UIApplication.shared.adguardUrl(action: filterRulesAction, from: openUrlFrom)
                let htmlString = String(format: htmlStringFormat, urlString)
                if let headerText = htmlString.attributedStringFromHtml() {
                    headerText.addAttribute(.foregroundColor, value: theme.lightGrayTextColor, range: NSRange(location: 0, length: headerText.length))
                    headerText.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: headerText.length))
                    cell.helpTextView.attributedText = headerText
                }
            default:
                cell.helpTextView.text = model?.descriptionTitle
                cell.helpTextView.textColor = theme.lightGrayTextColor
            }
            cell.helpTextView.backgroundColor = theme.backgroundColor
            theme.setupTextView(cell.helpTextView)
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RuleCellID") as! RuleCell
            let rule = model!.listOfRules[indexPath.row]
            if rule.attributedString == nil {
                cell.ruleLabel.text = rule.rule
            } else {
                cell.ruleLabel.attributedText = rule.attributedString
            }
            
            cell.ruleLabel.textColor = rule.textColor
            cell.ruleLabel.font = rule.font
            
            let selected = rule.selected
            configureCell(cell, selected: selected)
            
            theme.setupTableCell(cell)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section) {
        
        case enabledSection:
            enabledSwitch.setOn(!enabledSwitch.isOn, animated: true)
            
        case helpSection:
            if model!.listType == .safariUserFilter
            {
                UIApplication.shared.openAdguardUrl(action: filterRulesAction, from: openUrlFrom)
            }
            
        case rulesSection:
            guard let rule = model?.listOfRules[indexPath.row] else { return }
            if isCustomEditing {
                if let cell = tableView.cellForRow(at: indexPath) as? RuleCell {
                    toggleCellSelection(cell: cell, rule: rule)
                }
            }
            else {
                showRuleDetails(rule)
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - searchbar delegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model?.searchString = searchText
    }
    
    // MARK: - actions
    
    func deleteAction(sender: UIButton) {
        let index = sender.tag
        
        model?.deleteRule(index: index, errorHandler: { (error) in
            
        }) {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        searchBar.text = ""
        model?.searchString = ""
        searchBar.becomeFirstResponder()
        updateUI()
    }
    
    @IBAction func cancelSearchAction(_ sender: Any) {
        searchBar.text = ""
        model?.searchString = nil
        updateUI()
    }
    
    @IBAction func addAction(_ sender: Any) {
        searchBar.text = ""
        model?.searchString = nil
        
        updateUI()
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "AddRuleController") as? AddRuleController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.delegate = self
        controller.type = model!.listType
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func toggleEnabled(_ sender: UISwitch) {
        model?.listOfRulesEnabled = sender.isOn
        
        // Waiting when UISwitch animation is finished
        // Using this hack, because needed function is changed in IOS 13 and later
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.tableView.reloadSections([self?.enabledSection ?? 0], with: .none)
        }
    }
    
    // MARK: - Presentation delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    // MARK: - AddRuleController delegate
    
    func addRule(rule: String) {
        
        model?.addRule(ruleText: rule, errorHandler: { [weak self] (error) in
                        guard let strongSelf = self else { return }
                        DispatchQueue.main.async {
                            ACSSystemUtils.showSimpleAlert(for: strongSelf, withTitle: nil, message: error.description)
                            self?.tableView.reloadData()
                        }
            },
                      completionHandler: { [weak self] in
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
        })
        
        tableView.reloadData()
        
        updateUI()
    }
    
    func importRules() {
        (parent as! ListOfRulesController).importAction(self)
    }
    
    // MARK: - ImportRulesControllerDelegate
    
    func loadRules(url urlString: String, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: urlString) else {
            DDLogError("(UserFilterTablecontroller) loadRules error. wrong url format: \(urlString)")
            completion(false)
            return
        }
        
        let parser = AASFilterSubscriptionParser(networking: networking)
        parser.parse(from: url) { [weak self]  (result, error) in
            
            guard let strongSelf = self else {return}
            if let parserError = error {
                ACSSystemUtils.showSimpleAlert(for: strongSelf, withTitle: nil, message: parserError.localizedDescription)
                return
            }
            
            if let rules = result?.rules as? [ASDFilterRule] {
                let ruleTexts = rules.map({$0.ruleText})
                self?.model?.addRules(ruleTexts: ruleTexts, errorHandler: { (error) in
                    
                    }, completionHandler: {
                    DispatchQueue.main.async {
                        strongSelf.updateUI()
                        strongSelf.tableView.reloadData()
                        completion(true)
                    }
                })
                return
            }
        }
    }
    
    // MARK: - RuleDetailsController delegate methods
    
    func removeRule(rule: RuleInfo) {
        model?.deleteRule(rule, errorHandler: { (message) in
            
        }, completionHandler: {
            
        })
    }
    
    func changeRule(rule: RuleInfo, newText: String) {
        model?.changeRule(rule: rule, newText: newText, errorHandler: { (error) in
            
        }, completionHandler: { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    public func updateNavBarButtons() {
        updateUI()
    }
    
    // MARK: - private methods
    private func updateUI() {
        
        if model?.searchString != nil {
            // add searchbar if needed
            if tableView.tableHeaderView != searchView {
                tableView.tableHeaderView = searchView
                tableView.layoutIfNeeded()
            }
            
            parent?.navigationItem.rightBarButtonItems = [cancelButton]
        }
        else {
            // hide searchbar if needed
            if tableView.tableHeaderView != headerView {
                tableView.tableHeaderView = headerView
            }
            
            parent?.navigationItem.rightBarButtonItems = [addButton, searchButton]
        }
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupSearchBar(searchBar)
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
    
    private func configureCell(_ cell: RuleCell, selected: Bool) {
        
        if isCustomEditing {
            if cell.accessoryView == nil {
                let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
                image.image = UIImage.init(named: "round-check")
                image.highlightedImage = UIImage.init(named: "round-check-checked")
                cell.accessoryView = image
            }
            cell.selectionStyle = .none
            
            (cell.accessoryView as? UIImageView)?.isHighlighted = selected
        }
        else {
            cell.accessoryView = nil
            cell.selectionStyle = .gray
        }
    }
    
    private func showRuleDetails(_ rule: RuleInfo) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "RuleDetailsController") as? RuleDetailsController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        
        controller.delegate = self
        controller.rule = rule
        controller.type = model!.listType
        
        present(controller, animated: true, completion: nil)
    }
    
    private func toggleCellSelection(cell: RuleCell, rule: RuleInfo) {
        let selected = !rule.selected
        rule.selected = selected
        configureCell(cell, selected: selected)
    }
}
