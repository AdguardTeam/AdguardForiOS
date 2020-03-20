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

class ActivityViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var changePeriodTypeButton: UIButton!
    
    @IBOutlet weak var requestsNumberLabel: ThemableLabel!
    @IBOutlet weak var blockedNumberLabel: UILabel!
    @IBOutlet weak var dataSavedLabel: UILabel!
    @IBOutlet weak var companiesNumberLabel: ThemableLabel!
    
    @IBOutlet weak var mostActiveCompany: ThemableLabel!
    @IBOutlet weak var mostBlockedCompany: ThemableLabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var themableButtons: [ThemableButton]!
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    
    // MARK: - Outlet views for tableview
    @IBOutlet var sectionHeaderView: UIView!
    @IBOutlet var tableHeaderView: UIView!
    
    
    // MARK: - Services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - Notifications
    
    private var themeToken: NotificationToken?
    private var keyboardShowToken: NotificationToken?
    private var developerModeToken: NSKeyValueObservation?
    
    // MARK: - Public variables
    
    var model: DnsRequestLogViewModel?
    
    // MARK: - Private variables
    
    private let activityTableViewCellReuseId = "ActivityTableViewCellId"
    private let showDnsContainerSegueId = "showDnsContainer"
    private let showMostActiveCompaniesSegueId = "showMostActiveCompaniesId"
    
    private var selectedRecord: DnsLogRecordExtended?
    private var activeCompaniesDisplayType: ActiveCompaniesDisplayType?
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        
        setupTableView()
        
        model?.delegate = self
        
        let periodType = resources.sharedDefaults().integer(forKey: ActivityStatisticsPeriodType)
        dateTypeChanged(dateType: ChartDateType(rawValue: periodType) ?? .alltime)
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: .main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        keyboardShowToken = NotificationCenter.default.observe(name: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] (notification) in
            self?.keyboardWillShow()
        }
        
        developerModeToken = configuration.observe(\.developerMode) {[weak self] (_, _) in
            self?.observeDeveloperMode()
        }
        
        model?.recordsObserver = { [weak self] (records) in
            self?.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDnsContainerSegueId, let controller = segue.destination as? DnsContainerController {
            controller.logRecord = selectedRecord
        } else if segue.identifier == showMostActiveCompaniesSegueId, let controller = segue.destination as? MostActiveCompaniesController {
            controller.activeCompaniesDisplayType = activeCompaniesDisplayType
        }
    }
    
    // MARK: - Actions
    
    @IBAction func changePeriodTypeAction(_ sender: UIButton) {
        showChartDateTypeController()
    }
    
    @IBAction func infoAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let title = String.localizedString("requests_info_alert_title")
            let message = String.localizedString("requests_info_alert_message")
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: title, message: message)
        case 1:
            let title = String.localizedString("blocked_info_alert_title")
            let message = String.localizedString("blocked_info_alert_message")
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: title, message: message)
        case 2:
            let title = String.localizedString("data_saved_info_alert_title")
            let message = String.localizedString("data_saved_info_alert_message")
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: title, message: message)
        case 3:
            let title = String.localizedString("companies_info_alert_title")
            let message = String.localizedString("companies_info_alert_message")
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: title, message: message)
        default:
            return
        }
    }
    
    @IBAction func mostActiveTapped(_ sender: UITapGestureRecognizer) {
        activeCompaniesDisplayType = .requests
        performSegue(withIdentifier: showMostActiveCompaniesSegueId, sender: self)
    }
    
    @IBAction func mostBlockedTapped(_ sender: UITapGestureRecognizer) {
        activeCompaniesDisplayType = .blocked
        performSegue(withIdentifier: showMostActiveCompaniesSegueId, sender: self)
    }
    
    @IBAction func clearActivityLogAction(_ sender: UIButton) {
        showResetAlert(sender)
    }
    
    @IBAction func changeRequestsTypeAction(_ sender: UIButton) {
        showGroupsAlert(sender)
    }
    
    // MARK: - Tableview Datasource and Delegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.records.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: activityTableViewCellReuseId) as? ActivityTableViewCell {
            guard let record = model?.records[indexPath.row] else { return UITableViewCell() }
            cell.developerMode = configuration.developerMode
            cell.theme = theme
            cell.record = record
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let record = model?.records[indexPath.row] {
            selectedRecord = record
            performSegue(withIdentifier: showDnsContainerSegueId, sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private methods

    private func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        sectionHeaderView.backgroundColor = theme.backgroundColor
        tableHeaderView.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        theme.setupSearchBar(searchBar)
        theme.setupLabels(themableLabels)
        theme.setupButtons(themableButtons)
        theme.setupSeparators(separators)
        tableView.reloadData()
    }
    
    private func observeDeveloperMode(){
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func showResetAlert(_ sender: UIButton){
        let alert = UIAlertController(title: String.localizedString("reset_activity_title"), message: String.localizedString("reset_activity_message"), preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: String.localizedString("common_action_yes"), style: .destructive) {[weak self] _ in
            alert.dismiss(animated: true, completion: nil)
            self?.model?.clearRecords()
        }
        
        alert.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func showGroupsAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let allRequestsAction = UIAlertAction(title: String.localizedString("all_requests_alert_action"), style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let blockedOnlyAction = UIAlertAction(title: String.localizedString("blocked_only_alert_action"), style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let allowedOnlyAction = UIAlertAction(title: String.localizedString("allowed_only_alert_action"), style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(allRequestsAction)
        alert.addAction(blockedOnlyAction)
        alert.addAction(allowedOnlyAction)
        alert.addAction(cancelAction)
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    /**
     Presents ChartDateTypeController
     */
    private func showChartDateTypeController(){
        let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ChartDateTypeController") as? ChartDateTypeController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    private func setupTableView(){
        let nib = UINib.init(nibName: "ActivityTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: activityTableViewCellReuseId)
    }
    
    private func keyboardWillShow() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension ActivityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model?.searchString = searchText
    }
}

// MARK: - DnsRequestsDelegateProtocol

extension ActivityViewController: DnsRequestsDelegateProtocol {
    func requestsCleared() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - DateTypeChangedProtocol

extension ActivityViewController: DateTypeChangedProtocol {
    func dateTypeChanged(dateType: ChartDateType) {
        resources.sharedDefaults().set(dateType.rawValue, forKey: ActivityStatisticsPeriodType)
        changePeriodTypeButton.setTitle(dateType.getDateTypeString(), for: .normal)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension ActivityViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
}
