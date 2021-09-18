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
import DnsAdGuardSDK

final class LowLevelSettingsController: UITableViewController {
    
    @IBOutlet weak var blockIpv6Switch: UISwitch!
    @IBOutlet weak var tunnelModeDescription: ThemableLabel!
    @IBOutlet weak var blockimgModeDescription: ThemableLabel!
    @IBOutlet weak var blockingResponseTtlDescription: ThemableLabel!
    @IBOutlet weak var warningTextView: UITextView!
    @IBOutlet weak var betaChannelTextView: UITextView!
    @IBOutlet weak var fallbacksDescription: ThemableLabel!
    @IBOutlet weak var bootstrapsDescription: ThemableLabel!
    @IBOutlet weak var backgroundFetchTitle: ThemableLabel!
    @IBOutlet weak var backgroundFetchDescription: ThemableLabel!
    
    @IBOutlet weak var lastSeparator: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    @IBOutlet var notSupportedLabels: [UILabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
    
    private let customAddress = 1
    private let blockIpv6 = 2
    private let blockResponseTtl = 3
    private let boostraps = 4
    private let fallbacks = 5
    private let backgroundFetch = 6
    
    private var dnsImplementationObserver: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundFetchTitle.text = String.localizedString("background_app_refresh_time_title")
        lastSeparator.isHidden = true
        blockIpv6Switch.isOn = resources.blockIpv6
        setupBackButton()
        updateTheme()
        
        dnsImplementationObserver = NotificationCenter.default.observe(name: .dnsImplementationChanged, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.setupNotSupportedLabels(isNative: self.resources.dnsImplementation == .native)
        }
        
        setupNotSupportedLabels(isNative: resources.dnsImplementation == .native)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTunnelModeDescription()
        setBlockingModeDescription()
        setBlockedResponseTllDescription()
        setBootstrapsDescription()
        setFallbacksDescription()
        setBackgroundFethcDescription()
        tableView.reloadData()
    }
    
    // MARK: - actions
    
    @IBAction func blockIpv6Action(_ sender: UISwitch) {
        resources.blockIpv6 = sender.isOn
        vpnManager.updateSettings(completion: nil)
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
        case blockIpv6:
            blockIpv6Switch.setOn(!blockIpv6Switch.isOn, animated: true)
            blockIpv6Action(blockIpv6Switch)
        case blockResponseTtl:
            showBlockedResponseTtlAlert()
        case boostraps:
            showAlert(forType: .bootstrap)
        case fallbacks:
            showAlert(forType: .fallback)
        case backgroundFetch:
            showBackgroundFetchAlert()
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
    
    // MARK: - Private methods
    
    private func setTunnelModeDescription() {
        switch resources.tunnelMode {
        case .split:
            tunnelModeDescription.text = String.localizedString("tunnel_mode_split_description")
        case .full:
            tunnelModeDescription.text = String.localizedString("tunnel_mode_full_description")
        case .fullWithoutVpnIcon:
            tunnelModeDescription.text = String.localizedString("tunnel_mode_full_without_icon_description")
        }
    }
    
    private func setBlockingModeDescription() {
        blockimgModeDescription.text = resources.blockingMode.name
    }
    
    private func setBlockedResponseTllDescription() {
        blockingResponseTtlDescription.text = String(format: String.localizedString("s_unit"), String(resources.blockedResponseTtlSecs))
    }

    private func setFallbacksDescription() {
        guard let string = resources.customFallbackServers?.joined(separator: ", "), !string.isEmpty else {
            fallbacksDescription.text = String.localizedString("low_level_fallbacks_placeholder")
            return
        }
        fallbacksDescription.text = string
    }
    
    private func setBootstrapsDescription() {
        guard let string = resources.customBootstrapServers?.joined(separator: ", "), !string.isEmpty else {
            bootstrapsDescription.text = String.localizedString("low_level_bootstraps_placeholder")
            return
        }
        bootstrapsDescription.text = string
    }
    
    private func setBackgroundFethcDescription() {
        periodSelected(period: resources.backgroundFetchUpdatePeriod)
    }
    
    private func showBlockedResponseTtlAlert() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "BlockedResponseTtlController") as? BlockedResponseTtlController else { return }
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    private func showAlert(forType type: UpstreamType) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "UpstreamsController") as? UpstreamsController else { return }
        controller.upstreamType = type
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    private func showBackgroundFetchAlert() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "BackgroundFetchController") as? BackgroundFetchController else { return }
        controller.delegate = self
        present(controller, animated: true)
    }
    
    private func setupBetaChannelTextView() {
        let betaLinkFormat = ACLocalizedString("low_level_beta_link", nil)
        let url = UIApplication.shared.adguardUrl(action: "beta_channel", from: "low_level_settings", buildVersion: productInfo.buildVersion())
        let betaLink = String(format: betaLinkFormat, url)
        setBetaChannelLink(betaLink)
    }
    
    private func setupWarningDescriptionTextView() {
        let warningDescriptionFormat = ACLocalizedString("low_level_description", nil)
        let warningDescription = String(format: warningDescriptionFormat)
        warningTextView.attributedText = NSMutableAttributedString.fromHtml(warningDescription, fontSize: warningTextView.font!.pointSize, color: theme.blackTextColor, textAlignment: .center)
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
    
    private func setupNotSupportedLabels(isNative: Bool) {
        if isNative {
            notSupportedLabels.forEach { $0.text = String.localizedString("unsupported_setting") }
        } else {
            notSupportedLabels.forEach { $0.text = nil }
        }
    }

}

extension LowLevelSettingsController: BlockedResponseTtlDelegate {
    func setTtlDescription(ttl: String) {
        blockingResponseTtlDescription.text = String(format: String.localizedString("s_unit"), ttl)
    }
}

extension LowLevelSettingsController: UpstreamsControllerDelegate {
    func updateDescriptionLabel(type: UpstreamType, text: String) {
        let isEmptyText = text.isEmpty
        switch type {
        case .bootstrap:
            bootstrapsDescription.text = isEmptyText ? String.localizedString("low_level_bootstraps_placeholder") : text
            
        case .customAddress:
            return
            
        case .fallback:
            fallbacksDescription.text = isEmptyText ? String.localizedString("low_level_fallbacks_placeholder"): text
        }
        
        tableView.reloadData()
    }
}

// MARK: - LowLevelSettingsController + ThemableProtocol

extension LowLevelSettingsController: ThemableProtocol {
    func updateTheme() {
        setupBetaChannelTextView()
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        theme.setupSeparators(separators)
        theme.setupSwitch(blockIpv6Switch)
        theme.setupTextView(betaChannelTextView)
        setupWarningDescriptionTextView()
        tableView.reloadData()
    }
}

// MARK: - LowLevelSettingsController + BackgroundFetchControllerDelegate

extension LowLevelSettingsController: BackgroundFetchControllerDelegate {
    func periodSelected(period: BackgroundFetchUpdateInterval) {
        backgroundFetchDescription.text = period.title
    }
}

// MARK: - DnsProxyBlockingMode + name

extension DnsProxyBlockingMode {
    var name: String {
        switch self {
        case .defaultMode: return "Default"
        case .refused: return "REFUSED"
        case .nxdomain: return "NXDOMAIN"
        case .unspecifiedAddress: return "Unspecified IP"
        case .customAddress: return "Custom IP"
        }
    }
}
