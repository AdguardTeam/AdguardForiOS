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

struct OpenUserFilterControllerParser: IURLSchemeParametersParser {

    private let executor: IURLSchemeExecutor

    init(executor: IURLSchemeExecutor) {
        self.executor = executor
    }

    func parse(_ url: URL) -> Bool {
        let rule = String(url.path.suffix(url.path.count - 1))
        if rule.isEmpty { return false }
        if let domainLevels = getDomainLevels(fullDomain: rule) {
            let action: UserRulesRedirectAction = UserRulesRedirectAction.addToBlocklist(domain: rule, domainLevels: domainLevels)
            return executor.openUserRulesRedirectController(for: action)
        }

        DDLogError("(OpenUserFilterControllerParser) - parse; Failed to get domain levels for string: \(rule)")
        return false
    }

    private func getDomainLevels(fullDomain: String) -> String? {
        if let index = fullDomain.firstIndex(of: "#") {
            let result = fullDomain[fullDomain.startIndex..<index]
            return result.isEmpty ? nil : String(result)
        } else {
            let splited = fullDomain.split(separator: ".")
            return splited.count > 0 ? fullDomain : nil
        }
    }
}
