/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2016 Performix LLC. All rights reserved.
 
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
