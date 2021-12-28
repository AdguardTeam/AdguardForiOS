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

import XCTest
import SharedAdGuardSDK

class SafariMigration4_3_1Test: XCTestCase {
    private var safariMigration: SafariMigration4_3_1Protocol!
    private var resources: SharedResourcesMock!
    private var safariProtection: SafariProtectionMigrationMock!

    override func setUp() {
        resources = SharedResourcesMock()
        safariProtection = SafariProtectionMigrationMock()
        safariMigration = SafariMigration4_3_1(resources: resources, safariProtection: safariProtection)
    }


    func testMigrate() {
        generateUserRules()
        safariMigration.migrate()
        let expectedRules: [UserRule] = [
            UserRule(ruleText: "rule#1", isEnabled: true),
            UserRule(ruleText: "rule#2", isEnabled: false),
            UserRule(ruleText: "rule#3", isEnabled: false),
            UserRule(ruleText: "rule#4", isEnabled: false),
            UserRule(ruleText: "rule#5", isEnabled: true)
        ]
        XCTAssertEqual(safariProtection.invokedGetRulesCount, 3)
        XCTAssertEqual(safariProtection.invokedRemoveRulesCount, 3)
        XCTAssertEqual(safariProtection.invokedAddCount, 3)
        XCTAssertEqual(safariProtection.invokedAddParametersList.count, 3)
        safariProtection.invokedAddParametersList.forEach {
            XCTAssertEqual($0.rules, expectedRules)
        }
    }

    func testMigrateWithEmptyRules() {
        safariMigration.migrate()
        XCTAssertEqual(safariProtection.invokedGetRulesCount, 3)
        XCTAssertEqual(safariProtection.invokedRemoveRulesCount, 0)
        XCTAssertEqual(safariProtection.invokedAddCount, 0)
        XCTAssertEqual(safariProtection.invokedAddParametersList.count, 0)
    }

    func testMigrationWithAddError() {
        generateUserRules()
        safariProtection.stubbedAddError = NSError(domain: "test_error", code: 1, userInfo: nil)
        safariMigration.migrate()

        let expectedRules: [UserRule] = [
            UserRule(ruleText: "rule#1", isEnabled: true),
            UserRule(ruleText: "rule#2", isEnabled: false),
            UserRule(ruleText: "rule#3", isEnabled: false),
            UserRule(ruleText: "rule#4", isEnabled: false),
            UserRule(ruleText: "rule#5", isEnabled: true)
        ]

        XCTAssertEqual(safariProtection.invokedGetRulesCount, 1)
        XCTAssertEqual(safariProtection.invokedRemoveRulesCount, 1)
        XCTAssertEqual(safariProtection.invokedAddCount, 1)
        XCTAssertEqual(safariProtection.invokedAddParametersList.count, 1)
        safariProtection.invokedAddParametersList.forEach {
            XCTAssertEqual($0.rules, expectedRules)
        }
    }

    private func generateUserRules() {
        let rules: [UserRule] = [
            UserRule(ruleText: "rule#1", isEnabled: true),
            UserRule(ruleText: "rule#2\nrule#3\nrule#4", isEnabled: false),
            UserRule(ruleText: "rule#5", isEnabled: true),
        ]
        safariProtection.stubbedGetRulesResult = rules
    }

}
