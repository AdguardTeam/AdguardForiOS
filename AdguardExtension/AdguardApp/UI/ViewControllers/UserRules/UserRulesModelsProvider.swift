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

import struct SharedAdGuardSDK.UserRule

protocol UserRulesModelsProviderProtocol {
    var searchString: String? { get set }
    var rules: [UserRuleCellModel] { get }

    func addRuleModel(_ ruleModel: UserRuleCellModel)
    func setEditing(_ editing: Bool)
    func modifyRule(_ oldRuleText: String, newRule: UserRule)
    func removeRule(_ rule: String)
    func setRule(_ rule: String, selected: Bool)
    func deselectAll()
}

final class UserRulesModelsProvider: UserRulesModelsProviderProtocol {

    // MARK: - Internal properties

    var searchString: String? {
        didSet {
            processSearchString()
        }
    }

    var rules: [UserRuleCellModel] { isSearching ? searchModels : initialModels }

    // MARK: - Private properties

    private var isSearching: Bool { searchString != nil && !searchString!.isEmpty }

    private var initialModels: [UserRuleCellModel]
    private var searchModels: [UserRuleCellModel] = []

    init(initialModels: [UserRuleCellModel]) {
        self.initialModels = initialModels
    }

    // MARK: - Internal methods

    func addRuleModel(_ ruleModel: UserRuleCellModel) {
        initialModels.append(ruleModel)
        processSearchString()
    }

    func setEditing(_ editing: Bool) {
        for i in 0..<initialModels.count {
            initialModels[i].isEditing = editing
        }
        processSearchString()
    }

    func modifyRule(_ oldRuleText: String, newRule: UserRule) {
        if let modifiedRuleIndex = initialModels.firstIndex(where: { $0.rule == oldRuleText }) {
            initialModels[modifiedRuleIndex].isEnabled = newRule.isEnabled
            initialModels[modifiedRuleIndex].ruleAttrString = newRule.ruleText.clearAttrString
        }
        processSearchString()
    }

    func removeRule(_ rule: String) {
        if let removedRuleIndex = initialModels.firstIndex(where: { $0.rule == rule }) {
            initialModels.remove(at: removedRuleIndex)
        }
        processSearchString()
    }

    func setRule(_ rule: String, selected: Bool) {
        if let ruleIndex = initialModels.firstIndex(where: { $0.rule == rule }) {
            initialModels[ruleIndex].isSelected = selected
        }
        if isSearching, let ruleIndex = searchModels.firstIndex(where: { $0.rule == rule }) {
            searchModels[ruleIndex].isSelected = selected
        }
    }

    func deselectAll() {
        for i in 0..<initialModels.count {
            initialModels[i].isSelected = false
        }
        for i in 0..<searchModels.count {
            searchModels[i].isSelected = false
        }
    }

    // MARK: - Private methods

    private func processSearchString() {
        guard isSearching, let searchString = searchString else { return }

        let words = searchString.split(separator: " ").map { String($0) }

        searchModels = initialModels.compactMap { initialModel -> UserRuleCellModel? in
            let highlightedOccurancies = initialModel.rule.highlight(occuranciesOf: Set(words))
            if highlightedOccurancies.matchesFound {
                return UserRuleCellModel(
                    ruleAttrString: highlightedOccurancies.attrString,
                    isEnabled: initialModel.isEnabled,
                    isSelected: initialModel.isSelected,
                    isEditing: initialModel.isEditing
                )
            } else {
                return nil
            }
        }
    }
}
