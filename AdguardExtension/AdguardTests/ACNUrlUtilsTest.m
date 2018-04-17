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
#import "ACNUrlUtils.h"

@interface ACNUrlUtilsTest : XCTestCase

@end

@implementation ACNUrlUtilsTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testHostsLine {
    
    NSString* ip;
    NSString* domain;
    
    BOOL result = [ACNUrlUtils checkHostsLine:@"127.0.0.1 example.com" ip:&ip domain:&domain];
    
    XCTAssertEqualObjects(@"example.com", domain);
    XCTAssertEqualObjects(@"127.0.0.1", ip);
    
    result = [ACNUrlUtils checkHostsLine:@"127.0.0.2      example1.com" ip:&ip domain:&domain];
    
    XCTAssertEqualObjects(@"example1.com", domain);
    XCTAssertEqualObjects(@"127.0.0.2", ip);
    
    result = [ACNUrlUtils checkHostsLine:@"     127.0.0.3   \t\t\t   example3.com\t\t\t" ip:&ip domain:&domain];
    
    XCTAssertEqualObjects(@"example3.com", domain);
    XCTAssertEqualObjects(@"127.0.0.3", ip);
    
    result = [ACNUrlUtils checkHostsLine:@"example3.com" ip:&ip domain:&domain];
    XCTAssertFalse(result);
    
    result = [ACNUrlUtils checkHostsLine:@"   example3.com   " ip:&ip domain:&domain];
    XCTAssertFalse(result);
    
    // valid ipv6 address and domain
    
    result = [ACNUrlUtils checkHostsLine:@"::1 example4.com" ip:&ip domain:&domain];
    XCTAssertTrue(result);
    XCTAssertEqualObjects(@"example4.com", domain);
    XCTAssertEqualObjects(@"::1", ip);
    
    // invalid ip
    result = [ACNUrlUtils checkHostsLine:@"127.0.0 example5.com" ip:&ip domain:&domain];
    XCTAssertFalse(result);
    
    // invalid domain
    result = [ACNUrlUtils checkHostsLine:@"127.0.0.1 exam^ple.com" ip:&ip domain:&domain];
    XCTAssertFalse(result);
}

@end
