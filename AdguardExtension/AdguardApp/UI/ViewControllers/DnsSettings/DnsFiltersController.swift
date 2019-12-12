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

class AddFilterCell: UITableViewCell {
    
}

class DnsFilterCell: UITableViewCell {
    @IBOutlet weak var filterNameLabel: ThemableLabel!
    @IBOutlet weak var updateLabel: ThemableLabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    var filter: DnsFilter? {
        didSet {
            if let attrString = filter?.attributedString {
                filterNameLabel.attributedText = attrString
            } else {
                filterNameLabel.text = filter?.name
            }
            
            let dateString = filter?.updateDate?.formatedStringWithHoursAndMinutes() ?? ""
            updateLabel.text = String(format: ACLocalizedString("filter_date_format", nil), dateString)
            
            filterSwitch.isOn = filter?.enabled ?? false
        }
    }
}

class DnsFiltersController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, UISearchBarDelegate, DnsFiltersChangedProtocol, NewCustomFilterDetailsDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    lazy private var model: DnsFiltersModel = {
        let filtersService:DnsFiltersServiceProtocol = ServiceLocator.shared.getService()!
        return DnsFiltersModel(filtersService: filtersService)
    }()
    
    private var themeObservation: Any? = nil
    
    private let filterDetailsControllerId = "FilterDetailsController"
    
    private let dnsCellReuseId = "DnsFilterCell"
    private let addFilterCellReuseId = "AddFilterCell"
    
    private let addFilterSection = 0
    private let filtersSection = 1
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themeObservation = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        navigationItem.rightBarButtonItems = [searchButton]
        
        model.delegate = self
        
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.updateFilters()
        updateTheme()
    }
    
    // MARK: - Table view delegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if model.isSearchActive && indexPath.section == addFilterSection{
            return 0.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == addFilterSection ? 1 : model.filters.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == addFilterSection {
            if let cell = tableView.dequeueReusableCell(withIdentifier: addFilterCellReuseId) as? AddFilterCell {
                theme.setupTableCell(cell)
                if model.isSearchActive {
                    cell.isHidden = true
                }
                return cell
            }
        } else if indexPath.section == filtersSection {
            if let cell = tableView.dequeueReusableCell(withIdentifier: dnsCellReuseId) as? DnsFilterCell {
                cell.filter = model.filters[indexPath.row]
                
                theme.setupLabels(cell.themableLabels)
                theme.setupSwitch(cell.filterSwitch)
                theme.setupTableCell(cell)
                
                cell.filterSwitch.tag = indexPath.row
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == addFilterSection {
            showAddFilterDialog()
        } else {
            let filter = model.filters[indexPath.row]
            showFilterDetailsController(with: filter)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        model.isSearchActive = true
        navigationItem.rightBarButtonItems = [cancelButton]
        navigationItem.setHidesBackButton(true, animated:true)
        tableView.tableHeaderView = searchView
        searchBar.becomeFirstResponder()
        
        model.searchFilter(by: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        model.isSearchActive = false
        navigationItem.setHidesBackButton(false, animated:true)
        navigationItem.rightBarButtonItems = [searchButton]
        tableView.tableHeaderView = nil
        searchBar.text = nil
        
        model.searchFilter(by: nil)
    }
    
    // MARK: - Search Bar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.searchFilter(by: searchBar.text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        model.searchFilter(by: nil)
    }
    
    // MARK: - Presentation delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    // MARK: - DnsFiltersChangedProtocol method
    
    func filtersChanged() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - NewCustomFilter delegate
    
    func addCustomFilter(filter: AASCustomFilterParserResult) {
        let meta = filter.meta
        let dnsFilter = DnsFilter(subscriptionUrl: meta.subscriptionUrl, name: meta.name, date: meta.updateDate ?? Date(), enabled: true, desc: meta.descr, version: meta.version, rulesCount: filter.rules.count, homepage: meta.homepage)
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            let isAlreadyAdded = self.model.addFilter(dnsFilter, data: filter.filtersData)
            if isAlreadyAdded {
                ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: String.localizedString("filter_exists"))
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Actions
    
    @IBAction func filterStateAction(_ sender: UISwitch) {
        model.setFilter(index: sender.tag, enabled: sender.isOn)
    }
    
    // MARK: - Private methods
    
    private func showAddFilterDialog() {
        let storyboard = UIStoryboard(name: "Filters", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "NewCustomFilterInfoController") as? UINavigationController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        
        (controller.viewControllers.first as? AddCustomFilterController)?.delegate = self
        (controller.viewControllers.first as? AddCustomFilterController)?.type = .dnsCustom
        
        present(controller, animated: true, completion: nil)
    }
    
    private func showFilterDetailsController(with filter: FilterDetailedInterface) {
        let storyboard = UIStoryboard(name: "Filters", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: filterDetailsControllerId) as? FilterDetailsController else { return }
        
        controller.filter = filter
        controller.isCustom = true
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    private func updateTheme() {
        theme.setupTable(tableView)
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupSearchBar(searchBar)
        theme.setubBarButtonItem(searchButton)
        theme.setubBarButtonItem(cancelButton)
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
}
