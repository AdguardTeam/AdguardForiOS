
import XCTest

class LoginServiceTest: XCTestCase {
    
    lazy var loginService: LoginService = { return  LoginService(defaults: defaults, network: network, keychain: keychain) }()
    let defaults = UserDefaults(suiteName: "test_defaults")!
    let keychain = KeychainMock()
    let network = NetworkMock()
    
    override func setUp() {
    }

    override func tearDown() {
        UserDefaults.standard.removeSuite(named: "test_defaults")
    }

    func testLoginActive() {
        
        let expectation = XCTestExpectation(description: "Login request")
        
        network.returnString = """
        {
            "auth_status": "SUCCESS",
            "premium_status": "ACTIVE",
            "expiration_date": 99999999999999999999,
            "license_info": {
                "licenses": [
                    {
                        "license_key": "ABCDE12345",
                        "license_status": "VALID",
                        "license_type": "MOBILE",
                        "expiration_date": 99999999999999999999,
                        "license_computers_count": 0,
                        "license_max_computers_count": 3,
                        "subscription": {
                            "status": "ACTIVE",
                            "next_bill_date": 99999999999999999999
                        }
                    }
                ],

                "license": "ABCDE12345"
            }
        }
"""
        
        loginService.login(name: "name", password: "password") { (error) in
        
            XCTAssertNil(error)
            XCTAssert(self.loginService.loggedIn)
            XCTAssert(self.loginService.hasPremiumLicense)
            XCTAssert(self.loginService.active)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoginNoPremium() {
        
        let expectation = XCTestExpectation(description: "Login request")
        
        network.returnString = """
        {
            "auth_status": "SUCCESS",
            "premium_status": "FREE",
            "license_info": { }
        }
        """
        
        loginService.login(name: "name", password: "password") { (error) in
            
            XCTAssertNil(error)
            XCTAssert(self.loginService.loggedIn)
            XCTAssertFalse(self.loginService.hasPremiumLicense)
            XCTAssertFalse(self.loginService.active)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoginBadCredentials() {
        
        let expectation = XCTestExpectation(description: "Login request")
        
        network.returnString = """
        {
        "auth_status": "BAD_CREDENTIALS"
        }
        """
        
        loginService.login(name: "name", password: "password") { (error) in
            
            XCTAssertNotNil(error)
            XCTAssertFalse(self.loginService.loggedIn)
            XCTAssertFalse(self.loginService.hasPremiumLicense)
            XCTAssertFalse(self.loginService.active)
            XCTAssertEqual((error! as NSError).code, LoginService.loginBadCredentials)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testExpired() {
        let expectation = XCTestExpectation(description: "Login request")
        
        network.returnString = """
        {
            "auth_status": "SUCCESS",
            "premium_status": "ACTIVE",
            "expiration_date": 100000,
            "license_info": {
                "licenses": [
                    {
                    "license_status": "VALID",
                    "expiration_date": 100000,
                    }
                ],
        
                "license": "ABCDE12345"
            }
        }
        """
        
        loginService.login(name: "name", password: "password") { (error) in
            
            XCTAssertNil(error)
            XCTAssert(self.loginService.loggedIn)
            XCTAssert(self.loginService.hasPremiumLicense)
            XCTAssertFalse(self.loginService.active)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWillExpired() {
        let expectation = XCTestExpectation(description: "Login request")
        
        let expirationDate = Date().addingTimeInterval(2.0).timeIntervalSince1970 * 1000
        network.returnString = "{\"auth_status\": \"SUCCESS\",\"premium_status\": \"ACTIVE\",\"expiration_date\": \(expirationDate)}"
        
        loginService.login(name: "name", password: "password") { (error) in
            
            XCTAssertNil(error)
            XCTAssert(self.loginService.loggedIn)
            XCTAssert(self.loginService.hasPremiumLicense)
            XCTAssert(self.loginService.active)
            
            self.loginService.activeChanged = {
                XCTAssert(self.loginService.loggedIn)
                XCTAssert(self.loginService.hasPremiumLicense)
                XCTAssertFalse(self.loginService.active)
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testActiveteKey() {
        let expectation = XCTestExpectation(description: "Login request")
        
        network.returnString = """
        {
        "auth_status": "SUCCESS",
        "premium_status": "ACTIVE",
        "expiration_date": 99999999999999999999,
        "license_info": {
        "licenses": [
        {
        "license_key": "ABCDE12345",
        "license_status": "VALID",
        "license_type": "MOBILE",
        "expiration_date": 99999999999999999999,
        "license_computers_count": 0,
        "license_max_computers_count": 3,
        "subscription": {
        "status": "ACTIVE",
        "next_bill_date": 99999999999999999999
        }
        }
        ],
        
        "license": "ABCDE12345"
        }
        }
        """
        
        loginService.login(name:nil, password: "licenseKey") { (error) in
            
            XCTAssertNil(error)
            XCTAssert(self.loginService.loggedIn)
            XCTAssert(self.loginService.hasPremiumLicense)
            XCTAssert(self.loginService.active)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

class NetworkMock: ACNNetworkingProtocol {
    
    var returnString = ""
    
    func data(with url: URL, completionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        
        DispatchQueue.main.async {
            completionHandler?(self.returnString.data(using: .utf8), nil, nil)
        }
    }
    
    func data(with url: URL, timeoutInterval: TimeInterval, completionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        
        DispatchQueue.main.async {
            completionHandler?(self.returnString.data(using: .utf8), nil, nil)
        }
    }
    
    func data(with URLrequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        DispatchQueue.main.async {
            completionHandler(self.returnString.data(using: .utf8), nil, nil)
        }
    }
    
    
}

class KeychainMock: KeychainServiceProtocol {
    
    var appId: String?
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
    
    func loadLiceseKey(server: String) -> String? {
        return licenseKey
    }
    
    func deleteLicenseKey(server: String) -> Bool {
        licenseKey = nil
        return true
    }
    
}
