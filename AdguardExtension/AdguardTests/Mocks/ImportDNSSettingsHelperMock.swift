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

import Foundation

class ImportDNSSettingsHelperMock: ImportDNSSettingsHelperProtocol {

    var invokedImportDnsBlocklistRules = false
    var invokedImportDnsBlocklistRulesCount = 0
    var invokedImportDnsBlocklistRulesParameters: (rules: [String], override: Bool)?
    var invokedImportDnsBlocklistRulesParametersList = [(rules: [String], override: Bool)]()

    func importDnsBlocklistRules(_ rules: [String], override: Bool) {
        invokedImportDnsBlocklistRules = true
        invokedImportDnsBlocklistRulesCount += 1
        invokedImportDnsBlocklistRulesParameters = (rules, override)
        invokedImportDnsBlocklistRulesParametersList.append((rules, override))
    }

    var invokedImportDnsServer = false
    var invokedImportDnsServerCount = 0
    var invokedImportDnsServerParameters: (serverId: Int, Void)?
    var invokedImportDnsServerParametersList = [(serverId: Int, Void)]()
    var stubbedImportDnsServerResult: Bool! = false

    func importDnsServer(serverId: Int) -> Bool {
        invokedImportDnsServer = true
        invokedImportDnsServerCount += 1
        invokedImportDnsServerParameters = (serverId, ())
        invokedImportDnsServerParametersList.append((serverId, ()))
        return stubbedImportDnsServerResult
    }

    var invokedImportDnsFilters = false
    var invokedImportDnsFiltersCount = 0
    var invokedImportDnsFiltersParameters: (filtersContainer: ImportSettingsService.FiltersImportContainer, override: Bool)?
    var invokedImportDnsFiltersParametersList = [(filtersContainer: ImportSettingsService.FiltersImportContainer, override: Bool)]()
    var stubbedImportDnsFiltersCompletionResult: [ImportSettings.FilterSettings] = []

    func importDnsFilters(_ filtersContainer: ImportSettingsService.FiltersImportContainer, override: Bool, completion: @escaping ([ImportSettings.FilterSettings]) -> Void) {
        invokedImportDnsFilters = true
        invokedImportDnsFiltersCount += 1
        invokedImportDnsFiltersParameters = (filtersContainer, override)
        invokedImportDnsFiltersParametersList.append((filtersContainer, override))
        completion(stubbedImportDnsFiltersCompletionResult)
    }
}
