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

protocol BackgroundFetchControllerDelegate: AnyObject {
    func periodSelected(period: BackgroundFetchUpdateInterval)
}

/// View controller for choosing background fetch interval
final class BackgroundFetchController: BottomAlertController {

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var tableView: ContentSizedTableView!

    // MARK: - Properties

    weak var delegate: BackgroundFetchControllerDelegate?
    private var selectedCell: BackgroundFetchUpdateInterval?


    // MARK: - Services

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTheme()
        selectedCell = resources.backgroundFetchUpdatePeriod
        setupTableView()
    }

    // MARK: - Private methods

    private func applySelectedOption(row: BackgroundFetchUpdateInterval) {
        AppDelegate.setBackgroundFetchInterval(row.interval)
        selectedCell = row
        resources.backgroundFetchUpdatePeriod = row
        delegate?.periodSelected(period: row)
    }

    private func setupTableView() {
        ExtendedRadioButtonCell.registerCell(forTableView: tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        titleLabel.text = String.localizedString("background_app_refresh_time_title")
    }
}

// MARK: - BackgroundFetchController + UITableViewDataSource

extension BackgroundFetchController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExtendedRadioButtonCell.reuseIdentifier, for: indexPath) as? ExtendedRadioButtonCell else { return UITableViewCell() }
        let row = BackgroundFetchUpdateInterval.allCases[indexPath.row]
        cell.delegate = self
        cell.titleString = row.title
        cell.radioButtonSelected = selectedCell == row
        cell.isArrowRightHidden = true
        cell.cellTag = indexPath.row
        cell.updateTheme(themeService: themeService)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BackgroundFetchUpdateInterval.allCases.count
    }
}

// MARK: - BackgroundFetchController + UITableViewDelegate

extension BackgroundFetchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = BackgroundFetchUpdateInterval.allCases[indexPath.row]
        applySelectedOption(row: row)
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension BackgroundFetchController: ExtendedRadioButtonCellDelegate {
    func radioButtonTapped(with tag: Int) {
        let row = BackgroundFetchUpdateInterval.allCases[tag]
        applySelectedOption(row: row)
        dismiss(animated: true)
    }
}

extension BackgroundFetchController: ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = themeService.popupBackgroundColor
        tableView.backgroundColor = themeService.popupBackgroundColor
        themeService.setupLabel(titleLabel)
        tableView.reloadData()
    }
}

extension BackgroundFetchUpdateInterval {
     var title: String {
        switch self {
        case .defaultPeriod: return String.localizedString("background_fetch_default_period")
        case .everyHour: return String.localizedString("background_fetch_hour_period")
        case .every3Hour: return String.localizedString("background_fetch_tree_hours_period")
        case .every12Hours: return String.localizedString("background_fetch_twelve_hours_period")
        case .every24Hours: return String.localizedString("background_fetch_twenty_four_hours_period")
        }
    }
}
