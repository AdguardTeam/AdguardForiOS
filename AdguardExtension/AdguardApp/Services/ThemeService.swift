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

/**
 ThemeService - service is responsible for dark/light theme switching
 */

@objc protocol ThemeServiceProtocol : NSObjectProtocol {

    var backgroundColor: UIColor { get }
    var invertedBackgroundColor: UIColor { get }
    var popupBackgroundColor: UIColor { get }
    var popupTitleTextColor: UIColor { get }
    var bottomBarBackgroundColor: UIColor { get }
    var blackTextColor: UIColor { get }
    var lightGrayTextColor: UIColor { get }
    var placeholderTextColor: UIColor { get }
    var grayTextColor: UIColor { get }
    var separatorColor: UIColor { get }
    var selectedCellColor: UIColor { get }
    var errorRedColor: UIColor { get }
    var editLineColor: UIColor { get }
    var editLineSelectedColor: UIColor { get }
    var tabBarColor: UIColor { get }
    var navigationBarColor: UIColor { get }
    var notificationWindowColor: UIColor { get }
    var chartViewTextColor: UIColor { get }
    var logBlockedCellColor: UIColor { get }
    var logSelectedCellColor: UIColor { get }
    var ruleTextColor: UIColor { get }
    var textFieldTextColor: UIColor { get }
    
    var indicatorStyle: UIActivityIndicatorView.Style { get }
    
    func setupImage(_ imageView: ThemeableImageView)
    func setupLabel(_ label: ThemableLabel)
    func setupLabelInverted(_ label: ThemableLabel)
    func setupLabels(_ labels: [ThemableLabel])
    func setupButton(_ button: ThemableButton)
    func setupButtons(_ buttons: [ThemableButton])
    func setupButtonImage(_ button: ThemableButton)
    func setupButtonsImage(_ button: [ThemableButton])
    func setupPopupLabel(_ label: ThemableLabel)
    func setupPopupLabels(_ labels: [ThemableLabel])
    func setupPopupButton(_ button: RoundRectButton)
    func setupPopupButtons(_ buttons: [RoundRectButton])
    func setupNavigationBar(_ navBar: UINavigationBar?)
    func setupSearchBar(_ searchBar: UISearchBar)
    func setupTextField(_ textField: UITextField)
    func setupTextView(_ textView: UITextView)
    func setupTable(_ table: UITableView)
    func setupTableCell(_ cell: UITableViewCell)
    func setupLogTableCell(_ cell: UITableViewCell, blocked: Bool)
    func statusbarStyle()->UIStatusBarStyle
    func setupTagButton(_ button: RoundRectButton)
    func setubBarButtonItem(_ button: UIBarButtonItem)
    func setupSwitch(_ switch: UISwitch)
    func setupSegmentedControl(_ segmentedControl: UISegmentedControl)
    func setupSeparator(_ separator: UIView)
    func setupSeparators(_ separators: [UIView])
}

class ThemeService : NSObject, ThemeServiceProtocol {
    
    let configuration: ConfigurationServiceProtocol
    
    init(_ configuration: ConfigurationServiceProtocol) {
        self.configuration = configuration
        super.init()
    }
    
    var backgroundColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.darkBackground : .white
    }
    
    var invertedBackgroundColor: UIColor {
        return configuration.darkTheme ? .white : UIColor.AdGuardColor.darkBackground
    }
    
    var popupBackgroundColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.black1 : .white
    }
    
    var popupTitleTextColor: UIColor {
        return configuration.darkTheme ? .white : UIColor.AdGuardColor.lightGray2
    }
    
    var bottomBarBackgroundColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.darkBackground : UIColor.AdGuardColor.lightGray6
    }
    
    var blackTextColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.lightGray6 : UIColor.AdGuardColor.lightGray2
    }
    
    var grayTextColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.lightGray5 : UIColor.AdGuardColor.lightGray2
    }

    var lightGrayTextColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.lightGray4 : UIColor.AdGuardColor.lightGray3
    }
    
    var placeholderTextColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.lightGray2 : UIColor.AdGuardColor.lightGray5
    }
    
    var separatorColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.lightGray2 : UIColor.AdGuardColor.lightGray5
    }
    
    var selectedCellColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.lightGray1 : UIColor.AdGuardColor.lightGray6
    }
    
    var errorRedColor: UIColor {
        return UIColor.AdGuardColor.errorRedColor
    }
    
    var editLineColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.lightGray2 : UIColor.AdGuardColor.lightGray5
    }
    
    var editLineSelectedColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.lightGray5 : UIColor.AdGuardColor.lightGray2
    }
    
    var logBlockedCellColor: UIColor {
        return UIColor.AdGuardColor.logBlockedCellColor
    }
    
    var logSelectedCellColor: UIColor {
        return UIColor.AdGuardColor.logSelectedCellColor
    }
    
    var tabBarColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.darkBackground : .white
    }
    
    var ruleTextColor: UIColor {
        return configuration.darkTheme ? grayTextColor : UIColor.AdGuardColor.lightGray2
    }
    
    var navigationBarColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.lightGray6 : UIColor.AdGuardColor.lightGray2
    }
    
    var notificationWindowColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.lightGray2 : UIColor.AdGuardColor.lightGray6
    }
    
    var chartViewTextColor: UIColor {
        return configuration.darkTheme ? UIColor.AdGuardColor.lightGray2 : UIColor.AdGuardColor.lightGray5
    }
    
    var indicatorStyle: UIActivityIndicatorView.Style {
        return configuration.darkTheme ? UIActivityIndicatorView.Style.white : .gray
    }
    
    var textFieldTextColor: UIColor {
        return configuration.darkTheme ? .white : .darkGray
    }
    
    func setupTagButton(_ button: RoundRectButton) {
        button.customBackgroundColor = configuration.darkTheme ? UIColor.AdGuardColor.lightGray6  : UIColor.AdGuardColor.lightGray2
        button.setTitleColor(configuration.darkTheme ? UIColor.AdGuardColor.lightGray2 : UIColor.AdGuardColor.lightGray5, for: .normal)
    }
    
    func setupImage(_ imageView: ThemeableImageView) {
        imageView.image = configuration.darkTheme ? imageView.darkThemeImage : imageView.lightThemeImage
    }
    
    func setupLabel(_ label: ThemableLabel) {
        label.textColor = label.greyText ? grayTextColor : label.lightGreyText ? lightGrayTextColor : blackTextColor
    }
    
    func setupLabelInverted(_ label: ThemableLabel) {
        if configuration.darkTheme {
            label.textColor = UIColor.AdGuardColor.lightGray8
        }
        else {
            label.textColor = .white
        }
    }
    
    func setupLabels(_ labels: [ThemableLabel]) {
        for label in labels {
            setupLabel(label)
        }
    }
    
    func setupButton(_ button: ThemableButton) {
        let color = button.greyText ? grayTextColor : button.lightGreyText ? lightGrayTextColor : blackTextColor
        button.setTitleColor(color, for: .normal)
    }
    
    func setupButtons(_ buttons: [ThemableButton]) {
        buttons.forEach({ setupButton($0) })
    }
    
    func setupButtonImage(_ button: ThemableButton) {
        let image = configuration.darkTheme ? button.darkThemeImage : button.lightThemeImage
        button.setImage(image, for: .normal)
    }
    
    func setupButtonsImage(_ buttons: [ThemableButton]) {
        buttons.forEach({ setupButtonImage($0) })
    }
    
    func setupPopupLabel(_ label: ThemableLabel) {
        label.textColor = label.greyText ? grayTextColor : label.lightGreyText ? lightGrayTextColor : blackTextColor
    }
    
    func setupPopupLabels(_ labels: [ThemableLabel]) {
        for label in labels {
            setupPopupLabel(label)
        }
    }
    
    func setupPopupButton(_ button: RoundRectButton) {
        let color = configuration.darkTheme ? lightGrayTextColor : lightGrayTextColor
        button.setTitleColor(color, for: .normal)
        button.customHighlightedBackgroundColor = selectedCellColor
    }
    
    func setupPopupButtons(_ buttons: [RoundRectButton]) {
        for button in buttons {
            setupPopupButton(button)
        }
    }

    func setupNavigationBar(_ navBarOrNil: UINavigationBar?) {
        guard let navBar = navBarOrNil else { return }
        let dark = configuration.darkTheme
        let textAttributes = [NSAttributedString.Key.foregroundColor: navigationBarColor]
        navBar.titleTextAttributes = textAttributes
        navBar.barTintColor = backgroundColor
        navBar.tintColor = UIColor.AdGuardColor.lightGray3
        navBar.barStyle = dark ? .black : .default
    }
    
    func setupSearchBar(_ searchBar: UISearchBar) {
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        let textFieldColor = configuration.darkTheme ? UIColor.AdGuardColor.lightGray6 : UIColor.AdGuardColor.black2
        
        textField?.textColor = textFieldColor
        searchBar.tintColor = textFieldColor
        
        if let iconView = textField?.leftView as? UIImageView {
            iconView.tintColor = textFieldColor
        }
        
        textField?.keyboardAppearance = configuration.darkTheme ? .dark : .light
        
        if let iconView = textField?.leftView as? UIImageView {
            iconView.tintColor = configuration.darkTheme ? UIColor.AdGuardColor.lightGray6 : UIColor.AdGuardColor.black2
        }
        
        textField?.keyboardAppearance = configuration.darkTheme ? .dark : .light
        
        searchBar.barTintColor = .clear
        textField?.backgroundColor = notificationWindowColor
        searchBar.backgroundImage = UIImage()
    }
    
    func statusbarStyle() -> UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return configuration.darkTheme ? .lightContent : .darkContent
        } else {
            return configuration.darkTheme ? .lightContent : .default
        }
    }
    
    func setupTextField(_ textField: UITextField) {
        let placeHolderText = textField.placeholder ?? ""
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderText,
        attributes: [NSAttributedString.Key.foregroundColor: placeholderTextColor])
        
        textField.textColor = textFieldTextColor
        textField.keyboardAppearance = configuration.darkTheme ? .dark : .light
    }
    
    func setupTextView(_ textView: UITextView) {
        textView.textColor = configuration.darkTheme ? .white : .darkGray
        textView.keyboardAppearance = configuration.darkTheme ? .dark : .light
    }
    
    func setupTable(_ table: UITableView) {
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0.0
        }
        table.separatorColor = separatorColor
        table.tableFooterView?.backgroundColor = backgroundColor
    }
    
    func setupTableCell(_ cell: UITableViewCell) {
        let bgColorView = UIView()
        bgColorView.backgroundColor = selectedCellColor
        cell.selectedBackgroundView = bgColorView
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
    }
    
    func setupLogTableCell(_ cell: UITableViewCell, blocked: Bool) {
        if (!blocked) {
            setupTableCell(cell)
            return
        }

        let bgColorView = UIView()
        bgColorView.backgroundColor = logSelectedCellColor
        cell.selectedBackgroundView = bgColorView
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = logBlockedCellColor
    }
    
    func textColor() -> UIColor {
        return .darkGray
    }
    
    func textColorDarkMode() -> UIColor {
        return .white
    }
    
    func setubBarButtonItem(_ button: UIBarButtonItem) {
        button.tintColor = configuration.darkTheme ? .white : .darkGray
    }
    
    func setupSwitch(_ switchControl: UISwitch) {
        switchControl.onTintColor = UIColor.AdGuardColor.lightGreen1
        switchControl.layer.cornerRadius = switchControl.frame.height / 2
    }
    
    func setupSegmentedControl(_ segmentedControl: UISegmentedControl) {
        segmentedControl.backgroundColor = notificationWindowColor
        let textColor = configuration.darkTheme ? UIColor.AdGuardColor.lightGray6 : UIColor.AdGuardColor.black2
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor], for: .normal)
        segmentedControl.tintColor = textColor
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = backgroundColor
        }
    }
    
    func setupSeparator(_ separator: UIView) {
        separator.backgroundColor = separatorColor
    }
    
    func setupSeparators(_ separators: [UIView]) {
        for separator in separators {
            setupSeparator(separator)
        }
    }

}
