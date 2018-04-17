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
#import "APTunnelConnectionsHandler.h"

@interface APTunnelConnectionHandlerTest : XCTestCase

@end

@implementation APTunnelConnectionHandlerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testDnsReplacement {
    
    APTunnelConnectionsHandler * handler = [[APTunnelConnectionsHandler alloc] initWithProvider:(PacketTunnelProvider *)@"fake"];
    
    NSArray* systemIpv4DNSs = @[[APDnsServerAddress addressWithIp:@"111.111.111.111" port:@"53"],
                                [APDnsServerAddress addressWithIp:@"111.111.111.112" port:@"54"]];
    
    NSArray* systemIpv6DNSs = @[[APDnsServerAddress addressWithIp:@"aa::aa" port:@"53"],
                                [APDnsServerAddress addressWithIp:@"bb::bb" port:@"54"]];
    
    NSArray* remoteIpv4DNSs = @[[APDnsServerAddress addressWithIp:@"222.222.222.222" port:@"53"],
                                [APDnsServerAddress addressWithIp:@"222.222.222.223" port:@"54"]];
    
    NSArray* remoteIpv6DNSs = @[[APDnsServerAddress addressWithIp:@"cc::cc" port:@"53"],
                                [APDnsServerAddress addressWithIp:@"dd::dd" port:@"53"]];
    
    NSArray* fakeIpv4DNSs = @[@"333.333.333.333", @"444.444.444.444"];
    
    NSArray* fakeIpv6DNSs = @[@"ee::ee", @"gg::gg"];
    
    
    [handler setDeviceDnsAddressesIpv4:systemIpv4DNSs
                deviceDnsAddressesIpv6:systemIpv6DNSs
         adguardRemoteDnsAddressesIpv4:remoteIpv4DNSs
         adguardRemoteDnsAddressesIpv6:remoteIpv6DNSs
           adguardFakeDnsAddressesIpv4:fakeIpv4DNSs
           adguardFakeDnsAddressesIpv6:fakeIpv6DNSs];
    
    APDnsServerAddress* whitelisTest = [handler whitelistServerAddressForAddress:@"333.333.333.333"];
    XCTAssertEqualObjects(whitelisTest.ip, @"111.111.111.111");
    XCTAssertEqualObjects(whitelisTest.port, @"53");
    
    APDnsServerAddress* whitelisTest2 = [handler whitelistServerAddressForAddress:@"444.444.444.444"];
    XCTAssertEqualObjects(whitelisTest2.ip, @"111.111.111.112");
    XCTAssertEqualObjects(whitelisTest2.port, @"54");
    
    APDnsServerAddress* remoteTest = [handler serverAddressForFakeDnsAddress:@"333.333.333.333"];
    XCTAssertEqualObjects(remoteTest.ip, @"222.222.222.222");
    XCTAssertEqualObjects(remoteTest.port, @"53");
    
    APDnsServerAddress* remoteTest2 = [handler serverAddressForFakeDnsAddress:@"444.444.444.444"];
    XCTAssertEqualObjects(remoteTest2.ip, @"222.222.222.223");
    XCTAssertEqualObjects(remoteTest2.port, @"54");
}

- (void)testWhitelistDomain {

    APTunnelConnectionsHandler *handler = [[APTunnelConnectionsHandler alloc] initWithProvider:(PacketTunnelProvider *)@"fake"];
    
    AERDomainFilter* filter = [AERDomainFilter filter];
    [filter addRule: [AERDomainFilterRule rule: @"@@||lenta.ru^"]];
    [filter addRule: [AERDomainFilterRule rule: @"@@||domain.com^"]];
    
    [handler setUserWhitelistFilter:filter];
    
    XCTAssert([handler isUserWhitelistDomain:@"www.lenta.ru"]);
    XCTAssert([handler isUserWhitelistDomain:@"lenta.ru"]);
    XCTAssertFalse([handler isUserWhitelistDomain:@"www.lenta.com"]);
    XCTAssertFalse([handler isUserWhitelistDomain:@"wwwlenta.ru"]);

    [handler setUserWhitelistFilter:[AERDomainFilter filter]];

    XCTAssertFalse([handler isUserWhitelistDomain:@"www.lenta.com"]);
}

- (void)testBlacklistDomain {

    APTunnelConnectionsHandler *handler = [[APTunnelConnectionsHandler alloc] initWithProvider:(PacketTunnelProvider *)@"fake"];

    AERDomainFilter* filter = [AERDomainFilter filter];
    [filter addRule: [AERDomainFilterRule rule: @"||lenta.ru^"]];
    [filter addRule: [AERDomainFilterRule rule: @"||domain.com^"]];
    
    [handler setUserBlacklistFilter:filter];
    
    XCTAssert([handler isUserBlacklistDomain:@"www.lenta.ru"]);
    XCTAssert([handler isUserBlacklistDomain:@"lenta.ru"]);
    XCTAssertFalse([handler isUserBlacklistDomain:@"www.lenta.com"]);
    XCTAssertFalse([handler isUserBlacklistDomain:@"wwwlenta.ru"]);

    [handler setUserBlacklistFilter:[AERDomainFilter filter]];

    XCTAssertFalse([handler isUserBlacklistDomain:@"www.lenta.com"]);
}

@end
