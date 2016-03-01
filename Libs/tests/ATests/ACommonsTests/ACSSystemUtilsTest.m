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
#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "ACLang.h"
#import "ACSSystemUtils.h"

@interface ACSSystemUtilsTest : XCTestCase

@end

@implementation ACSSystemUtilsTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // init logger (file, debug console)
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [DDLog removeAllLoggers];
}

- (void)testCliUtil {
    // This is an example of a functional test case.
    NSString *output;
    int result = [ACSSystemUtils cliUtil:@"/bin/ls" arguments:@[@"-la"] output:&output];
    DDLogError(@"Result \"ls\" - %i", result);
    DDLogError(@"Output:\n%@", output);

    output = nil;
    result = [ACSSystemUtils cliUtil:@"/bin/ls" arguments:nil output:NULL];
    DDLogError(@"Result \"ls\" - %i", result);
    DDLogError(@"Output:\n%@", output);
    
    XCTAssertThrows([ACSSystemUtils cliUtil:@"/bin/lssss" arguments:@[@"-la"] output:&output]);
    
}

@end
