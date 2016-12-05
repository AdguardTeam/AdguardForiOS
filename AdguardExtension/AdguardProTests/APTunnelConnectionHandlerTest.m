//
//  APTunnelConnectionHandlerTest.m
//  Adguard
//
//  Created by Roman Sokolov on 05.12.16.
//  Copyright © 2016 Performiks. All rights reserved.
//

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
    
    APTunnelConnectionsHandler *handler = [[APTunnelConnectionsHandler alloc] initWithProvider:@"fake"];
    
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
    
    APTunnelConnectionsHandler *handler = [[APTunnelConnectionsHandler alloc] initWithProvider:@"fake"];
    
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
