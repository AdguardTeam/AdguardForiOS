//
//  AERDomainFilterTest.m
//  Adguard
//
//  Created by Roman Sokolov on 27.03.17.
//  Copyright © 2017 Performiks. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AERDomainFilter.h"

@interface AERDomainFilterTest : XCTestCase

@end

@implementation AERDomainFilterTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDomainFilter {
    
    AERDomainFilter *filter = [AERDomainFilter filter];
    
    [filter addRule:[AERDomainFilterRule rule:@"||anet*.tradedoubler.com^"]];
    [filter addRule:[AERDomainFilterRule rule:@"@@://googleadservices.com"]];
    [filter addRule:[AERDomainFilterRule rule:@"@@|https://www.googleadservices.com"]];
    [filter addRule:[AERDomainFilterRule rule:@"|www.domain.com|"]];
    [filter addRule:[AERDomainFilterRule rule:@"www.domain2.com^"]];
    [filter addRule:[AERDomainFilterRule rule:@"||www.blacklist.com^"]];
    [filter addRule:[AERDomainFilterRule rule:@"@@||www.whitelist.com^"]];

    [filter addRule:[AERDomainFilterRule rule:@"@@*"]];

    AERDomainFilterRule *rule = [filter filteredDomain:@"superanet.tradedoubler.com"];
    XCTAssertNil(rule);
    
    [filter addRule:[AERDomainFilterRule rule:@"*anet*.tra*dedoubler.com**"]];
    rule = [filter filteredDomain:@"superanet.tradedoubler.com"];
    XCTAssert(rule);
    
    rule = [filter filteredDomain:@"superanet.tra.tata.dedoubler.com.con"];
    XCTAssert(rule);

    rule = [filter filteredDomain:@"super.anet.tradedoubler.com"];
    XCTAssert(rule);
    
    rule = [filter filteredDomain:@"anet.privet.tradedoubler.com"];
    XCTAssert(rule);
    
    rule = [filter filteredDomain:@"www.domain.com"];
    XCTAssert(rule);
    
    rule = [filter filteredDomain:@"subdomain.www.blacklist.com"];
    XCTAssert(rule);
    
    rule = [filter filteredDomain:@"www.whitelist.com"];
    XCTAssert(rule);
    XCTAssert(rule.isWhiteListRule);

    rule = [filter filteredDomain:@"googleadservices.com"];
    XCTAssert(rule);
    XCTAssert(rule.isWhiteListRule);

    rule = [filter filteredDomain:@"www.googleadservices.com"];
    XCTAssert(rule);
    XCTAssert(rule.isWhiteListRule);

    rule = [filter filteredDomain:@"subdomain.googleadservices.com"];
    XCTAssertNil(rule);
    
    rule = [filter filteredDomain:@"bad.domain.com"];
    XCTAssertNil(rule);
    
}

@end
