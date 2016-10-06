//
//  AEBlacklistDomainObjectTest.m
//  Adguard
//
//  Created by Roman Sokolov on 05.10.16.
//  Copyright © 2016 Performiks. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AEBlacklistDomainObject.h"
#import "ASDFilterObjects.h"

@interface AEBlacklistDomainObjectTest : XCTestCase

@end

@implementation AEBlacklistDomainObjectTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateBlacklistDomain {
    
    AEBlacklistDomainObject *object = [[AEBlacklistDomainObject alloc] initWithDomain:@"www.domain.com"];
    
    XCTAssert([object.rule.ruleText isEqualToString:@"||www.domain.com^"]);
    
    ASDFilterRule *ruleObject = object.rule;
    object = [[AEBlacklistDomainObject alloc] initWithRule:ruleObject];
    
    XCTAssert([object.domain isEqualToString:@"www.domain.com"]);
    
    object.domain = @"web.domain.com";
    XCTAssert([object.rule.ruleText isEqualToString:@"||web.domain.com^"]);
    
    ruleObject.ruleText = @"||lenta.ru^";
    object.rule = ruleObject;
    
    XCTAssert([object.domain isEqualToString:@"lenta.ru"]);
    
    ruleObject.ruleText = @"@@||lenta.ru$document";
    object = [[AEBlacklistDomainObject alloc] initWithRule:ruleObject];
    
    XCTAssertNil(object);
}

@end
