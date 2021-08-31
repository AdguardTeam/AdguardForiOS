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

import UIKit
import SafariAdGuardSDK

final class UserRulesTableController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var enableButton: UIButton!
    @IBOutlet weak var disableButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    
    // MARK: - Internal properties
    
    var rulesType: UserRuleType = .blocklist
    
    // MARK: - Private properties
    
    /* Services */
    private var themeObserver: NotificationToken?
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    private let sharedResources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private var model: UserRulesTableModelProtocol!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [editButton, searchButton]
        setupTableView()
        setupBackButton()
        updateTheme()
        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }
    
    // MARK: - Actions
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func enableButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func disableButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        presentAlert()
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        switch rulesType {
        case .blocklist:
            model = SafariUserRulesTableModel(type: .blocklist, safariProtection: safariProtection, resources: sharedResources)
        case .allowlist:
            model = SafariUserRulesTableModel(type: .allowlist, safariProtection: safariProtection, resources: sharedResources)
        case .invertedAllowlist:
            model = SafariUserRulesTableModel(type: .invertedAllowlist, safariProtection: safariProtection, resources: sharedResources)
        case .dnsBlocklist:
            return
        case .dnsAllowlist:
            return
        }
        model.delegate = self
        
        tableView.backgroundColor = .clear
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        tableView.tableHeaderView = ExtendedTitleTableHeaderView(title: model.title, htmlDescription: model.description)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 84.0
        tableView.sectionFooterHeight = 0.01
        tableView.estimatedRowHeight = 48.0
        tableView.rowHeight = UITableView.automaticDimension
        
        AddTableViewCell.registerCell(forTableView: tableView)
        UserRuleTableViewCell.registerCell(forTableView: tableView)
    }
    
    private final func presentAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .deviceAlertStyle)
        
        let selectAction = UIAlertAction(title: String.localizedString("common_select"), style: .default) { [weak self] _ in
            self?.select()
        }
        alert.addAction(selectAction)
        
        let importAction = UIAlertAction(title: String.localizedString("import"), style: .default) { [weak self] _ in
            self?.importRules()
        }
        alert.addAction(importAction)
        
        let exportAction = UIAlertAction(title: String.localizedString("export"), style: .default) { [weak self] _ in
            self?.exportRules()
        }
        alert.addAction(exportAction)
        
        let cancelAction = UIAlertAction(title: String.localizedString("cancel_button_title"), style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @available(iOS 14.0, *)
    private func createMenu() -> UIMenu {
        let selectAction = UIAction(title: String.localizedString("common_select"), image: UIImage(systemName: "checkmark.circle")) { [weak self] a in
            print(a)
            self?.select()
        }
        let importAction = UIAction(title: String.localizedString("import"), image: UIImage(systemName: "square.and.arrow.down")) { [weak self] _ in
            self?.importRules()
        }
        let exportAction = UIAction(title: String.localizedString("export"), image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
            self?.exportRules()
        }
        
        let menu = UIMenu(children: [selectAction, importAction, exportAction])
        return menu
    }
    
    private func select() {
        
    }
    
    private func importRules() {
        
    }
    
    private func exportRules() {
        
    }
    
    private func presentAddRuleController() {
        let storyboard = UIStoryboard(name: "UserFilter", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "AddRuleController") as? AddRuleController else { return }
        controller.delegate = model
        switch rulesType {
        case .blocklist: controller.type = .safariUserfilter
        case .allowlist: controller.type = .safariWhitelist
        case .invertedAllowlist: controller.type = .invertedSafariWhitelist
        case .dnsBlocklist: controller.type = .systemBlacklist
        case .dnsAllowlist: controller.type = .systemWhitelist
        }
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - UserRulesTableController + UITableViewDatasource

extension UserRulesTableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let isEnabled = model.isEnabled
        let model = StateHeaderViewModel(iconImage: model.icon, title: isEnabled.localizedStateDescription, isEnabled: isEnabled, id: isEnabled)
        let view =  StateHeaderView<Bool>(frame: .zero)
        view.config = IdentifiableViewConfig(model: model, delegate: self)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.rulesModels.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = AddTableViewCell.getCell(forTableView: tableView)
            cell.addTitle = String.localizedString("add_new_rule")
            cell.updateTheme(themeService)
            return cell
        } else {
            let cell = UserRuleTableViewCell.getCell(forTableView: tableView)
            cell.model = model.rulesModels[indexPath.row - 1]
            cell.delegate = model
            cell.updateTheme(themeService)
            return cell
        }
    }
}

// MARK: - UserRulesTableController + UITableViewDelegate

extension UserRulesTableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            presentAddRuleController()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UserRulesTableController + UserRulesTableModelDelegate

extension UserRulesTableController: UserRulesTableModelDelegate {
    func ruleSuccessfullyAdded() {
        tableView.insertRows(at: [IndexPath(row: model.rulesModels.count, section: 0)], with: .left)
    }
}

// MARK: - UserRulesTableController + ThemableProtocol

extension UserRulesTableController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        buttonsStackView.backgroundColor = themeService.notificationWindowColor
        themeService.setupTable(tableView)
        tableView.reloadData()
    }
}

// MARK: - UserRulesTableController + IdentifiableObjectDelegate

extension UserRulesTableController: IdentifiableObjectDelegate {
    func modelChanged<Model: IdentifiableObject>(_ newModel: Model) {
        guard let newModel = newModel as? StateHeaderViewModel<Bool> else { return }
        model.isEnabled = newModel.isEnabled
    }
}
