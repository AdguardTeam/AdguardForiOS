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

class LoginServiceTest: XCTestCase {
    
    lazy var loginService: LoginService = { return  LoginService(defaults: defaults, network: network, keychain: keychain, productInfo: ProductInfoMock()) }()
    let defaults = UserDefaults(suiteName: "test_defaults")!
    let keychain = KeychainMock()
    let network = NetworkMock()
    
    override func setUp() {
    }

    override func tearDown() {
        UserDefaults.standard.removeSuite(named: "test_defaults")
    }
    
    func test300_301migration() {
        
        let parser = ParserMock()
        loginService.loginResponseParser = parser
        
        // user was logged in by name/password in v3.0.0
        keychain.auth = ("name", "password")
        
        parser.statusResults = [ (false, nil, nil), // app_id was not bound yet
                                 (true, Date(timeIntervalSinceNow: 1000), nil)
            ]
        
        parser.loginResult = (true, true, Date(timeIntervalSinceNow: 1000), "LICENSE_KEY", nil)
        
        let expectation = XCTestExpectation(description: "status expectation")
        
        loginService.checkStatus { (error) in
            XCTAssertNil(error)
            XCTAssert(self.loginService.loggedIn)
            XCTAssert(self.loginService.hasPremiumLicense)
            XCTAssert(self.loginService.active)
            XCTAssertNil(self.keychain.auth)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test300_301migration2() {
        
        let parser = ParserMock()
        loginService.loginResponseParser = parser
        
        // user was logged in by name/password in v3.0.0
        keychain.licenseKey = "LICENSE_KEY"
        
        parser.statusResults = [ (false, nil, nil), // app_id was not bound yet
            (true, Date(timeIntervalSinceNow: 1000), nil)
        ]
        
        parser.loginResult = (true, true, Date(timeIntervalSinceNow: 1000), "LICENSE_KEY", nil)
        
        let expectation = XCTestExpectation(description: "status expectation")
        
        loginService.checkStatus { (error) in
            XCTAssertNil(error)
            XCTAssert(self.loginService.loggedIn)
            XCTAssert(self.loginService.hasPremiumLicense)
            XCTAssert(self.loginService.active)
            XCTAssertNil(self.keychain.auth)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // test error on first status request
    // in this case we must not change login status
    func test300_301migrationFailed() {
        
        let parser = ParserMock()
        loginService.loginResponseParser = parser
        loginService.hasPremiumLicense = true
        loginService.expirationDate = Date(timeIntervalSinceNow: 1000);
        
        // user was logged in by name/password in v3.0.0
        keychain.licenseKey = "LICENSE_KEY"
        loginService.loggedIn = true
        
        parser.statusResults = [ (false, nil, NSError(domain: "error", code: -100, userInfo: nil)) ] // error here
        
        parser.loginResult = (true, true, Date(timeIntervalSinceNow: 1000), "LICENSE_KEY", nil)
        
        let expectation = XCTestExpectation(description: "status expectation")
        
        loginService.checkStatus { (error) in
            XCTAssertNotNil(error)
            XCTAssert(self.loginService.loggedIn)
            XCTAssert(self.loginService.hasPremiumLicense)
            XCTAssert(self.loginService.active)
            XCTAssertNil(self.keychain.auth)
            XCTAssertNotNil(self.keychain.licenseKey)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // test error on login after succedded status request
    // in this case we must not change login status
    func test300_301migrationFailed2() {
        
        let parser = ParserMock()
        loginService.loginResponseParser = parser
        loginService.hasPremiumLicense = true
        loginService.expirationDate = Date(timeIntervalSinceNow: 1000);
        
        // user was logged in by name/password in v3.0.0
        keychain.licenseKey = "LICENSE_KEY"
        loginService.loggedIn = true
        
        parser.statusResults = [ (false, nil, nil),
                                 (false, nil, NSError(domain: "error", code: -100, userInfo: nil))] // error here
        
        let expectation = XCTestExpectation(description: "status expectation")
        
        loginService.checkStatus { (error) in
            XCTAssertNotNil(error)
            XCTAssertTrue(self.loginService.loggedIn)
            XCTAssertTrue(self.loginService.hasPremiumLicense)
            XCTAssertTrue(self.loginService.active)
            XCTAssertNil(self.keychain.auth)
            XCTAssertNotNil(self.keychain.licenseKey)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // test error on second status request
    // in this case we must not change login status
    func test300_301migrationFailed3() {
        
        let parser = ParserMock()
        loginService.loginResponseParser = parser
        loginService.hasPremiumLicense = true
        loginService.expirationDate = Date(timeIntervalSinceNow: 1000);
        
        // user was logged in by name/password in v3.0.0
        keychain.licenseKey = "LICENSE_KEY"
        loginService.loggedIn = true
        
        parser.statusResults = [ (false, nil, nil),
                                 (false, nil,  NSError(domain: "error", code: -100, userInfo: nil))   ] // error here
        
        parser.loginResult = (true, true,  Date(timeIntervalSinceNow: 1000), "LICENSE_KEY", nil) // error here
        
        let expectation = XCTestExpectation(description: "status expectation")
        
        loginService.checkStatus { (error) in
            XCTAssertNotNil(error)
            XCTAssert(self.loginService.loggedIn)
            XCTAssert(self.loginService.hasPremiumLicense)
            XCTAssert(self.loginService.active)
            XCTAssertNil(self.keychain.auth)
            XCTAssertNotNil(self.keychain.licenseKey)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWillExpired() {
        
        let parser = ParserMock()
        loginService.loginResponseParser = parser
        loginService.hasPremiumLicense = true
        loginService.loggedIn = true
        loginService.expirationDate = Date(timeIntervalSinceNow: 1000);
        
        keychain.auth = nil
        keychain.licenseKey = nil
        
        let expectation = XCTestExpectation(description: "Login request")
        
        self.loginService.activeChanged = {
            XCTAssertFalse(self.loginService.loggedIn)
            XCTAssertFalse(self.loginService.hasPremiumLicense)
            XCTAssertFalse(self.loginService.active)
            
            expectation.fulfill()
        }
        
        parser.statusResults = [(false, Date(timeIntervalSinceNow: -1), nil), (false, Date(timeIntervalSinceNow: -1), nil)]
        
        loginService.checkStatus { (error) in
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
}

class NetworkMock: ACNNetworkingProtocol {
    
    var returnString = ""
    var response = URLResponse()
    
    func data(with url: URL, completionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        
        DispatchQueue(label: "NetworkMock queue").async {
            completionHandler?(self.returnString.data(using: .utf8), self.response, nil)
        }
    }
    
    func data(with url: URL, timeoutInterval: TimeInterval, completionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        
        DispatchQueue(label: "NetworkMock queue").async {
            completionHandler?(self.returnString.data(using: .utf8), self.response, nil)
        }
    }
    
    func data(with URLrequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        DispatchQueue(label: "NetworkMock queue").async {
            completionHandler(self.returnString.data(using: .utf8), self.response, nil)
        }
    }
}

class KeychainMock: KeychainServiceProtocol {
    
    var appId: String? = "123"
    var licenseKey: String?
    
    var auth: (String, String)?
    func loadAuth(server: String) -> (login: String, password: String)? {
        return auth
    }
    
    func saveAuth(server: String, login: String, password: String) -> Bool {
        auth = (login, password)
        return true
    }
    
    func deleteAuth(server: String) -> Bool {
        auth = nil
        return true
    }
    
    func saveLicenseKey(server: String, key: String) -> Bool {
        licenseKey = key
        return true
    }
    
    func loadLicenseKey(server: String) -> String? {
        return licenseKey
    }
    
    func deleteLicenseKey(server: String) -> Bool {
        licenseKey = nil
        return true
    }
    
    func reset() {}
}

class ParserMock: LoginResponseParser {
    
    var statusResults: [(premium: Bool, expirationDate: Date?, NSError?)] = [(true, nil, nil)]
    var loginResult: (loggedIn: Bool, premium: Bool, expirationDate: Date?, licenseKey: String?, NSError?) = (true, true, nil, nil, nil)
    var currentStatusResultIndex = 0
    
    override func processStatusResponse(data: Data) -> (premium: Bool, expirationDate: Date?, NSError?) {
        
        let result = statusResults[currentStatusResultIndex]
        currentStatusResultIndex += 1;
        
        return result;
    }
    
    override func processLoginResponse(data: Data) -> (loggedIn: Bool, premium: Bool, expirationDate: Date?, licenseKey: String?, NSError?) {
        return loginResult
    }
}
