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

class SafariProtectionController: UITableViewController {

    @IBOutlet weak var safariProtectionStateLabel: UILabel!
    @IBOutlet weak var numberOfFiltersLabel: UILabel!
    @IBOutlet weak var userFilterStateLabel: UILabel!
    @IBOutlet weak var protectionStateSwitch: UISwitch!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let filtersService: FiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    
    private var filtersCountObservation: Any?
    private var activeFiltersCountObservation: Any?
    
    private let descriptionSection = 0
    private let descriptionCell = 0
    
    private let contentSection = 1
    private let stateCell = 0
    private let filtersCell = 1
    private let userFilterCell = 2
    private let whiteListCell = 3
    
    private let whiteListSegue = "whiteListSegue"
    private let blackListSegue = "blackListSegue"
    
    // MARK: - view controler life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case whiteListSegue:
            if let controller = segue.destination as? UserFilterController{
                controller.whitelist = true
            }
            
        case blackListSegue:
            if let controller = segue.destination as? UserFilterController{
                controller.whitelist = false
            }
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        updateTheme()
        
        let updateFilters: ()->() = { [weak self] in
            guard let sSelf = self else { return }
            let filtersDescriptionText = String(format: ACLocalizedString("filters_description_format", nil), sSelf.filtersService.activeFiltersCount, sSelf.filtersService.filtersCount)
            sSelf.numberOfFiltersLabel.text = filtersDescriptionText
        }
        
        filtersCountObservation = (filtersService as! FiltersService).observe(\.filtersCount) { (_, _) in
            updateFilters()
        }
        
        activeFiltersCountObservation = (filtersService as! FiltersService).observe(\.filtersCount) { (_, _) in
            updateFilters()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        let protectionEnabled = resources.sharedDefaults().object(forKey: SafariProtectionState) as? Bool
        protectionStateSwitch.isOn = protectionEnabled ?? true
        
        updateFilters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let key = AEDefaultsUserFilterEnabled
        if let userFilterEnabled = resources.sharedDefaults().object(forKey: key) as? Bool {
            userFilterStateLabel.text = userFilterEnabled ? ACLocalizedString("enabled", nil) : ACLocalizedString("disabled", nil)
        } else {
            userFilterStateLabel.text = ACLocalizedString("enabled", nil)
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let width = tableView.frame.width
        let height: CGFloat = 5.0
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let view = UIView(frame: frame)
        view.backgroundColor = configuration.darkTheme ? .black : .white
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        
        return cell
    }
    
    @IBAction func protectionSwitchAction(_ sender: UISwitch) {
        let enabled = sender.isOn
        resources.sharedDefaults().set(enabled, forKey: SafariProtectionState)
        contentBlockerService.reloadJsons(backgroundUpdate: false) { (error) in
            if error != nil {
                DDLogError("Safari protection was switched to \(enabled) state with error : \(String(describing: error?.localizedDescription))")
            } else {
                DDLogInfo("Safari protection was successfully switched to \(enabled) state")
            }
        }
    }
    
    // MARK: - Private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupSwitch(protectionStateSwitch)
        theme.setupTable(tableView)
        theme.setupLabels(themableLabels)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
}
