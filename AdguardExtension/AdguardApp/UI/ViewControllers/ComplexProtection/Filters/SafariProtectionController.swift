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
    @IBOutlet weak var whitelistLabel: ThemableLabel!
    @IBOutlet weak var safariIcon: UIImageView!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let filtersService: FiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    private let antibanner: AESAntibannerProtocol = ServiceLocator.shared.getService()!
    private let complexProtection: ComplexProtectionServiceProtocol = ServiceLocator.shared.getService()!
    
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
    
    private var notificationToken: NotificationToken?
    
    private let enabledColor = UIColor(hexString: "#67b279")
    private let disabledColor = UIColor(hexString: "#888888")
    
    // MARK: - view controler life cycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == whiteListSegue {
            if let controller = segue.destination as? ListOfRulesController{
                let inverted = resources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
                let model: ListOfRulesModelProtocol = inverted ? InvertedSafariWhitelistModel(resources: resources, contentBlockerService: contentBlockerService, antibanner: antibanner, theme: theme) : SafariWhitelistModel(resources: resources, contentBlockerService: contentBlockerService, antibanner: antibanner, theme: theme)
                controller.model = model
            }
        } else if segue.identifier == blackListSegue {
            if let controller = segue.destination as? ListOfRulesController{
                let model: ListOfRulesModelProtocol = UserFilterModel(resources: resources, contentBlockerService: contentBlockerService, antibanner: antibanner, theme: theme)
                controller.model = model
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        updateTheme()
        
        resources.sharedDefaults().addObserver(self, forKeyPath: SafariProtectionState, options: .new, context: nil)
        
        let inverted = resources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
        whitelistLabel.text = inverted ? ACLocalizedString("inverted_whitelist_title", nil) : ACLocalizedString("whitelist_title", nil)
        
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
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        updateSafariProtectionInfo()
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
    
    deinit {
        resources.sharedDefaults().removeObserver(self, forKeyPath: SafariProtectionState)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == SafariProtectionState {
            updateSafariProtectionInfo()
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 32.0 : 0.1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        
        return cell
    }
    
    @IBAction func protectionSwitchAction(_ sender: UISwitch) {
        let enabled = sender.isOn
        resources.sharedDefaults().set(enabled, forKey: SafariProtectionState)
        safariProtectionStateLabel.text = enabled ? String.localizedString("on_state") : String.localizedString("off_state")
        
        complexProtection.switchSafariProtection(state: enabled)
    }
    
    // MARK: - Private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupSwitch(protectionStateSwitch)
        theme.setupTable(tableView)
        theme.setupLabels(themableLabels)
        topSeparator.backgroundColor = theme.separatorColor
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
    
    private func updateSafariProtectionInfo(){
        let protectionEnabled = resources.safariProtectionEnabled
        protectionStateSwitch.isOn = protectionEnabled
        safariProtectionStateLabel.text = protectionEnabled ? String.localizedString("on_state") : String.localizedString("off_state")
        
        safariIcon.tintColor = protectionEnabled ? enabledColor : disabledColor
    }
}
