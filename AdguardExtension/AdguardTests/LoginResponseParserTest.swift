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

class LoginResponseParserTest: XCTestCase {
    
    var parser: LoginResponseParserProtocol!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        parser = LoginResponseParser()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMaxComputer() {
        
        let responseString = """
                                {
                                    "status":"ERROR",
                                    "licenseKeyStatus":"MAX_COMPUTERS_EXCEED",
                                    "licenseKey":null,
                                    "expirationDate":1566302768202
                                }
                             """
        
        guard let data = responseString.data(using: .utf8) else { return XCTFail() }
        
        let (premium, _, error) = parser.processStatusResponse(data: data)
        
        XCTAssertFalse(premium)
        XCTAssertEqual(error?.domain, LoginService.loginErrorDomain)
        XCTAssertEqual(error?.code, LoginService.loginMaxComputersExceeded)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
