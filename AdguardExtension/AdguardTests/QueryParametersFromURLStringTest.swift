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

class QueryParametersFromURLStringTest: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testValidQueryExtension() {
        let stringOne = "location=https://easylist.to/easylist/easylist.txt&title=EasyList"
        let stringTwo = "some_token=123&foo=321&bar=qwerty"
        let stringThree = "foo="
        let stringFour = "="
        
        
        let valOne = stringOne.getQueryParametersFromQueryString()
        let valTwo = stringTwo.getQueryParametersFromQueryString()
        let valThree = stringThree.getQueryParametersFromQueryString()
        let valFour = stringFour.getQueryParametersFromQueryString()
        
        XCTAssertNotNil(valOne)
        XCTAssertNotNil(valTwo)
        XCTAssertNotNil(valThree)
        XCTAssertNotNil(valFour)
        
        XCTAssertEqual(valOne!["location"], "https://easylist.to/easylist/easylist.txt")
        XCTAssertEqual(valOne!["title"], "EasyList")
        
        XCTAssertEqual(valTwo!["some_token"], "123")
        XCTAssertEqual(valTwo!["foo"], "321")
        XCTAssertEqual(valTwo!["bar"], "qwerty")
        
        XCTAssertEqual(valThree!["foo"], "")
        XCTAssertEqual(valFour![""], "")

    }
    
    func testNotValidQueryExtension() {
        let invalidStringOne = "SomeFooBar"
        let invalidStringTwo = "&"
        let emptyInvalidString = ""
        
        let valOne = invalidStringOne.getQueryParametersFromQueryString()
        let valTwo = invalidStringTwo.getQueryParametersFromQueryString()
        let valThree = emptyInvalidString.getQueryParametersFromQueryString()
        XCTAssertNil(valOne)
        XCTAssertNil(valTwo)
        XCTAssertNil(valThree)
        
    }

}
