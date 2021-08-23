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

protocol AddDomainToListDelegate {
    /**
     Adds domain or a rule to blacklist / whitelist
     
     - Parameters:
        - domain: the domain to add to list.
        - needsCorrecting: flag indicating the need to make a rule from domain.
        - type: type of domain blacklist / whitelist.
     */
    func add(domain: String, needsCorrecting: Bool, by type: DnsLogButtonType)
}

class DnsContainerController: UIViewController, AddDomainToListDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: BottomShadowView!
    
    var logRecord: DnsLogRecordExtended!
    
    private var blockRequestControllerId = "BlockRequestControllerId"
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsFiltersService: DnsFiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let domainsConverter: DomainsConverterProtocol = DomainsConverter()
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    
    private var advancedModeObserver: NotificationToken?
    
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
        
        advancedModeObserver = NotificationCenter.default.observe(name: .advancedModeChanged, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateButtons()
        })
        
        updateButtons()
        
        setupBackButton()
        updateTheme()
    }
    
    // MARK: - AddDomainToListDelegate method
    
    func add(domain: String, needsCorrecting: Bool, by type: DnsLogButtonType) {
        if type == .addDomainToWhitelist {
            let rule = needsCorrecting ? domainsConverter.whitelistRuleFromDomain(domain) : domain
            logRecord.logRecord.userRule = rule
            dnsFiltersService.addWhitelistRule(rule)
            set(logRecord!.logRecord.userStatus == .removedFromWhitelist ? .modified : .movedToWhitelist, rule)
        } else if type == .addRuleToUserFlter {
            let rule = needsCorrecting ? domainsConverter.blacklistRuleFromDomain(domain) : domain
            logRecord.logRecord.userRule = rule
            dnsFiltersService.addBlacklistRule(rule)
            set(logRecord!.logRecord.userStatus == .removedFromBlacklist ? .modified : .movedToBlacklist, rule)
        }
    }
    
    // MARK: - private methods
    
    private func set(_ status: DnsLogRecordUserStatus, _ rule: String? = nil) {
        logRecord.logRecord.userStatus = status
        detailsController?.updateStatusLabel()
        updateButtons()
    }
    
    private func updateButtons() {
        shadowView.isHidden = !configuration.advancedMode
        
        if !configuration.advancedMode {
            shadowView.buttons = []
            return
        }
        
        let buttons = logRecord!.logRecord.getButtons().map{ [weak self] (type) -> BottomShadowButton in
            guard let self = self else { return BottomShadowButton() }
            let button = BottomShadowButton()
            let title = type.buttonTitle.uppercased()
            var color: UIColor!
            
            switch (type) {
            case .addRuleToUserFlter:
                color = UIColor(hexString: "#DF3812")
                button.action = {
                    if let rule = self.logRecord?.logRecord.domain {
                        self.presentBlockRequestController(with: rule, type: type, delegate: self)
                    }
                }
                
            case .removeDomainFromWhitelist:
                color = UIColor(hexString: "#DF3812")
                button.action = {
                    if let record = self.logRecord?.logRecord {
                        let userDomain = self.domainsConverter.whitelistRuleFromDomain(record.userRule ?? "")
                        
                        let isOriginalRecord = record.userStatus == .none || record.userStatus == .modified
                        let rules = isOriginalRecord ? record.blockRules : [userDomain]

                        self.dnsFiltersService.removeWhitelistRules(rules ?? [])
                        self.set(record.userStatus == .movedToWhitelist ? .modified : .removedFromWhitelist)
                    }
                }
                
            case .removeRuleFromUserFilter:
                color = UIColor.AdGuardColor.lightGreen1
                button.action = {
                    if let record = self.logRecord?.logRecord {
                        let isOriginalRecord = record.userStatus == .none || record.userStatus == .modified
                        let rules = isOriginalRecord ? record.blockRules : [record.userRule ?? ""] 

                        self.dnsFiltersService.removeUserRules(rules ?? [])
                        self.set(self.logRecord!.logRecord.userStatus == .movedToBlacklist ? .modified : .removedFromBlacklist)
                    }
                }
                
            case .addDomainToWhitelist:
                color = UIColor.AdGuardColor.lightGreen1
                button.action = {
                    if let domain = self.logRecord?.logRecord.domain {
                        self.presentBlockRequestController(with: domain, type: type, delegate: self)
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

extension DnsContainerController: ThemableProtocol {
    func updateTheme() {
        theme.setupNavigationBar(navigationController?.navigationBar)
        view.backgroundColor = theme.backgroundColor
        shadowView.updateTheme()
    }
}
