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

class GroupsTitleCell: UITableViewCell {
    @IBOutlet weak var groupsTitleLabel: ThemableLabel!
}

class GroupsController: UITableViewController, FilterMasterControllerDelegate {
    
    // MARK: oen url settings
    
    var openUrl: String?
    var openTitle: String?
    
    // MARK: private properties
    
    private let enabledColor = UIColor.init(hexString: "67B279")
    private let disabledColor = UIColor.init(hexString: "D8D8D8")
    
    private let filtersSegueID = "showFiltersSegue"
    private let getProSegueID = "getProSegue"
    
    private let groupsTitleCellId = "GroupsTitleCellId"
    
    // Sections
    private let titleSection = 0
    private let groupsSection = 1
    
    var viewModel: FiltersAndGroupsViewModelProtocol? = nil
    private var selectedIndex: Int?
    
    private lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    private let filtersService: FiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.load() {[weak self] () in
            DispatchQueue.main.async {
                self?.viewModel?.updateAllGroups()
                self?.tableView.reloadData()
                
                self?.processOpenUrl()
            }
        }
        
        viewModel?.bind { [weak self] (Int) in
            self?.tableView.reloadData()
        }
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(GroupsController.refresh), for: .valueChanged)
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.updateAllGroups()
        updateTheme()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if viewModel?.constantAllGroups.count ?? 0 > 0 {
            guard let selectedGroup = viewModel?.constantAllGroups[selectedIndex ?? 0] else { return }
            viewModel?.currentGroup = selectedGroup
        }
        
        viewModel?.cancelSearch()
        
        if segue.identifier == filtersSegueID {
            let controller = segue.destination as! FiltersController
            controller.openUrl = openUrl
            controller.openTitle = openTitle
            controller.viewModel = viewModel
            
            openUrl = nil
            openTitle = nil
        }
    }
    
    // MARK: - table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == titleSection ? 1 : viewModel?.constantAllGroups.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == titleSection, let cell = tableView.dequeueReusableCell(withIdentifier: groupsTitleCellId) as? GroupsTitleCell {
            theme.setupTableCell(cell)
            theme.setupLabel(cell.groupsTitleLabel)
            return cell
        }
        
        guard let group = viewModel?.constantAllGroups[indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as? GroupCell
              else { return UITableViewCell() }
        
        cell.nameLabel.text = group.name
        cell.descriptionLabel.text = group.subtitle
        
        cell.enabledSwitch.isOn = group.enabled
        
        cell.enabledSwitch.tag = indexPath.row
        cell.enabledSwitch.removeTarget(self, action: nil, for: .valueChanged)
        cell.enabledSwitch.addTarget(self, action: #selector(GroupsController.enabledChanged(_:)), for: .valueChanged)
        
        cell.icon.image = UIImage(named: group.iconName ?? "")
        theme.setupSeparator(cell.separator)
        theme.setupLabels(cell.themableLabels)
        
        if group.proOnly && !configuration.proStatus {
            cell.enabledSwitch.isUserInteractionEnabled = false
            cell.descriptionLabel.text = group.groupId == FilterGroupId.security ? String.localizedString("security_description") : String.localizedString("custom_description")
            cell.descriptionLabel.textColor = UIColor(hexString: "#eb9300")
            cell.icon.tintColor = UIColor(hexString: "#d8d8d8")
        } else {
            cell.enabledSwitch.isUserInteractionEnabled = true
            cell.icon.tintColor = UIColor.AdGuardColor.lightGreen1
        }
        theme.setupTableCell(cell)
        theme.setupSwitch(cell.enabledSwitch)
        
        if let lastIndex = viewModel?.constantAllGroups.count, indexPath.row == lastIndex - 1 {
            cell.separator.isHidden = true
        }
        
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
    
    @objc private func refresh() {
        viewModel?.refresh { [weak self] in
            // Delay to show user that filters update is called
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func processOpenUrl() {
        if openUrl != nil {
            if !configuration.proStatus {
                performSegue(withIdentifier: getProSegueID, sender: self)
            }
            else {
                var index = 0
                viewModel?.groups?.forEach{ (group) in
                    if group.groupId == FilterGroupId.custom {
                        selectedIndex = index
                    }
                    index += 1
                }
                
                performSegue(withIdentifier: filtersSegueID, sender: self)
            }
            
            openUrl = nil
        }
    }
}

extension GroupsController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
}
