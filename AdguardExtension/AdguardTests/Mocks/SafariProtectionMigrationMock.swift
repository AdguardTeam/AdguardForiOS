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

import SafariAdGuardSDK
import SharedAdGuardSDK

class SafariProtectionMigrationMock: SafariProtectionMigrationsProtocol {

    var invokedGetRules = false
    var invokedGetRulesCount = 0
    var invokedGetRulesParameters: (type: SafariUserRuleType, Void)?
    var invokedGetRulesParametersList = [(type: SafariUserRuleType, Void)]()
    var stubbedGetRulesResult: [UserRule]! = []

    func getRules(for type: SafariUserRuleType) -> [UserRule] {
        invokedGetRules = true
        invokedGetRulesCount += 1
        invokedGetRulesParameters = (type, ())
        invokedGetRulesParametersList.append((type, ()))
        return stubbedGetRulesResult
    }

    var invokedRemoveRules = false
    var invokedRemoveRulesCount = 0
    var invokedRemoveRulesParameters: (type: SafariUserRuleType, Void)?
    var invokedRemoveRulesParametersList = [(type: SafariUserRuleType, Void)]()

    func removeRules(for type: SafariUserRuleType) {
        invokedRemoveRules = true
        invokedRemoveRulesCount += 1
        invokedRemoveRulesParameters = (type, ())
        invokedRemoveRulesParametersList.append((type, ()))
    }

    var invokedAdd = false
    var invokedAddCount = 0
    var invokedAddParameters: (rules: [UserRule], type: SafariUserRuleType, override: Bool)?
    var invokedAddParametersList = [(rules: [UserRule], type: SafariUserRuleType, override: Bool)]()
    var stubbedAddError: Error?

    func add(rules: [UserRule], for type: SafariUserRuleType, override: Bool) throws {
        invokedAdd = true
        invokedAddCount += 1
        invokedAddParameters = (rules, type, override)
        invokedAddParametersList.append((rules, type, override))
        if let error = stubbedAddError {
            throw error
        }
    }

    var invokedSetGroup = false
    var invokedSetGroupCount = 0
    var invokedSetGroupParameters: (groupType: SafariGroup.GroupType, enabled: Bool)?
    var invokedSetGroupParametersList = [(groupType: SafariGroup.GroupType, enabled: Bool)]()
    var stubbedSetGroupError: Error?

    func setGroup(_ groupType: SafariGroup.GroupType, enabled: Bool) throws {
        invokedSetGroup = true
        invokedSetGroupCount += 1
        invokedSetGroupParameters = (groupType, enabled)
        invokedSetGroupParametersList.append((groupType, enabled))
        if let error = stubbedSetGroupError {
            throw error
        }
    }

    var invokedSetFilter = false
    var invokedSetFilterCount = 0
    var invokedSetFilterParameters: (id: Int, groupId: Int, enabled: Bool)?
    var invokedSetFilterParametersList = [(id: Int, groupId: Int, enabled: Bool)]()
    var stubbedSetFilterError: Error?

    func setFilter(withId id: Int, _ groupId: Int, enabled: Bool) throws {
        invokedSetFilter = true
        invokedSetFilterCount += 1
        invokedSetFilterParameters = (id, groupId, enabled)
        invokedSetFilterParametersList.append((id, groupId, enabled))
        if let error = stubbedSetFilterError {
            throw error
        }
    }

    var invokedReinitializeGroupsAndFilters = false
    var invokedReinitializeGroupsAndFiltersCount = 0
    var stubbedReinitializeGroupsAndFiltersError: Error?

    func reinitializeGroupsAndFilters() throws {
        invokedReinitializeGroupsAndFilters = true
        invokedReinitializeGroupsAndFiltersCount += 1
        if let error = stubbedReinitializeGroupsAndFiltersError {
            throw error
        }
    }

    var invokedConvertFiltersAndReloadCbs = false
    var invokedConvertFiltersAndReloadCbsCount = 0
    var convertFiltersAndReloadCbsError: Error?

    func convertFiltersAndReloadCbs(onCbReloaded: ((Error?) -> Void)?) {
        invokedConvertFiltersAndReloadCbs = true
        invokedConvertFiltersAndReloadCbsCount += 1
        onCbReloaded?(convertFiltersAndReloadCbsError)
    }
}
