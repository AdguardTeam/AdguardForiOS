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

import XCTest

class AEInvertedWhitelistDomainsObjectTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMigration4_0() {
        
        let encoder = NSKeyedArchiver()
        
        // encode old format
        let domains = ["google.com", "example.com"]
        encoder.encode(domains, forKey: "domains")
        
        let data = encoder.encodedData
        let decoder = NSKeyedUnarchiver(forReadingWith: data)

        let invertedWLObject = AEInvertedWhitelistDomainsObject(coder: decoder)
        
        // create object in new format
        
        let rules = domains.map { ASDFilterRule(text: $0, enabled: true) }
        let newInvertedWLObject = AEInvertedWhitelistDomainsObject(rules: rules)
        
        XCTAssertEqual(invertedWLObject?.rule, newInvertedWLObject.rule)
        XCTAssertEqual(invertedWLObject?.rules, newInvertedWLObject.rules)
    }
}
