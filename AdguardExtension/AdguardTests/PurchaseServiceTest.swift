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
import Foundation

class PurchaseServiceTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testSaveKeychain() {
//        let service = PurchaseService(network: NetworkMock(), resources: AESharedResources())
//        _ = service.deleteLoginFromKeychain()
//        
//        XCTAssert(service.saveToKeychain(login: "test_login", password: "test_pass"))
//        
//        let result = service.loadAuthFromKeychain()
//        XCTAssertNotNil(result)
//        
//        XCTAssertEqual(result?.login, "test_login")
//        XCTAssertEqual(result?.password, "test_pass")
//    }
//    
//    func testChangeLogin() {
//        let service = PurchaseService(network: NetworkMock(), resources: AESharedResources())
//        _ = service.deleteLoginFromKeychain()
//        
//        XCTAssert(service.saveToKeychain(login: "test_login", password: "test_pass"))
//        XCTAssert(service.saveToKeychain(login: "new_login", password: "new_password"))
//        
//        let result = service.loadAuthFromKeychain()
//        XCTAssertNotNil(result)
//        
//        XCTAssertEqual(result?.login, "new_login")
//        XCTAssertEqual(result?.password, "new_password")
//        
//        XCTAssert(service.saveToKeychain(login: "new_login2", password: "new_password2"))
//        let result2 = service.loadAuthFromKeychain()
//        XCTAssertNotNil(result2)
//        
//        XCTAssertEqual(result2?.login, "new_login2")
//        XCTAssertEqual(result2?.password, "new_password2")
//    }
//    
//    func testDeleteLogin() {
//        let service = PurchaseService(network: NetworkMock(), resources: AESharedResources())
//        XCTAssert(service.saveToKeychain(login: "test_delete_login", password: "test_pass"))
//        
//        XCTAssert(service.deleteLoginFromKeychain())
//        
//        let result = service.loadAuthFromKeychain()
//        XCTAssertNil(result)
//    }
//    
//    class NetworkMock: ACNNetworkingProtocol {
//        func data(with url: URL!, completionHandler: ((Data?, URLResponse?, Error?) -> Void)!) {
//            
//        }
//        
//        func data(with url: URL!, timeoutInterval: TimeInterval, completionHandler: ((Data?, URLResponse?, Error?) -> Void)!) {
//            
//        }
//        
//        func data(with URLrequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
//            
//            let data = answer.data(using: .utf8)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                completionHandler(data, nil, nil)
//            }
//        }
//        
//        var answer: String = ""
//    }
//    
//    func testLogin () {
//        let network = NetworkMock()
//        let service = PurchaseService(network: network, resources: AESharedResources())
//        
//        // success test
//        network.answer = """
//        {
//        "authStatus": "success",
//        "premiumStatus": "active",
//        "expirationDate": 10000000000000
//        }
//        """
//        
//        let expectation = XCTestExpectation(description: "Login request")
//        
//        service.login(withName: "name1", password: "password1") { (success) in
//            XCTAssert(success)
//            expectation.fulfill()
//        }
//        
//        // bed credintals
//        network.answer = """
//        {
//        "authStatus": "bad_credentials",
//        "premiumStatus": "active",
//        "expirationDate": 10000000000000
//        }
//        """
//        
//        let expectation2 = XCTestExpectation(description: " wrong Login request")
//        service.login(withName: "name2", password: "password2") { (success) in
//            XCTAssertFalse(success)
//            expectation2.fulfill()
//        }
//        
//        // not paid account
//        network.answer = """
//        {
//        "authStatus": "success",
//        "premiumStatus": "free",
//        "expirationDate": 10000000000000
//        }
//        """
//        
//        let expectation3 = XCTestExpectation(description: " free Login request")
//        service.login(withName: "name3", password: "password3") { (success) in
//            XCTAssertFalse(success)
//            expectation3.fulfill()
//        }
//        
//        // not paid account
//        network.answer = """
//        {
//        "authStatus": "success",
//        "premiumStatus": "expired",
//        "expirationDate": 10000000
//        }
//        """
//        
//        let expectation4 = XCTestExpectation(description: " expired Login request")
//        service.login(withName: "name4", password: "password4") { (success) in
//            XCTAssertFalse(success)
//            expectation4.fulfill()
//        }
//        
//        // null test
//        network.answer = """
//        {
//        "authStatus": "success",
//        "premiumStatus": null,
//        "expirationDate": null
//        }
//        """
//        
//        let expectation5 = XCTestExpectation(description: " null Login request")
//        service.login(withName: "name5", password: "password5") { (success) in
//            XCTAssertFalse(success)
//            expectation5.fulfill()
//        }
//        
//        // test type cast
//        network.answer = """
//        {
//        "authStatus": "success",
//        "premiumStatus": "active",
//        "expirationDate": "10000000000000"
//        }
//        """
//        
//        let expectation6 = XCTestExpectation(description: " null Login request")
//        service.login(withName: "name5", password: "password5") { (success) in
//            XCTAssert(success)
//            expectation6.fulfill()
//        }
//        
//        wait(for: [expectation, expectation2, expectation3, expectation4, expectation5, expectation6], timeout: 10.0)
//        
//    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
