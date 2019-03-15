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
    
    let siteUrl = URL(string: "https://adguard.com/en/welcome.html")!
    let forumUrl = URL(string: "https://forum.adguard.com/index.php")!
    let thanksUrl = URL(string: "https://kb.adguard.com/en/miscellaneous/acknowledgments")!
    let moreUrl = URL(string: "http://agrd.io/ios_adguard_products")!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    
    // MARK: - view controller life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }

    // MARK: - Actions
 
    @IBAction func siteAction(_ sender: Any) {
        UIApplication.shared.open(siteUrl, options: [:], completionHandler: nil)
    }
    @IBAction func forumAction(_ sender: Any) {
        UIApplication.shared.open(forumUrl, options: [:], completionHandler: nil)
    }
    @IBAction func thanksAction(_ sender: Any) {
        UIApplication.shared.open(thanksUrl, options: [:], completionHandler: nil)
    }
    @IBAction func moreAction(_ sender: Any) {
        UIApplication.shared.open(moreUrl, options: [:], completionHandler: nil)
    }
    
    private func updateTheme() {
        theme.setupLabels(themableLabels)
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
    }
}
