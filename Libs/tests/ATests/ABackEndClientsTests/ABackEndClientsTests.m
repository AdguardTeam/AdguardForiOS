/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015 Performix LLC. All rights reserved.

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
#import "ACommons/ACLang.h"
#import "ASDModels/ASDFilterObjects.h"
#import "ABackEndClients/ABECFilter.h"

@interface AABackEndClientTests : XCTestCase

@end

@implementation AABackEndClientTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [DDLog removeAllLoggers];
}

- (void)testFilterVersions
{
    ABECFilterClient *filterClient = [ABECFilterClient new];
    
    NSArray *versions = [filterClient filterVersionListForApp:@"MACOSXADGUARDTESTAPPLICATIONIDSTRING" filterIds:@[@0, @1, @2, @5, @7]];
    
    for (ASDFilterMetadata *item in versions)
        DDLogError(@"Filter data-%@", item);
    
}

- (void)testFilter {
    
    ABECFilterClient *filterClient = [ABECFilterClient new];
    
    ASDFilter *filter = [filterClient filterForApp:@"MACOSXADGUARDTESTAPPLICATIONIDSTRING" affiliateId:@"performix.ru" filterId:2];
    
    DDLogError(@"Filter data-%@", filter);
    
    filter = [filterClient filterForApp:@"MACOSXADGUARDTESTAPPLICATIONIDSTRING" affiliateId:@"performix.ru" filterId:1];
    
    DDLogError(@"Filter data-%@", filter);
}

@end