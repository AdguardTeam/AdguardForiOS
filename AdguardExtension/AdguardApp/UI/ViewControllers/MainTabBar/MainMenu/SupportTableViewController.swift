//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import SharedAdGuardSDK

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(SupportTableViewController.self)

class SupportTableViewController: UITableViewController {

    @IBOutlet var themableLabels: [ThemableLabel]!

    // MARK: - Services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let support: SupportServiceProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!

    // MARK: - Sections and Rows

    private let titleSection = 0
    private let optionsSection = 1

    private let videoTutorialRow = 0
    private let faqRow = 1
    private let reportIncorrectBlockingRow = 2
    private let reportBugRow = 3
    private let discussRow = 4
    private let rateAppRow = 5
    private let exportLogsRow = 6

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTheme()
        setupBackButton()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
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
        case (optionsSection, faqRow):
            UIApplication.shared.openAdguardUrl(action: "faq", from: "support", buildVersion: productInfo.buildVersion())
        case (optionsSection, reportIncorrectBlockingRow):
            reportIncorrectBlockingRowTapped()
        case (optionsSection, discussRow):
            UIApplication.shared.openAdguardUrl(action: "discuss", from: "support", buildVersion: productInfo.buildVersion())
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

    private func reportIncorrectBlockingRowTapped() {
        let reportUrl = ApplicationWebReporter().createUrl()
        UIApplication.shared.open(reportUrl, options: [:], completionHandler: nil)
    }

    private func rateAppRowTapped() {
        AppDelegate.shared.presentRateAppController()
    }

    private func exportLogsTapped() {
        guard let exportLogsCell = tableView.cellForRow(at: IndexPath(row: exportLogsRow, section: optionsSection)) else {
            return
        }

        var zipLog: URL?
        do {
            zipLog = try support.exportLogs()
        } catch {
            LOG.error("On export zip file error occurred: \(error)")
            showUnknownErrorAlert()
        }
        guard let zipLog = zipLog else {
            support.deleteLogsFiles()
            return
        }

        let activityVC = UIActivityViewController(activityItems: [zipLog] as [Any], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {[weak self] _, _, _, error in
            if let error = error {
                LOG.error("Error exporting logs: \(error)")
            }
            self?.support.deleteLogsFiles()
        }

        if let presenter = activityVC.popoverPresentationController {
            presenter.sourceView = exportLogsCell
            presenter.sourceRect = exportLogsCell.bounds
        }

        present(activityVC, animated: true)
    }
}

extension SupportTableViewController: ThemableProtocol {
    func updateTheme() {
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        tableView.reloadData()
    }
}
