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

enum BlockedRecordType {
    case normal, whitelisted, blocked, tracked
}

class DnsRequestCell: UITableViewCell {
    @IBOutlet weak var domain: ThemableLabel!
    @IBOutlet weak var details: ThemableLabel!
    @IBOutlet weak var timeLabel: ThemableLabel!
}

class DnsLogController: UITableViewController, UISearchBarDelegate, DnsRequestsDelegateProtocol, DnsLogContainerControllerDelegate {
    //MARK: - IB Outlets
    
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var refreshView: UIRefreshControl!
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - public fields
    
    var model: DnsRequestLogViewModel?
    
    // MARK: - private fields
    
    private var selectedRecord: DnsLogRecordExtended?
    private var themeToken: NotificationToken?
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.delegate = self
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        model?.recordsObserver = { [weak self] (records) in
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
        
        tableView.tableHeaderView = searchView
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    
        updateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model?.obtainRecords()
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return theme.statusbarStyle()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DnsRequestCell") as! DnsRequestCell
        guard let record = model?.records[indexPath.row] else { return UITableViewCell() }
                
        let timeString = record.logRecord.time()
        let name = record.category.name
        let domain = record.logRecord.getDetailsString()
    
        cell.domain.text = name == nil ? record.logRecord.firstLevelDomain() : name
        cell.details.attributedText = domain
        cell.timeLabel.text = timeString
        
        let type: BlockedRecordType
        switch (record.logRecord.status, record.category.isTracked) {
        case (.processed, true):
            type = .tracked
        case (.processed, _):
            type = .normal
        case (.whitelisted, _):
            type = .whitelisted
        case (.blacklistedByUserFilter, _), (.blacklistedByOtherFilter, _):
            type = .blocked
        }
        
        setupRecordCell(cell: cell, type: type, dnsStatus: record.logRecord.answerStatus ?? "")
        
        theme.setupLabel(cell.domain)
        theme.setupLabel(cell.details)
        theme.setupLabel(cell.timeLabel)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.records.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let record = model?.records[indexPath.row] {
            selectedRecord = record
            performSegue(withIdentifier: "showDnsContainer", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? DnsContainerController
        controller?.logRecord = selectedRecord
    }
    
    // MARK: - searchbar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model?.searchString = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // MARK: - dns requests delegate
    
    func requestsCleared() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - DnsLogContainerControllerDelegate method
    
    func clearButtonTapped() {
        model?.clearRecords()
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        refreshView.tintColor = theme.invertedBackgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
        theme.setupSearchBar(searchBar)
    }
    
    @objc private func refresh() {
        model?.obtainRecords()
    }
    
    private func setupRecordCell(cell: UITableViewCell, type: BlockedRecordType, dnsStatus: String){
        
        var logSelectedCellColor: UIColor = .clear
        var logBlockedCellColor: UIColor = .clear
        
        switch type {
        case .blocked:
            logSelectedCellColor = UIColor(hexString: "#4DDF3812")
            logBlockedCellColor = UIColor(hexString: "#33DF3812")
        case .whitelisted:
            logSelectedCellColor = UIColor(hexString: "#4D67b279")
            logBlockedCellColor = UIColor(hexString: "#3367b279")
        case .normal, .tracked:
            logSelectedCellColor = theme.selectedCellColor
            logBlockedCellColor = .clear
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = logSelectedCellColor
        cell.selectedBackgroundView = bgColorView
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = logBlockedCellColor
    }
}
