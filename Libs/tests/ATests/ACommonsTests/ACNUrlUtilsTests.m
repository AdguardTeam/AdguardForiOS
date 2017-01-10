//
//  ACNUrlUtilsTests.m
//  ATests
//
//  Created by Roman Sokolov on 11.01.17.
//
//

#import "ACNetwork.h"
#import <XCTest/XCTest.h>

@interface ACNUrlUtilsTests : XCTestCase

@end

@implementation ACNUrlUtilsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testIPAddressCheckers {
    
    XCTAssertFalse([ACNUrlUtils isIPv4:@"0.521.12"]);
    XCTAssertFalse([ACNUrlUtils isIPv4:@"256.21.12.6"]);
    XCTAssertFalse([ACNUrlUtils isIPv4:@"0.0.text"]);
    XCTAssertFalse([ACNUrlUtils isIPv4:@"0.0000.000.000"]);
    
    XCTAssert([ACNUrlUtils isIPv4:@"127.01.12.1"]);
    XCTAssert([ACNUrlUtils isIPv4:@"255.255.255.255"]);
    XCTAssert([ACNUrlUtils isIPv4:@"0.0.0.1"]);

    XCTAssertFalse([ACNUrlUtils isIPv6:@"127.01.12.1"]);
    XCTAssertFalse([ACNUrlUtils isIPv6:@"FF:OPA::1"]);
    XCTAssertFalse([ACNUrlUtils isIPv6:@"0.0.text"]);
    XCTAssertFalse([ACNUrlUtils isIPv6:@"0.0000.000.000"]);
    
    XCTAssert([ACNUrlUtils isIPv6:@"fe80:0000:0000:0000:0204:61ff:fe9d:f156"]);        // full form of IPv6
    XCTAssert([ACNUrlUtils isIPv6:@"fe80:0:0:0:204:61ff:fe9d:f156"]);                  // drop leading zeroes
    XCTAssert([ACNUrlUtils isIPv6:@"fe80::204:61ff:fe9d:f156"]);                       // collapse multiple zeroes to :: in the IPv6 address
    XCTAssert([ACNUrlUtils isIPv6:@"fe80:0000:0000:0000:0204:61ff:254.157.241.86"]);   // IPv4 dotted quad at the end
    XCTAssert([ACNUrlUtils isIPv6:@"fe80:0:0:0:0204:61ff:254.157.241.86"]);            // drop leading zeroes, IPv4 dotted quad at the end
    XCTAssert([ACNUrlUtils isIPv6:@"fe80::204:61ff:254.157.241.86"]);                  // dotted quad at the end, multiple zeroes collapsed
    
    XCTAssert([ACNUrlUtils isIPv6:@"::1"]);        // localhost
    XCTAssert([ACNUrlUtils isIPv6:@"fe80::"]);     // link-local prefix
    XCTAssert([ACNUrlUtils isIPv6:@"2001::"]);     // global unicast prefix
}

- (void)testNSURLPath{
    
    XCTAssert([[[ACNUrlUtils URLWithString:@"lenta.ru"] path] isEqualToString:@"lenta.ru"]);
    XCTAssert([[[ACNUrlUtils URLWithString:@"http://lenta.ru"] path] isEqualToString:@""]);
    XCTAssert([[[ACNUrlUtils URLWithString:@"http://lenta.ru/"] path] isEqualToString:@"/"]);
    XCTAssert([[[ACNUrlUtils URLWithString:@"http://lenta.ru?param=1&param=2"] path] isEqualToString:@""]);
    XCTAssert([[[ACNUrlUtils URLWithString:@"http://lenta.ru/this/is/path.txt"] path] isEqualToString:@"/this/is/path.txt"]);
    XCTAssert([[[ACNUrlUtils URLWithString:@"http://lenta.ru/this/is/path.txt?param=1"] path] isEqualToString:@"/this/is/path.txt"]);
    XCTAssert([[[ACNUrlUtils URLWithString:@"http://syndication.twitter.com/tweets.json?ids=524936293965643776&lang=en&callback=twttr.tfw.callbacks.cb0&suppress_response_codes=true"] path] isEqualToString:@"/tweets.json"]);
    XCTAssert([[[ACNUrlUtils URLWithString:@"http://lenta.ru:8082"] path] isEqualToString:@""]);
    XCTAssert([[[ACNUrlUtils URLWithString:@"http://lenta.ru:8082?"] path] isEqualToString:@""]);
}

- (void)testHost{
    
    XCTAssert([[ACNUrlUtils host:@"http://lenta.ru?param=1&param=2"] isEqualToString:@"lenta.ru"]);
    XCTAssert([[ACNUrlUtils host:@"http://lenta.ru:8082"] isEqualToString:@"lenta.ru"]);
    XCTAssert([[ACNUrlUtils host:@"http://lenta.ru:8082?"] isEqualToString:@"lenta.ru"]);
    XCTAssert([[ACNUrlUtils host:@"http://lenta.ru:12/?param=1&param=2"] isEqualToString:@"lenta.ru"]);
    XCTAssert([[ACNUrlUtils host:@"//lenta.ru:8082/"] isEqualToString:@"lenta.ru"]);
    XCTAssert([[ACNUrlUtils host:@"//lenta.ru:"] isEqualToString:@"lenta.ru"]);
    
}


- (void)testFragment{
    
    NSURL *url = [ACNUrlUtils URLWithString:@"lenta.ru#fragment"];
    NSString *fragment = url.fragment;
    XCTAssert([fragment isEqualToString:@"fragment"]);
    fragment = [[ACNUrlUtils URLWithString:@"http://lenta.ru/opa?tipa=ww#фрагмент"] fragment];
    fragment = [fragment stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    XCTAssert([fragment isEqualToString:@"фрагмент"]);
}



@end
