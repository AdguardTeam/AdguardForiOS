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
import UIKit

class LowLevelSettingsController: UITableViewController {
    
    @IBOutlet weak var blockIpv6Switch: UISwitch!
    @IBOutlet weak var tunnelModeDescription: ThemableLabel!
    @IBOutlet weak var blockimgModeDescription: ThemableLabel!
    @IBOutlet weak var blockingResponseTtlDescription: ThemableLabel!
    @IBOutlet weak var customAddressCell: UITableViewCell!
    @IBOutlet weak var warningTextView: UITextView!
    @IBOutlet weak var betaChannelTextView: UITextView!
    @IBOutlet weak var customAddressDescription: ThemableLabel!
    @IBOutlet weak var fallbacksDescription: ThemableLabel!
    @IBOutlet weak var bootstrapsDescription: ThemableLabel!
    
    @IBOutlet weak var lastSeparator: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
    
    private let customAddress = 2
    private let blockIpv6 = 3
    private let blockResponseTtl = 4
    private let boostraps = 5
    private let fallbacks = 6
    
    private var notificationToken: NotificationToken?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastSeparator.isHidden = true
        blockIpv6Switch.isOn = resources.blockIpv6
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        setupBackButton()
        updateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTunnelModeDescription()
        setBlockingModeDescription()
        setBlockedResponseTllDescription()
        setBootstrapsDescription()
        setCustomAddressDescription()
        setFallbacksDescription()
        tableView.reloadData()
    }
    
    // MARK: - actions
    
    @IBAction func blockIpv6Action(_ sender: UISwitch) {
        vpnManager.updateSettings(completion: nil)
        resources.blockIpv6 = sender.isOn
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case customAddress:
            showCustomAddressAlert()
        case blockIpv6:
            blockIpv6Switch.setOn(!blockIpv6Switch.isOn, animated: true)
            blockIpv6Action(blockIpv6Switch)
        case blockResponseTtl:
            showBlockedResponseTtlAlert()
        case boostraps:
            showBottstrapsAlert()
        case fallbacks:
            showFallbacksAlert()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if cell == self.customAddressCell && resources.blockingMode != .AGBM_CUSTOM_ADDRESS {
            return 0
        }
        return tableView.rowHeight
    }
    
    // MARK: - Private methods
    
    private func updateTheme() {
        setupBetaChnnelTextView()
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        theme.setupSeparators(separators)
        theme.setupSwitch(blockIpv6Switch)
        theme.setupTextView(betaChannelTextView)
        setupWarningDescriptionTextView()
        
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
    
    private func setTunnelModeDescription() {
        switch resources.tunnelMode {
        case APVpnManagerTunnelModeSplit:
            tunnelModeDescription.text = String.localizedString("tunnel_mode_split_description")
        case APVpnManagerTunnelModeFull:
            tunnelModeDescription.text = String.localizedString("tunnel_mode_full_description")
        case APVpnManagerTunnelModeFullWithoutVPNIcon:
            tunnelModeDescription.text = String.localizedString("tunnel_mode_full_without_icon_description")
        default:
            break
        }
    }
    
    private func setBlockingModeDescription() {
        
        switch resources.blockingMode {
        case .AGBM_DEFAULT:
            blockimgModeDescription.text = "Default"
        case .AGBM_REFUSED:
            blockimgModeDescription.text = "REFUSED"
        case .AGBM_NXDOMAIN:
            blockimgModeDescription.text = "NXDOMAIN"
        case .AGBM_UNSPECIFIED_ADDRESS:
            blockimgModeDescription.text = "UNSPECIFIED_ADDRESS"
        case .AGBM_CUSTOM_ADDRESS:
            blockimgModeDescription.text = "CUSTOM_ADDRESS"
        default:
            break
        }
    }
    
    private func setBlockedResponseTllDescription() {
        blockingResponseTtlDescription.text = String(format: String.localizedString("s_unit"), String(resources.blockedResponseTtlSecs))
    }
    
    private func setCustomAddressDescription() {
        customAddressDescription.text = resources.customBlockingIp?.joined(separator: ", ")
    }
    
    private func setFallbacksDescription() {
        fallbacksDescription.text = resources.customFallbackServers?.joined(separator: ", ")
    }
    
    private func setBootstrapsDescription() {
        guard let string = resources.customBootstrapServers?.joined(separator: ", "), string.count > 0 else {
            bootstrapsDescription.text = String.localizedString("low_level_bootstraps_placeholder")
            return
        }
        bootstrapsDescription.text = string
    }


    
    private func showBlockedResponseTtlAlert() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "BlockedResponseTtlController") as? BlockedResponseTtlController else { return }
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    private func showBottstrapsAlert() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "UpstreamsController") as? UpstreamsController else { return }
        controller.upstreamType = .Bootstrap
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    private func showFallbacksAlert() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "UpstreamsController") as? UpstreamsController else { return }
        controller.upstreamType = .Fallback
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    private func showCustomAddressAlert() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "UpstreamsController") as? UpstreamsController else { return }
        controller.upstreamType = .CustomAddress
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    private func setupBetaChnnelTextView() {
        let betaLinkFormat = ACLocalizedString("low_level_beta_link", nil)
        let url = UIApplication.shared.adguardUrl(action: "beta_channel", from: "low_level_settings", buildVersion: productInfo.buildVersion())
        let betaLink = String(format: betaLinkFormat, url)
        setBetaChannelLink(betaLink)
    }
    
    private func setupWarningDescriptionTextView() {
        let warningDescriptionFormat = ACLocalizedString("low_level_description", nil)
        let warningDescription = String(format: warningDescriptionFormat, theme.errorRedColor.hex())
        warningTextView.attributedText = NSMutableAttributedString.fromHtml(warningDescription, fontSize: warningTextView.font!.pointSize, color: theme.blackTextColor, attachmentImage: nil, textAlignment: .center)
    }
    
    private func setBetaChannelLink(_ text: String){
        if let headerText = text.attributedStringFromHtml() {
            let font = betaChannelTextView.font ?? UIFont.systemFont(ofSize: 16.0)
            betaChannelTextView.text = ""
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            
            headerText.addAttribute(.foregroundColor, value: theme.lightGrayTextColor , range: NSRange(location: 0, length: headerText.length))
            headerText.addAttribute(.font, value: font, range: NSRange(location: 0, length: headerText.length))
            headerText.addAttributes([.paragraphStyle : style], range: NSRange(location: 0, length: headerText.length))
            betaChannelTextView.attributedText = headerText
        }
    }

}

extension LowLevelSettingsController: BlockedResponseTtlDelegate {
    func setTtlDescription(ttl: String) {
        blockingResponseTtlDescription.text = String(format: String.localizedString("s_unit"), ttl)
    }
}

extension LowLevelSettingsController: UpstreamsControllerDelegate {
    func updateBootstrapsDescriptionLabel(text: String) {
        guard text.count > 0 else {
            bootstrapsDescription.text = String.localizedString("low_level_bootstraps_placeholder")
            return
        }
        bootstrapsDescription.text = text
    }
    
    func updateCustomAddressDescriptionLabel(text: String) {
        customAddressDescription.text = text
        let indexPath = IndexPath(row: customAddress, section: 1)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func updateFallbacksDescriptionLabel(text: String) {
        fallbacksDescription.text = text
        let indexPath = IndexPath(row: fallbacks, section: 1)
        tableView.reloadRows(at: [indexPath], with: .none)

    }
}
