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

class CustomSchemeURLParserTest: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testParseURL() {
        let url = URL(string: "adguard:subscribe?location=https://easylist.to/easylist/easylist.txt&title=EasyList")!
        let result = url.parseUrl()
        
        
        let locationValue = result.params?["location"]
        let titleValue = result.params?["title"]
        
        XCTAssertNotNil(locationValue)
        XCTAssertNotNil(titleValue)
        
        XCTAssertEqual(locationValue, "https://easylist.to/easylist/easylist.txt")
        XCTAssertEqual(titleValue, "EasyList")
    }
    
    func testParseAuthURL() {
        let url = URL(string: "adguard://auth#some_token=123&foo=321&bar=qwerty")!
        let result = url.parseAuthUrl()
        
        let tokenValue = result.params?["some_token"]
        let fooValue = result.params?["foo"]
        let barValue = result.params?["bar"]
        
        XCTAssertNotNil(tokenValue)
        XCTAssertNotNil(fooValue)
        XCTAssertNotNil(barValue)
        
        XCTAssertEqual(tokenValue, "123")
        XCTAssertEqual(fooValue, "321")
        XCTAssertEqual(barValue, "qwerty")
    }
    
    func testParseIncorectParamsOfURL() {
        let url = URL(string: "adguard:subscribe?&location=&&&=&")!
        let result = url.parseUrl()
        
        let locationValue = result.params?["location"]
        let emptyValue = result.params?[""]
        
        XCTAssertNotNil(locationValue)
        XCTAssertNotNil(emptyValue)
        
        XCTAssertEqual(locationValue, "")
        XCTAssertEqual(emptyValue, "")
    }
    
    func testParseIncorectParamsOfAuthURL() {
        let url = URL(string: "adguard:subscribe#location=&&&=&")!
        let result = url.parseAuthUrl()
        
        let locationValue = result.params?["location"]
        let emptyValue = result.params?[""]
        
        XCTAssertNil(locationValue)
        XCTAssertNil(emptyValue)
    }
}
