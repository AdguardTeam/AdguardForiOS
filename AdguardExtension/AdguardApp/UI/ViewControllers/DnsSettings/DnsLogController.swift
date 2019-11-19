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
    @IBOutlet weak var timeLabel: ThemableLabel!
}

class DnsLogController: UITableViewController, UISearchBarDelegate, DnsRequestsDelegateProtocol {
    //MARK: - IB Outlets
    
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let model = DnsRequestLogViewModel(vpnManager: ServiceLocator.shared.getService()!, dnsTrackerService: ServiceLocator.shared.getService()!, dnsFiltersService: ServiceLocator.shared.getService()!)
    
    // MARK: - private fields
    
    private var selectedRecord: LogRecord?
    private var notificationToken: NotificationToken?
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        model.recordsObserver = { [weak self] (records) in
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
        model.obtainRecords()
        
        tableView.tableHeaderView = searchView
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
     
        setupBackButton()
        updateTheme()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DnsRequestCell") as! DnsRequestCell
        let record = model.records[indexPath.row]
        
        // Change to category description
        var detailsString = String(format: "type: %@", record.type!)
        let timeString = record.time ?? ""
        
        if record.answer == nil || record.answer == "" {
            detailsString += ", NXDOMAIN"
        }

        cell.domain.text = record.domain
        cell.details.text = detailsString
        cell.timeLabel.text = timeString
        
        let type = isBlocked(record)
        setupRecordCell(cell: cell, type: type)
        
        theme.setupLabel(cell.domain)
        theme.setupLabel(cell.details)
        theme.setupLabel(cell.timeLabel)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.records.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecord = model.records[indexPath.row]
        performSegue(withIdentifier: "showDnsContainer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? DnsContainerController
        controller?.logRecord = selectedRecord
    }
    
    // MARK: - Actions
    
    @IBAction func clearAction(_ sender: UIBarButtonItem) {
        model.clearRecords()
    }
    
    // MARK: - searchbar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.searchString = searchText
    }
    
    // MARK: - dns requests delegate
    
    func requestsCleared() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
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
    
    private func isBlocked(_ logRecord: LogRecord) -> BlockedRecordType {
        if logRecord.answer == nil || logRecord.answer == "" {
            // Mark all NXDOMAIN responses as blocked
            return .blocked
        }

        if logRecord.answer!.contains("0.0.0.0") ||
            logRecord.answer!.contains("127.0.0.1") ||
            logRecord.answer!.contains("[::]")  {
            return .blocked
        }

        if logRecord.isTracked ?? false {
            return .tracked
        }
        
        return .normal
    }
    
    private func setupRecordCell(cell: UITableViewCell, type: BlockedRecordType){
        if type == .normal {
            theme.setupTableCell(cell)
            return
        }
        var logSelectedCellColor: UIColor = .clear
        var logBlockedCellColor: UIColor = .clear
        
        switch type {
        case .blocked:
            logSelectedCellColor = UIColor(hexString: "#4DDF3812")
            logBlockedCellColor = UIColor(hexString: "#33DF3812")
        case .tracked:
            logSelectedCellColor = UIColor(hexString: "#4Df5a623")
            logBlockedCellColor = UIColor(hexString: "#33f5a623")
        case .whitelisted:
            logSelectedCellColor = UIColor(hexString: "#4D67b279")
            logBlockedCellColor = UIColor(hexString: "#3367b279")
        default:
            return
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = logSelectedCellColor
        cell.selectedBackgroundView = bgColorView
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = logBlockedCellColor
    }
    
    private enum BlockedRecordType{
        case blocked, whitelisted, tracked, normal
    }
}
