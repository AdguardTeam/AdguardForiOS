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

class AddFilterCell: UITableViewCell {
    
}

class DnsFilterCell: UITableViewCell {
    @IBOutlet weak var filterNameLabel: ThemableLabel!
    @IBOutlet weak var updateLabel: ThemableLabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    var filter: DnsFilter? {
        didSet {
            filterNameLabel.text = filter?.name
            
            let dateString = filter?.date.formatedStringWithHoursAndMinutes() ?? ""
            updateLabel.text = String(format: ACLocalizedString("filter_date_format", nil), dateString)
            
            filterSwitch.isOn = filter?.enabled ?? false
        }
    }
}

class DnsFiltersController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let model: DnsFiltersModel = DnsFiltersModel()
    
    private var themeObservation: Any? = nil
    
    private let dnsCellReuseId = "DnsFilterCell"
    private let addFilterCellReuseId = "AddFilterCell"
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themeObservation = NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        updateTheme()
    }
    
    // MARK: - Table view delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : model.filters.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: addFilterCellReuseId) as? AddFilterCell {
                // Hide cell
                cell.frame.size.height = 0.0
                cell.isHidden = true
                
                theme.setupTableCell(cell)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: dnsCellReuseId) as? DnsFilterCell {
                cell.filter = model.filters[indexPath.row]
                
                theme.setupLabels(cell.themableLabels)
                theme.setupSwitch(cell.filterSwitch)
                theme.setupTableCell(cell)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Add filter
        } else {
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func updateTheme() {
        theme.setupTable(tableView)
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    @IBAction func filterStateAction(_ sender: UISwitch) {
    }
}
