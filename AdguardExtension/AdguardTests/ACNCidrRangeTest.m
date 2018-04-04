/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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
#import "ACNCidrRange.h"
#import "NSString+Utils.h"

@interface ACNCidrRangeTest : XCTestCase

@end

@implementation ACNCidrRangeTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) testUtilMethod {
    
    /* Shortened at end */
    NSString *expanded1 = [ACNCidrRange expandIPv6String:@"2000::"];
    XCTAssertEqualObjects(@"2000:0:0:0:0:0:0:0", expanded1);
    /* Shortened at begin */
    NSString *expanded2 = [ACNCidrRange expandIPv6String: @"::ffff:aaaa:bbbb"];
    XCTAssertEqualObjects(@"0:0:0:0:0:ffff:aaaa:bbbb", expanded2);
    /* Shortened in the middle */
    NSString *expanded3 = [ACNCidrRange expandIPv6String:@"2001:db8:a::1"];
    XCTAssertEqualObjects(@"2001:db8:a:0:0:0:0:1", expanded3);
    
    /* Error! */
    NSString *expanded4 = nil;
    @try {
        expanded4 = [ACNCidrRange expandIPv6String: @"2001:db8::a::1"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    XCTAssertNil(expanded4);
    
    /* Zero replaced by "::", has 8 ":"s but still valid */
    NSString *expanded5 = [ACNCidrRange expandIPv6String: @"1:2:3:4:5:6:7::"];
    XCTAssertEqualObjects(@"1:2:3:4:5:6:7:0", expanded5);
    /* Zero replaced by "::", has 8 ":"s but still valid */
    NSString *expanded6 =  [ACNCidrRange expandIPv6String: @"::1:2:3:4:5:6:7"];
    XCTAssertEqualObjects(@"0:1:2:3:4:5:6:7", expanded6);

    NSString *shortened1 = [ACNCidrRange shortenIPv6String:@"0:0:0:0:0:0:0:0"];
    XCTAssertEqualObjects(@"::", shortened1);
    NSString * shortened2 = [ACNCidrRange shortenIPv6String:@"0000:0000:0000:0000:0000:0000:0000:1"];
    XCTAssertEqualObjects(@"::1", shortened2);
    NSString * shortened3 = [ACNCidrRange shortenIPv6String:@"2000:0:0:0:0:0:0:0"];
    XCTAssertEqualObjects(@"2000::", shortened3);
    NSString * shortened4 = [ACNCidrRange shortenIPv6String:@"0202:0000::0:0:0:0"];
    XCTAssertEqualObjects(@"202::", shortened4);
    NSString * shortened5 = [ACNCidrRange shortenIPv6String:@"1:0:0:0:0:1:0:0"];
    XCTAssertEqualObjects(@"1::1:0:0", shortened5);
    NSString * shortened6 = [ACNCidrRange shortenIPv6String:@"1:0:1:1:1:1:1:1"];
    XCTAssertEqualObjects(@"1:0:1:1:1:1:1:1", shortened6);

    NSArray *addr1 = [ACNCidrRange getAddressFromString:@"127.0.0.1"];
    NSArray *result1 = @[@(127), @(0), @(0), @(1)];
    XCTAssertEqualObjects(result1, addr1);
    NSArray *addr2 = [ACNCidrRange getAddressFromString:@"::ffff:127.0.0.1"];
    NSArray *result2 = @[@(0), @(0), @(0), @(0), @(0), @(0), @(0), @(0), @(0), @(0), @(0xff), @(0xff), @(127), @(0), @(0), @(1)];
    XCTAssertEqualObjects(result2, addr2);
    NSArray *addr3 = [ACNCidrRange getAddressFromString: @"2001:db8:a::1"];
    NSArray *result3 = @[@(0x20), @(0x01), @(0xd), @(0xb8), @(0), @(0xa), @(0), @(0), @(0), @(0), @(0), @(0), @(0), @(0), @(0), @(1)];
    XCTAssertEqualObjects(result3, addr3);
}

- (void) testCreate {
    ACNCidrRange *range1 = [[ACNCidrRange alloc] initWithCidrString:@"2000::/3"];
    ACNCidrRange *range2 = [[ACNCidrRange alloc] initWithCidrString:@"2000::/3"];
    XCTAssertEqualObjects(range1, range2);
    ACNCidrRange *range3 = [[ACNCidrRange alloc] initWithCidrString:@"172.16.0.0/16"];
    ACNCidrRange *range4 = [[ACNCidrRange alloc] initWithCidrString:@"172.16.0.0/16"];
    XCTAssertEqualObjects(range3, range4);
}

- (void) testSplit {
    [self testSplitWithOriginal:@"::/0" left:@"::/1" right:@"8000::/1"];
    [self testSplitWithOriginal:@"::/1" left:@"::/2" right:@"4000::/2"];
    [self testSplitWithOriginal:@"::/2" left:@"::/3" right:@"2000::/3"];
    [self testSplitWithOriginal:@"2000::/3" left:@"2000::/4" right:@"3000::/4"];
    [self testSplitWithOriginal:@"2000::/4" left:@"2000::/5" right:@"2800::/5"];
    [self testSplitWithOriginal:@"2000::/5" left:@"2000::/6" right:@"2400::/6"];
    [self testSplitWithOriginal:@"2400::/6" left:@"2400::/7" right:@"2600::/7"];
    [self testSplitWithOriginal:@"2600::/7" left:@"2600::/8" right:@"2700::/8"];
    [self testSplitWithOriginal:@"2600::/8" left:@"2600::/9" right:@"2680::/9"];
    [self testSplitWithOriginal:@"2600::/9" left:@"2600::/10" right:@"2640::/10"];
    [self testSplitWithOriginal:@"2600::/15" left:@"2600::/16" right:@"2601::/16"];
}

- (void) testSplitWithOriginal:(NSString*) original left:(NSString*) splittedLeft right:(NSString*) splittedRight {
    ACNCidrRange *range = [[ACNCidrRange alloc] initWithCidrString:original];
    ACNCidrRange *rangeLeftExp = [[ACNCidrRange alloc] initWithCidrString:splittedLeft];
    ACNCidrRange *rangeRightExp = [[ACNCidrRange alloc] initWithCidrString:splittedRight];
    NSArray<ACNCidrRange*> *splittedRange = [range split];
    XCTAssertNotNil(splittedRange);
    XCTAssertEqualObjects(rangeLeftExp, splittedRange[0]);
    XCTAssertEqualObjects(rangeRightExp, splittedRange[1]);
}

- (void) testContains {
    ACNCidrRange *range1 = [[ACNCidrRange alloc] initWithCidrString:@"2000::/3"];
    ACNCidrRange *range2 = [[ACNCidrRange alloc] initWithCidrString:@"4000::/3"];
    ACNCidrRange *smallRange1 = [[ACNCidrRange alloc] initWithCidrString:@"2600:1000::/28"];
    ACNCidrRange *smallRange2 = [[ACNCidrRange alloc] initWithCidrString:@"2600:1010::/29"];
    XCTAssertTrue([range1 contains:smallRange1]);
    XCTAssertTrue([range1 contains:smallRange2]);
    XCTAssertFalse([range2 contains:smallRange1]);
    XCTAssertFalse([range2 contains:smallRange2]);
}

- (void) testExcludeIpv6 {
    ACNCidrRange *range = [[ACNCidrRange alloc] initWithCidrString:@"2000::/3"];
    NSMutableArray<ACNCidrRange*> *originalRanges = [NSMutableArray new];
    [originalRanges addObject: range];
    
    ACNCidrRange *excludedRange1 = [[ACNCidrRange alloc] initWithCidrString:@"2600:1000::/28"];
    ACNCidrRange *excludedRange2 = [[ACNCidrRange alloc] initWithCidrString:@"2600:1010::/29"];
    NSArray<ACNCidrRange*> *excludedRanges = @[excludedRange1, excludedRange2];
    
    [self testExcludingRangesOriginalRanges: originalRanges excludedRanges: excludedRanges];
}

- (void) testExcludingRangesOriginalRanges: (NSArray*)originalRanges excludedRanges: (NSArray*) excludedRanges {
    NSArray* resultingRanges = [ACNCidrRange excludeFrom:originalRanges excludedRanges:excludedRanges];
    
    // Check that list is sorted
    NSArray *resultingRangesSorted = [resultingRanges sortedArrayUsingSelector:@selector(compare:)];
    
    XCTAssertEqualObjects(resultingRanges, resultingRangesSorted);
    
    // Check that list doesn't contain all excluded routes
    for (ACNCidrRange *resultingRange in resultingRanges) {
        for (ACNCidrRange *excludedRange in excludedRanges) {
            XCTAssertFalse([resultingRange contains:excludedRange]);
        }
    }

    // todo: add bigint library and check ip numbers
//    BigInteger ipsNum = numberOfIps(resultingRanges);
//    BigInteger ipsNumExc = numberOfIps(excludedRanges);
//    BigInteger ipsNumWithExc = ipsNum.add(ipsNumExc);
//
//    System.out.println(String.format("Number of IPs in original ranges:               %32x", numberOfIps(originalRanges)));
//    System.out.println(String.format("Number of IPs in excluded ranges:               %32x", ipsNumExc));
//    System.out.println(String.format("Number of IPs in resulting ranges:              %32x", ipsNum));
//    System.out.println(String.format("Number of IPs in excluded and resulting ranges: %32x", ipsNumWithExc));
//
//    assertEquals(numberOfIps(originalRanges), ipsNumWithExc);
}

- (void) testExcludeIpv4 {
    ACNCidrRange *range = [[ACNCidrRange alloc] initWithCidrString:@"0.0.0.0/0"];
    NSArray *originalRanges = @[range];
    
    // Always exclude multicast
    ACNCidrRange *excludedRange1 = [[ACNCidrRange alloc] initWithCidrString:@"224.0.0.0/3"];
    // Exclude test IP
    ACNCidrRange *excludedRange2 = [[ACNCidrRange alloc] initWithCidrString:@"1.2.3.4"];
    NSArray *excludedRanges = @[excludedRange1, excludedRange2];
    
    [self testExcludingRangesOriginalRanges:originalRanges excludedRanges:excludedRanges];
}

/**
 * Reads exclusions from string
 * @param exclusions String with exclusions from advanced settings
 * @return List of excluded subnets
 */
- (NSArray<ACNCidrRange*> *) readExclusions:(NSString*) exclusions {
    
    NSArray<NSString*> *lines = [exclusions componentsSeparatedByString:@"\n"];
    
    // First calculating excluded subnets
    NSMutableArray<ACNCidrRange*> *excludedSubNets = [NSMutableArray new];
    for (NSString *line in lines) {
        
        NSString *cidr = [NSString stringByTrim:line];
        
        if (cidr.length && ![cidr hasPrefix:@"//"]) {
            @try {
                ACNCidrRange *range = [[ACNCidrRange alloc] initWithCidrString: cidr];
                [excludedSubNets addObject:range];
            }
            @catch (NSException *ex){
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot convert cidr" userInfo:nil];
            }
        }
    }
    return excludedSubNets;
}

- (void) testExclusionsToCidrLis {
    NSString *exclusions = @"// Reserved subnets\n"
    @"0.0.0.0/8\n"
    @"10.0.0.0/8\n"
    @"100.64.0.0/10\n"
    @"172.16.0.0/12\n"
    @"192.0.0.0/24\n"
    @"192.168.0.0/16\n"
    @"224.0.0.0/4\n"
    @"240.0.0.0/4\n"
    @"255.255.255.255/32\n"
    @"\n"
    @"// T-Mobile wi-fi calling (#233)\n"
    @"208.54.0.0/16\n"
    @"\n"
    @"// UK EE wi-fi calling (#582)\n"
    @"109.249.0.0/16";
    
    NSArray *excludedSubNets = [self readExclusions:exclusions];
    
    XCTAssertEqual(11, excludedSubNets.count);
    
    NSArray *originalRanges = [ACNCidrRange excludeFrom:[[ACNCidrRange alloc] initWithCidrString:@"0.0.0.0/0"] excludedRange:[[ACNCidrRange alloc] initWithCidrString:@"224.0.0.0/3"]];
    
    NSArray *includedSubNets = [ACNCidrRange excludeFrom:originalRanges excludedRanges:excludedSubNets];
    
    // Same count as in old IpAddressUtils after converting ranges to cidr lists
    XCTAssertEqual(74, includedSubNets.count);
}

- (void) testExclusion {
    
    NSArray *excludeIpv6cidrs = @[
                                  @"2001:ad00:ad00::/113",
                                  @"2001:ad00:ad00::8000/115",
                                  @"2001:ad00:ad00::a000/117",
                                  @"2001:ad00:ad00::a800/118",
                                  @"2001:ad00:ad00::ac00/120",
                                  @"2001:ad00::/33",
                                  @"2001:ad00:8000::/35",
                                  @"2001:ad00:a000::/37",
                                  @"2001:ad00:a800::/38",
                                  @"2001:ad00:ac00::/40",
                                  @"2001::/17",
                                  @"2001:8000::/19",
                                  @"2001:a000::/21",
                                  @"2001:a800::/22",
                                  @"2001:ac00::/24",
                                  @"2000::/16",
                                  @"::/3",
                                  @"2001:ad00:ad00::ad02/127",
                                  @"2001:ad00:ad00::ad04/126",
                                  @"2001:ad00:ad00::ad08/125",
                                  @"2001:ad00:ad00::ad10/124",
                                  @"2001:ad00:ad00::ad20/123",
                                  @"2001:ad00:ad00::ad40/122",
                                  @"2001:ad00:ad00::ad80/121",
                                  @"2001:ad00:ad00::ae00/119",
                                  @"2001:ad00:ad00::b000/116",
                                  @"2001:ad00:ad00::c000/114",
                                  @"2001:ad00:ad00::1:0/112",
                                  @"2001:ad00:ad00::2:0/111",
                                  @"2001:ad00:ad00::4:0/110",
                                  @"2001:ad00:ad00::8:0/109",
                                  @"2001:ad00:ad00::10:0/108",
                                  @"2001:ad00:ad00::20:0/107",
                                  @"2001:ad00:ad00::40:0/106",
                                  @"2001:ad00:ad00::80:0/105",
                                  @"2001:ad00:ad00::100:0/104",
                                  @"2001:ad00:ad00::200:0/103",
                                  @"2001:ad00:ad00::400:0/102",
                                  @"2001:ad00:ad00::800:0/101",
                                  @"2001:ad00:ad00::1000:0/100",
                                  @"2001:ad00:ad00::2000:0/99",
                                  @"2001:ad00:ad00::4000:0/98",
                                  @"2001:ad00:ad00::8000:0/97",
                                  @"2001:ad00:ad00::1:0:0/96",
                                  @"2001:ad00:ad00::2:0:0/95",
                                  @"2001:ad00:ad00::4:0:0/94",
                                  @"2001:ad00:ad00::8:0:0/93",
                                  @"2001:ad00:ad00::10:0:0/92",
                                  @"2001:ad00:ad00::20:0:0/91",
                                  @"2001:ad00:ad00::40:0:0/90",
                                  @"2001:ad00:ad00::80:0:0/89",
                                  @"2001:ad00:ad00::100:0:0/88",
                                  @"2001:ad00:ad00::200:0:0/87",
                                  @"2001:ad00:ad00::400:0:0/86",
                                  @"2001:ad00:ad00::800:0:0/85",
                                  @"2001:ad00:ad00::1000:0:0/84",
                                  @"2001:ad00:ad00::2000:0:0/83",
                                  @"2001:ad00:ad00::4000:0:0/82",
                                  @"2001:ad00:ad00::8000:0:0/81",
                                  @"2001:ad00:ad00:0:1::/80",
                                  @"2001:ad00:ad00:0:2::/79",
                                  @"2001:ad00:ad00:0:4::/78",
                                  @"2001:ad00:ad00:0:8::/77",
                                  @"2001:ad00:ad00:0:10::/76",
                                  @"2001:ad00:ad00:0:20::/75",
                                  @"2001:ad00:ad00:0:40::/74",
                                  @"2001:ad00:ad00:0:80::/73",
                                  @"2001:ad00:ad00:0:100::/72",
                                  @"2001:ad00:ad00:0:200::/71",
                                  @"2001:ad00:ad00:0:400::/70",
                                  @"2001:ad00:ad00:0:800::/69",
                                  @"2001:ad00:ad00:0:1000::/68",
                                  @"2001:ad00:ad00:0:2000::/67",
                                  @"2001:ad00:ad00:0:4000::/66",
                                  @"2001:ad00:ad00:0:8000::/65",
                                  @"2001:ad00:ad00:1::/64",
                                  @"2001:ad00:ad00:2::/63",
                                  @"2001:ad00:ad00:4::/62",
                                  @"2001:ad00:ad00:8::/61",
                                  @"2001:ad00:ad00:10::/60",
                                  @"2001:ad00:ad00:20::/59",
                                  @"2001:ad00:ad00:40::/58",
                                  @"2001:ad00:ad00:80::/57",
                                  @"2001:ad00:ad00:100::/56",
                                  @"2001:ad00:ad00:200::/55",
                                  @"2001:ad00:ad00:400::/54",
                                  @"2001:ad00:ad00:800::/53",
                                  @"2001:ad00:ad00:1000::/52",
                                  @"2001:ad00:ad00:2000::/51",
                                  @"2001:ad00:ad00:4000::/50",
                                  @"2001:ad00:ad00:8000::/49",
                                  @"2001:ad00:ad01::/48",
                                  @"2001:ad00:ad02::/47",
                                  @"2001:ad00:ad04::/46",
                                  @"2001:ad00:ad08::/45",
                                  @"2001:ad00:ad10::/44",
                                  @"2001:ad00:ad20::/43",
                                  @"2001:ad00:ad40::/42",
                                  @"2001:ad00:ad80::/41",
                                  @"2001:ad00:ae00::/39",
                                  @"2001:ad00:b000::/36",
                                  @"2001:ad00:c000::/34",
                                  @"2001:ad01::/32",
                                  @"2001:ad02::/31",
                                  @"2001:ad04::/30",
                                  @"2001:ad08::/29",
                                  @"2001:ad10::/28",
                                  @"2001:ad20::/27",
                                  @"2001:ad40::/26",
                                  @"2001:ad80::/25",
                                  @"2001:ae00::/23",
                                  @"2001:b000::/20",
                                  @"2001:c000::/18",
                                  @"2002::/15",
                                  @"2004::/14",
                                  @"2008::/13",
                                  @"2010::/12",
                                  @"2020::/11",
                                  @"2040::/10",
                                  @"2080::/9",
                                  @"2100::/8",
                                  @"2200::/7",
                                  @"2400::/6",
                                  @"2800::/5",
                                  @"3000::/4",
                                  @"4000::/2",
                                  @"8000::/1",
                                  ];
    
    ACNCidrRange *defaultRoute = [[ACNCidrRange alloc]initWithCidrString:@"::/0"];
    NSArray<ACNCidrRange*> * dnsRanges = @[
                                           [[ACNCidrRange alloc]initWithCidrString:@"2001:ad00:ad00::ad00"],
                                           [[ACNCidrRange alloc]initWithCidrString:@"2001:ad00:ad00::ad01"]
                                           ];
    NSArray<ACNCidrRange*> *excludedRanges = [ACNCidrRange excludeFrom:@[defaultRoute] excludedRanges:dnsRanges];
    
    XCTAssertEqual(excludedRanges.count, excludeIpv6cidrs.count);
    
    NSArray *resultArray = [excludeIpv6cidrs sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray<NSString*> *excludedArray = [NSMutableArray new];
    for (ACNCidrRange* range in excludedRanges) {
        [excludedArray addObject:[range toString]];
    }
    [excludedArray sortUsingSelector:@selector(compare:)];
    
    for (ACNCidrRange* range in excludedRanges) {
        
        XCTAssertFalse([range contains:dnsRanges[0]]);
        XCTAssertFalse([range contains:dnsRanges[1]]);
    }
    
    XCTAssertEqualObjects(resultArray, excludedArray);
}

- (void) testExclusion2 {
    
    NSArray* excludeIpv4Cidrs = @[
                                  
                                  @"0.0.0.1/32",
                                  @"0.0.0.2/31",
                                  @"0.0.0.4/30",
                                  @"0.0.0.8/29",
                                  @"0.0.0.16/28",
                                  @"0.0.0.32/27",
                                  @"0.0.0.64/26",
                                  @"0.0.0.128/25",
                                  @"0.0.1.0/24",
                                  @"0.0.2.0/23",
                                  @"0.0.4.0/22",
                                  @"0.0.8.0/21",
                                  @"0.0.16.0/20",
                                  @"0.0.32.0/19",
                                  @"0.0.64.0/18",
                                  @"0.0.128.0/17",
                                  @"0.1.0.0/16",
                                  @"0.2.0.0/15",
                                  @"0.4.0.0/14",
                                  @"0.8.0.0/13",
                                  @"0.16.0.0/12",
                                  @"0.32.0.0/11",
                                  @"0.64.0.0/10",
                                  @"0.128.0.0/9",
                                  @"1.0.0.0/8",
                                  @"2.0.0.0/7",
                                  @"4.0.0.0/6",
                                  @"8.0.0.0/5",
                                  @"16.0.0.0/4",
                                  @"32.0.0.0/3",
                                  
                                  @"64.0.0.0/3",
                                  @"96.0.0.0/4",
                                  @"112.0.0.0/5",
                                  @"120.0.0.0/8",
                                  @"121.0.0.0/10",
                                  @"121.64.0.0/11",
                                  @"121.96.0.0/12",
                                  @"121.112.0.0/13",
                                  @"121.120.0.0/16",
                                  @"121.121.0.0/18",
                                  @"121.121.64.0/19",
                                  @"121.121.96.0/20",
                                  @"121.121.112.0/21",
                                  @"121.121.120.0/24",
                                  @"121.121.121.0/26",
                                  @"121.121.121.64/27",
                                  @"121.121.121.96/28",
                                  @"121.121.121.112/29",
                                  @"121.121.121.120/32",
                                  @"121.121.121.125/32",
                                  @"121.121.121.126/31",
                                  @"121.121.121.128/25",
                                  @"121.121.122.0/23",
                                  @"121.121.124.0/22",
                                  @"121.121.128.0/17",
                                  @"121.122.0.0/15",
                                  @"121.124.0.0/14",
                                  @"121.128.0.0/9",
                                  @"122.0.0.0/7",
                                  @"124.0.0.0/6",
                                  @"128.0.0.0/1",
                                  ];
    
    ACNCidrRange *defaultRoute = [[ACNCidrRange alloc]initWithCidrString:@"0.0.0.0/0"];
    NSArray<ACNCidrRange*> * dnsRanges = @[
                                           [[ACNCidrRange alloc]initWithCidrString:@"121.121.121.121"],
                                           [[ACNCidrRange alloc]initWithCidrString:@"121.121.121.122"],
                                           [[ACNCidrRange alloc]initWithCidrString:@"121.121.121.123"],
                                           [[ACNCidrRange alloc]initWithCidrString:@"121.121.121.124"],
                                           [[ACNCidrRange alloc]initWithCidrString:@"0.0.0.0/32"]
                                           ];
    NSArray<ACNCidrRange*> *excludedRanges = [ACNCidrRange excludeFrom:@[defaultRoute] excludedRanges:dnsRanges];
    
    XCTAssertEqual(excludedRanges.count, excludeIpv4Cidrs.count);
    
    NSArray *resultArray = [excludeIpv4Cidrs sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray<NSString*> *excludedArray = [NSMutableArray new];
    for (ACNCidrRange* range in excludedRanges) {
        [excludedArray addObject:[range toString]];
    }
    [excludedArray sortUsingSelector:@selector(compare:)];
    
    for (ACNCidrRange* range in excludedRanges) {
        
        XCTAssertFalse([range contains:dnsRanges[0]]);
        XCTAssertFalse([range contains:dnsRanges[1]]);
        XCTAssertFalse([range contains:dnsRanges[2]]);
        XCTAssertFalse([range contains:dnsRanges[3]]);
    }
    
    XCTAssertEqualObjects(resultArray, excludedArray);
}

- (void)testPerformanceExample {
    [self measureBlock:^{
    }];
}

@end
