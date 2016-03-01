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
#import "ACLang.h"

@interface AdguardCommonsTests : XCTestCase

@end

@implementation AdguardCommonsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
// init logger (file, debug console)
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [DDLog removeAllLoggers];
}

- (void)testLogger
{

    DDLogError(@"This file: %@ This method: %@", THIS_FILE, THIS_METHOD);
    DDLogTrace();
}

- (void)testExceptions
{
    XCTAssertThrows([[NSException argumentException:@"testArgument"] raise], @"argumentException FAIL");
    XCTAssertThrows([[NSException mallocException:nil] raise], @"mallocException:nil FAIL");
    XCTAssertThrows([[NSException mallocException:@"testName"] raise], @"mallocException FAIL");
    
}

- (void) testACWildcard {
    
    NSString *testoutput = @"^\\[a-zA-z].*.*.*... tipa replace test$";
    NSString *rString = [ACLWildcard regexFromWildcard:@"[a-zA-z]***??? tipa replace test"];
    
    XCTAssert([testoutput isEqualToString:rString]);
    
    ACLWildcard *wild = [ACLWildcard wildcard:@"*tipa tre*ZHOPA?test*"];
    DDLogError(@"%@", [ACLWildcard regexFromWildcard:@"*tipa tre*ZHOPA?test"]);
    
    XCTAssert([wild matchWildcard:@"1234567890 tipa treZHOPA ZHOPA test1234567890"]);
    XCTAssertFalse([wild matchWildcard:@"1234567890 tipa tre 1234567890"]);
    
    XCTAssert([@"tarara" isEqualToString:[[ACLWildcard wildcard:@"*tarara*trtr*tr??"] shortcut]]);
    XCTAssert([@"this is it" isEqualToString:[[ACLWildcard wildcard:@"this is it*trtr*tr??"] shortcut]]);
    XCTAssert([@"longest string" isEqualToString:[[ACLWildcard wildcard:@"*tarara*trtr*this is?longest string"] shortcut]]);
    XCTAssert([@"longest string" isEqualToString:[[ACLWildcard wildcard:@"*tarara*trtr*this is?longest string*"] shortcut]]);

}

- (void) testIndexOf {
    NSString *string = @"123456789012345678901234567890 12345678901234567890";
    
    XCTAssert([string indexOf:@" 123" fromIndex:40] == -1);
    XCTAssert([string indexOf:@" 1" fromIndex:3] == 30);
    
}

- (void)testNSURLMethod {

//    NSURL *baseURL = [NSURL URLWithString:@"http://user:pass@domain.com:9080/tipa/"];
    NSURL *url = [NSURL URLWithString:@"http://user:pass@domain.com:9080/tipa/url/path/;urlparameter.par?query=string&query2=string2#fragment"];
    
//    NSString *urlString = @"url/path/;urlparameter.par?query=string&query2=string2#fragment";
//    NSString *urlString = @"http://user:pass@domain.com:9080/tipa/url/";
    
//    NSURL *url = [NSURL URLWithString:urlString relativeToURL:baseURL];
    
    DDLogError(@"relativeString=%@", [url relativeString]);
    DDLogError(@"relativePath=%@", [url relativePath]);
    DDLogError(@"absoluteString=%@", [url absoluteString]);
    DDLogError(@"path=%@", [url path]);
    DDLogError(@"query=%@", [url query]);
    DDLogError(@"fragment=%@", [url fragment]);
    DDLogError(@"parameterString=%@", [url parameterString]);
    DDLogError(@"relativeUrlString=%@", [url relativeUrlString]);
    DDLogError(@"relativeUrlString=%@", [url relativeUrlString]);

}

- (void)testISO8601DateFromString {
    
    NSDate *date = [NSDate dateWithISO8601String:@"2014-04-15T20:01:25.873+04:00"];
    
    DDLogError(@"Date=%@", date);

}

@end
