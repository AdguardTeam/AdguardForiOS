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
}

class MostActiveCompaniesController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - Services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // MARK: - Notifications
    private var themeToken: NotificationToken?
    
    // MARK: - Public variables
    var activeCompaniesDisplayType: ActiveCompaniesDisplayType?
    
    // MARK: - Private variables
    private let mostActiveCompaniesCellReuseId = "MostActiveCompaniesCell"
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        setupBackButton()
        
        segmentedControl.selectedSegmentIndex = activeCompaniesDisplayType?.rawValue ?? 0
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
    }
    
    // MARK: - Private methods

    private func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        theme.setupLabels(themableLabels)
        theme.setupSegmentedControl(segmentedControl)
        tableView.reloadData()
    }
}

extension MostActiveCompaniesController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: mostActiveCompaniesCellReuseId) as? MostActiveCompaniesCell {
            cell.theme = theme
            return cell
        }
        return UITableViewCell()
    }
}
