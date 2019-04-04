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

class GetProTableController: UITableViewController {
    
    // MARK: - IB outlets
    
    @IBOutlet weak var logo: ThemeableImageView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    // MARK: - private fields
    
    var proObservation: NSKeyValueObservation?
    
    // MARK: - View controller livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        
        proObservation = configuration.observe(\.proStatus) {[weak self] (_, _) in
            self?.updateTheme()
        }
    }
    
    // MARK: - table view delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return configuration.proStatus ? 4 : 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        theme.setupTableCell(cell)
        
        return cell
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        
        theme.setupTable(tableView)
        theme.setupLabels(themableLabels)
        theme.setupImage(logo)
    }
    
    
}
