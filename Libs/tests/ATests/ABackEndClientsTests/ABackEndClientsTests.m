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

- (void)testFilterMetaI18n
{
 
    ABECFilterClientLocalization *i18n = [[ABECFilterClient singleton] i18n];
    
    XCTAssertNotNil(i18n.filters);
    XCTAssertNotNil(i18n.groups);
    
    NSLog(@"Groups i18n\n%@", i18n.groups.localizations);
    NSLog(@"Filters i18n\n%@", i18n.filters.localizations);
    
    ABECFilterClientMetadata *meta = [[ABECFilterClient singleton] metadata];
    
    XCTAssertNotNil(meta.filters);
    XCTAssertNotNil(meta.groups);
    
    NSLog(@"Groups metas\n%@", meta.groups);
    NSLog(@"Filters metas\n%@", meta.filters);
    
}

- (void)testFilter {
    
    ASDFilter *filter = [[ABECFilterClient singleton] filterWithFilterId:@1];
    
    XCTAssertNotNil(filter);
    
    NSLog(@"Filter data-%@", filter);
    
}

@end
