//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import SafariServices
import DnsAdGuardSDK

/// Delegate for DnsProvidersController
protocol DnsProviderDetailsControllerDelegate: AnyObject {
    /// Notify the delegate that provider have been selected
    func providerSelected()
}

/// Details controller that represent info about provider
final class DnsProviderDetailsController : UITableViewController {

    fileprivate enum ProviderSection: Int, CaseIterable {
        case headerSection = 0
        case actionSection
        case featuresSection
    }

    fileprivate enum ProviderRow: Int, CaseIterable {
        case serverRow = 0
        case websiteRow
    }

    // MARK: - public fields
    var providerId: Int!
    weak var delegate: DnsProviderDetailsControllerDelegate?

    // MARK: - Services
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let dnsProvidersManager: DnsProvidersManagerProtocol = ServiceLocator.shared.getService()!
    private let domainParserService: DomainParserServiceProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!

    // MARK: - private properties
    private lazy var model: DnsProviderDetailsModel = {
        return DnsProviderDetailsModel(providerId: providerId, resources: resources, dnsProvidersManager: dnsProvidersManager, vpnManager: vpnManager)
    }()
    private let providerDetailSections: [ProviderSection] = ProviderSection.allCases
    private let providerDetailRows: [ProviderRow]  = ProviderRow.allCases
    private let selectDnsProtocolControllerIdentifier = "SelectDnsProtocolController"
    private var dnsImplementationObserver: NotificationToken?

    // MARK: - view controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        DnsProviderHeaderCell.registerCell(forTableView: tableView)
        DnsProviderActionCell.registerCell(forTableView: tableView)
        DnsProviderFeatureCell.registerCell(forTableView: tableView)
        tableView.separatorStyle = .singleLine

        updateTheme()
        setupBackButton()

        dnsImplementationObserver = NotificationCenter.default.observe(name: .dnsImplementationChanged, object: nil, queue: .main) { [weak self] _ in
            self?.model.dnsImplementationChanged()
            self?.tableView.reloadData()
        }
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return providerDetailSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = providerDetailSections[section]
        switch section {
        case .headerSection: return 1
        case .actionSection: return 2
        case .featuresSection: return model.features.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = providerDetailSections[indexPath.section]

        let cell: UITableViewCell
        switch section {
        case .headerSection:
            cell = getHeaderCell(tableView: tableView, model: model)
        case .actionSection :
            let row = providerDetailRows[indexPath.row]
            switch row {
            case .serverRow:
                cell = getServerCell(tableView: tableView)
            case .websiteRow:
                cell = getWebsiteCell(tableView: tableView, model: model)
            }
        case .featuresSection:
            let feature = model.features[indexPath.row]
            cell = getFeatureCell(tableView: tableView, feature: feature)
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard providerDetailSections[indexPath.section] == .actionSection else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }

        let row = providerDetailRows[indexPath.row]
        // hide empty cells
        switch row {
        case .serverRow:
            return model.dnsProtocols.isEmpty ? 0 : UITableView.automaticDimension
        case .websiteRow:
            return model.providerHomepage.isEmpty ? 0 : UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        guard providerDetailSections[indexPath.section] == .actionSection else { return }
        let row = providerDetailRows[indexPath.row]

        switch row {
        case .serverRow:
            showSelectServerAlert()
        case .websiteRow:
            guard let url = URL(string: model.providerHomepage) else { return }

            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    // MARK: - Actions

    @IBAction func selectTapped(_ sender: Any) {
        do {
            try model.selectProviderWithActiveDnsProtocol()
            delegate?.providerSelected()
            navigationController?.popViewController(animated: true)
        } catch {
            DDLogError("(DnsProviderDetailsController) - selectTapped; While selecting provider error occurred: \(error)")
            showUnknownErrorAlert()
        }
    }

    private func showSelectServerAlert(){
        guard let controller = storyboard?.instantiateViewController(withIdentifier: selectDnsProtocolControllerIdentifier) as? SelectDnsProtocolController else { return }
        controller.delegate = self
        controller.availableProtocols = model.dnsProtocols
        controller.selectedProtocol = model.activeDnsProtocol

        present(controller, animated: true, completion: nil)
    }

    // MARK: - private methods

    // MARK: - Cell getters

    private func getHeaderCell(tableView: UITableView, model: DnsProviderDetailsModel) -> UITableViewCell {
        let cell = DnsProviderHeaderCell.getCell(forTableView: tableView)
        cell.logoImage = model.providerLogo
        cell.darkLogoImage = model.providerDarkLogo
        cell.descriptionString = model.providerDescription
        cell.updateTheme(themeService: themeService)
        return cell
    }

    private func getServerCell(tableView: UITableView) -> UITableViewCell {
        let cell = DnsProviderActionCell.getCell(forTableView: tableView)
        cell.actionNameTitle = String.localizedString("server_title")
        cell.selectedOptionTitle = model.activeDnsProtocol.localizedName
        cell.updateTheme(themeService: themeService)
        return cell
    }

    private func getWebsiteCell(tableView: UITableView, model: DnsProviderDetailsModel) -> UITableViewCell {
        let cell = DnsProviderActionCell.getCell(forTableView: tableView)
        cell.actionNameTitle = String.localizedString("website_title")
        let host = URL(string: model.providerHomepage)?.host ?? ""
        let option = domainParserService.domainParser?.parse(host: host)?.domain ?? model.providerHomepage
        cell.selectedOptionTitle = option
        cell.updateTheme(themeService: themeService)
        return cell
    }

    private func getFeatureCell(tableView: UITableView, feature: DnsAdGuardSDK.DnsFeature) -> UITableViewCell {
        let cell = DnsProviderFeatureCell.getCell(forTableView: tableView)
        cell.logoImage = feature.logo
        cell.nameString = feature.name
        cell.descriptionString = feature.featureDescription
        cell.updateTheme(themeService: themeService)
        return cell
    }
}

extension DnsProviderDetailsController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupTable(tableView)
        tableView.reloadData()
    }
}

// MARK: - DnsProviderDetailsController + SelectDnsProtocolControllerDelegate

extension DnsProviderDetailsController: SelectDnsProtocolControllerDelegate {
    func protocolSelected(dnsProtocol: DnsProtocol) {
        do {
            try model.selectProviderWith(dnsProtocol: dnsProtocol)
            tableView.reloadData()
        } catch {
            DDLogError("(DnsProviderDetailsController) - protocolSelected; While selecting protocol error occurred: \(error)")
            showUnknownErrorAlert()
        }
    }
}
