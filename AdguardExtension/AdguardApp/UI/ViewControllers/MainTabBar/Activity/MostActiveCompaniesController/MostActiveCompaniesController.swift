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

enum ActiveCompaniesDisplayType: Int {
    typealias RawValue = Int
    case requests = 0, blocked = 1
    
    var title: String {
        get {
            switch self {
            case .requests:
                return String.localizedString("most_active_companies")
            case .blocked:
                return String.localizedString("most_blocked_companies")
            }
        }
    }
}

class MostActiveCompaniesController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var controllerTitle: ThemableLabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - Services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // MARK: - Notifications
    private var themeToken: NotificationToken?
    
    // MARK: - Public variables

    var chartDateType: ChartDateType?
    var activeCompaniesDisplayType: ActiveCompaniesDisplayType?
    
    var mostRequestedCompanies: [CompanyRequestsRecord] = []
    var mostBlockedCompanies: [CompanyRequestsRecord] = []
    
    // MARK: - Private variables
    
    private var choosenRecord: CompanyRequestsRecord?
    
    private let mostActiveCompaniesCellReuseId = "MostActiveCompaniesCellId"
    private let showCompanyDetailsSegueId = "showCompanyDetails"
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        setupBackButton()
        
        segmentedControl.selectedSegmentIndex = activeCompaniesDisplayType?.rawValue ?? 0
        animateTitleTextChange()
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showCompanyDetailsSegueId {
            if let controller = segue.destination as? CompanyDetailedController {
                controller.record = choosenRecord
                controller.chartDateType = chartDateType
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        let index = segmentedControl.selectedSegmentIndex
        activeCompaniesDisplayType = ActiveCompaniesDisplayType(rawValue: index)
        animateTitleTextChange()
        tableView.reloadData()
    }
    
    // MARK: - Private methods

    private func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        theme.setupLabels(themableLabels)
        theme.setupSegmentedControl(segmentedControl)
        tableView.reloadData()
    }
    
    private func animateTitleTextChange() {
        UIView.transition(with: controllerTitle, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.controllerTitle.text = self?.activeCompaniesDisplayType?.title
        })
    }
}

extension MostActiveCompaniesController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeCompaniesDisplayType == .requests ? mostRequestedCompanies.count : mostBlockedCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: mostActiveCompaniesCellReuseId) as? MostActiveCompaniesCell {
            let requestActive = activeCompaniesDisplayType == .requests
            let record = requestActive ? mostRequestedCompanies[indexPath.row] : mostBlockedCompanies[indexPath.row]
            cell.theme = theme
            cell.companyLabel.text = record.key
            
            let text = requestActive ? String(format: String.localizedString("requests_number"), record.requests) : String(format: String.localizedString("blocked_number"), record.encrypted)
            cell.requestsNumberLabel.text = text
            
            if indexPath.row == 0 {
                let fontSize = cell.companyLabel.font.pointSize
                cell.companyLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let requestActive = activeCompaniesDisplayType == .requests
        choosenRecord = requestActive ? mostRequestedCompanies[indexPath.row] : mostBlockedCompanies[indexPath.row]
        performSegue(withIdentifier: showCompanyDetailsSegueId, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
