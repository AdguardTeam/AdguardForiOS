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

class ContentBlockerTitleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: ThemableLabel!
}

class ContentBlockerStateController: UITableViewController {
    
    var theme: ThemeServiceProtocol? = nil
    
    var contentBlockersDataSource: ContentBlockersDataSource? = nil
    
    private let cbTitleReuseIdentifier = "ContentBlockerTitleCell"
    private let reuseIdentifier = "contentBlockerStateCell"
    
    private let titleSection = 0
    private let contentBlockersSection = 1
    
    private let typeByRow : [Int : ContentBlockerType] = [
        0 : .general,
        1 : .privacy,
        2 : .custom,
        3 : .socialWidgetsAndAnnoyances,
        4 : .other,
        5 : .security
    ]
    
    private let rowByType : [ContentBlockerType : Int] = [
        .general : 0,
        .privacy : 1,
        .custom : 2,
        .socialWidgetsAndAnnoyances : 3,
        .other : 4,
        .security : 5
    ]
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addObservers()
        setupBackButton()
        updateTheme()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == titleSection ? 1 : contentBlockersDataSource!.contentBlockers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setup title
        if indexPath.section == titleSection {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cbTitleReuseIdentifier) as? ContentBlockerTitleCell else {
                return UITableViewCell()
            }
            theme!.setupTableCell(cell)
            theme!.setupLabel(cell.titleLabel)
            return cell
        }
        
        // Setup cb rows
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ContentBlockerStateCell {
            
            theme!.setupTableCell(cell)
            theme!.setupLabels(cell.themableLabels)
            
            guard let type = typeByRow[indexPath.row] else { return UITableViewCell() }
            cell.layoutIfNeeded()
            cell.blockerState = contentBlockersDataSource!.contentBlockers[type]!
            return cell
        } else {
           return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // MARK: - private methods
    
    private var safariObserver1: NotificationToken?
    private var safariObserver2: NotificationToken?
    private var contentBlockerObserver: NotificationToken?
    
    private func addObservers(){
        
        // Start of filter update observing
        safariObserver1 = NotificationCenter.default.observe(name: SafariService.filterBeganUpdating, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            
            guard let type = notification.userInfo?[SafariService.contentBlockerTypeString] as! ContentBlockerType? else { return }
            self?.contentBlockersDataSource!.contentBlockers[type]?.currentState = .updating
            self?.reloadRaw(with: type)
        }
        
        // Finish of filter update observer
        safariObserver2 = NotificationCenter.default.observe(name: SafariService.filterFinishedUpdating, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            
            guard let type = notification.userInfo?[SafariService.contentBlockerTypeString] as! ContentBlockerType? else { return }
            
            guard let success = notification.userInfo?[SafariService.successString] as? Bool else { return }
            if !success {
                self?.contentBlockersDataSource!.contentBlockers[type]?.currentState = .failedUpdating
                self?.reloadRaw(with: type)
            } else {
                let blocker = self?.contentBlockersDataSource!.contentBlockers[type]
                self?.contentBlockersDataSource!.contentBlockers[type]?.currentState = (blocker?.numberOfOverlimitedRules == 0) ? (blocker?.enabled ?? false ? .enabled : .disabled) : .overLimited
                self?.reloadRaw(with: type)
            }
        }
        
        // Content blockers checked observer
        contentBlockerObserver = NotificationCenter.default.observe(name: SafariService.contentBlcokersChecked, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            DispatchQueue.main.async {
                self?.contentBlockersDataSource!.updateContentBlockersArray()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func reloadRaw(with type: ContentBlockerType){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            guard let raw = self.rowByType[type] else { return }
            let indexPath = IndexPath(row: raw, section: self.contentBlockersSection)
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    private func setupTableView(){
        let nib = UINib.init(nibName: "ContentBlockerStateCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
}

extension ContentBlockerStateController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme!.backgroundColor
        theme!.setupNavigationBar(navigationController?.navigationBar)
        theme!.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
