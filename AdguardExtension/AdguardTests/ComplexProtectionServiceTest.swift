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

class ComplexProtectionServiceTest: XCTestCase {

    var complexProtection: ComplexProtectionService!
    
    var resources: SharedResourcesMock!
    var safari: SafariServiceMock!
    var configuration: ConfigurationServiceMock!
    var vpnManager: VpnManagerMock!
    
    override func setUp() {
        resources = SharedResourcesMock()
        safari = SafariServiceMock()
        configuration = ConfigurationServiceMock()
        vpnManager = VpnManagerMock()
        let safariProtection = SafariProtectionService(resources: resources)
        complexProtection = ComplexProtectionService(resources: resources, safariService: safari, configuration: configuration, vpnManager: vpnManager, safariProtection: safariProtection, productInfo: ProductInfoMock(), nativeProvidersService: NativeProvidersServiceMock())
    }

    override func tearDown() {
    }
    
    let safariEnableCases = [
                              ((false, false, false), (true, false, true)),
                              ((false, false, true), (true, false, true)),
                              ((false, true, false), (true, true, true)),
                              ((false, true, true), (true, true, true)),
                              ((true, false, false), (true, false, true)),
    ]
    
    let safariDisableCases = [
                              ((true, false, false), (false, false, false)),
                              ((true, false, true), (false, false, false)),
                              ((true, true, false), (false, true, false)),
                              ((true, true, true), (false, true, true)),
                              ((false, true, true), (false, true, true)),
                              ((false, true, false), (false, true, false)),
    ]
    
    let systemEnableCases = [
                              ((false, false, false), (false, true, true)),
                              ((false, false, true), (false, true, true)),
                              ((false, true, false), (false, true, true)),
                              ((false, true, true), (false, true, true)),
                              ((true, false, false), (true, true, true)),
    ]
    
    let systemDisableCases = [ ((false, true, false), (false, false, false)),
                              ((false, true, true), (false, false, false)),
                              ((false, false, false), (false, false, false)),
                              ((true, true, true), (true, false, true)),
    ]
    
    let complexEnableCases = [
                              ((false, false, false), (true, true, true)),
                              ((false, true, false), (false, true, true)),
                              ((true, false, false), (true, false, true)),
                              ((true, true, false), (true, true, true)),
                              ((true, true, true), (true, true, true)),
    ]
    
    let complexDisableCases = [
                              ((false, false, true), (false, false, false)),
                              ((false, true, true), (false, true, false)),
                              ((true, false, true), (true, false, false)),
                              ((true, true, true), (true, true, false)),
                              ((true, true, false), (true, true, false)),
    ]
    
    
    func testEnableSafari() {
        for (old, new) in safariEnableCases {
            testEnable(.safari, state: true, oldStates: old, expectedStates: new)
        }
    }
    
    func testDisableSafari() {
        for (old, new) in safariDisableCases {
            testEnable(.safari, state: false, oldStates: old, expectedStates: new)
        }
    }
    
    func testEnableSystem() {
        for (old, new) in systemEnableCases {
            testEnable(.system, state: true, oldStates: old, expectedStates: new)
        }
    }
    
    func testDisableSystem() {
        for (old, new) in systemDisableCases {
            testEnable(.system, state: false, oldStates: old, expectedStates: new)
        }
    }
    
    func testEnableComplex() {
        for (old, new) in complexEnableCases {
            testEnable(.complex, state: true, oldStates: old, expectedStates: new)
        }
    }
    
    func testDisableComplex() {
        for (old, new) in complexDisableCases {
            testEnable(.complex, state: false, oldStates: old, expectedStates: new)
        }
    }
    
    
    
    enum Enable {
        case safari, system, complex
    }

    private func testEnable(_ what: Enable, state: Bool, oldStates: (safari: Bool, system: Bool, complex: Bool), expectedStates: (safari: Bool, system:Bool, complex:Bool)) {
        resources.safariProtectionEnabled = oldStates.safari
        resources.systemProtectionEnabled = oldStates.system
        resources.complexProtectionEnabled = oldStates.complex
        
        safari.invalidateCalled = false
        vpnManager.updateCalled = false
    
        let expectation = XCTestExpectation()
        
        switch what {
        case .safari:
            complexProtection.switchSafariProtection(state: state, for: nil) { (error) in
                XCTAssertNil(error)
                expectation.fulfill()
            }
        case .system:
            complexProtection.switchSystemProtection(state: state, for: nil) { (error) in
                XCTAssertNil(error)
                expectation.fulfill()
            }
        case .complex:
            complexProtection.switchComplexProtection(state: state, for: nil) { (safariError, systemError) in
                XCTAssertNil(safariError)
                XCTAssertNil(systemError)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssert(resources.safariProtectionEnabled == expectedStates.safari)
        XCTAssert(resources.systemProtectionEnabled == expectedStates.system)
        XCTAssert(resources.complexProtectionEnabled == expectedStates.complex)
    }
}
