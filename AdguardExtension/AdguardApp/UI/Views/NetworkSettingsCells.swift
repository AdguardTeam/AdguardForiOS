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
        let title = ACLocalizedString("filter_mobile_title", nil)
        let description = ACLocalizedString("mobile_data_description", nil)
        let image = UIImage(named: "mobiledata") ?? UIImage()
        
        filterDataImage.image = image
        filterDataName.text = title
        filterDataDescription.text = description
    }
    
    private func setupWifiData(){
        let title = ACLocalizedString("filter_wifi_title", nil)
        let description = ACLocalizedString("wifi_data_description", nil)
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

class AddExceptionCell: UITableViewCell {
    
    @IBOutlet weak var addExceptionLabel: UILabel!
    
    var theme: ThemeServiceProtocol? {
        didSet{
           updateTheme()
        }
    }
    
    var exceptionLabelTitle: String? {
        didSet {
            addExceptionLabel.text = exceptionLabelTitle
        }
    }
    
    private func updateTheme(){
        theme?.setupTableCell(self)
    }
}

class WifiExceptionsCell: UITableViewCell {
    
    @IBOutlet weak var wifiExceptionNameLabel: ThemableLabel!
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var exceptionStateButton: UIButton!
    @IBOutlet weak var sepator: UIView!
    
    private let enabledImage: UIImage = UIImage(named: "logocheck") ?? UIImage()
    private let disabledImage: UIImage = UIImage(named: "cross") ?? UIImage()
    
    var theme: ThemeServiceProtocol? {
        didSet{
            updateTheme()
        }
    }
    
    var exceptionName: String? {
        didSet {
            wifiExceptionNameLabel.text = exceptionName
        }
    }
    
    var enabled: Bool? {
        didSet{
            let safeEnabled: Bool = enabled ?? false
            stateImage.image = safeEnabled ? enabledImage : disabledImage
        }
    }
    
    private func updateTheme(){
        theme?.setupLabel(wifiExceptionNameLabel)
        theme?.setupTableCell(self)
        sepator.backgroundColor = theme?.separatorColor
    }
}
