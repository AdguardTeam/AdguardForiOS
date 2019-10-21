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

class SettingsController: UITableViewController {
    
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    
    @IBOutlet weak var wifiUpdateSwitch: UISwitch!
    @IBOutlet weak var invertedSwitch: UISwitch!
    @IBOutlet weak var developerModeSwitch: UISwitch!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var tableFooterView: UIView!
    
    @IBOutlet var themeButtons: [UIButton]!
    
    // Sections
    private let themeSection = 0
    private let otherSection = 1
    
    // Raws
    private let systemDefault = 0
    private let dark = 1
    private let light = 2
    
    private let wifiOnlyRow = 0
    private let invertWhitelistRow = 1
    private let developerModeRow = 2
    private let advancedSettingsRow = 3
    
    private var headersTitles: [String] = []
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }

        fillHeaderTitles()
        tableView.sectionHeaderHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        
        invertedSwitch.isOn = resources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
        
        let wifiOnlyObject = resources.sharedDefaults().object(forKey: AEDefaultsWifiOnlyUpdates) as? NSNumber
        let wifiOnly = wifiOnlyObject?.boolValue ?? true
        wifiUpdateSwitch.isOn = wifiOnly
        
        developerModeSwitch.isOn = configuration.developerMode
        
        setupBackButton()
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
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
            invertedSwitch.setOn(!invertedSwitch!.isOn, animated: true)
            toggleInverted(invertedSwitch)
        case (otherSection, developerModeRow):
            developerModeSwitch.setOn(!developerModeSwitch!.isOn, animated: true)
            developerModeAction(developerModeSwitch)
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
        change(senderSwitch: sender, forKey: AEDefaultsInvertedWhitelist)
    }
    
    @IBAction func developerModeAction(_ sender: UISwitch) {
        configuration.developerMode = sender.isOn
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
    
    @IBAction func resetAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: String.localizedString("confirm_reset_text"), preferredStyle: .alert)
        
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
        
        let height = calculateHeaderHeight(section: section)
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: height))
        view.backgroundColor = theme.backgroundColor
        
        let label = ThemableLabel(frame: CGRect(x: 24.0, y: height - 32, width: self.view.frame.width - 24.0, height: 24.0))
        label.greyText = true
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
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
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    // MARK: - private methods
    
    private func change(senderSwitch: UISwitch, forKey key: String) {
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
        
        let oldValue = resources.sharedDefaults().bool(forKey: key)
        let newValue = senderSwitch.isOn
        
        if oldValue != newValue {
            resources.sharedDefaults().set(newValue, forKey: key)
            
            contentBlockerService.reloadJsons(backgroundUpdate: false) { [weak self] (error) in
                if error != nil {
                    self?.resources.sharedDefaults().set(oldValue, forKey: key)
                    DispatchQueue.main.async {
                        senderSwitch.setOn(oldValue, animated: true)
                    }
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        }
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        tableFooterView.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        theme.setupSwitch(invertedSwitch)
        theme.setupSwitch(wifiUpdateSwitch)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
    }
    
    private func updateUI() {
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
        headersTitles.append(ACLocalizedString("theme_header_title", nil))
        headersTitles.append(ACLocalizedString("other_header_title", nil))
    }
    
    private func calculateHeaderHeight(section: Int) -> CGFloat{
        return (section == themeSection) ? 48.0 : 64.0
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
}
