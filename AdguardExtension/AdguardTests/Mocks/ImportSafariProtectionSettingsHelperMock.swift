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

class ImportSafariProtectionSettingsHelperMock: ImportSafariProtectionSettingsHelperProtocol {

    var invokedImportSafariFilters = false
    var invokedImportSafariFiltersCount = 0
    var invokedImportSafariFiltersParameters: (filtersToImport: [ImportSettings.DefaultSafariFilterSettings], override: Bool)?
    var invokedImportSafariFiltersParametersList = [(filtersToImport: [ImportSettings.DefaultSafariFilterSettings], override: Bool)]()
    var stubbedImportSafariFiltersResult: [ImportSettings.DefaultSafariFilterSettings]! = []

    func importSafariFilters(_ filtersToImport: [ImportSettings.DefaultSafariFilterSettings], override: Bool) -> [ImportSettings.DefaultSafariFilterSettings] {
        invokedImportSafariFilters = true
        invokedImportSafariFiltersCount += 1
        invokedImportSafariFiltersParameters = (filtersToImport, override)
        invokedImportSafariFiltersParametersList.append((filtersToImport, override))
        return stubbedImportSafariFiltersResult
    }

    var invokedImportSafariBlocklistRules = false
    var invokedImportSafariBlocklistRulesCount = 0
    var invokedImportSafariBlocklistRulesParameters: (rules: [String], override: Bool)?
    var invokedImportSafariBlocklistRulesParametersList = [(rules: [String], override: Bool)]()

    func importSafariBlocklistRules(_ rules: [String], override: Bool) {
        invokedImportSafariBlocklistRules = true
        invokedImportSafariBlocklistRulesCount += 1
        invokedImportSafariBlocklistRulesParameters = (rules, override)
        invokedImportSafariBlocklistRulesParametersList.append((rules, override))
    }

    var invokedImportCustomSafariFilters = false
    var invokedImportCustomSafariFiltersCount = 0
    var invokedImportCustomSafariFiltersParameters: (filtersContainer: ImportSettingsService.FiltersImportContainer, override: Bool)?
    var invokedImportCustomSafariFiltersParametersList = [(filtersContainer: ImportSettingsService.FiltersImportContainer, override: Bool)]()
    var stubbedImportCustomSafariFiltersCompletionResult: [ImportSettings.FilterSettings] = []

    func importCustomSafariFilters(_ filtersContainer: ImportSettingsService.FiltersImportContainer, override: Bool, completion: @escaping ([ImportSettings.FilterSettings]) -> Void) {
        self.invokedImportCustomSafariFilters = true
        self.invokedImportCustomSafariFiltersCount += 1
        self.invokedImportCustomSafariFiltersParameters = (filtersContainer, override)
        self.invokedImportCustomSafariFiltersParametersList.append((filtersContainer, override))
        completion(self.stubbedImportCustomSafariFiltersCompletionResult)
    }
}
