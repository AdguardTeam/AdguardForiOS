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

class ActivityViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var changePeriodTypeButton: UIButton!
    
    @IBOutlet weak var requestsNumberLabel: ThemableLabel!
    @IBOutlet weak var blockedNumberLabel: UILabel!
    @IBOutlet weak var dataSavedLabel: UILabel!
    @IBOutlet weak var companiesNumberLabel: ThemableLabel!
    
    @IBOutlet weak var mostActiveCompany: ThemableLabel!
    @IBOutlet weak var mostBlockedCompany: ThemableLabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var themableButtons: [ThemableButton]!
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    
    
    // MARK: - Services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    // MARK: - Notifications
    
    private var themeToken: NotificationToken?
    private var developerModeToken: NSKeyValueObservation?
    
    // MARK: - Public variables
    
    var model: DnsRequestLogViewModel?
    
    // MARK: - Private variables
    
    private let activityTableViewCellReuseId = "ActivityTableViewCellId"
    private let showDnsContainerSegueId = "showDnsContainer"
    
    private var selectedRecord: DnsLogRecordExtended?

    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        
        model?.delegate = self
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        developerModeToken = configuration.observe(\.developerMode) {[weak self] (_, _) in
            self?.observeDeveloperMode()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? DnsContainerController
        controller?.logRecord = selectedRecord
    }
    
    // MARK: - Actions
    
    @IBAction func changePeriodTypeAction(_ sender: UIButton) {
    }
    
    @IBAction func infoAction(_ sender: UIButton) {
    }
    
    
    @IBAction func clearActivityLogAction(_ sender: UIButton) {
    }
    
    @IBAction func changeRequestsTypeAction(_ sender: UIButton) {
    }
    
    // MARK: - Private methods

    private func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        scrollContentView.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        theme.setupSearchBar(searchBar)
        theme.setupLabels(themableLabels)
        theme.setupButtons(themableButtons)
        theme.setupSeparators(separators)
    }
    
    private func observeDeveloperMode(){
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension ActivityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.records.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: activityTableViewCellReuseId) as? ActivityTableViewCell {
            guard let record = model?.records[indexPath.row] else { return UITableViewCell() }
            cell.developerMode = configuration.developerMode
            cell.theme = theme
            cell.record = record
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let record = model?.records[indexPath.row] {
            selectedRecord = record
            performSegue(withIdentifier: showDnsContainerSegueId, sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension ActivityViewController: UISearchBarDelegate {
    
}

// MARK: - UIScrollViewDelegate

extension ActivityViewController: UIScrollViewDelegate {
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        tableView.isScrollEnabled = true
        scrollView.isScrollEnabled = false
    }
}

// MARK: - DnsRequestsDelegateProtocol

extension ActivityViewController: DnsRequestsDelegateProtocol {
    func requestsCleared() {
        
    }
}
