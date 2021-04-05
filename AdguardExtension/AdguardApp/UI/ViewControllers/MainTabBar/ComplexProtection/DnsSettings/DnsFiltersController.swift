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

protocol DnsFiltersControllerDelegate: AnyObject {
    func filtersStateWasChanged()
}

class DnsFilterTitleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var rulesNumberLabel: ThemableLabel!
}

class AddFilterCell: UITableViewCell {
    
}

class DnsFilterCell: UITableViewCell {
    @IBOutlet weak var filterNameLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var importantDescriptionLabel: ThemableLabel!
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
            let dateFormatedString = String(format: ACLocalizedString("filter_date_format", nil), dateString)
            
            let trimmedString = ((filter?.desc == nil || filter?.desc?.isEmpty ?? true) ? dateFormatedString : filter!.desc! + "\n" + dateFormatedString).trimmingCharacters(in: .whitespaces)
            descriptionLabel.text = trimmedString
            importantDescriptionLabel.text = filter?.importantDesc
            
            filterSwitch.isOn = filter?.enabled ?? false
        }
    }
}

class DnsFiltersController: UITableViewController, UISearchBarDelegate, DnsFiltersChangedProtocol, AddNewFilterDelegate {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    
    private var model: DnsFiltersModelProtocol = DnsFiltersModel(filtersService: ServiceLocator.shared.getService()!, networking: ServiceLocator.shared.getService()!)
    
    private var themeObservation: NotificationToken?
    
    private let filterDetailsControllerId = "FilterDetailsController"
    
    private let titleCellReuseId = "DnsFilterTitleCell"
    private let dnsCellReuseId = "DnsFilterCell"
    private let addFilterCellReuseId = "AddFilterCell"
    
    private let titleSection = 0
    private let addFilterSection = 1
    private let filtersSection = 2
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeObservation = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        resources.sharedDefaults().addObserver(self, forKeyPath: TunnelErrorCode, options: .new, context: nil)
        
        navigationItem.rightBarButtonItems = [searchButton]
        
        model.delegate = self
        searchBar.delegate = self
        
        refreshControl?.addTarget(self, action: #selector(updateFilters(sender:)), for: .valueChanged)
        
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        
        setupBackButton()
        updateTheme()
    }
    
    
    deinit {
        resources.sharedDefaults().removeObserver(self, forKeyPath: TunnelErrorCode)
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if model.isSearchActive && indexPath.section == addFilterSection {
            return 0.0
        }

        if model.isSearchActive && indexPath.section == titleSection {
            return 0.0
        }

        if !configuration.advancedMode && indexPath.section == addFilterSection {
            return 0.0
        }

        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == titleSection {
            return 0.01
        }
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case titleSection:
            return 1
        case addFilterSection:
            return 1
        case filtersSection:
            return model.filters.count
        default:
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == titleSection {
            if let cell = tableView.dequeueReusableCell(withIdentifier: titleCellReuseId) as? DnsFilterTitleCell {
                theme.setupTableCell(cell)
                theme.setupLabel(cell.titleLabel)
                
                let rulesNumberString = String.simpleThousandsFormatting(NSNumber(integerLiteral: model.enabledRulesCount))
                if resources.tunnelErrorCode == 3 {
                    let redColor = UIColor(hexString: "#df3812")
                    cell.rulesNumberLabel.textColor = redColor
                    cell.rulesNumberLabel.text = String(format: String.localizedString("dns_filters_overlimit_title"), rulesNumberString)
                } else {
                    cell.rulesNumberLabel.text = String(format: String.localizedString("dns_filters_number_title"), rulesNumberString)
                    theme.setupLabel(cell.rulesNumberLabel)
                }
                
                if model.isSearchActive{
                    cell.isHidden = true
                }
                return cell
            }
        } else if indexPath.section == addFilterSection {
            if let cell = tableView.dequeueReusableCell(withIdentifier: addFilterCellReuseId) as? AddFilterCell {
                theme.setupTableCell(cell)
                if model.isSearchActive || !configuration.advancedMode{
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        navigationItem.title = String.localizedString("navigation_item_dns_filters_title")
        navigationItem.setHidesBackButton(true, animated:true)
        tableView.tableHeaderView = searchView
        searchBar.becomeFirstResponder()
        
        model.searchFilter(by: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        model.isSearchActive = false
        navigationItem.setHidesBackButton(false, animated:true)
        navigationItem.rightBarButtonItems = [searchButton]
        navigationItem.title = nil
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
    
    // MARK: - DnsFiltersChangedProtocol method
    
    func filtersChanged() {
        tableView.reloadData()
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
        }
    }

    // MARK: - Actions
    
    @IBAction func filterStateAction(_ sender: UISwitch) {
        model.setFilter(index: sender.tag, enabled: sender.isOn)
        updateTextForTitle()
    }
    
    // MARK: - Observing Values from User Defaults
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == TunnelErrorCode {
            updateTextForTitle()
        }
    }
    
    // MARK: - Private methods
    
    private func showAddFilterDialog() {
        let storyboard = UIStoryboard(name: "Filters", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "AddCustomFilterController") as? AddCustomFilterController else { return }
        controller.delegate = self
        controller.type = .dnsCustom
        present(controller, animated: true, completion: nil)
    }
    
    private func showFilterDetailsController(with filter: FilterDetailedInterface) {
        let storyboard = UIStoryboard(name: "Filters", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: filterDetailsControllerId) as? FilterDetailsController else { return }
        controller.delegate = self
        
        controller.filter = filter
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func updateTextForTitle(){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.tableView.reloadSections(IndexSet(integer: self.titleSection), with: .fade)
        }
    }
    
    private func updateTheme() {
        theme.setupTable(tableView)
        view.backgroundColor = theme.backgroundColor
        refreshControl?.tintColor = theme.grayTextColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupSearchBar(searchBar)
        theme.setubBarButtonItem(searchButton)
        theme.setubBarButtonItem(cancelButton)
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func updateFilters(sender: UIRefreshControl) {
        model.updateFilters { [weak self] (success) in
            if success {
                self?.tableView.reloadData()
            }
            self?.refreshControl?.endRefreshing()
        }
    }
}

extension DnsFiltersController: DnsFiltersControllerDelegate {
    func filtersStateWasChanged() {
        model.refreshFilters()
    }
}
