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

class AboutTableController : UITableViewController {
    
    private let homeAction = "home"
    private let forumAction = "forum"
    private let acknowledgmentsAction = "acknowledgments"
    
    private let openUrlFrom = "about"
    
    private let licenseSegue = "licenseSegue"
    private let trialSegue = "trialSegue"
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    // MARK: - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }
    
    // MARK: - Actions
 
    @IBAction func siteAction(_ sender: Any) {
        UIApplication.shared.openAdguardUrl(action: homeAction, from: openUrlFrom)
    }
    @IBAction func forumAction(_ sender: Any) {
        UIApplication.shared.openAdguardUrl(action: forumAction, from: openUrlFrom)
    }
    @IBAction func thanksAction(_ sender: Any) {
        UIApplication.shared.openAdguardUrl(action: acknowledgmentsAction, from: openUrlFrom)
    }
    
    @IBAction func licenseAction(_ sender: Any) {
        let segueId = configuration.proStatus ? licenseSegue : trialSegue
        performSegue(withIdentifier: segueId, sender: self)
    }
    
    // MARK: - private methods
    private func updateTheme() {
        theme.setupLabels(themableLabels)
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
}
