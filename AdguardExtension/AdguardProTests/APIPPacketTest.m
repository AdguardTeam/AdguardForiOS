/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2016 Performix LLC. All rights reserved.
 
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
#import "APIPPacket.h"

@interface APIPPacketTest : XCTestCase

@end

@implementation APIPPacketTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPacket {
    
    NSString *packetData = @"69,0,0,63,178,41,0,0,255,17,38,177,169,254,254,2,185,53,129,156,243,247,0,53,0,43,162,8,200,204,1,0,0,1,0,0,0,0,0,0,7,103,117,122,122,111,110,105,5,97,112,112,108,101,3,99,111,109,0,0,1,0,1";
    
    
    NSData *packet = [self packetFromDumpString:packetData];
    
    XCTAssert(packet.length == 63);
    
    APIPPacket *ipPacket = [[APIPPacket alloc] initWithData:packet af:@(AF_INET)];
    
    XCTAssertNotNil(ipPacket);
    XCTAssert(ipPacket.protocol == IPPROTO_UDP);
}
- (void)testChangePacket {
    
    NSString *packetData = @"69,0,0,99,195,22,0,0,255,17,21,160,169,254,254,2,185,53,129,156,250,183,0,53,0,79,230,247,70,214,1,0,0,1,0,0,0,0,0,0,27,112,51,54,45,107,101,121,118,97,108,117,101,115,101,114,118,105,99,101,45,99,117,114,114,101,110,116,4,101,100,103,101,6,105,99,108,111,117,100,9,97,112,112,108,101,45,100,110,115,3,110,101,116,0,0,1,0,1";
    
    
    NSData *packet = [self packetFromDumpString:packetData];
    
    XCTAssert(packet.length == 99);
    
    APIPPacket *ipPacket = [[APIPPacket alloc] initWithData:packet af:@(AF_INET)];
    
    XCTAssert(ipPacket.protocol == IPPROTO_UDP);
    
    ipPacket.srcAddress = @"1.1.1.1";
    ipPacket.dstAddress = @"2.2.2.2";

    NSString *testString = @"Test string";
    ipPacket.payload = [testString dataUsingEncoding:NSUTF8StringEncoding];
    
    XCTAssert([ipPacket.srcAddress isEqualToString:@"1.1.1.1"]);
    XCTAssert([ipPacket.dstAddress isEqualToString:@"2.2.2.2"]);
    
    NSString *newTestString = [[NSString alloc] initWithData:ipPacket.payload encoding:NSUTF8StringEncoding];
    XCTAssert([testString isEqualToString:newTestString]);
}

/*
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
*/

- (NSData *)packetFromDumpString:(NSString *)dumpString{
    
    NSArray *bytes = [dumpString componentsSeparatedByString:@","];
    
    NSMutableData *_data = [NSMutableData dataWithLength:bytes.count];
    
    Byte *buffer = (Byte *)_data.mutableBytes;
    [bytes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        *(buffer + idx) = (Byte)[obj intValue];
    }];
    
    return _data;
}

@end
