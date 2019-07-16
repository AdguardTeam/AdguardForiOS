//
//  AEUEMainController.swift
//  ActionExtension
//
//  Created by Илья Ковальчук on 12.07.2019.
//  Copyright © 2019 Performiks. All rights reserved.
//

import UIKit
import CoreServices

class SimpleConfigurationSwift: NSObject, ConfigurationServiceProtocol{
    var userThemeMode: AEThemeMode {
        return AELightThemeMode
    }
    
    var systemAppearenceIsDark: Bool {
        return true
    }
    
    var resources: AESharedResourcesProtocol
    
    var darkTheme: Bool {
        return self.resources.sharedDefaults().bool(forKey: AEDefaultsDarkTheme)
    }
    
    var proStatus: Bool {
        return false
    }
    
    var purchasedThroughLogin: Bool {
        return false
    }

    init(withResources resources: AESharedResourcesProtocol) {
        self.resources = resources
    }
}

@objcMembers
class ActionExtensionMainController: UITableViewController {
    
    
    @IBOutlet var enabledSwitch: UISwitch!
    @IBOutlet weak var domainLabel: ThemableLabel!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    var domainName: String?
    var url: URL?
    var iconUrl: URL?
    var enableChangeDomainFilteringStatus: Bool = false
    var domainEnabled: Bool = false
    var injectScriptSupported: Bool = false
    
    var resources: AESharedResourcesProtocol? = nil
    var safariService: SafariServiceProtocol? = nil
    var contentBlockerService: ContentBlockerService? = nil
    var support: AESSupportProtocol? = nil
    var theme: ThemeServiceProtocol?
    
    var enabledHolder: Bool?
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizationNotNeeded(Constants.aeProductName())
        
        let resources = AESharedResources()
        let configuration: SimpleConfigurationSwift = SimpleConfigurationSwift(withResources: resources)
        self.theme = ThemeService(configuration)
        
        enabledSwitch.isOn = domainEnabled
        enabledHolder = domainEnabled
        domainLabel.text = domainName
        
        safariService!.checkStatus { [weak self] (enabled) in
            if (!enabled){
                DispatchQueue.main.async{[weak self] in
                    guard let sSelf = self else { return }
                    ACSSystemUtils.showSimpleAlert(for: sSelf, withTitle: ACLocalizedString("common_warning_title", nil), message: ACLocalizedString("content_blocker_disabled_format", nil))
                }
            }
        }
        
        resources.sharedDefaults().set(true, forKey: AEDefaultsActionExtensionUsed)

        theme?.setupTable(tableView)
        theme?.setupSwitch(enabledSwitch)
        theme?.setupNavigationBar(navigationController?.navigationBar)
        theme?.setupLabels(themableLabels)
        view.backgroundColor = theme?.backgroundColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    deinit {
        DDLogDebug("(AEAUIMainController) run deinit.")
    }
    
    @IBAction func toggleStatus(_ sender: UISwitch) {
        let newEnabled = sender.isOn
        if newEnabled == self.domainEnabled {
            return
        }
        //check rule overlimit
        if !(enableChangeDomainFilteringStatus) {
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: ACLocalizedString("common_error_title", nil), message: ACLocalizedString("filter_rules_maximum", nil))
            enabledSwitch.isOn = domainEnabled
            return
        }
        
        let inverted: Bool = resources!.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
        
        // disable filtering == remove from inverted whitelist
        if inverted && domainEnabled{
            contentBlockerService!.removeInvertedWhitelistDomain(domainName!) {[weak self] (error) in
                guard let sSelf = self else { return }
                sSelf.safariService!.invalidateBlockingJsons {[weak self] (error) in
                    guard let sSelf = self else { return }
                    sSelf.domainEnabled = false
                }
            }
        }
        // enable filtering == add to inverted whitelist
        else if (inverted && !(self.domainEnabled)) {
            contentBlockerService!.addInvertedWhitelistDomain(domainName!) {[weak self] (error) in
                guard let sSelf = self else { return }
                sSelf.safariService!.invalidateBlockingJsons { [weak self] (error) in
                    guard let sSelf = self else { return }
                    sSelf.domainEnabled = true
                }
            }
        }
        // disable filtering (add to whitelist)
        else if domainEnabled{
            let domainObject = AEWhitelistDomainObject(domain: domainName!)
            guard let domObj = domainObject else { return }
            contentBlockerService!.addWhitelistRule(domObj.rule) { [weak self] (error) in
                guard let sSelf = self else { return }
                if error != nil {
                    sSelf.enabledSwitch.isOn = sSelf.domainEnabled
                } else {
                    sSelf.domainEnabled = newEnabled
                }
            }
        }
        // enable filtering (remove from whitelist)
        else {
            let domainObject = AEWhitelistDomainObject(domain: domainName!)
 
            guard let domObj = domainObject else {
                self.enabledSwitch.isOn = self.domainEnabled
                return
            }
            self.contentBlockerService!.removeWhitelistRule(domObj.rule) {[weak self] (error) in
                guard let sSelf = self else { return }
                if error != nil {
                    sSelf.enabledSwitch.isOn = sSelf.domainEnabled
                } else {
                    sSelf.domainEnabled = newEnabled
                }
            }
        }
    }
    
    @IBAction func clickedMissedAd(_ sender: UITapGestureRecognizer) {
        guard let url = support!.composeWebReportUrl(forSite: self.url) else { return }
        openWithUrl(url)
    }
    
    @IBAction func clickedBlockElement(_ sender: UITapGestureRecognizer) {
        if injectScriptSupported{
            let extensionItem = NSExtensionItem()
            
            let obj: NSItemProvider = NSItemProvider(item:
                 [ NSExtensionJavaScriptFinalizeArgumentKey  : [
                    "blockElement": NSNumber(value: 1),
                    "settings": ""
                ]] as NSSecureCoding, typeIdentifier: String(kUTTypePropertyList))
           
            extensionItem.attachments = [obj]
            if let context = self.extensionContext{
                context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
            }
        }
        else{
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: ACLocalizedString("common_error_title", nil), message: ACLocalizedString("assistant_launching_unable", nil))
            enabledSwitch.isOn = domainEnabled
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        let extensionItem = NSExtensionItem()
        let obj: NSItemProvider = NSItemProvider(item:
            [ NSExtensionJavaScriptFinalizeArgumentKey  : [
                "needReload": "\(enabledHolder != self.domainEnabled)"
                ]] as NSSecureCoding, typeIdentifier: String(kUTTypePropertyList))
        
        extensionItem.attachments?.append(obj)
        if let context = self.extensionContext{
            context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
        }
    }
    
// MARK: - Tableview delegates
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme?.setupTableCell(cell)
        return cell
    }
    
// MARK: - Private Methods
    
    @objc private func openWithUrl(_ url: URL?) {
        guard let Url = url else { return }
        var responder: UIResponder? = self
        while responder != nil{
            if responder?.responds(to: Selector("openURL:")) ?? false{
                responder?.perform(Selector("openURL:"), with: Url)
            }
            responder = responder?.next
        }
    }
}
