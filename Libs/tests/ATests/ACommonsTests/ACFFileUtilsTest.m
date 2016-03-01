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
#import "ACFiles.h"
#import "ACLang.h"

@interface ACFFileUtilsTest : XCTestCase

@end

@implementation ACFFileUtilsTest

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

- (void) testfileLastWriteTimeForUrl {

    XCTAssert([[ACFFileUtils fileLastWriteTimeForUrl:nil] compare:[NSDate distantFuture]] == NSOrderedSame);
    
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"fbProfile" withExtension:@"jpg"];
    NSDate *tDate = [ACFFileUtils fileLastWriteTimeForUrl:url];
    
    DDLogError(@"fbProfile.jpg date: %@", tDate);

}

- (void) testTouchForUrl {

    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"fbProfile" withExtension:@"jpg"];
    
    NSDate *tDate = [ACFFileUtils fileLastWriteTimeForUrl:url];
    
    [ACFFileUtils touchForUrl:url];

    NSDate *t2Date = [ACFFileUtils fileLastWriteTimeForUrl:url];
    
    XCTAssert([t2Date compare:tDate] != NSOrderedSame);
}

- (void) testFileOlderThen{

    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"fbProfile" withExtension:@"jpg"];
    
    XCTAssert([ACFFileUtils isFile:url olderThan:[NSDate date]]);
    XCTAssertFalse([ACFFileUtils isFile:url olderThan:[NSDate distantPast]]);
    XCTAssertFalse([ACFFileUtils isFile:url olderThan:nil]);
}

- (void) testChecksumMD5 {
    
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"fbProfile" withExtension:@"jpg"];
    
    NSString *sum = [ACFFileUtils fileChecksum:url];
    DDLogError(@"CheckSum: %@", sum);
    
    XCTAssert([sum isEqualToString:@"1b77670d19c0a05becf2407945b238ae"]);
    
}

- (void) testWriteReadDel {
    
//    NSError *err;
    NSURL *caches = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSString *path = [[caches path] stringByAppendingPathComponent:[[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:@"CFBundleIdentifier"]];
    
    NSURL *urlFrom = [[NSBundle bundleForClass:[self class]] URLForResource:@"simpleText" withExtension:@"txt"];
    NSURL *urlTo = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:@"theFile"]];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    [ACFFileUtils writeQuetly:[[NSString alloc] initWithData:[ACFFileUtils readQuetlyForUrl:urlFrom] encoding:NSUTF8StringEncoding] toFile:urlTo];
    
//    XCTAssert([[ACFFileUtils readQuetlyForUrl:urlTo] isEqualToString:[ACFFileUtils readQuetlyForUrl:urlFrom]]);
    
    XCTAssert([ACFFileUtils deleteQuetlyForUrl:urlTo]);
    XCTAssert([ACFFileUtils readQuetlyForUrl:urlTo] == nil);
    
}
@end
