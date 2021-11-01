///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import UIKit
import enum DnsAdGuardSDK.StatisticsPeriod

protocol DateTypeChangedProtocol: AnyObject {
    func statisticsPeriodChanged(statisticsPeriod: StatisticsPeriod)
}

final class ChartDateTypeController: BottomAlertController {

    @IBOutlet weak var periodLabel: ThemableLabel!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var tableView: UITableView!

    weak var delegate: DateTypeChangedProtocol?

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateTheme()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 52.0
        ExtendedRadioButtonCell.registerCell(forTableView: tableView)
    }
}

// MARK: - ChartDateTypeController + UITableViewDelegate

extension ChartDateTypeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let period = StatisticsPeriod.allCases[indexPath.row]
        delegate?.statisticsPeriodChanged(statisticsPeriod: period)
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
}

// MARK: - ChartDateTypeController + UITableViewDataSource

extension ChartDateTypeController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { StatisticsPeriod.allCases.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExtendedRadioButtonCell.getCell(forTableView: tableView)
        let period = StatisticsPeriod.allCases[indexPath.row]
        cell.titleString = period.dateTypeString
        cell.radioButtonSelected = resources.chartDateType == period
        cell.isArrowRightHidden = true
        cell.updateTheme(themeService: theme)
        cell.cellTag = indexPath.row
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

// MARK: - ChartDateTypeController + ExtendedRadioButtonCellDelegate

extension ChartDateTypeController: ExtendedRadioButtonCellDelegate {
    func radioButtonTapped(with tag: Int) {
        let indexPath = IndexPath(row: tag, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - ChartDateTypeController + ThemableProtocol

extension ChartDateTypeController: ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        periodLabel.textColor = theme.popupTitleTextColor
        tableView.reloadData()
    }
}
