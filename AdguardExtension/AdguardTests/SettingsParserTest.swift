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

class SettingsParserTest: XCTestCase {

    func testEmptyJson() {
        let parser = SettingsParser()
        let settings = try! parser.parse(query: "{}")
        XCTAssertNotNil(settings)
    }

    func testParseJsonWithError() {
        let parser = SettingsParser()
        XCTAssertThrowsError(try parser.parse(query: "JSON"))
    }

    func testAllSettings() {
        let parser = SettingsParser()

        let json = """
                    {
                      "version": 1,
                      "cb_filter_default": [
                        {
                          "id": 1,
                          "enable": true
                        },
                        {
                          "id": 2,
                          "enable": false
                        }
                      ],
                      "cb_filter_default_override": false,
                      "cb_filter_custom": [
                        {
                          "name": "custom",
                          "url": "custom_filter_url"
                        }
                      ],
                      "cb_filter_custom_override": false,
                      "dns_filter_list": [
                        {
                          "name": "custom_dns_filter",
                          "url": "dns_filter_url"
                        }
                      ],
                      "dns_filter_list_override": true,
                      "user_rules": [
                        "rule1", "rule2"
                      ],
                      "user_rules_override": false,
                      "dns_user_rules": [
                          "dns_rule1", "dns_rule2"
                      ],
                      "dns_user_rules_override": true,
                      "disabled_apps": [],
                      "allowlist_rules": [],
                      "license": "LICENSE",
                      "dns_server_id": 33
                    }
        """
        let settings = try! parser.parse(query: json)

        XCTAssertNotNil(settings)

        XCTAssertEqual(settings.defaultSafariFilters?[0].id, 1)
        XCTAssertEqual(settings.defaultSafariFilters?[0].enable, true)
        XCTAssertEqual(settings.defaultSafariFilters?[1].id, 2)
        XCTAssertEqual(settings.defaultSafariFilters?[1].enable, false)
        XCTAssertEqual(settings.customSafariFilters?.first?.name, "custom")
        XCTAssertEqual(settings.customSafariFilters?.first?.url, "custom_filter_url")
        XCTAssertEqual(settings.dnsFilters?.first?.name, "custom_dns_filter")
        XCTAssertEqual(settings.dnsFilters?.first?.url, "dns_filter_url")
        XCTAssertEqual(settings.license, "LICENSE")
        XCTAssertEqual(settings.safariBlocklistRules, ["rule1", "rule2"])
        XCTAssertEqual(settings.dnsBlocklistRules, ["dns_rule1", "dns_rule2"])
        XCTAssertEqual(settings.dnsServerId, 33)
        XCTAssertEqual(settings.overrideDnsBlocklistRules, true)
        XCTAssertEqual(settings.overrideDnsFilters, true)
    }
}
