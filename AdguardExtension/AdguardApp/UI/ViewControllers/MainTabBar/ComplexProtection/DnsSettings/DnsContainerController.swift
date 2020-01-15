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

class DnsContainerController: UIViewController, UIViewControllerTransitioningDelegate, AddDomainToListDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: BottomShadowView!
    
    
    var logRecord: DnsLogRecordExtended!
    
    private var blockRequestControllerId = "BlockRequestControllerId"
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsFiltersService: DnsFiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsLogService: DnsLogRecordsServiceProtocol = ServiceLocator.shared.getService()!
    private let domainsConverter: DomainsConverterProtocol = DomainsConverter()
    
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
    
    // MARK: - Presentation delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    // MARK: - AddDomainToListDelegate method
    
    func add(domain: String, needsCorrecting: Bool, by type: DnsLogButtonType) {
        if type == .addDomainToWhitelist {
            let rule = needsCorrecting ? domainsConverter.whitelistRuleFromDomain(domain) : domain
            logRecord.logRecord.userRule = rule
            dnsFiltersService.addWhitelistDomain(rule)
            set(logRecord!.logRecord.userStatus == .removedFromWhitelist ? .none : .movedToWhitelist, rule)
        } else if type == .addRuleToUserFlter {
            let rule = needsCorrecting ? domainsConverter.blacklistRuleFromDomain(domain) : domain
            logRecord.logRecord.userRule = rule
            dnsFiltersService.addBlacklistRule(rule)
            set(logRecord!.logRecord.userStatus == .removedFromBlacklist ? .none : .movedToBlacklist, rule)
        }
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        theme.setupNavigationBar(navigationController?.navigationBar)
        view.backgroundColor = theme.backgroundColor
        shadowView.updateTheme()
    }
    
    private func set(_ status: DnsLogRecordUserStatus, _ rule: String? = nil) {
        dnsLogService.set(rowId: self.logRecord.logRecord.rowid!, status: status, userRule: rule)
        logRecord.logRecord.userStatus = status
        detailsController?.updateStatusLabel()
        updateButtons()
    }
    
    private func presentBlockRequestController(with domain: String, type: DnsLogButtonType){
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "EditRequestController") as? UINavigationController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        
        if let vc = controller.viewControllers.first as? BlockRequestController {
            vc.fullDomain = domain
            vc.type = type
            vc.delegate = self
        }
        
        present(controller, animated: true, completion: nil)
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
                        self.presentBlockRequestController(with: rule, type: type)
                    }
                }
                
            case .removeDomainFromWhitelist:
                title = String.localizedString("remove_from_whitelist")
                color = UIColor(hexString: "#eb9300")
                button.action = {
                    if let record = self.logRecord?.logRecord {
                        let userDomain = self.domainsConverter.whitelistRuleFromDomain(record.userRule ?? "")
                        
                        let rules = record.userStatus != .none ? [userDomain] : record.blockRules

                        self.dnsFiltersService.removeWhitelistRules(rules ?? [])
                        self.set(record.userStatus == .movedToWhitelist ? .none : .removedFromWhitelist)
                    }
                }
                
            case .removeRuleFromUserFilter:
                title = String.localizedString("remove_from_blacklist")
                color = UIColor(hexString: "#67b279")
                button.action = {
                    if let record = self.logRecord?.logRecord {
                        let rules = record.userStatus != .none ? [record.userRule ?? ""] : record.blockRules

                        self.dnsFiltersService.removeUserRules(rules ?? [])
                        self.set(self.logRecord!.logRecord.userStatus == .movedToBlacklist ? .none : .removedFromBlacklist)
                    }
                }
                
            case .addDomainToWhitelist:
                title = String.localizedString("add_to_whitelist")
                color = UIColor(hexString: "#67b279")
                button.action = {
                    if let domain = self.logRecord?.logRecord.domain {
                        self.presentBlockRequestController(with: domain, type: type)
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
