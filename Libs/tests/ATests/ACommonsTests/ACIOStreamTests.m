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
#import <CoreFoundation/CoreFoundation.h>
#import "ACIOStream.h"

#define BUFFER_SIZE 1024

@interface ACIOStreamTests : XCTestCase <ACIOStreamDelegate>{

    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;

}

@end

@implementation ACIOStreamTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testHttpConnection
{
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"ya.ru", 80, &readStream, &writeStream);
    XCTAssert(readStream != nil);
    XCTAssert(writeStream != nil);
    CFReadStreamOpen(readStream);
    CFWriteStreamOpen(writeStream);
    
    ACIOStream *stream = [[ACIOStream alloc] initWithDelegate:self];
    char bytes[] = "GET / HTTP/1.0\r\n\r\n";
    [stream write:(const uint8_t *)bytes maxLength:strlen(bytes)];
    char buf[BUFFER_SIZE];
    NSInteger count = [stream read:(uint8_t *)buf maxLength:BUFFER_SIZE];
    XCTAssert(count > 0);
    
    CFWriteStreamClose(writeStream);
    CFReadStreamClose(readStream);
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len stream:(ACIOStream *)stream{
    
    return CFReadStreamRead(readStream, buffer, len);
}

- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len stream:(ACIOStream *)stream{
    
    return CFWriteStreamWrite(writeStream, buffer, len);
}

@end
