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
import SafariAdGuardSDK

class SettingsController: UITableViewController {
    
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let statisticsService: DnsStatisticsServiceProtocol = ServiceLocator.shared.getService()!
    private let activityStatisticsService: ActivityStatisticsServiceProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    
    @IBOutlet weak var wifiUpdateSwitch: UISwitch!
    @IBOutlet weak var invertedSwitch: UISwitch!
    @IBOutlet weak var advancedModeSwitch: UISwitch!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    @IBOutlet var themeButtons: [UIButton]!
    
    // Sections
    private let titleSection = 0
    private let themeSection = 1
    private let otherSection = 2
    
    // Raws
    private let systemDefault = 0
    private let dark = 1
    private let light = 2
    
    private let wifiOnlyRow = 0
    private let invertWhitelistRow = 1
    private let advancedModeRow = 2
    private let advancedSettingsRow = 3
    private let resetStatisticsRow = 4
    private let resetSettingsRow = 5
    
    private var isBigScreen: Bool { traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular }
    
    private var headersTitles: [String] = []
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillHeaderTitles()
        tableView.sectionHeaderHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        
        let wifiOnlyObject = resources.sharedDefaults().object(forKey: AEDefaultsWifiOnlyUpdates) as? NSNumber
        let wifiOnly = wifiOnlyObject?.boolValue ?? true
        wifiUpdateSwitch.isOn = wifiOnly
        
        advancedModeSwitch.isOn = configuration.advancedMode
        
        let inverted = resources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
        invertedSwitch.isOn = inverted
        
        setupBackButton()
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch (indexPath.section, indexPath.row) {
        // Theme section
        case (themeSection, _):
            setTheme(withButtonTag: indexPath.row)
        
        // Other section
        case (otherSection, wifiOnlyRow):
            wifiUpdateSwitch.setOn(!wifiUpdateSwitch!.isOn, animated: true)
            toggleWifiOnly(wifiUpdateSwitch)
        case (otherSection, invertWhitelistRow):
            invertedSwitch.setOn(!invertedSwitch.isOn, animated: true)
            toggleInverted(invertedSwitch)
        case (otherSection, advancedModeRow):
            advancedModeSwitch.setOn(!advancedModeSwitch!.isOn, animated: true)
            advancedModeAction(advancedModeSwitch)
        case (otherSection, resetStatisticsRow):
            resetStatistics(indexPath)
        case (otherSection, resetSettingsRow):
            resetSettings(indexPath)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func toggleWifiOnly(_ sender: UISwitch) {
        resources.sharedDefaults().set(sender.isOn, forKey: AEDefaultsWifiOnlyUpdates)
    }
    
    @IBAction func toggleInverted(_ sender: UISwitch) {
        invertWhitelist()
    }
    
    @IBAction func advancedModeAction(_ sender: UISwitch) {
        configuration.advancedMode = sender.isOn
        if !sender.isOn {
           NotificationCenter.default.post(name: NSNotification.Name.HideStatusView, object: self)
        }
        tableView.reloadData()
    }
    
    @IBAction func systemDefaultTheme(_ sender: UIButton) {
        setTheme(withButtonTag: sender.tag)
    }
    
    @IBAction func darkTheme(_ sender: UIButton) {
        setTheme(withButtonTag: sender.tag)
    }
    
    @IBAction func lightTheme(_ sender: UIButton) {
        setTheme(withButtonTag: sender.tag)
    }
    
    private func resetStatistics(_ indexPath: IndexPath){
        let alert = UIAlertController(title: String.localizedString("reset_stat_title"), message: String.localizedString("reset_stat_descr"), preferredStyle: .deviceAlertStyle)
        
        let yesAction = UIAlertAction(title: String.localizedString("reset_title").uppercased(), style: .destructive) { [weak self] _ in
            alert.dismiss(animated: true, completion: nil)
            self?.statisticsService.deleteAllRecords()
            self?.activityStatisticsService.deleteAllRecords()
            NotificationCenter.default.post(name: NSNotification.resetStatistics, object: self)
        }
        
        alert.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }
    
    private func resetSettings(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: String.localizedString("confirm_reset_text"), preferredStyle: .deviceAlertStyle)
        
        let yesAction = UIAlertAction(title: String.localizedString("common_action_yes"), style: .destructive) { _ in
            alert.dismiss(animated: true, completion: nil)
            (UIApplication.shared.delegate as? AppDelegate)?.resetAllSettings()
        }
        
        alert.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }
    
    // MARK: - table view cells
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == titleSection { return UIView() }
        
        let padding: CGFloat = isBigScreen ? 24.0 : 16.0
        let font = UIFont.systemFont(ofSize: isBigScreen ? 30.0 : 20.0, weight: .medium)
        let labelHeight: CGFloat = isBigScreen ? 30.0 : 20.0
        
        let height = calculateHeaderHeight(section: section)
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: height))
        view.backgroundColor = theme.backgroundColor
        
        let label = ThemableLabel(frame: CGRect(x: padding, y: height - 32, width: self.view.frame.width - padding, height: labelHeight))
        label.greyText = true
        label.font = font
        label.text = headersTitles[section]
        label.textAlignment = .left
        theme.setupLabel(label)
        
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return calculateHeaderHeight(section: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == themeSection && indexPath.row == systemDefault {
            if #available(iOS 13.0, *){ } else {
                tableView.cellForRow(at: indexPath)?.isHidden = true
                return 0.0
            }
        }
        
        if !configuration.advancedMode && indexPath.section == otherSection && indexPath.row == advancedSettingsRow {
            tableView.cellForRow(at: indexPath)?.isHidden = true
            return 0.0
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    // MARK: - private methods
    
    private func updateUI() {
        themeButtons.forEach({ $0.isSelected = false })
        switch configuration.userThemeMode {
        case AESystemDefaultThemeMode:
            themeButtons[systemDefault].isSelected = true
        case AELightThemeMode:
            themeButtons[light].isSelected = true
        case AEDarkThemeMode:
            themeButtons[dark].isSelected = true
        default:
            themeButtons[light].isSelected = true
        }
    }
    
    private func fillHeaderTitles(){
        headersTitles.append("")
        headersTitles.append(ACLocalizedString("theme_header_title", nil))
        headersTitles.append(ACLocalizedString("other_header_title", nil))
    }
    
    private func calculateHeaderHeight(section: Int) -> CGFloat{
        switch section {
        case titleSection:
            return 0.0
        case themeSection:
            return 48.0
        case otherSection:
            return isBigScreen ? 96.0 : 64.0
        default:
            return 0.0
        }
    }
    
    private func setTheme(withButtonTag tag: Int){
        guard let button = themeButtons?.first(where: {$0.tag == tag}) else { return }
        themeButtons.forEach({$0.isSelected = false})
        button.isSelected = true
        switch tag {
        case systemDefault:
            configuration.userThemeMode = AESystemDefaultThemeMode
        case dark:
            configuration.userThemeMode = AEDarkThemeMode
        case light:
            configuration.userThemeMode = AELightThemeMode
        default:
            configuration.userThemeMode = AELightThemeMode
        }
        updateTheme()
    }
    
    private func invertWhitelist() {
        
        let oldValue = resources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
        let newValue = invertedSwitch.isOn
        
        if oldValue != newValue {
            resources.sharedDefaults().set(newValue, forKey: AEDefaultsInvertedWhitelist)
            
            safariProtection.update(allowlistIsInverted: newValue) { [weak self] error in
                if error != nil {
                    self?.resources.sharedDefaults().set(oldValue, forKey: AEDefaultsInvertedWhitelist)
                    DispatchQueue.main.async {
                        self?.invertedSwitch.setOn(oldValue, animated: true)
                    }
                }
            }
        }
    }
}

extension Notification.Name {
    static let resetStatistics = Notification.Name("resetStatistics")
    static let resetSettings = Notification.Name("resetSettings")
}

@objc extension NSNotification {
    public static let resetStatistics = Notification.Name.resetStatistics
    public static let resetSettings = Notification.Name.resetSettings
}

extension SettingsController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        theme.setupSwitch(wifiUpdateSwitch)
        theme.setupSwitch(invertedSwitch)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.updateUI()
        }
    }
}
