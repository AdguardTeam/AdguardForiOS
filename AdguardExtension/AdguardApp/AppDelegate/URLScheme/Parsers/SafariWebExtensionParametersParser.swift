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
import SharedAdGuardSDK

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(SafariWebExtensionParametersParser.self)

/// This object is responsible for obtaining parameters from app scheme links
/// And performing an action considering these parameters
struct SafariWebExtensionParametersParser: IURLSchemeParametersParser {
    private let executor: IURLSchemeExecutor

    init(executor: IURLSchemeExecutor) {
        self.executor = executor
    }

    func parse(_ url: URL) -> Bool {
        guard let actionStr = url.parseUrl().params?["action"],
              let encodedDomain = url.parseUrl().params?["domain"],
              let decodedDomain = encodedDomain.removingPercentEncoding
        else {
            LOG.error("Failed to extract info from url=\(url.absoluteString)")
            return false
        }

        if actionStr == "enableSiteAndSafariProtection" {
            return executor.openMainPageControllerAndTurnOnProtection(for: decodedDomain)
        }

        let result = Domain.findDomains(in: decodedDomain)

        if result.isEmpty {
            LOG.error("(SafariWebExtensionParametersParser) - parse; Failed to get absolute domain string from string=\(decodedDomain)")
            return false
        }

        let absoluteDomainString = result.first!
        let action = UserRulesRedirectAction.action(from: actionStr, domain: decodedDomain, absoluteDomainString: absoluteDomainString)
        return executor.openUserRulesRedirectController(for: action)
    }
}
