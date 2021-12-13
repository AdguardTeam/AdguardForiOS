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
import SharedAdGuardSDK
import SafariAdGuardSDK
import DnsAdGuardSDK

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
    @IBOutlet var cancelFromSearchButton: UIBarButtonItem!

    // MARK: - Internal properties

    var rulesType: UserRuleType = .blocklist

    // MARK: - Private properties

    private var editButton: UIBarButtonItem {
        return generateBarButtonItem()
    }

    // MARK: - Private properties

    private let openEditorSegueId = "openEditorSegueId"

    /* Headers */
    private lazy var titleHeader: ExtendedTitleTableHeaderView = {
        ExtendedTitleTableHeaderView(title: model.title, htmlDescription: model.description)
    }()
    private let searchHeader = AGSearchView()

    /* Services */
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    private let dnsProtection: DnsProtectionProtocol = ServiceLocator.shared.getService()!
    private let sharedResources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let dnsConfigAssistant: DnsConfigManagerAssistantProtocol = ServiceLocator.shared.getService()!
    private let fileShareHelper = FileShareHelper()
    private var model: UserRulesTableModelProtocol!

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationItem.rightBarButtonItems = [editButton, searchButton]
        setupBackButton()
        updateTheme()
        searchHeader.delegate = self
        setupToHideKeyboardOnTapOnView(ignoringViews: [])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let nav = navigationController as? MainNavigationController {
            nav.currentSwipeRecognizer?.delegate = self
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let nav = navigationController as? MainNavigationController {
            nav.currentSwipeRecognizer?.delegate = nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == openEditorSegueId, let userRulesEditorVC = segue.destination as? UserRulesEditorController {
            userRulesEditorVC.model = model
        }
    }

    // MARK: - Actions

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let paths = tableView.indexPathsForSelectedRows, !paths.isEmpty else {
            return
        }
        let selectedRules = paths.map { model.rulesModels[$0.row].rule }
        model.remove(rules: selectedRules, for: paths)
        goToNormalMode()
    }

    @IBAction func enableButtonTapped(_ sender: UIButton) {
        guard let paths = tableView.indexPathsForSelectedRows, !paths.isEmpty else {
            return
        }
        let selectedRules = paths.map { model.rulesModels[$0.row].rule }
        model.turn(rules: selectedRules, for: paths, on: true)
        goToNormalMode()
    }

    @IBAction func disableButtonTapped(_ sender: UIButton) {
        guard let paths = tableView.indexPathsForSelectedRows, !paths.isEmpty else {
            return
        }
        let selectedRules = paths.map { model.rulesModels[$0.row].rule }
        model.turn(rules: selectedRules, for: paths, on: false)
        goToNormalMode()
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        goToNormalMode()
    }

    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        goToSearchMode()
    }

    @IBAction func cancelFromSearchTapped(_ sender: UIBarButtonItem) {
        goToNormalMode()
    }

    // MARK: - Private methods

    private func setupTableView() {
        switch rulesType {
        case .blocklist:
            model = SafariUserRulesTableModel(type: .blocklist, safariProtection: safariProtection, resources: sharedResources, fileShareHelper: fileShareHelper)
        case .allowlist:
            model = SafariUserRulesTableModel(type: .allowlist, safariProtection: safariProtection, resources: sharedResources, fileShareHelper: fileShareHelper)
        case .invertedAllowlist:
            model = SafariUserRulesTableModel(type: .invertedAllowlist, safariProtection: safariProtection, resources: sharedResources, fileShareHelper: fileShareHelper)
        case .dnsBlocklist:
            model = DnsUserRulesTableModel(type: .blocklist, dnsProtection: dnsProtection, resources: sharedResources, fileShareHelper: fileShareHelper, dnsConfigAssistant: dnsConfigAssistant)
        case .dnsAllowlist:
            model = DnsUserRulesTableModel(type: .allowlist, dnsProtection: dnsProtection, resources: sharedResources, fileShareHelper: fileShareHelper, dnsConfigAssistant: dnsConfigAssistant)
        }
        model.delegate = self

        tableView.backgroundColor = .clear
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        tableView.tableHeaderView = titleHeader
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = 0.01
        tableView.estimatedRowHeight = 48.0
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
            tableView.fillerRowHeight = 0.0
        }

        AddTableViewCell.registerCell(forTableView: tableView)
        UserRuleTableViewCell.registerCell(forTableView: tableView)
    }

    private final func presentAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .deviceAlertStyle)

        let selectAction = UIAlertAction(title: String.localizedString("common_select"), style: .default) { [weak self] _ in
            self?.select()
        }
        alert.addAction(selectAction)

        let openEditorAction = UIAlertAction(title: String.localizedString("open_user_rules_editor"), style: .default) { [weak self] _ in
            self?.openEditor()
        }
        alert.addAction(openEditorAction)

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
        let selectAction = UIAction(title: String.localizedString("common_select"), image: UIImage(systemName: "checkmark.circle")) { [weak self] _ in
            self?.select()
        }
        let openEditorAction = UIAction(title: String.localizedString("open_user_rules_editor"), image: UIImage(systemName: "pencil.circle")) { [weak self] _ in
            self?.openEditor()
        }
        let importAction = UIAction(title: String.localizedString("import"), image: UIImage(systemName: "square.and.arrow.down")) { [weak self] _ in
            self?.importRules()
        }
        let exportAction = UIAction(title: String.localizedString("export"), image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
            self?.exportRules()
        }

        let menu = UIMenu(children: [selectAction, openEditorAction, importAction, exportAction])
        return menu
    }

    private func select() {
        goToEditingMode()
    }

    private func openEditor() {
        performSegue(withIdentifier: openEditorSegueId, sender: self)
    }

    private func importRules() {
        model.importFile(for: self) { [weak self] error in
            if error != nil {
                self?.showUnknownErrorAlert()
            }
        }
    }

    private func exportRules() {
        model.exportFile(for: self)
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
        present(controller, animated: true)
    }

    private func presentDetailsController(rule: UserRule, indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "UserFilter", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "RuleDetailsController") as? RuleDetailsController else { return }

        let type: RulesType
        switch rulesType {
        case .blocklist: type = .safariUserfilter
        case .allowlist: type = .safariWhitelist
        case .invertedAllowlist: type = .invertedSafariWhitelist
        case .dnsBlocklist: type = .systemBlacklist
        case .dnsAllowlist: type = .systemWhitelist
        }

        let context = RuleDetailsController.Context(
            rule: rule,
            ruleIndexPath: indexPath,
            delegate: model,
            ruleType: type
        )
        controller.context = context
        present(controller, animated: true)
    }

    private func goToSearchMode() {
        model.isSearching = true
        navigationItem.rightBarButtonItems = model.isEditing ? [cancelFromSearchButton] : [editButton, cancelFromSearchButton]
        navigationItem.leftBarButtonItem = nil
        navigationItem.setHidesBackButton(true, animated: true)
        tableView.tableHeaderView = searchHeader
        searchHeader.textField.returnKeyType = .search
        searchHeader.textField.borderState = .enabled
        searchHeader.textField.becomeFirstResponder()
        tableView.reloadWithSelectedRows()
    }

    private func goToEditingMode() {
        model.isEditing = true
        buttonsStackView.isHidden = false
        UIView.animate(withDuration: 0.2) { [unowned self] in
            buttonsStackView.alpha = 1.0
            stackViewHeightConstraint.constant = 40.0
            view.layoutIfNeeded()
        }
        navigationItem.rightBarButtonItems = model.isSearching ? [cancelFromSearchButton] : [cancelFromSearchButton, searchButton]
        tableView.reloadWithSelectedRows()
    }

    private func goToNormalMode() {
        model.isEditing = false
        model.isSearching = false
        searchHeader.textField.text = nil
        model.searchString = nil
        model.deselectAll()

        UIView.animate(withDuration: 0.2) { [unowned self] in
            buttonsStackView.alpha = 0.0
            stackViewHeightConstraint.constant = 0.0
            view.layoutIfNeeded()
        } completion: { [unowned self] _ in
            buttonsStackView.isHidden = true
        }
        navigationItem.rightBarButtonItems = [editButton, searchButton]
        navigationItem.setHidesBackButton(false, animated: true)
        setupBackButton()
        tableView.reloadData()
        tableView.tableHeaderView = titleHeader
        view.endEditing(true)
    }

    private func model(for row: Int) -> UserRuleCellModel {
        if model.isEditing || model.isSearching {
            return model.rulesModels[row]
        } else {
            return model.rulesModels[row - 1]
        }
    }

    @objc
    private final func editButtonTapped(_ sender: UIBarButtonItem) {
        presentAlert()
    }

    @objc
    private final func editButtonTappedForSelection(_ sender: UIBarButtonItem) {
        select()
    }

    private func generateBarButtonItem() -> UIBarButtonItem {
        let image = UIImage(named: "edit")

        if model.isSearching {
            return UIBarButtonItem(image: image, style: .done, target: self, action: #selector(editButtonTappedForSelection(_:)))
        } else if #available(iOS 14.0, *) {
            let menu = createMenu()
            return UIBarButtonItem(image: image, menu: menu)
        } else {
            return UIBarButtonItem(image: image, style: .done, target: self, action: #selector(editButtonTapped(_:)))
        }
    }
}

// MARK: - UserRulesTableController + UITableViewDatasource

extension UserRulesTableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if model.isEditing || model.isSearching {
            return UIView()
        }
        let isEnabled = model.isEnabled
        let model = StateHeaderViewModel(iconImage: model.icon, title: isEnabled.localizedStateDescription, isEnabled: isEnabled, id: isEnabled)
        let view =  StateHeaderView<Bool>(frame: .zero)
        view.config = IdentifiableViewConfig(model: model, delegate: self)
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if model.isEditing || model.isSearching {
            return 0.01
        }
        return UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.isEditing || model.isSearching ? model.rulesModels.count : model.rulesModels.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && !model.isEditing && !model.isSearching {
            let cell = AddTableViewCell.getCell(forTableView: tableView)
            cell.addTitle = String.localizedString("add_new_rule")
            cell.updateTheme(themeService)
            return cell
        } else {
            let cell = UserRuleTableViewCell.getCell(forTableView: tableView)
            cell.model = model(for: indexPath.row)
            cell.delegate = model
            cell.updateTheme(themeService)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //indexPath.row == 0 - it is "Add new rule cell"
        return (model.isEditing || model.isSearching) ? true : indexPath.row > 0
    }
}

// MARK: - UserRulesTableController + UITableViewDelegate

extension UserRulesTableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if model.isEditing, let cell = tableView.cellForRow(at: indexPath) as? UserRuleTableViewCell {
            model.setRule(cell.model.rule, selected: true)
            cell.model.isSelected = true
            cell.setSelected(true, animated: false)
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if model.isEditing, let cell = tableView.cellForRow(at: indexPath) as? UserRuleTableViewCell {
            model.setRule(cell.model.rule, selected: false)
            cell.model.isSelected = false
            cell.setSelected(false, animated: false)
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && !model.isEditing && !model.isSearching {
            presentAddRuleController()
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }

        if !model.isEditing {
            let ruleModel = model(for: indexPath.row)
            let userRule = UserRule(ruleText: ruleModel.rule, isEnabled: ruleModel.isEnabled)
            presentDetailsController(rule: userRule, indexPath: indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let title = String.localizedString("delete_title").capitalized
        let deleteAction = UIContextualAction(style: .destructive, title: title) { [weak self] (_, _, success: (Bool) -> Void) in
            guard let self = self else { success(false); return }
            let selectedRule = self.model(for: indexPath.row).rule

            self.model.remove(rules: [selectedRule], for: [indexPath])
            success(true)
        }
        deleteAction.backgroundColor = UIColor.AdGuardColor.red
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionConfig
    }
}

// MARK: - UserRulesTableController + UserRulesTableModelDelegate

extension UserRulesTableController: UserRulesTableModelDelegate {
    func rulesChanged() {
        tableView.reloadWithSelectedRows()
    }

    func rulesChanged(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }

    func rulesRemoved(at indexPaths: [IndexPath]) {
        tableView.deleteRows(at: indexPaths, with: .left)
    }

    func ruleSuccessfullyAdded() {
        tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
    }
}

// MARK: - UserRulesTableController + ThemableProtocol

extension UserRulesTableController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        buttonsStackView.backgroundColor = themeService.notificationWindowColor
        themeService.setupTable(tableView)
        deleteButton.setTitleColor(UIColor.AdGuardColor.red, for: .normal)
        deleteButton.tintColor = UIColor.AdGuardColor.red
        enableButton.setTitleColor(themeService.grayTextColor, for: .normal)
        enableButton.tintColor = themeService.grayTextColor
        disableButton.setTitleColor(themeService.grayTextColor, for: .normal)
        disableButton.tintColor = themeService.grayTextColor
        cancelButton.setTitleColor(themeService.lightGrayTextColor, for: .normal)
        cancelButton.tintColor = themeService.lightGrayTextColor
        tableView.reloadWithSelectedRows()
        searchHeader.updateTheme()
    }
}

// MARK: - UserRulesTableController + AGSearchViewDelegate

extension UserRulesTableController: AGSearchViewDelegate {
    func textChanged(to newText: String) {
        model.searchString = newText
    }
}

// MARK: - UserRulesTableController + IdentifiableObjectDelegate

extension UserRulesTableController: IdentifiableObjectDelegate {
    func modelChanged<Model: IdentifiableObject>(_ newModel: Model) {
        guard let changedModel = newModel as? StateHeaderViewModel<Bool> else {
            return
        }
        model.isEnabled = changedModel.isEnabled
    }
}

// MARK: - UITableView + Helper method

fileprivate extension UITableView {
    func reloadWithSelectedRows() {
        guard let paths = indexPathsForSelectedRows, !paths.isEmpty else {
            reloadData()
            return
        }

        reloadData()
        paths.forEach { selectRow(at: $0, animated: false, scrollPosition: .none) }
    }
}

// MARK: - UserRulesTableController + UIGestureRecognizerDelegate

extension UserRulesTableController: UIGestureRecognizerDelegate {

    /**
     This method is needed to avoid collisions between table view swipe gesture and navigation controller swipes
     */
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }

        let translation = panGesture.translation(in: tableView)
        return translation.x > 0
    }
}
