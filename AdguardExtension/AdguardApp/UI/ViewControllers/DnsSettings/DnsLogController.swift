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
import UIKit

class DnsRequestCell: UITableViewCell {
    @IBOutlet weak var domain: ThemableLabel!
    @IBOutlet weak var details: ThemableLabel!
}

class DnsLogController: UITableViewController, UISearchBarDelegate {
    //MARK: - IB Outlets
    
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - services
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    let model = DnsRequestLogViewModel(ServiceLocator.shared.getService()!)
    
    // MARK: - private fields
    
    var selectedRecord: LogRecord?
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: Notification.Name(ConfigurationService.themeChangeNotification), object: nil)
        
        model.recordsObserver = { [weak self] (records) in
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
        model.obtainRecords()
        
        tableView.tableHeaderView = searchView
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        updateTheme()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DnsRequestCell") as! DnsRequestCell
        let record = model.records[indexPath.row]
        
        var detailsString = String(format: "%@, type: %@", record.time!, record.type!)
        if record.answer == nil || record.answer == "" {
            detailsString += ", NXDOMAIN"
        }

        cell.domain.text = record.name
        cell.details.text = detailsString
        
        theme.setupLogTableCell(cell, blocked: isBlocked(record))
        theme.setupLabel(cell.domain)
        theme.setupLabel(cell.details)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.records.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecord = model.records[indexPath.row]
        performSegue(withIdentifier: "requestDetailsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? DnsRequestDetailsController
        controller?.logRecord = selectedRecord
    }
    
    // MARK: - Actions
    
    // MARK: - searchbar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.searchString = searchText
    }
    
    // MARK: - private methods
    
    @objc private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
        theme.setupSearchBar(searchBar)
    }
    
    @objc private func refresh() {
        model.obtainRecords()
    }
    
    private func isBlocked(_ logRecord: LogRecord) -> Bool {
        if logRecord.answer == nil || logRecord.answer == "" {
            // Mark all NXDOMAIN responses as blocked
            return true
        }

        if logRecord.answer!.contains("0.0.0.0") || logRecord.answer!.contains("127.0.0.1") {
            return true
        }

        return false
    }
}
