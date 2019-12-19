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
    
    var logBlockedCellColor: UIColor { get }
    var logSelectedCellColor: UIColor { get }
    
    var ruleTextColor: UIColor { get }
    
    func setupImage(_ imageView: ThemeableImageView)
    func setupLabel(_ label: ThemableLabel)
    func setupLabelInverted(_ label: ThemableLabel)
    func setupLabels(_ labels: [ThemableLabel])
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
        return configuration.darkTheme ? .black : .white
    }
    
    var invertedBackgroundColor: UIColor {
        return configuration.darkTheme ? .white : .black
    }
    
    var popupBackgroundColor: UIColor {
        return configuration.darkTheme ? UIColor(hexString: "#131313") : .white
    }
    
    var bottomBarBackgroundColor: UIColor {
        return configuration.darkTheme ? UIColor(hexString: "#131313") : UIColor(hexString: "#F3F3F3")
    }
    
    var blackTextColor: UIColor {
        return configuration.darkTheme ? .white : UIColor.init(hexString: "#222222")
    }
    
    var grayTextColor: UIColor {
        return configuration.darkTheme ? .white : UIColor.init(hexString: "#4A4A4A")
    }

    var lightGrayTextColor: UIColor {
        return configuration.darkTheme ? .white : UIColor.init(hexString: "#888888")
    }
    
    var placeholderTextColor: UIColor {
        return configuration.darkTheme ? UIColor.init(hexString: "#777777") : UIColor.init(hexString: "#DDDDDD")
    }
    
    var separatorColor: UIColor {
        return configuration.darkTheme ? UIColor(hexString: "4D4D4D") : UIColor(hexString: "D8D8D8")
    }
    
    var selectedCellColor: UIColor {
         return configuration.darkTheme ?  UIColor(hexString: "#0E1911") : UIColor.init(hexString: "#F3F3F3")
    }
    
    var errorRedColor: UIColor {
        return UIColor(hexString: "#df3812")
    }
    
    var editLineColor: UIColor {
        return configuration.darkTheme ? UIColor(hexString: "#4d4d4d") : UIColor(hexString: "#d8d8d8")
    }
    
    var editLineSelectedColor: UIColor {
        return configuration.darkTheme ? UIColor(hexString: "#d8d8d8") : UIColor(hexString: "#4d4d4d")
    }
    
    var logBlockedCellColor: UIColor {
        return UIColor(hexString: "#33DF3812")
    }
    
    var logSelectedCellColor: UIColor {
        return UIColor(hexString: "#4DDF3812")
    }
    
    var tabBarColor: UIColor {
        return configuration.darkTheme ? UIColor(hexString: "#1e1e1e") : .white
    }
    
    var ruleTextColor: UIColor {
        return configuration.darkTheme ? grayTextColor : UIColor.init(hexString: "#434343")
    }
    
    var navigationBarColor: UIColor {
        return configuration.darkTheme ? UIColor.white : UIColor(hexString: "4D4D4D")
    }
    
    var notificationWindowColor: UIColor {
        return configuration.darkTheme ? UIColor(hexString: "#4d4d4d") : UIColor(hexString: "#f3f3f3")
    }
    
    func setupTagButton(_ button: RoundRectButton) {
        button.customBackgroundColor = configuration.darkTheme ? UIColor.init(hexString: "#F3F3F3") : UIColor.init(hexString: "#4D4D4D")
        button.setTitleColor(configuration.darkTheme ? UIColor.init(hexString: "#4D4D4D") : UIColor.init(hexString: "#D8D8D8"), for: .normal)
    }
    
    func setupImage(_ imageView: ThemeableImageView) {
        imageView.image = configuration.darkTheme ? imageView.darkThemeImage : imageView.lightThemeImage
    }
    
    func setupLabel(_ label: ThemableLabel) {
        
        label.textColor = label.greyText ? grayTextColor : label.lightGreyText ? lightGrayTextColor : blackTextColor
    }
    
    func setupLabelInverted(_ label: ThemableLabel) {
        if configuration.darkTheme {
            label.textColor = UIColor.init(hexString: "#4A4A4A")
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
    
    func setupPopupLabel(_ label: ThemableLabel) {
        if configuration.darkTheme {
            label.textColor = label.greyText ? UIColor(hexString: "#888888") : UIColor(hexString: "#F3F3F3")
        }
        else {
            label.textColor = label.greyText ? UIColor(hexString: "#494949") : UIColor(hexString: "#888888")
        }
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
        navBar.barTintColor = dark ? .clear : .white
        navBar.barStyle = dark ? .black : .default
    }
    
    func setupSearchBar(_ searchBar: UISearchBar) {
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        textField?.textColor = configuration.darkTheme ? UIColor.init(hexString: "#F3F3F3") : UIColor.init(hexString: "#222222")
        searchBar.tintColor = configuration.darkTheme ? UIColor.init(hexString: "#F3F3F3") : UIColor.init(hexString: "#222222")
        
        searchBar.barTintColor = .clear
        textField?.backgroundColor = configuration.darkTheme ? UIColor.init(hexString: "#131313") : UIColor.init(hexString: "#F3F3F3")
        searchBar.backgroundImage = UIImage()
        searchBar.setImage(UIImage(named: "search-icon"), for: .search, state: .normal)
    }
    
    func statusbarStyle() -> UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            // (UIStatusBarStyle(rawValue: 3) - we use it instead of using .darkContent to prevent compile time error in xcode v. < 11.0
            // todo: we must remove this hack, when xcode 11 will be released
            return configuration.darkTheme ? .lightContent : (UIStatusBarStyle(rawValue: 3) ?? .default)
        } else {
            return configuration.darkTheme ? .lightContent : .default
        }
    }
    
    func setupTextField(_ textField: UITextField) {
        textField.textColor = configuration.darkTheme ? .white : .darkGray
        textField.keyboardAppearance = configuration.darkTheme ? .dark : .default
    }
    
    func setupTextView(_ textView: UITextView) {
        textView.textColor = configuration.darkTheme ? .white : .darkGray
        textView.keyboardAppearance = configuration.darkTheme ? .dark : .default
    }
    
    func setupTable(_ table: UITableView) {
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
        switchControl.onTintColor = UIColor(hexString: "#67b279")
        switchControl.layer.cornerRadius = switchControl.frame.height / 2
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
