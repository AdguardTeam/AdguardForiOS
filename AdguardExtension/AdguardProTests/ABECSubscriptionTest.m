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

#import <XCTest/XCTest.h>
#import "ABECSubscription.h"

@interface ABECSubscriptionTest : XCTestCase

@end

@implementation ABECSubscriptionTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testParseText {
    
    NSString* text = @" \
                        ! comment \n \
                        \
                        ! rules \n\
                        ||google.com^ \n\
                        @@||yahoo.com^ \n\
                        \
                        ! domain \n\
                        ebay.com \n\
                        \
                        ! hosts \n\
                        127.0.0.1      amazon.com \n\
                        ::1  example.com \n\
                        ::127.0.0.1 example2.com \n\
                        ";
    
    NSArray* rules;
    NSDictionary* hosts;
    
    [ABECSubscription.singleton parseText:text rules:&rules hosts: &hosts];
    
    XCTAssertEqual(3, rules.count);
    XCTAssertEqual(3, hosts.count);
    
    XCTAssertEqualObjects(@"127.0.0.1", hosts[@"amazon.com"]);
}
@end
