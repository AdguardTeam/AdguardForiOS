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
#import "APPacketTunnelMigration.h"

@interface APPacketTunnelMigrationTest : XCTestCase

@end

@implementation APPacketTunnelMigrationTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testRulesMigration {
    
    // migration needed
    NSArray* testArray = @[@"rule1", @"rule2", @"rule3"];
    
    id migrated = [APPacketTunnelMigration migrateRulesIfNeeded:testArray];
    
    NSMutableDictionary *result = [NSMutableDictionary new];
    result[@"MIGRATED_UUID"] = @[@"rule1", @"rule2", @"rule3"];
    XCTAssertEqualObjects(result, migrated);
    
    // migration not needed
    
    NSDictionary *testDictionary = @{@"test_uuid":@[@"rule", @"rule2"]};
    id migrated2 = [APPacketTunnelMigration migrateRulesIfNeeded:testDictionary];
    
    NSDictionary* result2 =  @{@"test_uuid":@[@"rule", @"rule2"]};
    XCTAssertEqualObjects(result2, migrated2);
}

- (void) testHostsMigration {
    
    // migration needed
    NSDictionary* testDictionary = @{@"test.com" : @"::1", @"test2.com" : @"::1"};
    
    id migrated = [APPacketTunnelMigration migrateHostsIfNeeded:testDictionary];
    
    NSDictionary* result = @{@"MIGRATED_UUID" : @{@"test.com" : @"::1", @"test2.com" : @"::1"}};
    XCTAssertEqualObjects(result, migrated);
    
    // migration not needed
    
    NSDictionary *testDictionary2 = @{@"test_uuid" : @{@"test3.com" : @"::1", @"test4.com" : @"::1"}};
    id migrated2 = [APPacketTunnelMigration migrateHostsIfNeeded:testDictionary2];
    
    NSDictionary* result2 = @{@"test_uuid" : @{@"test3.com" : @"::1", @"test4.com" : @"::1"}};
    XCTAssertEqualObjects(result2, migrated2);
}

@end
