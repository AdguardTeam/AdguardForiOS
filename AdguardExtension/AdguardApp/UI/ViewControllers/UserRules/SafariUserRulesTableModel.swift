///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import SharedAdGuardSDK
import SafariAdGuardSDK

final class SafariUserRulesTableModel: UserRulesTableModelProtocol {

    // MARK: - Internal properties

    weak var delegate: UserRulesTableModelDelegate?

    var editorTitle: String { title }

    var editorDescription: String { type.editorDescription }

    var userRulesString: String { rulesModels.map { $0.rule }.joined(separator: "\n") }

    var title: String { type.title }

    var description: String { type.description }

    var isEnabled: Bool {
        get {
            switch type {
            case .blocklist: return resources.safariUserFilterEnabled
            case .allowlist, .invertedAllowlist: return resources.safariWhitelistEnabled
            }
        }
        set {
            switch type {
            case .blocklist:
                resources.safariUserFilterEnabled = newValue
                safariProtection.update(blocklistIsEnabled: newValue, onCbReloaded: nil)
            case .allowlist, .invertedAllowlist:
                resources.safariWhitelistEnabled = newValue
                safariProtection.update(allowlistIsEnabled: newValue, onCbReloaded: nil)
            }
        }
    }

    var isEditing: Bool = false {
        didSet {
            guard isEditing != oldValue else { return }
            modelProvider.setEditing(isEditing)
        }
    }

    var isSearching: Bool = false

    var icon: UIImage? { type.icon }

    var searchString: String? {
        didSet {
            modelProvider.searchString = searchString
            delegate?.rulesChanged()
        }
    }

    var rulesModels: [UserRuleCellModel] { modelProvider.rules }

    // MARK: - Private properties

    private let type: SafariUserRuleType
    private let safariProtection: SafariProtectionProtocol
    private let resources: AESharedResourcesProtocol
    private let fileShareHelper: FileShareHelperProtocol
    private var modelProvider: UserRulesModelsProviderProtocol

    // MARK: - Initialization

    init(type: SafariUserRuleType, safariProtection: SafariProtectionProtocol, resources: AESharedResourcesProtocol, fileShareHelper: FileShareHelperProtocol) {
        self.type = type
        self.safariProtection = safariProtection
        self.resources = resources
        self.fileShareHelper = fileShareHelper
        self.modelProvider = UserRulesModelsProvider(initialModels: Self.models(safariProtection, type))
    }

    // MARK: - Internal methods

    func addRule(_ ruleText: String) throws {
        let rule = UserRule(ruleText: ruleText, isEnabled: true)
        try safariProtection.add(rule: rule, for: type, override: false, onCbReloaded: nil)
        let model = UserRuleCellModel(rule: ruleText, isEnabled: true, isSelected: false, isEditing: isEditing)
        modelProvider.addRuleModel(model)
        delegate?.ruleSuccessfullyAdded()
    }

    func ruleStateChanged(_ rule: String, newState: Bool) {
        do {
            let newRule = UserRule(ruleText: rule, isEnabled: newState)
            try safariProtection.modifyRule(rule, newRule, for: type, onCbReloaded: nil)
            modelProvider.modifyRule(rule, newRule: newRule)
        }
        catch {
            DDLogError("(SafariUserRulesTableModel) - ruleStateChanged; Error: \(error)")
        }
    }

    func removeRule(_ ruleText: String, at indexPath: IndexPath) throws {
        try safariProtection.removeRule(withText: ruleText, for: type, onCbReloaded: nil)
        modelProvider.removeRule(ruleText)
        delegate?.rulesRemoved(at: [indexPath])
    }

    func modifyRule(_ oldRuleText: String, newRule: UserRule, at indexPath: IndexPath) throws {
        try safariProtection.modifyRule(oldRuleText, newRule, for: type, onCbReloaded: nil)
        modelProvider.modifyRule(oldRuleText, newRule: newRule)
        delegate?.rulesChanged(at: [indexPath])
    }

    func turn(rules: [String], for indexPaths: [IndexPath], on: Bool) {
        safariProtection.turnRules(rules, on: on, for: type, onCbReloaded: nil)
        modelProvider = UserRulesModelsProvider(initialModels: Self.models(safariProtection, type))
        modelProvider.searchString = searchString
        delegate?.rulesChanged(at: indexPaths)
    }

    func remove(rules: [String], for indexPaths: [IndexPath]) {
        safariProtection.removeRules(rules, for: type, onCbReloaded: nil)
        modelProvider = UserRulesModelsProvider(initialModels: Self.models(safariProtection, type))
        modelProvider.searchString = searchString
        delegate?.rulesRemoved(at: indexPaths)
    }

    func setRule(_ rule: String, selected: Bool) {
        modelProvider.setRule(rule, selected: selected)
    }

    func saveUserRules(from text: String) {
        let userRulesString = text.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespaces) }
        safariProtection.set(rules: userRulesString, for: type, onCbReloaded: nil)
        modelProvider = UserRulesModelsProvider(initialModels: Self.models(safariProtection, type))
        delegate?.rulesChanged()
    }

    func deselectAll() {
        modelProvider.deselectAll()
    }

    func exportFile(for vc: UIViewController) {
        let rulesText = safariProtection.allRules(for: type).map { $0.ruleText }.joined(separator: "\n")
        fileShareHelper.exportFile(for: vc, filename: type.filename, text: rulesText)
    }

    func importFile(for vc: UIViewController, _ completion: @escaping (Error?) -> Void) {
        fileShareHelper.importFile(for: vc) { result in
            DispatchQueue.asyncSafeMain { [weak self] in
                switch result {
                case .success(let text):
                    self?.addNewRulesAfterImport(text, completion)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }

    // MARK: - Private methods

    private func addNewRulesAfterImport(_ rulesText: String, _ completion: @escaping (Error?) -> Void) {
        let rules = rulesText.split(separator: "\n").map { UserRule(ruleText: String($0), isEnabled: true) }
        do {
            try safariProtection.add(rules: rules, for: type, override: true, onCbReloaded: nil)
            modelProvider = UserRulesModelsProvider(initialModels: Self.models(safariProtection, type))
            completion(nil)
        }
        catch {
            completion(error)
        }
        delegate?.rulesChanged()
    }

    private static func models(_ safariProtection: SafariProtectionProtocol, _ type: SafariUserRuleType) -> [UserRuleCellModel] {
        let rules = safariProtection.allRules(for: type)
        return rules.map {
            UserRuleCellModel(rule: $0.ruleText, isEnabled: $0.isEnabled, isSelected: false, isEditing: false)
        }
    }
}

// MARK: - SafariUserRuleType + helper variables

fileprivate extension SafariUserRuleType {
    var title: String {
        switch self {
        case .blocklist: return String.localizedString("safari_userfilter_title")
        case .allowlist: return String.localizedString("whitelist_title")
        case .invertedAllowlist: return String.localizedString("inverted_whitelist_title")
        }
    }

    var description: String {
        let url = UIApplication.shared.adguardUrl(action: "filter_rules", from: "user_filter", buildVersion: ADProductInfo().buildVersion())
        switch self {
        case .blocklist:
            let format = String.localizedString("blacklist_text_format")
            return String(format: format, url)
        case .allowlist:
            let format = String.localizedString("whitelist_text")
            return String(format: format, url)
        case .invertedAllowlist:
            let format = String.localizedString("inverted_whitelist_text")
            return String(format: format, url)
        }
    }

    var editorDescription: String {
        switch self {
        case .blocklist: return String.localizedString("editor_safari_user_rules_description")
        case .allowlist: return String.localizedString("editor_allowlist_rules_description")
        case .invertedAllowlist: return String.localizedString("editor_inverted_allowlist_rules_description")
        }
    }

    var icon: UIImage? {
        switch self {
        case .blocklist: return UIImage(named: "user")
        case .allowlist, .invertedAllowlist: return UIImage(named: "thumbsup")
        }
    }

    var filename: String {
        switch self {
        case .blocklist: return "blocklist.txt"
        case .allowlist: return "allowlist.txt"
        case .invertedAllowlist: return "inverted_allowlist.txt"
        }
    }
}
