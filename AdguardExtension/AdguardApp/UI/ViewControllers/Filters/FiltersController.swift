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
class FiltersController: UITableViewController, UISearchBarDelegate, UIViewControllerTransitioningDelegate, CustomFilterInfoInfoDelegate, NewCustomFilterDetailsDelegate, TagButtonTappedDelegate {
    
    var viewModel: FiltersViewModelProtocol?
    
    // MARK:  private properties
    
    var theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private let newFilterCellId = "newCustomFilterReuseID"
    private let filterCellId = "filterCellID"
    private let groupCellId = "GroupCellReuseID"
    private let tagCellId = "tagCellId"
    private let langCellId = "langCellId"
    private let showFilterDetailsSegue = "showFilterDetailsSegue"
    
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
    
    
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 118
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        viewModel?.filtersChangedCallback = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
            sSelf.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            sSelf.tableView.setContentOffset(.zero, animated: false)
        }
        viewModel?.searchChangedCallback = { [weak self] in self?.updateBarButtons() }
        tableView.rowHeight = UITableView.automaticDimension
        updateBarButtons()
        navigationItem.title = viewModel?.group.name
        if viewModel?.customGroup ?? false {
            tableView.tableHeaderView = headerView
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
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
            
            let filter = viewModel?.filters[selectedIndex.row]
            
            detailsController.filter = filter
            detailsController.isCustom = viewModel?.customGroup ?? false
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
            return viewModel?.filters.count ?? 0
        default:
            return 0
        }
    }
    
    static var updated = false
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case groupSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: groupCellId) as! GroupCell
            cell.nameLabel.text = viewModel?.group.name
            cell.descriptionLabel.text = viewModel?.group.subtitle
            cell.icon.image = UIImage(named: viewModel?.group.iconName ?? "")
            
            let enabled = viewModel?.group.enabled ?? false
            if cell.enabledSwitch.isOn != enabled {
                cell.enabledSwitch.setOn(enabled, animated: true)
            }
            cell.enabledSwitch.removeTarget(self, action: nil, for: .valueChanged)
            cell.enabledSwitch.addTarget(self, action: #selector(toogleGroupEnable(_:)), for: .valueChanged)
            
            theme.setupLabels(cell.themableLabels)
            theme.setupTableCell(cell)
            theme.setupSwitch(cell.enabledSwitch)
            cell.separator.backgroundColor = theme.separatorColor
            
            return cell
            
        case addFilterSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: newFilterCellId)
            cell?.isHidden = (viewModel?.customGroup ?? false) ? false : true
            return cell!
            
        case filtersSection:
            let filter = viewModel?.filters[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: filterCellId) as! FilterCell
            cell.filterTagsView.delegate = self
            cell.filterTagsView.filter = filter
            
            cell.name.text = filter?.name ?? ""
            let dateString = filter?.updateDate?.formatedStringWithHoursAndMinutes() ?? ""
            cell.updateDate.text = String(format: ACLocalizedString("filter_date_format", nil), dateString)
            
            if let version = filter?.version {
                cell.version.text = String(format: ACLocalizedString("filter_version_format", nil), version)
            }

            cell.enableSwitch.tag  = indexPath.row
            cell.enableSwitch.isOn = filter?.enabled ?? false
            cell.homepageButton.tag = indexPath.row

            
            let groupEnabled = viewModel?.group.enabled ?? false
            cell.enableSwitch.isEnabled = groupEnabled
            cell.enableSwitch.isUserInteractionEnabled = groupEnabled
            cell.contentView.alpha = groupEnabled ? 1.0 : 0.5
            
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
//                selectedIndex = indexPath.row
//                showCustomFilterInfoDialog()
//            }
//            else {
//                let cell = tableView.cellForRow(at: indexPath) as! FilterCell
//                if cell.enableSwitch.isEnabled {
//                    cell.enableSwitch.setOn(!cell.enableSwitch.isOn, animated: true)
//                    toggleEnableSwitch(cell.enableSwitch)
//                }
//            }
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case groupSection:
            return 72
        case addFilterSection:
            return (viewModel?.customGroup ?? false) ? 60 : 0
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func toggleEnableSwitch(_ sender: UISwitch) {
        let row = sender.tag
        guard let filter = viewModel?.filters[row] else { return }
        viewModel?.set(filter: filter, enabled: sender.isOn)
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0, section: groupSection)], with: .automatic)
        tableView.endUpdates()
    }
    
    @IBAction func showSiteAction(_ sender: UIButton) {
        let row = sender.tag
        let filter = viewModel?.filters[row]
        guard   let homepage = filter?.homepage,
                let url = URL(string: homepage) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
    
    @IBAction func tagAction(_ sender: TagButton) {
        viewModel?.switchTag(name: sender.name ?? "")
    }
    
    @objc func langAction(_ sender: LangButton) {
        viewModel?.switchTag(name: sender.name ?? "")
    }
    
    @objc func toogleGroupEnable(_ sender: UISwitch) {
        viewModel?.setGroup(enabled: sender.isOn)
    }
    
    // MARK: - searchbar methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchFilter(query: searchBar.text ?? "")
    }
    
    // MARK: - Presentation delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    // MARK: - FilterInfo delegate methods
    
    func deleteFilter(filter: Filter) {
        viewModel?.deleteCustomFilter(filter: filter, completion: { (succes) in
            self.tableView.reloadData()
        })
    }
    
    // MARK: - NewCustomFilter delegate
    func addCustomFilter(filter: AASCustomFilterParserResult, overwriteExisted: Bool) {
        viewModel?.addCustomFilter(filter: filter, overwriteExisted: overwriteExisted, completion: { (success) in
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Tag Button Tapped delegate method
    func tagButtonTapped(_ sender: UIButton?) {
        if let lang = sender as? LangButton {
            langAction(lang)
        } else if let tag = sender as? TagButton{
            tagAction(tag)
        }
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
        theme.setupLabels(themableLabels)
    }
    
    private func updateBarButtons() {
        if viewModel!.isSearchActive {
            navigationItem.rightBarButtonItems = [cancelButton]
            tableView.tableHeaderView = searchView
            searchBar.text = viewModel?.searchString
        }
        else {
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
    
    private func showCustomFilterInfoDialog() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "CustomFilterInfoController") as? CustomFilterInfoInfoController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.filter = viewModel?.filters[selectedIndex!]
        controller.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
}
