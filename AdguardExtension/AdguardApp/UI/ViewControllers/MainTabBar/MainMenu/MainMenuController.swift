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

class MainMenuController: UITableViewController {
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let support: AESSupportProtocol = ServiceLocator.shared.getService()!
    private var dnsProviders: DnsProvidersService = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let filtersService: FiltersServiceProtocol = ServiceLocator.shared.getService()!
    
    
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var safariProtectionLabel: ThemableLabel!
    @IBOutlet weak var systemProtectionLabel: ThemableLabel!
    @IBOutlet weak var bugreportCell: UITableViewCell!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private var themeObserver: NotificationToken?
    private var filtersCountObservation: Any?
    private var activeFiltersCountObservation: Any?
    
    private var proStatus: Bool {
        return configuration.proStatus
    }
    
    // MARK: - view controler life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
        systemProtectionLabel.text = proStatus ? dnsProviders.currentServerName : String.localizedString("system_dns_server")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsImageView.image = UIImage(named: "advanced-settings-icon")
        
        themeObserver = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        let updateFilters: ()->() = { [weak self] in
            guard let self = self else { return }
            let safariFiltersTextFormat = String.localizedString("safari_filters_format")
            self.safariProtectionLabel.text = String.localizedStringWithFormat(safariFiltersTextFormat, self.filtersService.activeFiltersCount)
        }

        activeFiltersCountObservation = (filtersService as! FiltersService).observe(\.activeFiltersCount) { (_, _) in
            updateFilters()
        }
        
        updateFilters()
    }
    
    func proStatusEnableFailure() {}
    
    // MARK: - Actions
    @IBAction func contactSupportAction(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: ACLocalizedString("common_action_cancel", nil), style: .cancel, handler: nil)
        
        let rateAppAction = UIAlertAction(title: String.localizedString("rate_app_title"), style: .default) {[weak self] (action) in
            let storyboard = UIStoryboard(name: "RateApp", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "RateAppDialogController")
            self?.present(controller, animated: true)
        }
        
        let justSendFeedback = UIAlertAction(title: String.localizedString("just_send_feedback"), style: .default) {[weak self] (action) in
            let storyboard = UIStoryboard(name: "RateApp", bundle: nil)
            if let controller = storyboard.instantiateViewController(withIdentifier: "FeedbackController") as? UINavigationController {
                if let feedbackController = controller.viewControllers.first as? FeedbackController {
                    feedbackController.simpleFeedback = false
                    self?.present(controller, animated: true)
                }
            }
        }
         
        let incorrectAction = UIAlertAction(title: ACLocalizedString("incorrect_blocking_report", nil), style: .default) { (action) in
            guard let reportUrl = self.support.composeWebReportUrl(forSite: nil) else { return }
            UIApplication.shared.open(reportUrl, options: [:], completionHandler: nil)
        }
    
        let contactSupportAction = UIAlertAction(title: ACLocalizedString("action_contact_support", nil), style: .default) { (action) in
            
            self.support.sendMailBugReport(withParentController: self)
        }
        
        let exportLogsAction = UIAlertAction(title: ACLocalizedString("action_export_logs", nil), style: .default) { (action) in
            
            self.support.exportLogs(withParentController: self, sourceView: self.bugreportCell, sourceRect: self.bugreportCell.bounds);
        }
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(rateAppAction)
        actionSheet.addAction(justSendFeedback)
        actionSheet.addAction(incorrectAction)
        actionSheet.addAction(contactSupportAction)
        actionSheet.addAction(exportLogsAction)
        
        let popController = actionSheet.popoverPresentationController
        popController?.sourceView = self.bugreportCell
        popController?.sourceRect = self.bugreportCell.bounds
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - table view cells
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 32.0 : 0.1
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
}
