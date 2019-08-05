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

class SearchFilterController: UITableViewController, UISearchBarDelegate, TagButtonTappedDelegate, UIViewControllerTransitioningDelegate, CustomFilterInfoInfoDelegate, FilterMasterControllerDelegate {
    

    @IBOutlet var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    var viewModel: FilterGroupViewModelProtocol? = nil
    
    private let filterCellId = "filterCellID"
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
                self?.updateTheme()
            }
        
        tableView.tableHeaderView = searchView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 118
        
        self.searchBar.delegate = self

        viewModel?.filtersChangedCallback = { [weak self] in
            self?.tableView.reloadData()
            if self?.tableView.numberOfSections ?? 0 > 0 {
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            self?.tableView.setContentOffset(.zero, animated: false)
            self?.searchBar.text = self?.viewModel?.searchString
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.cancelSearch()
    }

    // MARK: -Table View Delegate and Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.groups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.groups?[section].filters.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let group = viewModel?.groups?[section] else { return UIView() }
        let height: CGFloat = 72.0
        let width: CGFloat = self.view.frame.width
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        view.backgroundColor = theme.backgroundColor
            
        let label = ThemableLabel(frame: CGRect(x: 24.0, y: height - 32, width: width - 24.0, height: 24.0))
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = group.name
        label.textAlignment = .left
        label.greyText = true
        theme.setupLabel(label)
            
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: filterCellId) as! FilterCell
        guard let group = viewModel?.groups?[indexPath.section] else { return UITableViewCell() }
        let filters = group.filters
        let filter = filters[indexPath.row]
        
        // Cell setup
        cell.filterTagsView.delegate = self
        cell.filter = filter
        cell.group = group
        cell.enableSwitch.row = indexPath.row
        cell.enableSwitch.section = indexPath.section
        
        theme.setupLabels(cell.themableLabels)
        theme.setupTableCell(cell)
        theme.setupSwitch(cell.enableSwitch)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let group = viewModel?.groups?[indexPath.section] else { return }
        if group.groupId == FilterGroupId.custom {
            let selectedRow = indexPath.row
            showCustomFilterInfoDialog(for: selectedRow)
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! FilterCell
            if cell.enableSwitch.isEnabled {
                cell.enableSwitch.setOn(!cell.enableSwitch.isOn, animated: true)
                toggleEnableSwitch(cell.enableSwitch)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Searchbar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            viewModel?.cancelSearch()
        }
        viewModel?.searchFilter(query: searchBar.text ?? "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // MARK: - Custom filter info delegate methods
    
    func deleteFilter(filter: Filter) {
        viewModel?.deleteCustomFilter(filter: filter, completion: {[weak self] (succes) in
            self?.tableView.reloadData()
        })
    }
    
    // MARK: - Master view controller delegate
    
    func cancelButtonTapped() {
        viewModel?.cancelSearch()
    }
    
    func searchButtonTapped() {
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func toggleEnableSwitch(_ sender: FilterCellUISwitch) {
        
        guard let row = sender.row else { return }
        guard let section = sender.section else { return }
        
        guard let filter = viewModel?.groups?[section].filters[row] else { return }
        viewModel?.set(filter: filter, enabled: sender.isOn)
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .automatic)
        tableView.endUpdates()
    }
    
    
    // MARK: - Private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
        theme.setupSearchBar(searchBar)
    }
    
    func tagButtonTapped(_ sender: TagButton) {
        viewModel?.switchTag(name: sender.name ?? "")
    }
    
    private func showCustomFilterInfoDialog(for filterIndex: Int) {
        guard let group = viewModel?.groups?.filter({ $0.groupId == FilterGroupId.custom }).first else { return }
        let filters = group.filters
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "CustomFilterInfoController") as? CustomFilterInfoInfoController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.filter = filters[filterIndex]
        controller.delegate = self
            
        present(controller, animated: true, completion: nil)
    }
}

