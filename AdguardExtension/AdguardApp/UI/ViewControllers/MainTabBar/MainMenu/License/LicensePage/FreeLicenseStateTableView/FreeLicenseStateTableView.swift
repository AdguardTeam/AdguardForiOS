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

import UIKit

protocol FreeLicenseStateTableViewProtocol: AnyObject {
    func updateSubscriptionInfo()
    func setLoading(_ isLoading: Bool)
}

/// This view is responsible for displaying info about in-purchase products, premium features and EULA and privacy
final class FreeLicenseStateTableView: UITableView, FreeLicenseStateTableViewProtocol {

    // MARK: - Private properties

    private let model: FreeLicenseStateTableViewModelProtocol
    private let themeService: ThemeServiceProtocol

    // MARK: - Public methods

    init(model: FreeLicenseStateTableViewModelProtocol, themeService: ThemeServiceProtocol) {
        self.model = model
        self.themeService = themeService
        super.init(frame: .zero, style: .plain)
        model.tableView = self
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("This initializer shouldn't be called")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTableHeaderView()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollection.onSizeClassChange(previousTraitCollection) {
            setBackgroundColor()
        }
    }

    func updateSubscriptionInfo() {
        reloadData()
    }

    func setLoading(_ isLoading: Bool) {
        let productChoiceIndexPath = IndexPath(row: 0, section: 0)
        if let cell = cellForRow(at: productChoiceIndexPath) as? LicenseProductChoiceCell {
            cell.setLoading(isLoading)
        }
    }

    func updateTheme() {
        setBackgroundColor()
        themeService.setupTable(self)
        if let header = tableHeaderView as? PremiumFeaturesPagingView {
            header.updateTheme()
        }
        reloadData()
    }

    // MARK: - Private methods

    private func initialize() {
        delegate = self
        dataSource = self

        let headerView = PremiumFeaturesPagingView()
        headerView.models = PremiumFeature.allCases.map { PremiumFeatureViewModel(icon: $0.icon, featureName: $0.localizedName, featureDescription: $0.localizedDescr) }
        tableHeaderView = headerView

        LicenseProductChoiceCell.registerCell(forTableView: self)
        LicenseSubscriptionTermsCell.registerCell(forTableView: self)

        separatorStyle = .none
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
    }

    private func setBackgroundColor() {
        if traitCollection.isIpadTraitCollection {
            backgroundColor = themeService.backgroundColor
        } else {
            backgroundColor = themeService.popupBackgroundColor
        }
    }
}

// MARK: - FreeLicenseStateTableView + UITableViewDataSource

extension FreeLicenseStateTableView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = LicenseProductChoiceCell.getCell(forTableView: tableView)
            cell.setTrialAvailability(model.trialIsAvailable)
            cell.setLoading(false)
            cell.setProductButtonTitle(model.selectedProductIsSubscription ? String.localizedString("upgrade_button_title") : String.localizedString("upgrade_lifetime_button_title"))
            cell.setTrialLabelTitle(model.getTrialDescriptionText())
            cell.setLicenseProduct(model.selectedProductPeriod, model.selectedProductPrice)
            cell.updateTheme(themeService)
            cell.delegate = model
            return cell
        case 1:
            let cell = LicenseSubscriptionTermsCell.getCell(forTableView: tableView)
            if let text = model.getSubscriptionsTermsText() {
                cell.setAttributedText(text)
            }
            cell.updateTheme(themeService)
            return cell
        default: return UITableViewCell()
        }
    }
}

// MARK: - FreeLicenseStateTableView + UITableViewDelegate

extension FreeLicenseStateTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
