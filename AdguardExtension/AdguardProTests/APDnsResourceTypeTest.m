//
//  APDnsResourceTypeTest.m
//  Adguard
//
//  Created by Roman Sokolov on 13.07.16.
//  Copyright © 2016 Performiks. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APDnsResourceType.h"

@interface APDnsResourceTypeTest : XCTestCase

@end

@implementation APDnsResourceTypeTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testType {
    
    APDnsResourceType *type = [APDnsResourceType type:28];
    
    XCTAssert([[type description] isEqualToString:@"AAAA"]);
    XCTAssert([[type humanReadable] isEqualToString:@"Ip6 Address."]);
}


@end
