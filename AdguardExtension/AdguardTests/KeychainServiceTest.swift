
import XCTest

class KeychainServiceTest: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testSave() {
        
        let keychain = KeychainService()
        
        XCTAssert(keychain.saveAuth(server: "test.com", login: "login", password: "pass"))
        
        let auth = keychain.loadAuth(server: "test.com")
        
        XCTAssertNotNil(auth)
        XCTAssertEqual(auth!.login, "login")
        XCTAssertEqual(auth!.password, "pass")
    }
    
    func testDelete() {
        let keychain = KeychainService()
        
        XCTAssert(keychain.saveAuth(server: "test.com", login: "login", password: "pass"))
        XCTAssert(keychain.deleteAuth(server: "test.com"))
        
        XCTAssertNil(keychain.loadAuth(server: "test.com"))
    }
    
    func testOverwrite() {
        let keychain = KeychainService()
        
        XCTAssert(keychain.saveAuth(server: "test.com", login: "login", password: "pass"))
        XCTAssert(keychain.saveAuth(server: "test.com", login: "login2", password: "pass2"))
        
        let auth = keychain.loadAuth(server: "test.com")
        
        XCTAssertEqual(auth!.login, "login2")
        XCTAssertEqual(auth!.password, "pass2")
    }
    
    func testStoreId() {
        let keychain = KeychainService()
        XCTAssert(keychain.deleteAppId())
        
        let appId = keychain.appId
        XCTAssertNotNil(appId)
        
        let appId2 = keychain.appId
        XCTAssertNotNil(appId2)
        
        XCTAssertEqual(appId, appId2)
    }
    
    func testDeleteId() {
        let keychain = KeychainService()
        XCTAssert(keychain.deleteAppId())
        
        let appId = keychain.appId
        XCTAssertNotNil(appId)
        
        XCTAssert(keychain.deleteAppId())
        
        let appId2 = keychain.appId
        XCTAssertNotNil(appId2)
        
        XCTAssertNotEqual(appId, appId2)
    }
    
    func testSaveLicenseKey() {
        let keychain = KeychainService()
        
        XCTAssert(keychain.saveLicenseKey(server: "test.server", key: "test key"))
     
        let key = keychain.loadLiceseKey(server: "test.server")
        
        XCTAssertNotNil(key)
        XCTAssertEqual(key, "test key")
    }
    
    func testDeleteLicenseKey() {
        let keychain = KeychainService()
        
        XCTAssert(keychain.saveLicenseKey(server: "test.server", key: "test key"))
        
        XCTAssert(keychain.deleteLicenseKey(server: "test.server"))
        
        let key = keychain.loadLiceseKey(server: "test.server")
        
        XCTAssertNil(key)
    }
}
