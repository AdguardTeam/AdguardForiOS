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

class ListOfRulesTableController: UITableViewController, ListOfRulesModelDelegate, AddRuleControllerDelegate, UIViewControllerTransitioningDelegate, RuleDetailsControllerDelegate, UISearchBarDelegate {

    @IBOutlet var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    /* Services */
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    /* Sections */
    private let enableListOfRulesSection = 0
    private let addRuleSection = 1
    private let rulesSection = 2
    
    /* Reuse identifiers */
    private let enableListReuseId = "enableListOfRulesCell"
    private let addRuleReuseId = "addRuleCell"
    private let ruleReuseId = "ruleCell"
    private let selectRuleReuseId = "selectRuleCell"
    
    private var themeObserver: Any? = nil
    
    var model: ListOfRulesModelProtocol? = nil
    
    var state: ControllerState {
        get {
            return model?.state ?? .normal
        }
        set {
            model?.rules.forEach({ $0.selected = false })
            
            if newValue == .searching && state == .normal{
                model?.state = newValue
                deleteSections()
            } else if newValue == .normal && state == .searching {
                model?.state = newValue
                insertSections()
            } else {
                model?.state = newValue
                DispatchQueue.main.async {[weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
                self?.updateTheme()
        }
        updateTheme()
    }
    
    // MARK: - Actions
    
    @IBAction func listOfRulesStateAction(_ sender: UISwitch) {
        model?.enabled = sender.isOn
        tableView.reloadRows(at: [IndexPath(row: 0, section: enableListOfRulesSection)], with: .fade)
    }
    
    @IBAction func changeRuleStateAction(_ sender: UIButton) {
        guard let rule = model?.rules[sender.tag] else { return }
        rule.enabled = !rule.enabled
        
        model?.changeRule(rule: rule, newText: rule.rule, errorHandler: {[weak self] (error) in
            guard let self = self else { return }
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: error)
        }, completionHandler: {})
        
        let section = state == .searching ? 0 : rulesSection
        let indexPath = IndexPath(row: sender.tag, section: section)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Searchbar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model?.searchString = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return state == .normal ? 3 : 1
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == enableListOfRulesSection ? 20.0 : super.tableView(tableView, heightForFooterInSection: section)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if state == .normal {
            switch section {
            case enableListOfRulesSection:
                return 1
            case addRuleSection:
                return 1
            case rulesSection:
                return model?.rules.count ?? 0
            default:
                return 0
            }
        } else {
            return model?.rules.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if state == .normal {
            switch indexPath.section {
            case enableListOfRulesSection:
                return setupEnableListOfRulesCell()
            case addRuleSection:
                return setupAddRuleCell()
            case rulesSection:
                return setupNormalRuleCell(row: indexPath.row)
            default:
                return UITableViewCell()
            }
        } else if state == .searching {
            return setupNormalRuleCell(row: indexPath.row)
        } else {
            return setupSelectedRuleCell(row: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if state == .normal {
            switch indexPath.section {
            case enableListOfRulesSection:
                break
            case addRuleSection:
                addRule()
            case rulesSection:
                showRuleDetails(indexPath: indexPath)
            default:
                break
            }
        } else if state == .editing {
            selectRule(indexPath: indexPath)
        } else {
            showRuleDetails(indexPath: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - ListOfRulesModelDelegate method
    
    func listOfRulesChanged() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    // MARK: - AddRuleController delegate
    
    func addRule(rule: String) {
        model?.addRule(ruleText: rule, errorHandler: { [weak self] (error) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                ACSSystemUtils.showSimpleAlert(for: strongSelf, withTitle: nil, message: error.description)
                self?.tableView.reloadData()
            }
        }, completionHandler: { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    func addRuleFromSafari(rule: String){
        model?.addRule(ruleText: rule, errorHandler: { [weak self] (error) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                ACSSystemUtils.showSimpleAlert(for: strongSelf, withTitle: nil, message: error.description)
                self?.tableView.reloadData()
            }
        }, completionHandler: { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Presentation delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    // MARK: - RuleDetailsControllerDelegate methods
    
    func removeRule(rule: RuleInfo) {
        model?.delete(rule: rule, errorHandler: { _ in }, completionHandler: {})
    }
    
    func changeRule(rule: RuleInfo, newText: String) {
        model?.changeRule(rule: rule, newText: newText, errorHandler: {[weak self] (error) in
            guard let sSelf = self else { return }
            ACSSystemUtils.showSimpleAlert(for: sSelf, withTitle: nil, message: error)
        }, completionHandler: {[weak self] in
            guard let sSelf = self else { return }
            DispatchQueue.main.async {
                if sSelf.state == .searching {
                    let string = sSelf.model?.searchString
                    sSelf.model?.searchString = string
                } else {
                    sSelf.tableView.reloadData()
                }
            }
        })
    }
    
    
    // MARK: - Update theme
    
    private func updateTheme(){
        theme.setupTable(tableView)
        tableView.backgroundColor = theme.backgroundColor
        view.backgroundColor = theme.backgroundColor
        theme.setupSearchBar(searchBar)
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Cells setup functions
    
    private func setupEnableListOfRulesCell() -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: enableListReuseId) as? EnableListOfRulesCell{
            cell.theme = theme
            cell.rulesDescription = model?.descriptionTitle
            cell.type = model?.type
            cell.serviceState = model?.enabled
            return cell
        }
        return UITableViewCell()
    }
    
    private func setupAddRuleCell() -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: addRuleReuseId) as? AddRuleCell{
            cell.theme = theme
            cell.type = model?.type
            return cell
        }
        return UITableViewCell()
    }
    
    private func setupNormalRuleCell(row: Int) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ruleReuseId) as? NormalRuleCell, let rule = model?.rules[row]{
            cell.theme = theme
            
            if state == .searching && (rule.attributedString != nil) {
                cell.ruleNameLabel.attributedText = rule.attributedString
            } else {
                cell.ruleNameLabel.attributedText = nil
                cell.rule = rule
                cell.type = model?.type
            }
            
            cell.ruleState = rule.enabled
            cell.changeRuleStateButton.tag = row
            cell.separatorView.isHidden = row + 1 == model?.rules.count
            return cell
        }
        return UITableViewCell()
    }
    
    private func setupSelectedRuleCell(row: Int) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: selectRuleReuseId) as? SelectRuleCell{
            cell.theme = theme
            cell.ruleName = model?.rules[row].rule
            cell.ruleIsSelected = model?.rules[row].selected
            cell.separatorView.isHidden = row + 1 == model?.rules.count
            return cell
        }
        return UITableViewCell()
    }
    
    /* Calls AddRuleController */
    private func addRule(){
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "AddRuleController") as? AddRuleController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.delegate = self
        controller.type = model?.type ?? .safariUserfilter
        
        present(controller, animated: true, completion: nil)
    }
    
    private func showRuleDetails(indexPath: IndexPath) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "RuleDetailsController") as? RuleDetailsController else { return }
        guard let rule = model?.rules[indexPath.row] else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        
        controller.delegate = self
        controller.rule = rule
        controller.type = model?.type ?? .safariUserfilter
        
        present(controller, animated: true, completion: nil)
    }
    
    /* Selects/Deselects rules */
    private func selectRule(indexPath: IndexPath){
        guard let rule = model?.rules[indexPath.row] else { return }
        rule.selected = !rule.selected
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func deleteSections(){
        searchView.alpha = 0.0
        searchBar.alpha = 0.0
        tableView.tableHeaderView = searchView
        
        DispatchQueue.main.async {[weak self] in
            UIView.animate(withDuration: 0.5){
                self?.tableView.deleteSections([0,1], with: .top)
                self?.searchView.alpha = 1.0
                self?.searchBar.alpha = 1.0
                self?.searchBar.becomeFirstResponder()
            }
        }
    }
    
    private func insertSections(){
        DispatchQueue.main.async {[weak self] in

            self?.searchBar.resignFirstResponder()
            self?.searchBar.text = nil
            self?.tableView.tableHeaderView = nil
            
            UIView.animate(withDuration: 0.5){
                self?.tableView.beginUpdates()
                self?.tableView.reloadSections([0], with: .right)
                self?.tableView.insertSections([0,1], with: .right)
                self?.tableView.endUpdates()
            }
        }
    }
}
