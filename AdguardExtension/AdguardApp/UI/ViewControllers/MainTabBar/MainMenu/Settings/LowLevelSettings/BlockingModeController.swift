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

class BlockingModeController: UITableViewController {
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    @IBOutlet var customIPDescriptionLabel: UILabel!
    @IBOutlet weak var defaultHeaderLabel: ThemableLabel!
    @IBOutlet weak var refusedHeaderLabel: ThemableLabel!
    @IBOutlet weak var nxDomainHeaderLabel: ThemableLabel!
    @IBOutlet weak var nullIPHeaderLabel: ThemableLabel!
    @IBOutlet weak var customIPHeaderLabel: ThemableLabel!
    
    private var notificationToken: NotificationToken?
    private var selectedCell = 0
    
    private let defaultMode = 0
    private let refusedMode = 1
    private let nxDomainMode = 2
    private let unspecifiedAddressMode = 3
    private let customAddressMode = 4
    
    // MARK: - services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!

    override func viewDidLoad() {
        super.viewDidLoad()

        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        
        let mode = resources.blockingMode
        
        switch mode {
        case .agDefault:
            selectedCell = defaultMode
        case .agRefused:
            selectedCell = refusedMode
        case .agNxdomain:
            selectedCell = nxDomainMode
        case .agUnspecifiedAddress:
            selectedCell = unspecifiedAddressMode
        case .agCustomAddress:
            selectedCell = customAddressMode
        }
        
        updateButtons(by: selectedCell)
        setupBackButton()
        
        updateTheme()
        
        var text = ""
        if let customBlockingIp = resources.customBlockingIp?.joined(separator: ", ") {
            text = customBlockingIp
        }
        updateDescriptionLabel(type: .customAddress, text: text)
        
        defaultHeaderLabel.text = BlockingModeSettings.agDefault.name
        refusedHeaderLabel.text = BlockingModeSettings.agRefused.name
        nxDomainHeaderLabel.text = BlockingModeSettings.agNxdomain.name
        nullIPHeaderLabel.text = BlockingModeSettings.agUnspecifiedAddress.name
        customIPHeaderLabel.text = BlockingModeSettings.agCustomAddress.name
    }
    
    // MARK: - Actions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        updateBlockingMode(index: sender.tag)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateBlockingMode(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private methods

    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        tableView.reloadData()
        theme.setupLabels(themableLabels)
        theme.setupSeparators(separators)
    }
    
    private func updateButtons(by index: Int) {
        buttons.forEach { $0.isSelected = $0.tag == index }
    }
    
    private func updateBlockingMode(index: Int) {
        let mode: BlockingModeSettings
        switch index {
        case defaultMode:
            mode = .agDefault
        case refusedMode:
            mode = .agRefused
        case nxDomainMode:
            mode = .agNxdomain
        case unspecifiedAddressMode:
            mode = .agUnspecifiedAddress
        case customAddressMode:
            mode = .agCustomAddress
            showCustomIPAlert()
        default:
            mode = .agDefault
        }
        
        selectedCell = index
        
        if mode != .agCustomAddress {
            setupMode(mode: mode)
        }
    }
    
    private func showCustomIPAlert() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "UpstreamsController") as? UpstreamsController else { return }
        controller.upstreamType = .customAddress
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    private func setupMode(mode: BlockingModeSettings) {
        resources.blockingMode = mode
        vpnManager.updateSettings(completion: nil)
        updateButtons(by: selectedCell)
    }
}

extension BlockingModeController: UpstreamsControllerDelegate {
    func updateDescriptionLabel(type: UpstreamType, text: String) {
        assert(type == .customAddress)
        var string = text
        if text.isEmpty {
            string = String.localizedString("custom_ip_description")
            if selectedCell == customAddressMode {
                updateBlockingMode(index: defaultMode)
            }
        } else if !text.isEmpty && selectedCell == customAddressMode && resources.blockingMode != .agCustomAddress {
            setupMode(mode: .agCustomAddress)
        }
        customIPDescriptionLabel.text = string
    }
}
