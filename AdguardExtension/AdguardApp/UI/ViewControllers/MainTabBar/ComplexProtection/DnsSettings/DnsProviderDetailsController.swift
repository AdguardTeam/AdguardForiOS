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
import SafariServices

class DnsProviderDetailsController : UITableViewController, UIViewControllerTransitioningDelegate,  ChooseProtocolControllerDelegate {
    
    // MARK: - public fields
    
    var provider: DnsProviderInfo?
    var selectedProtocol: DnsProtocol?
    
    //MARK: - IB Outlets
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    private let dnsProvidersService: DnsProvidersService = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - constants
    
    private let headerSection = 0
    private let buttonsSection = 1
    private let featuresSection = 2
    
    private let serverRow = 0
    private let websiteRow = 1
    
    // MARK: - private fields
    
    private var dnsServerObservetion: NSKeyValueObservation?
    private var notificationToken: NotificationToken?
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        updateProtocol()
        updateTheme()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case headerSection:
            return 1
        case buttonsSection:
            return 2
        case featuresSection:
            return provider?.features?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        
        switch (indexPath.section, indexPath.row) {
        case (headerSection, _):
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! DnsProviderHeaderCell
            cell = headerCell
            
            let logoImage = UIImage(named: provider?.logo ?? "")
            let logoImageDark = UIImage(named: provider?.logoDark ?? "")
            
            if logoImage == nil, logoImageDark == nil {
                headerCell.logoHeightConstraint.constant = 0
            }
            else {
                headerCell.logoHeightConstraint.constant = 56.0
                headerCell.logo.lightThemeImage = logoImage
                headerCell.logo.darkThemeImage = logoImageDark
            }
            
            headerCell.summary.text = ACLocalizedString(provider?.summary, nil)
            
            theme.setupLabel(headerCell.summary)
            theme.setupImage(headerCell.logo)
        
        case (buttonsSection, serverRow) :
            let serverCell = tableView.dequeueReusableCell(withIdentifier: "serverCell") as! DnsProviderServerCell
            cell = serverCell
            
            if let selectedProtocol = selectedProtocol {
                let dnsProtocolStringId = DnsProtocol.stringIdByProtocol[selectedProtocol]
                serverCell.server.text = ACLocalizedString(dnsProtocolStringId, nil)
            }
            
            theme.setupLabels(serverCell.themableLabels)
            serverCell.separator.backgroundColor = theme.separatorColor
        
        case (buttonsSection, websiteRow) :
            let websiteCell = tableView.dequeueReusableCell(withIdentifier: "websiteCell") as! DnsProviderWebsiteCell
            cell = websiteCell
            
            websiteCell.website.text = provider?.website
            theme.setupLabels(websiteCell.themableLabels)
            
        case (featuresSection, _):
            let featureCell = tableView.dequeueReusableCell(withIdentifier: "featureCell") as! DnsFeatureCell
            
            let feature = provider?.features?[indexPath.row]
            
            cell = featureCell
            featureCell.icon.image = UIImage(named: feature?.iconId ?? "")
            featureCell.name.text = ACLocalizedString(feature?.title, nil)
            featureCell.summary.text = ACLocalizedString(feature?.summary, nil)
            
            theme.setupLabels(featureCell.themableLabels)
            
            let lastCell = indexPath.row == provider!.features!.count - 1
            featureCell.separator.backgroundColor = lastCell ? .clear : theme.separatorColor
            
        default:
            break;
        }
        
        theme.setupTableCell(cell!)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // hide empty cells
        switch (indexPath.section, indexPath.row) {
        case (buttonsSection, serverRow):
            return provider?.protocols?.count == 0 ? 0 : 60
        case (buttonsSection, websiteRow):
            return (provider?.website?.count ?? 0) == 0 ? 0 : 60
        default:
            break
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row){
        case (buttonsSection, serverRow):
            selectServer()
        case (buttonsSection, websiteRow):
            if let url = URL(string: provider?.website ?? "") {
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Presentation delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    // MARK: - Actions
    
    func selectServer(){
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ChooseProtocolController") as? ChooseProtocolController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        
        controller.delegate = self
        
        controller.selectedProtocol = selectedProtocol
        controller.provider = provider
    
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - ChooseProtocolControllerDelegate methods
    
    func protocolSelected(chosenProtocol: DnsProtocol) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.selectedProtocol = chosenProtocol
            self.provider?.setActiveProtocol(self.resources, protcol: chosenProtocol)
            self.tableView.reloadData()
            
            if self.dnsProvidersService.activeDnsProvider == self.provider {
                if let server = self.provider?.serverByProtocol(dnsProtocol: chosenProtocol) {
                    self.dnsProvidersService.activeDnsServer = server
                    self.vpnManager.updateSettings(completion: nil)
                }
            }
        }
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
    
    private func updateProtocol() {
        if let prot = provider?.getActiveProtocol(resources) {
            selectedProtocol = prot
        }
    }
}

// MARK: - custom cells

class DnsFeatureCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: ThemableLabel!
    @IBOutlet weak var summary: ThemableLabel!
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
}

class DnsProviderHeaderCell : UITableViewCell {
    @IBOutlet weak var logo: ThemeableImageView!
    @IBOutlet weak var summary: ThemableLabel!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
}

class DnsProviderServerCell: UITableViewCell {
    
    @IBOutlet weak var server: ThemableLabel!
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
}

class DnsProviderWebsiteCell: UITableViewCell {
    
    @IBOutlet weak var website: ThemableLabel!
    @IBOutlet var themableLabels: [ThemableLabel]!
}
