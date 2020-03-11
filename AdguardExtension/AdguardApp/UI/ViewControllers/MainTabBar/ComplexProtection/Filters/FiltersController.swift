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


// MARK: - FiltersController
class FiltersController: UITableViewController, UISearchBarDelegate, UIViewControllerTransitioningDelegate, NewCustomFilterDetailsDelegate, TagButtonTappedDelegate {
    
    var viewModel: FiltersAndGroupsViewModelProtocol?
    var group: Group? {
        get {
            if viewModel?.isSearchActive ?? false {
                if viewModel?.groups?.count == 0{
                    return nil
                }
                return viewModel?.groups?[0]
            }
            return viewModel?.currentGroup
        }
    }
    
    // MARK:  private properties
    
    var theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private let newFilterCellId = "newCustomFilterReuseID"
    private let filterCellId = "filterCellID"
    private let groupCellId = "GroupCellReuseID"

    private let showFilterDetailsSegue = "showFilterDetailsSegue"
    private let filtersControllerKey = "filtersControllerKey"

    
    private var selectedIndex: Int?
    
    private let groupSection = 0
    private let addFilterSection = 1
    private let filtersSection = 2
    
    // MARK:  IB Outlets
    
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var headerLabel: ThemableLabel!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private var notificationToken: NotificationToken?
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 118.0
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        // Add callback to viewModel
        let filtersChangedCallback = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
            sSelf.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            sSelf.tableView.setContentOffset(.zero, animated: false)
        }
        viewModel?.add(filtersChangedCallback, with: filtersControllerKey)
        
        viewModel?.searchChangedCallback = { [weak self] in self?.updateBarButtons() }

        tableView.rowHeight = UITableView.automaticDimension
        updateBarButtons()
        navigationItem.title = viewModel?.currentGroup?.name ?? ""
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(FiltersController.refresh), for: .valueChanged)
        
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let searchString = viewModel?.searchString else { return }
        
        if searchString.count > 0 {
            viewModel?.searchFilter(query: searchString)
            searchBar.becomeFirstResponder()
        }
        
        viewModel?.updateCurrentGroup()
        updateTheme()
    }
    
    deinit {
        viewModel?.currentGroup = nil
        viewModel?.removeCallback(with: filtersControllerKey)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showFilterDetailsSegue {
            
            guard let detailsController = segue.destination as? FilterDetailsController else {
                assertionFailure("unexpected destination controller")
                return
            }
            guard let selectedIndex = tableView.indexPathForSelectedRow else {
                assertionFailure("cell not selected")
                return
            }
            
            let filter = group?.filters[selectedIndex.row]
            
            detailsController.filter = filter
        }
    }
    
    // MARK: - TableView delegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case groupSection, addFilterSection:
            return 1
        case filtersSection:
            return group?.filters.count ?? 0
        default:
            return 0
        }
    }
    
    static var updated = false
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case groupSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: groupCellId) as! GroupCell
            
            let enabled = viewModel?.currentGroup?.enabled ?? false
            if cell.enabledSwitch.isOn != enabled {
                cell.enabledSwitch.setOn(enabled, animated: true)
            }
            cell.nameLabel.text = enabled ? ACLocalizedString("on_state", nil) : ACLocalizedString("off_state", nil)
            cell.enabledSwitch.removeTarget(self, action: nil, for: .valueChanged)
            cell.enabledSwitch.addTarget(self, action: #selector(toogleGroupEnable(_:)), for: .valueChanged)
            
            theme.setupTableCell(cell)
            theme.setupLabels(cell.themableLabels)
            theme.setupSwitch(cell.enabledSwitch)
            cell.separator.backgroundColor = theme.separatorColor
            
            return cell
            
        case addFilterSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: newFilterCellId)
            cell?.isHidden = group?.groupId == FilterGroupId.custom ? false : true
            return cell!
            
        case filtersSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: filterCellId) as! FilterCell
            let filter = group?.filters[indexPath.row]

            // Cell setup
            cell.filterTagsView.delegate = self
            
            cell.filter = filter
            cell.group = group
            cell.enableSwitch.row = indexPath.row
            
            theme.setupLabels(cell.themableLabels)
            theme.setupTableCell(cell)
            theme.setupSwitch(cell.enableSwitch)
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case groupSection:
            break
        case addFilterSection:
            showAddFilterDialog()
        case filtersSection:
            performSegue(withIdentifier: showFilterDetailsSegue, sender: self)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case groupSection:
            return viewModel?.isSearchActive ?? true ? 0.0 : 72.0
        case addFilterSection:
            return group?.groupId == FilterGroupId.custom ? 60 : 0
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !(group?.groupId == FilterGroupId.custom) {
            return nil
        }
        return section == addFilterSection ? headerView : nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !(group?.groupId == FilterGroupId.custom) {
            return 0.0
        }
        return section == addFilterSection ? 72.0 : 0.0
    }
    
    // MARK: - Actions
    
    @IBAction func toggleEnableSwitch(_ sender: FilterCellUISwitch) {
        // Waiting when UISwitch animation is finished
        // Using this hack, because needed function is changed in IOS 13 and later
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let row = sender.row else { return }
            guard let filter = self?.group?.filters[row] else { return }
            self?.viewModel?.set(filter: filter, enabled: sender.isOn)
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
        viewModel?.searchFilter(query: "")
        self.updateBarButtons()
        searchBar.becomeFirstResponder()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        tableView.tableHeaderView = nil
        viewModel?.cancelSearch()
        self.updateBarButtons()
    }
    
    private func tagAction(_ sender: TagButton) {
        viewModel?.switchTag(name: sender.name ?? "")
    }
    
    @objc func toogleGroupEnable(_ sender: UISwitch) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {[weak self] in
            guard let sGroup = self?.viewModel?.currentGroup else { return }
            self?.viewModel?.set(groupId: sGroup.groupId, enabled: sender.isOn)
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - searchbar methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchFilter(query: searchBar.text ?? "")
    }
    
    // MARK: - Presentation delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    // MARK: - NewCustomFilter delegate
    func addCustomFilter(filter: AASCustomFilterParserResult) {
        viewModel?.addCustomFilter(filter: filter, completion: { (success) in
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Tag Button Tapped delegate method
    func tagButtonTapped(_ sender: TagButton) {
        tagAction(sender)
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
        theme.setupSearchBar(searchBar)
        theme.setubBarButtonItem(searchButton)
        theme.setubBarButtonItem(cancelButton)
        theme.setupLabels(themableLabels)
    }
    
    private func updateBarButtons() {
        if viewModel!.isSearchActive {
            navigationItem.rightBarButtonItems = [cancelButton]
            tableView.tableHeaderView = searchView
            searchBar.text = viewModel?.searchString
            navigationItem.setHidesBackButton(true, animated:true)
        }
        else {
            navigationItem.setHidesBackButton(false, animated:true)
            navigationItem.rightBarButtonItems = [searchButton]
            tableView.tableHeaderView = nil
            searchBar.text = viewModel?.searchString
        }
    }
    
    private func showAddFilterDialog() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "NewCustomFilterInfoController") as? UINavigationController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        
        (controller.viewControllers.first as? AddCustomFilterController)?.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    @objc private func refresh() {
        viewModel?.refresh { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}
