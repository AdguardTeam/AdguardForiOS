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

import Foundation

class NetworkSettingsTitleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: ThemableLabel!
}

class FilterDataCell: UITableViewCell {

    @IBOutlet weak var filterDataImage: UIImageView!
    @IBOutlet weak var filterDataName: ThemableLabel!
    @IBOutlet weak var filterDataDescription: ThemableLabel!
    @IBOutlet weak var filterDataSwitch: UISwitch!
    @IBOutlet weak var separator: UIView!

    /* Rows */
    private let mobileDataRow = 0
    private let wifiDataRow = 1

    var theme: ThemeServiceProtocol? {
        didSet{
            updateTheme()
        }
    }

    var filterDataTag: Int? {
        didSet {
            let tag: Int = filterDataTag ?? mobileDataRow
            if tag == mobileDataRow {
                setupMobileData()
            } else {
                setupWifiData()
            }
        }
    }

    var enabled: Bool? {
        didSet {
            let state = enabled ?? false
            filterDataSwitch.isOn = state
        }
    }

    private func updateTheme(){
        theme?.setupLabel(filterDataName)
        theme?.setupLabel(filterDataDescription)
        theme?.setupSwitch(filterDataSwitch)
        theme?.setupTableCell(self)
        separator.backgroundColor = theme?.separatorColor
    }

    private func setupMobileData(){
        let title = String.localizedString("filter_mobile_title")
        let description = String.localizedString("mobile_data_description")
        let image = UIImage(named: "mobiledata") ?? UIImage()

        filterDataImage.image = image
        filterDataName.text = title
        filterDataDescription.text = description
    }

    private func setupWifiData(){
        let title = String.localizedString("filter_wifi_title")
        let description = String.localizedString("wifi_data_description")
        let image = UIImage(named: "wi-fi") ?? UIImage()

        filterDataImage.image = image
        filterDataName.text = title
        filterDataDescription.text = description

        separator.isHidden = true
    }
}

class NetworkSettingsDescriptionCell: UITableViewCell {

    @IBOutlet weak var descriptionTopLabel: ThemableLabel!
    @IBOutlet weak var descriptionBottomLabel: ThemableLabel!


    var theme: ThemeServiceProtocol? {
        didSet{
            updateTheme()
        }
    }

    var wifiExceptionsTitle: String? {
        didSet {
            descriptionTopLabel.text = wifiExceptionsTitle
        }
    }

    var wifiExceptionsDescription: String? {
        didSet {
            descriptionBottomLabel.text = wifiExceptionsDescription
        }
    }

    private func updateTheme(){
        theme?.setupLabel(descriptionTopLabel)
        theme?.setupLabel(descriptionBottomLabel)
        theme?.setupTableCell(self)
    }
}
