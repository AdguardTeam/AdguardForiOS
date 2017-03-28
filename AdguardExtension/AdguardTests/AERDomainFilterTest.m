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

- (void)testDomainRule {
    
    AERDomainFilterRule *rule = [AERDomainFilterRule rule:@"||anet*.tradedoubler.com^"];
    XCTAssertTrue(rule.maskRule);
    XCTAssertTrue(rule.withSubdomainsRule);
    XCTAssertFalse(rule.whiteListRule);
    XCTAssert([rule.domainPattern isEqualToString:@"anet*.tradedoubler.com"]);
    
    rule = [AERDomainFilterRule rule:@"||anet.tradedoubler.com^"];
    XCTAssertFalse(rule.maskRule);
    XCTAssertTrue(rule.withSubdomainsRule);
    XCTAssertFalse(rule.whiteListRule);
    XCTAssert([rule.domainPattern isEqualToString:@"anet.tradedoubler.com"]);

    rule = [AERDomainFilterRule rule:@"anet.tradedoubler.com"];
    XCTAssertTrue(rule.maskRule);
    XCTAssertFalse(rule.withSubdomainsRule);
    XCTAssertFalse(rule.whiteListRule);
    XCTAssert([rule.domainPattern isEqualToString:@"*anet.tradedoubler.com*"]);
    
    rule = [AERDomainFilterRule rule:@"@@||anet.tradedoubler.com^"];
    XCTAssertFalse(rule.maskRule);
    XCTAssertTrue(rule.withSubdomainsRule);
    XCTAssertTrue(rule.whiteListRule);
    XCTAssert([rule.domainPattern isEqualToString:@"anet.tradedoubler.com"]);

    rule = [AERDomainFilterRule rule:@"@@//anet.tradedoubler.com^"];
    XCTAssertFalse(rule.maskRule);
    XCTAssertFalse(rule.withSubdomainsRule);
    XCTAssertTrue(rule.whiteListRule);
    XCTAssert([rule.domainPattern isEqualToString:@"anet.tradedoubler.com"]);

    rule = [AERDomainFilterRule rule:@"|anet.tradedoubler.com|"];
    XCTAssertFalse(rule.maskRule);
    XCTAssertFalse(rule.withSubdomainsRule);
    XCTAssertFalse(rule.whiteListRule);
    XCTAssert([rule.domainPattern isEqualToString:@"anet.tradedoubler.com"]);
    
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

    XCTAssertFalse([filter filteredDomain:@"superanet.tradedoubler.com"]);
    
    [filter addRule:[AERDomainFilterRule rule:@"*anet*.tra*dedoubler.com**"]];
    XCTAssertTrue([filter filteredDomain:@"superanet.tradedoubler.com"]);
    
    XCTAssertTrue([filter filteredDomain:@"superanet.tra.tata.dedoubler.com.con"]);

    XCTAssertTrue([filter filteredDomain:@"super.anet.tradedoubler.com"]);
    
    XCTAssertTrue([filter filteredDomain:@"anet.privet.tradedoubler.com"]);
    
    XCTAssertTrue([filter filteredDomain:@"www.domain.com"]);
    
    XCTAssertFalse([filter filteredDomain:@"subdomainwww.blacklist.com"]);
    
    XCTAssertTrue([filter filteredDomain:@"subdomain.www.blacklist.com"]);
    
    XCTAssertTrue([filter filteredDomain:@"www.whitelist.com"]);

    XCTAssertTrue([filter filteredDomain:@"googleadservices.com"]);

    XCTAssertTrue([filter filteredDomain:@"www.googleadservices.com"]);

    XCTAssertFalse([filter filteredDomain:@"subdomain.googleadservices.com"]);
    
    XCTAssertFalse([filter filteredDomain:@"bad.domain.com"]);
    
}

@end
