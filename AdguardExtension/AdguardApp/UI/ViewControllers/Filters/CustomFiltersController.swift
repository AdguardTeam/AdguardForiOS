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

class CustomFiltersController: UITableViewController, UIViewControllerTransitioningDelegate {
    
    let showFilterSegueID = "showCustomFilterSegue"
    
    lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    
    var filters: [Filter]?
    
    var searchString: String?
    
    // MARK: - IB Outlets
    @IBOutlet var searchBarButton: UIBarButtonItem!
    
    
    // MARK: - view controller lifcycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: Notification.Name(ConfigurationService.themeChangeNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    // MARK: - UITableView delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let filtersCount = filters == nil ? 0 : filters!.count
        
        return filtersCount + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == filters?.count ?? 0 {
            let newFilterCell = tableView.dequeueReusableCell(withIdentifier: "newCustomFilterReuseID")
            newFilterCell?.selectionStyle = .default
            return newFilterCell!
        }
        
        let filter = filters?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "customFilterReuseID") as! CustomFilterCell
        cell.name.text = filter?.name
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        
        theme.setupLabels(cell.themableLabels)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == filters?.count ?? 0 {
            addAction(tableView)
        }
        else {
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func deleteAction(_ sender: UIButton) {
        
    }

    @IBAction func searchAction(_ sender: Any) {
    }
    
    @IBAction func addAction(_ sender: Any) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "CustomFilterInfoController") else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self

        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Presentation delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    // MARK: - Private methods
    
    @objc private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
}
