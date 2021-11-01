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
import DnsAdGuardSDK

final class DnsUserRulesTableModel: UserRulesTableModelProtocol {

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
            case .blocklist: return resources.systemUserFilterEnabled
            case .allowlist: return resources.systemWhitelistEnabled
            }
        }
        set {
            switch type {
            case .blocklist:
                resources.systemUserFilterEnabled = newValue
                dnsProtection.update(blocklistIsEnabled: newValue)
            case .allowlist:
                resources.systemWhitelistEnabled = newValue
                dnsProtection.update(allowlistIsEnabled: newValue)
            }
            vpnManager.updateSettings(completion: nil)
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

    private let type: DnsUserRuleType
    private let dnsProtection: DnsProtectionProtocol
    private let resources: AESharedResourcesProtocol
    private let fileShareHelper: FileShareHelperProtocol
    private var modelProvider: UserRulesModelsProviderProtocol
    private let vpnManager: VpnManagerProtocol

    // MARK: - Initialization

    init(type: DnsUserRuleType,
         dnsProtection: DnsProtectionProtocol,
         resources: AESharedResourcesProtocol,
         fileShareHelper: FileShareHelperProtocol,
         vpnManager: VpnManagerProtocol) {
        self.type = type
        self.dnsProtection = dnsProtection
        self.resources = resources
        self.fileShareHelper = fileShareHelper
        self.modelProvider = UserRulesModelsProvider(initialModels: Self.models(dnsProtection, type))
        self.vpnManager = vpnManager
    }

    // MARK: - Internal methods

    func addRule(_ ruleText: String) throws {
        let rule = UserRule(ruleText: ruleText, isEnabled: true)
        try dnsProtection.add(rule: rule, override: false, for: type)
        vpnManager.updateSettings(completion: nil)
        let model = UserRuleCellModel(rule: ruleText, isEnabled: true, isSelected: false, isEditing: isEditing)
        modelProvider.addRuleModel(model)
        delegate?.ruleSuccessfullyAdded()
    }

    func ruleStateChanged(_ rule: String, newState: Bool) {
        do {
            let newRule = UserRule(ruleText: rule, isEnabled: newState)
            try dnsProtection.modifyRule(rule, newRule, for: type)
            vpnManager.updateSettings(completion: nil)
            modelProvider.modifyRule(rule, newRule: newRule)
        }
        catch {
            DDLogError("(DnsUserRulesTableModel) - ruleStateChanged; Error: \(error)")
        }
    }

    func removeRule(_ ruleText: String, at indexPath: IndexPath) throws {
        try dnsProtection.removeRule(withText: ruleText, for: type)
        vpnManager.updateSettings(completion: nil)
        modelProvider.removeRule(ruleText)
        delegate?.rulesRemoved(at: [indexPath])
    }

    func modifyRule(_ oldRuleText: String, newRule: UserRule, at indexPath: IndexPath) throws {
        try dnsProtection.modifyRule(oldRuleText, newRule, for: type)
        vpnManager.updateSettings(completion: nil)
        modelProvider.modifyRule(oldRuleText, newRule: newRule)
        delegate?.rulesChanged(at: [indexPath])
    }

    func turn(rules: [String], for indexPaths: [IndexPath], on: Bool) {
        dnsProtection.turnRules(rules, on: on, for: type)
        vpnManager.updateSettings(completion: nil)
        modelProvider = UserRulesModelsProvider(initialModels: Self.models(dnsProtection, type))
        modelProvider.searchString = searchString
        delegate?.rulesChanged(at: indexPaths)
    }

    func remove(rules: [String], for indexPaths: [IndexPath]) {
        dnsProtection.removeRules(rules, for: type)
        vpnManager.updateSettings(completion: nil)
        modelProvider = UserRulesModelsProvider(initialModels: Self.models(dnsProtection, type))
        modelProvider.searchString = searchString
        delegate?.rulesRemoved(at: indexPaths)
    }

    func setRule(_ rule: String, selected: Bool) {
        modelProvider.setRule(rule, selected: selected)
    }

    func saveUserRules(from text: String) {
        let userRulesString = text.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespaces) }
        dnsProtection.set(rules: userRulesString, for: type)
        vpnManager.updateSettings(completion: nil)
        modelProvider = UserRulesModelsProvider(initialModels: Self.models(dnsProtection, type))
        delegate?.rulesChanged()
    }

    func deselectAll() {
        modelProvider.deselectAll()
    }

    func exportFile(for vc: UIViewController) {
        let rulesText = dnsProtection.allRules(for: type).map { $0.ruleText }.joined(separator: "\n")
        fileShareHelper.exportFile(for: vc, filename: type.filename, text: rulesText)
    }

    func importFile(for vc: UIViewController, _ completion: @escaping (Error?) -> Void) {
        fileShareHelper.importFile(for: vc) { result in
            DispatchQueue.asyncSafeMain { [weak self] in
                switch result {
                case .success(let text):
                    self?.addNewRulesAfterImport(text, completion)
                    self?.vpnManager.updateSettings(completion: nil)
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
            try dnsProtection.add(rules: rules, override: true, for: type)
            modelProvider = UserRulesModelsProvider(initialModels: Self.models(dnsProtection, type))
            completion(nil)
        }
        catch {
            completion(error)
        }
        delegate?.rulesChanged()
    }

    private static func models(_ dnsProtection: DnsProtectionProtocol, _ type: DnsUserRuleType) -> [UserRuleCellModel] {
        let rules = dnsProtection.allRules(for: type)
        return rules.map {
            UserRuleCellModel(rule: $0.ruleText, isEnabled: $0.isEnabled, isSelected: false, isEditing: false)
        }
    }

}

// MARK: - DnsUserRuleType + helper variables

fileprivate extension DnsUserRuleType {
    var title: String {
        switch self {
        case .blocklist: return String.localizedString("dns_blacklist_title")
        case .allowlist: return String.localizedString("whitelist_title")
        }
    }

    var description: String {
        let url = UIApplication.shared.adguardUrl(action: "dns_filter_rules", from: "user_filter", buildVersion: ADProductInfo().buildVersion())
        switch self {
        case .blocklist:
            let format = String.localizedString("dns_blacklist_text_format")
            return String(format: format, url)
        case .allowlist:
            let format = String.localizedString("whitelist_text")
            return String(format: format, url)
        }
    }

    var editorDescription: String {
        switch self {
        case .blocklist: return String.localizedString("editor_dns_blocklist_rules_description")
        case .allowlist: return String.localizedString("editor_dns_allowlist_rules_description")
        }
    }

    var icon: UIImage? {
        switch self {
        case .blocklist: return UIImage(named: "blacklist-icon")
        case .allowlist: return UIImage(named: "thumbsup")
        }
    }

    var filename: String {
        switch self {
        case .blocklist: return "dns_blocklist.txt"
        case .allowlist: return "dns_allowlist.txt"
        }
    }
}
