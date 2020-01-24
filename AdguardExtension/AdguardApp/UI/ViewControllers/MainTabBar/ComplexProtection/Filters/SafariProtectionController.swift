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
    
    private let blacklistModel: ListOfRulesModelProtocol
    
    // MARK: - view controler life cycle
    
    required init?(coder: NSCoder) {
        blacklistModel = UserFilterModel(resources: resources, contentBlockerService: contentBlockerService, antibanner: antibanner, theme: theme)
        super.init(coder: coder)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == whiteListSegue {
            if let controller = segue.destination as? ListOfRulesController{
                let inverted = resources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
                let model: ListOfRulesModelProtocol = inverted ? InvertedSafariWhitelistModel(resources: resources, contentBlockerService: contentBlockerService, antibanner: antibanner, theme: theme) : SafariWhitelistModel(resources: resources, contentBlockerService: contentBlockerService, antibanner: antibanner, theme: theme)
                controller.model = model
            }
        } else if segue.identifier == blackListSegue {
            if let controller = segue.destination as? ListOfRulesController{
                controller.model = blacklistModel
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
            guard let self = self else { return }
            let safariFiltersTextFormat = String.localizedString("safari_filters_format")
            self.numberOfFiltersLabel.text = String.localizedStringWithFormat(safariFiltersTextFormat, self.filtersService.activeFiltersCount)
        }
        
        activeFiltersCountObservation = (filtersService as! FiltersService).observe(\.activeFiltersCount) { (_, _) in
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
        
        let userFilterTextFormat = String.localizedString("user_rules_format")
        let enabledRules = blacklistModel.rules.filter({ $0.enabled })
        let userRulesNumber = enabledRules.count
        userFilterStateLabel.text = String.localizedStringWithFormat(userFilterTextFormat, userRulesNumber)
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
        
        if indexPath.section == descriptionSection {
            let width = cell.bounds.size.width
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: width, bottom: 0.0, right: -width)
        }
        
        return cell
    }
    
    @IBAction func protectionSwitchAction(_ sender: UISwitch) {
        let enabled = sender.isOn
        resources.safariProtectionEnabled = enabled
        safariProtectionStateLabel.text = enabled ? String.localizedString("on_state") : String.localizedString("off_state")
        
        complexProtection.switchSafariProtection(state: enabled)
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
    
    private func updateSafariProtectionInfo(){
        let protectionEnabled = resources.safariProtectionEnabled
        protectionStateSwitch.isOn = protectionEnabled
        safariProtectionStateLabel.text = protectionEnabled ? String.localizedString("on_state") : String.localizedString("off_state")
        
        safariIcon.tintColor = protectionEnabled ? enabledColor : disabledColor
    }
}
