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

class SupportTableViewController: UITableViewController {

    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - Services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let support: AESSupportProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - Observers
    private var themeToken: NotificationToken?
    
    // MARK: - Sections and Rows
    
    private let titleSection = 0
    private let optionsSection = 1
    
    private let videoTutorialRow = 0
    private let reportBugRow = 1
    private let reportIncorrectBlockingRow = 2
    private let featureRequestRow = 3
    private let rateAppRow = 4
    private let exportLogsRow = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateTheme()
        setupBackButton()
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: .main) {[weak self] _ in
            self?.updateTheme()
        }
    }
    
    // MARK: - Table view data source
    
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
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (titleSection, _):
            break
        case (optionsSection, videoTutorialRow):
            showVideoTutorial()
        case (optionsSection, reportBugRow):
            reportBugRowTapped()
        case (optionsSection, reportIncorrectBlockingRow):
            reportIncorrectBlockingRowTapped()
        case (optionsSection, featureRequestRow):
            featureRequestRowTapped()
        case (optionsSection, rateAppRow):
            rateAppRowTapped()
        case (optionsSection, exportLogsRow):
            exportLogsTapped()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - private methods
    
    private func reportBugRowTapped() {
        // If user has setup his email in the settings than we will send email with logs to our mail
        if MFMailComposeViewController.canSendMail() {
            support.sendMailBugReport(withParentController: self)
        } else {
            showFeedbackController()
        }
    }
    
    private func reportIncorrectBlockingRowTapped() {
        guard let reportUrl = support.composeWebReportUrl(forSite: nil) else { return }
        UIApplication.shared.open(reportUrl, options: [:], completionHandler: nil)
    }
    
    private func featureRequestRowTapped() {
        showFeedbackController()
    }
    
    private func rateAppRowTapped() {
        UIApplication.shared.openAppStoreToRateApp()
    }
    
    private func exportLogsTapped() {
        guard let exportLogsCell = tableView.cellForRow(at: IndexPath(row: exportLogsRow, section: optionsSection)) else {
            return
        }
        support.exportLogs(withParentController: self, sourceView: exportLogsCell, sourceRect: exportLogsCell.bounds)
    }
    
    private func showFeedbackController() {
        AppDelegate.shared.presentFeedbackController()
    }

    private func updateTheme() {
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        tableView.reloadData()
    }
}
