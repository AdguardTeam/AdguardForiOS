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

class ListOfRulesTableController: UITableViewController, ListOfRulesModelDelegate, AddRuleControllerDelegate, UIViewControllerTransitioningDelegate, RuleDetailsControllerDelegate {

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
    
    var isEditingg: Bool = false {
        didSet{
            if !isEditingg {
                model?.rules.forEach({ $0.selected = false })
            }
            DispatchQueue.main.async {[weak self] in
                self?.tableView.reloadData()
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
    }
    
    @IBAction func changeRuleStateAction(_ sender: UIButton) {
        guard let rule = model?.rules[sender.tag] else { return }
        rule.enabled = !rule.enabled
        
        let indexPath = IndexPath(row: sender.tag, section: rulesSection)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return isEditingg ? 1 : 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEditingg {
            return model?.rules.count ?? 0
        } else {
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
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isEditingg {
            return setupSelectedRuleCell(row: indexPath.row)
        } else {
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
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditingg{
            selectRule(indexPath: indexPath)
        } else {
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
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - ListOfRulesModelDelegate method
    
    func listOfRulesChanged() {
        tableView.reloadData()
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
    
    // MARK: - RuleDetailsControllerDelegate methods
    
    func removeRule(rule: RuleInfo) {
        model?.delete(rule: rule, errorHandler: { _ in }, completionHandler: {})
    }
    
    func changeRule(rule: RuleInfo, newText: String) {
        model?.changeRule(rule: rule, newText: newText, errorHandler: {[weak self] (error) in
            guard let sSelf = self else { return }
            ACSSystemUtils.showSimpleAlert(for: sSelf, withTitle: nil, message: error)
        }, completionHandler: {
            DispatchQueue.main.async {[weak self] in
                self?.tableView.reloadData()
            }
        })
    }
    
    
    // MARK: - Update theme
    
    private func updateTheme(){
        theme.setupTable(tableView)
        tableView.backgroundColor = theme.backgroundColor
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: ruleReuseId) as? NormalRuleCell{
            cell.theme = theme
            cell.ruleName = model?.rules[row].rule
            cell.ruleState = model?.rules[row].enabled
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
//        searchBar.text = ""
//        model?.searchString = nil
        
//        updateUI()
        
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
}
