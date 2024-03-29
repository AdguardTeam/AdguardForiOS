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

/// Delegate protocol for DnsProviderDetailsController
protocol SelectDnsProtocolControllerDelegate: AnyObject {
    func protocolSelected(dnsProtocol: DnsProtocol)
}

/// Controller that represent dns protocol picker
final class SelectDnsProtocolController: BottomAlertController {

    // MARK: - IBOutlet

    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var tableView: ContentSizedTableView!
    
    // MARK: - Public properties

    weak var delegate: SelectDnsProtocolControllerDelegate?
    var availableProtocols: [DnsProtocol] = []
    var selectedProtocol: DnsProtocol = .dns

    // MARK: - Private properties

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTheme()
        setupTableView()
    }

    // MARK: - Private methods

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        ExtendedRadioButtonCell.registerCell(forTableView: tableView)
    }
}

// MARK: - SelectDnsProtocolController + UITableViewDataSource

extension SelectDnsProtocolController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableProtocols.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExtendedRadioButtonCell.getCell(forTableView: tableView)
        let prot = availableProtocols[indexPath.row]
        cell.titleString = prot.localizedName
        cell.radioButtonSelected = prot == selectedProtocol
        cell.isArrowRightHidden = true
        cell.updateTheme(themeService: themeService)
        cell.cellTag = indexPath.row
        cell.delegate = self
        return cell
    }
}

// MARK: - SelectDnsProtocolController + UITableViewDelegate

extension SelectDnsProtocolController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProtocol = availableProtocols[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.protocolSelected(dnsProtocol: selectedProtocol)
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

// MARK: - ChartDateTypeController + ExtendedRadioButtonCellDelegate

extension SelectDnsProtocolController: ExtendedRadioButtonCellDelegate {
    func radioButtonTapped(with tag: Int) {
        let indexPath = IndexPath(row: tag, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: indexPath)
    }
}

extension SelectDnsProtocolController: ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = themeService.popupBackgroundColor
        tableView.backgroundColor = themeService.popupBackgroundColor
        themeService.setupLabel(titleLabel)
        tableView.reloadData()
    }
}
