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

class MostActiveCompaniesController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var controllerTitle: ThemableLabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - Services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - Public variables

    var chartDateType: ChartDateType?
    var mostRequestedCompanies: [CompanyRequestsRecord] = []
    
    // MARK: - Private variables
    
    private var choosenRecord: CompanyRequestsRecord?
    
    private let mostActiveCompaniesCellReuseId = "MostActiveCompaniesCellId"
    private let showCompanyDetailsSegueId = "showCompanyDetails"
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        setupBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showCompanyDetailsSegueId {
            if let controller = segue.destination as? CompanyDetailedController {
                controller.record = choosenRecord
                controller.chartDateType = chartDateType
            }
        }
    }
}

extension MostActiveCompaniesController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mostRequestedCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: mostActiveCompaniesCellReuseId) as? MostActiveCompaniesCell {
            let record = mostRequestedCompanies[indexPath.row]
            cell.theme = theme
            cell.companyLabel.text = record.key
            cell.requestsNumberLabel.text = String(format: String.localizedString("requests_number"), record.requests)
            
            if indexPath.row == 0 {
                let fontSize = cell.companyLabel.font.pointSize
                cell.companyLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenRecord = mostRequestedCompanies[indexPath.row]
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

extension MostActiveCompaniesController: ThemableProtocol {
    func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        theme.setupLabels(themableLabels)
        tableView.reloadData()
    }
}
