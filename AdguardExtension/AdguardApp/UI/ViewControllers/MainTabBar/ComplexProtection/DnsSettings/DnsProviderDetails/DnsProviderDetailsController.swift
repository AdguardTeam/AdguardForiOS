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

import SafariServices
import DnsAdGuardSDK

/// Delegate for DnsProvidersController
protocol DnsProviderDetailsControllerDelegate: AnyObject {
    func activeServerChanged(_ newServer: DnsServerInfo)
}

/// Details controller that represent info about provider
final class DnsProviderDetailsController : UITableViewController {
    
    fileprivate enum ProviderSection: Int, CaseIterable {
        case headerSection = 0
        case buttonsSection
        case featuresSection
    }
    
    fileprivate enum ProviderRow: Int, CaseIterable {
        case serverRow = 0
        case websiteRow
    }
    
    // MARK: - public fields
    var model: DnsProviderDetailsModelProtocol?
    weak var delegate: DnsProviderDetailsControllerDelegate?
    private var selectedProtocol: DnsAdGuardSDK.DnsProtocol?
    
    // MARK: - Services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let domainsParserService: DomainsParserServiceProtocol = ServiceLocator.shared.getService()!
    
    
    // MARK: - private properties
    
    private let sections: [ProviderSection] = ProviderSection.allCases
    private let rows: [ProviderRow]  = ProviderRow.allCases
    
    private var dnsServerObservetion: NSKeyValueObservation?
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProtocol()
        updateTheme()
        setupBackButton()
    }
    
    //MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .headerSection: return 1
        case .buttonsSection: return 2
        case .featuresSection:
            guard let model = model else { return 0 }
            return model.features.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model else { return UITableViewCell() }
        let section = sections[indexPath.section]
        
        let cell: UITableViewCell
        switch section {
        case .headerSection:
            cell = getHeaderCell(tableView: tableView, model: model)
        case .buttonsSection :
            let row = rows[indexPath.row]
            switch row {
            case .serverRow:
                cell = getServerCell(tableView: tableView)
            case .websiteRow:
                cell = getWebsiteCell(tableView: tableView, model: model)
            }
        case .featuresSection:
            let feature = model.features[indexPath.row]
            let isLastCell = model.features.count - 1 == indexPath.row
            cell = getFeatureCell(tableView: tableView, feature: feature, isLastCell: isLastCell)
        }
        
        theme.setupTableCell(cell)
        return cell
    }
    
    //MARK: - UITableViewDlelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let model = model,
              sections[indexPath.section] == .buttonsSection else {
                  return super.tableView(tableView, heightForRowAt: indexPath)
              }
        
        let row = rows[indexPath.row]
        // hide empty cells
        switch row {
        case .serverRow:
            return model.dnsProtocols.isEmpty ? 0 : 60
        case .websiteRow:
            return model.providerHomepage.isEmpty ? 0 : 60
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        guard sections[indexPath.section] == .buttonsSection else { return }
        let row = rows[indexPath.row]
        
        switch row {
        case .serverRow:
            showSelectServerAlert()
        case .websiteRow:
            guard let model = model,
                  let url = URL(string: model.providerHomepage) else { return }
            
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func selectTapped(_ sender: Any) {
        //TODO: 
        if let currentProtocol = selectedProtocol {
            model?.selectServer(dnsProtocol: currentProtocol)
//            activateServer(currentServer)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func showSelectServerAlert(){
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "SelectDnsProtocolController") as? SelectDnsProtocolController else { return }
        controller.delegate = self
        controller.availableProtocols = model?.dnsProtocols ?? []
    
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - private methods
    
    private func updateProtocol() {
        if resources.dnsImplementation == .native {
            //TODO: Add native
//            selectedProtocol = nativeProviderService.currentServer?.dnsProtocol
        } else {
            selectedProtocol = model?.selectedDnsServer
        }
    }
    
    //MARK: - Cell getters
    private func getHeaderCell(tableView: UITableView, model: DnsProviderDetailsModelProtocol) -> UITableViewCell {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! DnsProviderHeaderCell
        let cell = headerCell
        
        if let logoImage = model.providerLogo,
           let logoImageDark = model.providerDarkLogo {
            headerCell.logoHeightConstraint.constant = 56.0
            headerCell.logo.lightThemeImage = logoImage
            headerCell.logo.darkThemeImage = logoImageDark
        } else {
            headerCell.logoHeightConstraint.constant = 0
        }

        headerCell.summary.text = model.providerDescription
        
        theme.setupLabel(headerCell.summary)
        theme.setupImage(headerCell.logo)
        return cell
    }

    
    private func getServerCell(tableView: UITableView) -> UITableViewCell {
        let serverCell = tableView.dequeueReusableCell(withIdentifier: "serverCell") as! DnsProviderServerCell
        let cell = serverCell
        
        if let selectedProtocol = selectedProtocol {
            serverCell.server.text = selectedProtocol.localizedString
        }
        
        theme.setupLabels(serverCell.themableLabels)
        serverCell.separator.backgroundColor = theme.separatorColor
        return cell
    }
    
    
    private func getWebsiteCell(tableView: UITableView, model: DnsProviderDetailsModelProtocol) -> UITableViewCell {
        let websiteCell = tableView.dequeueReusableCell(withIdentifier: "websiteCell") as! DnsProviderWebsiteCell
        let cell = websiteCell
        
        let host = URL(string: model.providerHomepage)?.host ?? ""
        websiteCell.website.text = domainsParserService.domainsParser?.parse(host: host)?.domain ?? model.providerHomepage
        theme.setupLabels(websiteCell.themableLabels)
        return cell
    }
    
    private func getFeatureCell(tableView: UITableView, feature: DnsAdGuardSDK.DnsFeature, isLastCell: Bool) -> UITableViewCell {
        let featureCell = tableView.dequeueReusableCell(withIdentifier: "featureCell") as! DnsFeatureCell
        let cell = featureCell
        
        featureCell.icon.image = feature.logo
        featureCell.name.text = feature.name
        featureCell.summary.text = feature.featureDescription
        
        theme.setupLabels(featureCell.themableLabels)
        
        featureCell.separator.backgroundColor = isLastCell ? .clear : theme.separatorColor
        return cell
    }
}

// MARK: - Custom cells

/// Feature cell
final class DnsFeatureCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: ThemableLabel!
    @IBOutlet weak var summary: ThemableLabel!
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
}

/// Header cell
final class DnsProviderHeaderCell : UITableViewCell {
    @IBOutlet weak var logo: ThemeableImageView!
    @IBOutlet weak var summary: ThemableLabel!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
}

/// Server cell
final class DnsProviderServerCell: UITableViewCell {
    
    @IBOutlet weak var server: ThemableLabel!
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
}

/// Website cell
final class DnsProviderWebsiteCell: UITableViewCell {
    @IBOutlet weak var website: ThemableLabel!
    @IBOutlet var themableLabels: [ThemableLabel]!
}

extension DnsProviderDetailsController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        tableView.reloadData()
    }
}

extension DnsProviderDetailsController: SelectDnsProtocolControllerDelegate {
    func protocolSelected(protocol: DnsAdGuardSDK.DnsProtocol) {
        //TODO: select, not activate server
    }

}

extension DnsAdGuardSDK.DnsProtocol {
    var localizedString: String {
        switch self {
        case .dns: return String.localizedString("regular_dns_protocol")
        case .dnscrypt: return String.localizedString("dns_crypt_protocol")
        case .doh: return String.localizedString("doh_protocol")
        case .dot: return String.localizedString("dot_protocol")
        case .doq: return String.localizedString("doq_protocol")
        }
    }
}
