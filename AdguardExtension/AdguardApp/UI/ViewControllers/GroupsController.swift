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

class GroupsController: UITableViewController {
    
    let enabledColor = UIColor.init(hexString: "67B279")
    let disabledColor = UIColor.init(hexString: "D8D8D8")
    
    let filtersSegueID = "showFiltersSegue"
    let customFiltersSegueID = "showCustomFiltersSegue"
    let getProSegueID = "getProSegue"
    
    // MARK: - properties
    let viewModel: FilterGroupViewModelProtocol
    var selectedIndex: Int?
    
    lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    
    let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    let aeService: AEServiceProtocol = ServiceLocator.shared.getService()!
    let filtersService: FiltersServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - lifecycle
    required init?(coder aDecoder: NSCoder) {
        viewModel = FilterGroupViewModel(filtersService: filtersService)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.load() {[weak self] () in
            self?.tableView.reloadData()
        }
        
        viewModel.bind { [weak self] (Int) in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let group = viewModel.groups?[selectedIndex ?? 0] else { return }
        
        let filtersModel = FiltersViewModel(filtersService: filtersService, group: group)
        
        switch segue.identifier {
        case filtersSegueID:
            let controller = segue.destination as! FiltersController
            
            controller.viewModel = filtersModel
        case customFiltersSegueID:
            
            let controller = segue.destination as! FiltersController
            controller.viewModel = filtersModel
            
            break;
        default:
            break;
        }
    }
    
    // MARK: - table view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = viewModel.groups?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as! GroupCell
        
        cell.nameLabel.text = group?.name
        cell.descriptionLabel.text = group?.subtitle
        
        cell.enabledSwitch.isOn = (group?.enabled ?? false)
        
        cell.icon.image = UIImage(named: group?.iconName ?? "")
        cell.enabledSwitch.tag = indexPath.row
        cell.enabledSwitch.removeTarget(self, action: nil, for: .valueChanged)
        cell.enabledSwitch.addTarget(self, action: #selector(GroupsController.enabledChanged(_:)), for: .valueChanged)
        
        var trailingConstraint: CGFloat = 0
        if group?.proOnly ?? false {
            cell.enabledSwitch.isHidden = true
            cell.getPremiumButton.isHidden = false
            cell.icon.tintColor = disabledColor
            trailingConstraint = cell.getPremiumButton.frame.width + 10
        }else {
            cell.enabledSwitch.isHidden = false
            cell.getPremiumButton.isHidden = true
            cell.icon.tintColor = enabledColor
            trailingConstraint = cell.enabledSwitch.frame.width + 10
        }
        
        cell.descriptionTrailingConstraint.constant = trailingConstraint
        cell.nameTrailingConstraint.constant = trailingConstraint

        theme.setupLabels(cell.themableLabels)
        theme.setupTableCell(cell)
        theme.setupSwitch(cell.enabledSwitch)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let group = viewModel.groups![selectedIndex!]
        if group.proOnly {
            performSegue(withIdentifier: getProSegueID, sender: self)
        }
        else if group.groupId == FilterGroupId.custom {
            performSegue(withIdentifier: "showCustomFiltersSegue", sender: self)}
        else {
            performSegue(withIdentifier: "showFiltersSegue", sender: self)
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
    
    // MARK: - private methods
    
    @objc func enabledChanged(_ enableSwitch: UISwitch) {
        let row = enableSwitch.tag
        let group = viewModel.groups![row]
        
        viewModel.set(group: group, enabled: enableSwitch.isOn) { (success) in
        }
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        tableView.reloadData()
    }
}
