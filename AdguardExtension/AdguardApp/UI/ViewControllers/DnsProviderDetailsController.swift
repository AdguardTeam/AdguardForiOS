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

class DnsProviderDetailsController : UITableViewController, UIViewControllerTransitioningDelegate,  ChooseProtocolControllerDelegate {
    
    // MARK: - public fields
    
    var provider: DnsProviderInfo?
    var selectedProtocol: DnsProtocol = .dns
    
    //MARK: - IB Outlets
    
    // MARK: - services
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    let vpnManager: APVPNManager = ServiceLocator.shared.getService()!
    
    // MARK: - constants
    
    private let headerSection = 0
    private let buttonsSection = 1
    private let featuresSection = 2
    
    private let serverRow = 0
    private let websiteRow = 1
    
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
            
            if logoImage == nil {
                headerCell.logoHeightConstraint.constant = 0
            }
            else {
                headerCell.logoHeightConstraint.constant = 31
                headerCell.logo.image = logoImage
            }
            
            headerCell.summary.text = ACLocalizedString(provider?.summary, nil)
            
            theme.setupLabel(headerCell.summary)
        
        case (buttonsSection, serverRow) :
            let serverCell = tableView.dequeueReusableCell(withIdentifier: "serverCell") as! DnsProviderServerCell
            cell = serverCell
            
            let protocolStringId: [DnsProtocol: String] = [         .dns: "regular_dns_protocol",
                                                                    .dnsCrypt: "dns_crypt_protocol",
                                                                    .doh: "doh_protocol",
                                                                    .dot: "dot_protocol"]
            
            let dnsProtocolStringId = protocolStringId[selectedProtocol]
            
            serverCell.server.text = ACLocalizedString(dnsProtocolStringId, nil)
            
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
            if provider?.protocols?.count == 0 { return 0 }
        case (buttonsSection, websiteRow):
            if (provider?.website?.count ?? 0) == 0 { return 0 }
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
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        default:
            break
        }
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
    
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - ChooseProtocolControllerDelegate methods
    
    func protocolSelected(protocol: DnsProtocol) {
        
        tableView.reloadData()
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
    }
    
}

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
