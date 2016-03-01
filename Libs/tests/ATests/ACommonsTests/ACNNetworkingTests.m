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
#import "ACommons/ACNetwork.h"

@interface ACNNetworkingTests : XCTestCase{
    BOOL ok;
    NSTimer *timer;
    NSUInteger taskCounter;
}

@end

@implementation ACNNetworkingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [DDLog removeAllLoggers];
}

- (void)testGoodData {

    [ACNNetworking dataWithURL:[NSURL URLWithString:@"http://yandex.ru/favicon.ico"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
        XCTAssertNil(error, @"Error occurs:\n%@", [error localizedDescription]);
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        XCTAssert((([httpResponse statusCode]/100) == 2));
        
        XCTAssertNotNil(data, @"Error occurs: Empty data returned.");
        
        DDLogError(@"Data:\n%@", data);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ok = YES;
            [timer invalidate];
        });
    }];
    
    timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    while (!ok && [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:30]]) {
        
    }
}

- (void)testBadData {
    
 void (^completionHandler)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
    
     if (error) {
         DDLogError(@"Error occurs:\n%@", [error localizedDescription]);
     }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    DDLogError(@"Response statusCode: %lu", [httpResponse statusCode]);
    
     if (data) {
         DDLogError(@"Data:\n%@", data);
     }
     taskCounter--;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!taskCounter) {
            [timer invalidate];
        }
    });
};

    
    taskCounter = 3;
    [ACNNetworking dataWithURL:[NSURL URLWithString:@"http://yandex.ru/badData"] completionHandler:completionHandler];
    [ACNNetworking dataWithURL:[NSURL URLWithString:@"http://bbbb.aaa.ddd.dddd.aaa.ttt.a/badData"] completionHandler:completionHandler];
    [ACNNetworking dataWithURL:[NSURL URLWithString:@"baddata"] completionHandler:completionHandler];
    
    timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    while (taskCounter && [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:30]]) {
        
    }
}


- (void)timerFired:(NSTimer *)timer{
    
    ok = YES;
    taskCounter = 0;
}

@end
