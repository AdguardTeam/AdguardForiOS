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

import DnsAdGuardSDK

class DnsModeController: UITableViewController {

    // MARK: - IB Outlets

    @IBOutlet var themableLabels: [ThemableLabel]!

    @IBOutlet weak var fullButton: UIButton!
    @IBOutlet weak var fullWithoutIconButton: UIButton!
    @IBOutlet weak var splitButton: UIButton!

    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!

    // MARK: - Services

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let dnsConfigAssistant: DnsConfigManagerAssistantProtocol = ServiceLocator.shared.getService()!

    // MARK: - Public properties

    var selectedCell = 0

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension

        let mode = resources.tunnelMode

        switch mode {
        case .split:
            selectedCell = 2
        case .full:
            selectedCell = 0
        case .fullWithoutVpnIcon:
            selectedCell = 1
        }

        updateButtons()
        setupBackButton()

        updateTheme()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }

        var mode: TunnelMode = .full
        switch indexPath.row {
        case 0:
            mode = .full
        case 1:
            mode = .fullWithoutVpnIcon
        case 2:
            mode = .split
        default:
            break
        }

        resources.tunnelMode = mode
        dnsConfigAssistant.applyDnsPreferences(for: .modifiedLowLevelSettings, completion: nil)

        selectedCell = indexPath.row
        updateButtons()

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Actions

    // MARK: - private methods

    private func updateButtons() {
        splitButton.isSelected = false
        fullButton.isSelected = false
        fullWithoutIconButton.isSelected = false

        switch selectedCell {
        case 2:
            splitButton.isSelected = true
        case 0:
            fullButton.isSelected = true
        case 1:
            fullWithoutIconButton.isSelected = true
        default:
            break
        }
    }
}

extension DnsModeController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        theme.setupLabels(themableLabels)
        separator1.backgroundColor = theme.separatorColor
        separator2.backgroundColor = theme.separatorColor
        tableView.reloadData()
    }
}
