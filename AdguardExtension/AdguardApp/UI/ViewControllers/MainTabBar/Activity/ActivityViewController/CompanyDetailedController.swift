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

class CompanyDetailedController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var titleLabel: ThemableLabel!
    
    @IBOutlet weak var requestsNumberLabel: ThemableLabel!
    @IBOutlet weak var blockedNumberLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var themableButtons: [ThemableButton]!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - Services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    // MARK: - Notifications
    
    private var themeToken: NotificationToken?
    private var developerModeToken: NSKeyValueObservation?
    
    // MARK: - Public variables
    
    // MARK: - Private variables
    
    private let activityTableViewCellReuseId = "ActivityTableViewCellId"
    
    //var model:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        
        setupTableView()
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        developerModeToken = configuration.observe(\.developerMode) {[weak self] (_, _) in
            self?.observeDeveloperMode()
        }
    }
    
    // MARK: - Actions
    
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
        default:
            return
        }
    }
    
    @IBAction func changeRequestsTypeAction(_ sender: UIButton) {
        showGroupsAlert(sender)
    }
    
    // MARK: - Private methods

    private func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        scrollContentView.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        theme.setupSearchBar(searchBar)
        theme.setupLabels(themableLabels)
        theme.setupButtons(themableButtons)
        tableView.reloadData()
    }
    
    private func observeDeveloperMode(){
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView(){
        let nib = UINib.init(nibName: "ActivityTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: activityTableViewCellReuseId)
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
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CompanyDetailedController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: activityTableViewCellReuseId) as? ActivityTableViewCell {

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension CompanyDetailedController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
