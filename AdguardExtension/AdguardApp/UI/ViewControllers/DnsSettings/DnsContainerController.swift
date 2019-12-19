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

class DnsContainerController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: BottomShadowView!
    
    
    var logRecord: DnsLogRecordExtended!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsFiltersService: DnsFiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsLogService: DnsLogRecordsServiceProtocol = ServiceLocator.shared.getService()!
    
    private var themeObserver: Any? = nil
    
    private var detailsController: DnsRequestDetailsController?
    
    // MARK: - view controller life cycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DnsRequestDetailsController {
            destinationVC.logRecord = logRecord
            destinationVC.shadowView = shadowView
            destinationVC.containerController = self
            detailsController = destinationVC
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeObserver = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        updateButtons()
        
        setupBackButton()
        updateTheme()
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        theme.setupNavigationBar(navigationController?.navigationBar)
        view.backgroundColor = theme.backgroundColor
        shadowView.updateTheme()
    }
    
    private func setUserStatus(_ status: DnsLogRecordUserStatus) {
        dnsLogService.setUserStatus(rowId: self.logRecord.logRecord.rowid!, status: status)
        logRecord.logRecord.userStatus = status
        detailsController?.updateStatusLabel()
        updateButtons()
    }
    
    private func updateButtons() {
        let buttons = logRecord!.logRecord.getButtons().map{ [weak self] (type) -> BottomShadowButton in
            guard let self = self else { return BottomShadowButton() }
            let button = BottomShadowButton()
            var title: String!
            var color: UIColor!
            
            switch (type) {
            case .addRuleToUserFlter:
                title = String.localizedString("add_to_blacklist")
                color = UIColor(hexString: "#eb9300")
                button.action = {
                    if let rule = self.logRecord?.logRecord.domain {
                        self.dnsFiltersService.addBlacklistDomain(rule)
                        self.setUserStatus(self.logRecord!.logRecord.userStatus == .removedFromBlacklist ? .none : .movedToBlacklist)
                    }
                }
                
            case .removeDomainFromWhitelist:
                title = String.localizedString("remove_from_whitelist")
                color = UIColor(hexString: "#eb9300")
                button.action = {
                    if let rules = self.logRecord?.logRecord.blockRules {
                        self.dnsFiltersService.removeWhitelistRules(rules)
                        self.setUserStatus(self.logRecord!.logRecord.userStatus == .movedToWhitelist ? .none : .removedFromWhitelist)
                    }
                }
                
            case .removeRuleFromUserFilter:
                title = String.localizedString("remove_from_blacklist")
                color = UIColor(hexString: "#67b279")
                button.action = {
                    if let rules = self.logRecord?.logRecord.blockRules {
                        self.dnsFiltersService.removeUserRules(rules)
                        self.setUserStatus(self.logRecord!.logRecord.userStatus == .movedToBlacklist ? .none : .removedFromBlacklist)
                    }
                }
                
            case .addDomainToWhitelist:
                title = String.localizedString("add_to_whitelist")
                color = UIColor(hexString: "#67b279")
                button.action = {
                    if let domain = self.logRecord?.logRecord.domain {
                        self.dnsFiltersService.addWhitelistDomain(domain)
                        self.setUserStatus(self.logRecord!.logRecord.userStatus == .removedFromWhitelist ? .none : .movedToWhitelist)
                    }
                }
            }
            
            button.title = title
            button.titleColor = color
            
            return button
        }
        
        shadowView.buttons = buttons
    }
}
