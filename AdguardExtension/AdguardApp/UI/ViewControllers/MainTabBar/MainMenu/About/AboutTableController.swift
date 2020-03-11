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
    
    // Sections
    private let titleSection = 0
    private let actionsSection = 1
    
    // Rows
    private let tutorialRow = 0
    private let websiteRow = 1
    private let forumRow = 2
    private let acknowledgmentsRow = 3
    
    @IBOutlet weak var logoImage: ThemeableImageView!
    @IBOutlet weak var versionLabel: ThemableLabel!
    @IBOutlet var loginButton: UIBarButtonItem!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    private var notificationToken: NotificationToken?
    private var proStatusObservation: NSKeyValueObservation?
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken =  NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        proStatusObservation = configuration.observe(\.proStatus) {[weak self] (_, _) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItems = self.configuration.proStatus ? [] : [self.loginButton]
            }
        }
        
        if !configuration.proStatus {
            navigationItem.rightBarButtonItems = [loginButton]
        }
        
        versionLabel.text = ACLocalizedString("about_version", nil) + " " +  ADProductInfo.versionWithBuildNumber()
        
        updateTheme()
        setupBackButton()
    }
    
    // MARK: - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case tutorialRow:
            showVideoTutorial()
        case websiteRow:
            UIApplication.shared.openAdguardUrl(action: homeAction, from: openUrlFrom)
        case forumRow:
            UIApplication.shared.openAdguardUrl(action: forumAction, from: openUrlFrom)
        case acknowledgmentsRow:
            UIApplication.shared.openAdguardUrl(action: acknowledgmentsAction, from: openUrlFrom)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - private methods
    private func updateTheme() {
        theme.setupImage(logoImage)
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
}
