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
    
    func testGetOuathTokenSuccess() {
        let responseString = """
                               {
                                 "access_token" : "123-321",
                                 "token_type" : "bearer",
                                 "expires_in" : 100,
                                 "scope" : "trust"
                               }
                             """
        
        guard let data = responseString.data(using: .utf8) else { return XCTFail() }
        
        let (token, expiration, error) = parser.processOauthTokenResponse(data: data)
        
        XCTAssertEqual(token, "123-321")
        XCTAssertNotNil(expiration)
        XCTAssertTrue(expiration! > Date(timeIntervalSinceNow: 0))
        XCTAssertNil(error)
    }
    
    func testGetToken2FARequired() {
        let responseString = """
                               {
                                 "error" : "2fa_required",
                                 "error_description" : "2FA is required"
                               }
                             """
        
        guard let data = responseString.data(using: .utf8) else { return XCTFail() }
        
        let (token, expiration, error) = parser.processOauthTokenResponse(data: data)
        
        XCTAssertNil(token)
        XCTAssertNil(expiration)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.domain, LoginService.loginErrorDomain)
        XCTAssertEqual(error?.code, LoginService.auth2FaRequired)
    }
    
    func testGetTokenBadCredentials() {
        let responseString = """
                               {
                                 "error" : "unauthorized",
                                 "error_description" : "Sorry, unrecognized username or password"
                               }
                             """
        
        guard let data = responseString.data(using: .utf8) else { return XCTFail() }
        
        let (token, expiration, error) = parser.processOauthTokenResponse(data: data)
        
        XCTAssertNil(token)
        XCTAssertNil(expiration)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.domain, LoginService.loginErrorDomain)
        XCTAssertEqual(error?.code, LoginService.loginBadCredentials)
    }
    
    func testGetTokenDisabled() {
        let responseString = """
                               {
                                 "error" : "unauthorized",
                                 "error_description" : "Account is disabled"
                               }
                             """
        
        guard let data = responseString.data(using: .utf8) else { return XCTFail() }
        
        let (token, expiration, error) = parser.processOauthTokenResponse(data: data)
        
        XCTAssertNil(token)
        XCTAssertNil(expiration)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.domain, LoginService.loginErrorDomain)
        XCTAssertEqual(error?.code, LoginService.accountIdDisabled)
    }
    
    func testGetTokenInvalide2FAToken() {
        let responseString = """
                               {
                                 "error" : "2fa_invalid",
                                 "error_description" : "Invalid token"
                               }
                             """
        
        guard let data = responseString.data(using: .utf8) else { return XCTFail() }
        
        let (token, expiration, error) = parser.processOauthTokenResponse(data: data)
        
        XCTAssertNil(token)
        XCTAssertNil(expiration)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.domain, LoginService.loginErrorDomain)
        XCTAssertEqual(error?.code, LoginService.outh2FAInvalid)
    }
    
    func testGetTokenUnknownError() {
        let responseString = """
                               {
                                 "error" : "unknown",
                                 "error_description" : "Some Error"
                               }
                             """
        
        guard let data = responseString.data(using: .utf8) else { return XCTFail() }
        
        let (token, expiration, error) = parser.processOauthTokenResponse(data: data)
        
        XCTAssertNil(token)
        XCTAssertNil(expiration)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.domain, LoginService.loginErrorDomain)
        XCTAssertEqual(error?.code, LoginService.loginError)
        XCTAssertNotNil(error?.userInfo)
        XCTAssertEqual(error?.userInfo[LoginService.errorDescription] as? String, "Some Error")
    }
    
}
