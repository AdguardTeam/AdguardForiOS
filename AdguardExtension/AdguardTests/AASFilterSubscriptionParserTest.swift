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

class AASFilterSubscriptionParserTest: XCTestCase {
    
    var networking: NetworkMock!
    var parser: AASFilterSubscriptionParser!

    override func setUp() {
        networking = NetworkMock()
        parser = AASFilterSubscriptionParser()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAffinity() {
        networking.returnString =   """

                                    ||noaffinity1.com^

                                    !#safari_cb_affinity(general)
                                    ||general.com^
                                    !#safari_cb_affinity

                                    !#safari_cb_affinity(other)
                                    ||other.com^
                                    !#safari_cb_affinity

                                    !#safari_cb_affinity(security)
                                    ||security.com^
                                    !#safari_cb_affinity

                                    !#safari_cb_affinity(privacy)
                                    ||privacy.com^
                                    !#safari_cb_affinity

                                    !#safari_cb_affinity(custom)
                                    ||custom.com^
                                    !#safari_cb_affinity

                                    !#safari_cb_affinity(social)
                                    ||social.com^
                                    !#safari_cb_affinity
                                    
                                    !#safari_cb_affinity(all)
                                    ||all.com^
                                    !#safari_cb_affinity

                                    !#safari_cb_affinity(general, other)
                                    ||general_and_other.com^
                                    !#safari_cb_affinity
                                    
                                    ||noaffinity2.com^

                                    """
        
        do {
            let result = try parser.parse(from: URL(string: "test.com")!, networking: networking)
            XCTAssertNotNil(result)
            
            var allUsed = Affinity()
            
            for rule in (result.rules as! [ASDFilterRule])  {
                
                let affinity = rule.affinity == nil ? nil : Affinity(rawValue: rule.affinity!.uint8Value)
                switch rule.ruleText {
                case "||general.com^":
                    XCTAssertTrue(affinity == .general)
                    allUsed.insert(.general)
                case "||other.com^":
                    XCTAssertTrue(affinity == .other)
                    allUsed.insert(.other)
                case "||security.com^":
                    XCTAssertTrue(affinity == .security)
                    allUsed.insert(.security)
                case "||privacy.com^":
                    XCTAssertTrue(affinity == .privacy)
                    allUsed.insert(.privacy)
                case "||custom.com^":
                    XCTAssertTrue(affinity == .custom)
                    allUsed.insert(.custom)
                case "||social.com^":
                    XCTAssertTrue(affinity == .socialWidgetsAndAnnoyances)
                    allUsed.insert(.socialWidgetsAndAnnoyances)
                    
                case "||all.com^":
                    XCTAssertTrue(affinity!.rawValue == 0)
                    
                case "||general_and_other.com^":
                    XCTAssertTrue(affinity!.contains(.general))
                    XCTAssertTrue(affinity!.contains(.other))
                    
                default:
                    XCTAssertNil(rule.affinity)
                }
            }
            
            XCTAssertTrue(allUsed.contains(.general))
            XCTAssertTrue(allUsed.contains(.other))
            XCTAssertTrue(allUsed.contains(.security))
            XCTAssertTrue(allUsed.contains(.privacy))
            XCTAssertTrue(allUsed.contains(.custom))
            XCTAssertTrue(allUsed.contains(.socialWidgetsAndAnnoyances))
        }
        catch {
            XCTFail()
        }
    }
}
