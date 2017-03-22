/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2016 Performix LLC. All rights reserved.
 
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

#import <XCTest/XCTest.h>
#import "APTunnelConnectionsHandler.h"

@interface APTunnelConnectionHandlerTest : XCTestCase

@end

@implementation APTunnelConnectionHandlerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWhitelistDomain {
    
    APTunnelConnectionsHandler *handler = [[APTunnelConnectionsHandler alloc] initWithProvider:(PacketTunnelProvider *)@"fake"];
    
    [handler setWhitelistDomains:@[ @"lenta.ru",
                                    @"domain.com"
                                    ]];
    
    XCTAssert([handler isWhitelistDomain:@"www.lenta.ru"]);
    XCTAssert([handler isWhitelistDomain:@"lenta.ru"]);
    XCTAssertFalse([handler isWhitelistDomain:@"www.lenta.com"]);
    XCTAssertFalse([handler isWhitelistDomain:@"wwwlenta.ru"]);
    
    [handler setWhitelistDomains:@[]];
    
    XCTAssertFalse([handler isWhitelistDomain:@"www.lenta.com"]);
}

- (void)testBlacklistDomain {
    
    APTunnelConnectionsHandler *handler = [[APTunnelConnectionsHandler alloc] initWithProvider:(PacketTunnelProvider *)@"fake"];
    
    [handler setBlacklistDomains:@[ @"lenta.ru",
                                    @"domain.com"
                                    ]];
    
    XCTAssert([handler isBlacklistDomain:@"www.lenta.ru"]);
    XCTAssert([handler isBlacklistDomain:@"lenta.ru"]);
    XCTAssertFalse([handler isBlacklistDomain:@"www.lenta.com"]);
    XCTAssertFalse([handler isBlacklistDomain:@"wwwlenta.ru"]);
    
    [handler setBlacklistDomains:@[]];
    
    XCTAssertFalse([handler isBlacklistDomain:@"www.lenta.com"]);
}

@end
