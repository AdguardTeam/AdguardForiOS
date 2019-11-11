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
import UIKit

class GroupsController: UITableViewController, FilterMasterControllerDelegate {
    
    let enabledColor = UIColor.init(hexString: "67B279")
    let disabledColor = UIColor.init(hexString: "D8D8D8")
    
    let filtersSegueID = "showFiltersSegue"
    let getProSegueID = "getProSegue"
    
    // MARK: - properties
    var viewModel: FiltersAndGroupsViewModelProtocol? = nil
    var selectedIndex: Int?
    
    lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    
    let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    let filtersService: FiltersServiceProtocol = ServiceLocator.shared.getService()!
    let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    private var notificationToken: NotificationToken?
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        viewModel?.load() {[weak self] () in
            DispatchQueue.main.async {
                self?.viewModel?.updateAllGroups()
                self?.tableView.reloadData()
            }
        }
        
        viewModel?.bind { [weak self] (Int) in
            self?.tableView.reloadData()
        }
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: Selector(("refresh")), for: .valueChanged)
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.updateAllGroups()
        updateTheme()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedGroup = viewModel?.constantAllGroups[selectedIndex ?? 0] else { return }
        viewModel?.currentGroup = selectedGroup
        
        viewModel?.cancelSearch()
        
        if segue.identifier == filtersSegueID {
            let controller = segue.destination as! FiltersController
            controller.viewModel = viewModel
        }
    }
    
    // MARK: - table view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.constantAllGroups.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let group = viewModel?.constantAllGroups[indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as! GroupCell
        
        cell.nameLabel.text = group.name
        cell.descriptionLabel.text = group.subtitle
        
        cell.enabledSwitch.isOn = group.enabled
        
        cell.enabledSwitch.tag = indexPath.row
        cell.enabledSwitch.removeTarget(self, action: nil, for: .valueChanged)
        cell.enabledSwitch.addTarget(self, action: #selector(GroupsController.enabledChanged(_:)), for: .valueChanged)
        
        cell.icon.image = UIImage(named: group.iconName ?? "")
        
        theme.setupLabels(cell.themableLabels)
        
        var trailingConstraint: CGFloat = 0
        if group.proOnly && !configuration.proStatus {
            cell.enabledSwitch.isHidden = true
            cell.getPremiumButton.isHidden = false
            cell.descriptionLabel.text = group.groupId == FilterGroupId.security ? ACLocalizedString("security_description", nil) : ACLocalizedString("custom_description", nil)
            cell.descriptionLabel.textColor = UIColor(hexString: "#eb9300")
            cell.icon.tintColor = UIColor(hexString: "#d8d8d8")
            trailingConstraint = cell.getPremiumButton.frame.width + 10.0 + 15.0
        } else {
            cell.enabledSwitch.isHidden = false
            cell.getPremiumButton.isHidden = true
            cell.icon.tintColor = UIColor(hexString: "#67b279")
            trailingConstraint = cell.enabledSwitch.frame.width + 10.0 + 15.0
        }
        
        cell.descriptionTrailingConstraint.constant = trailingConstraint
        cell.nameTrailingConstraint.constant = trailingConstraint

        theme.setupTableCell(cell)
        theme.setupSwitch(cell.enabledSwitch)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        guard let group = viewModel?.constantAllGroups[selectedIndex!] else { return }
        if group.proOnly && !configuration.proStatus {
            performSegue(withIdentifier: getProSegueID, sender: self)
        }
        else {
            performSegue(withIdentifier: filtersSegueID, sender: self)
        }
    }
    
    @IBAction func switchTap(_ sender: UIView) {
        for subview in (sender.superview?.subviews)! {
            if subview.isKind(of: UISwitch.self) {
                let enableSwitch = subview as! UISwitch
                enableSwitch.setOn(!enableSwitch.isOn, animated: true)
                enabledChanged(enableSwitch)
            }
        }
    }
    
    
    // MARK: - Master view controller delegate
    
    func cancelButtonTapped() {
        tableView.reloadData()
    }
    
    func searchButtonTapped() {
        
    }
    
    
    // MARK: - private methods
    
    @objc func enabledChanged(_ enableSwitch: UISwitch) {
        // Waiting when UISwitch animation is finished
        // Using this hack, because needed function is changed in IOS 13 and later
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            let row = enableSwitch.tag
            guard let group = self?.viewModel?.constantAllGroups[row] else { return }
            self?.viewModel?.set(groupId: group.groupId, enabled: enableSwitch.isOn)
        }
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
    
    @objc private func refresh() {
        viewModel?.refresh { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
}
