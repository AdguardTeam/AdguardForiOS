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
    
    @IBOutlet weak var defaultModeButton: UIButton!
    @IBOutlet weak var refusedModeButton: UIButton!
    @IBOutlet weak var nxDomainModeButton: UIButton!
    @IBOutlet weak var unspecifiedAddressModeButton: UIButton!
    @IBOutlet weak var customAddressModeButton: UIButton!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!

    private var notificationToken: NotificationToken?

    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!

    
    var selectedCell = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        
        let mode = resources.blockingMode
        
        switch mode {
        case .AGBM_DEFAULT:
            selectedCell = 0
        case .AGBM_REFUSED:
            selectedCell = 1
        case .AGBM_NXDOMAIN:
            selectedCell = 2
        case .AGBM_UNSPECIFIED_ADDRESS:
            selectedCell = 3
        case .AGBM_CUSTOM_ADDRESS:
            selectedCell = 4
        default:
            break
        }
        
        updateButtons()
        setupBackButton()
        
        updateTheme()

    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var mode = AGBlockingMode.AGBM_DEFAULT
        switch indexPath.row {
        case 0:
            mode = .AGBM_DEFAULT
        case 1:
            mode = .AGBM_REFUSED
        case 2:
            mode = .AGBM_NXDOMAIN
        case 3:
            mode = .AGBM_UNSPECIFIED_ADDRESS
        case 4:
            mode = .AGBM_CUSTOM_ADDRESS
        default:
            break
        }
        
        resources.blockingMode = mode
        vpnManager.updateSettings(completion: nil)
        
        selectedCell = indexPath.row
        updateButtons()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private methods

    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
        theme.setupLabels(themableLabels)
        separators.forEach { $0.backgroundColor = theme.separatorColor }
    }
    
    private func updateButtons() {
        
        defaultModeButton.isSelected = false
        refusedModeButton.isSelected = false
        nxDomainModeButton.isSelected = false
        unspecifiedAddressModeButton.isSelected = false
        customAddressModeButton.isSelected = false
        
        switch selectedCell {
        case 0:
            defaultModeButton.isSelected = true
        case 1:
            refusedModeButton.isSelected = true
        case 2:
            nxDomainModeButton.isSelected = true
        case 3:
            unspecifiedAddressModeButton.isSelected = true
        case 4:
            customAddressModeButton.isSelected = true
        default:
            break
        }
    }
}
