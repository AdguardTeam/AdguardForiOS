//
//  ABERequestTests.m
//  ATests
//
//  Created by Roman Sokolov on 05.10.16.
//
//

#import <XCTest/XCTest.h>
#import "ABECRequest.h"

@interface ABERequestTests : XCTestCase

@end

@implementation ABERequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStringFromParameters {
    
    NSString *testString = @"\n\0\r\t &/{}|=#\\normal-text русский-текст";
    
    NSString *resultString = @"param=%0A%00%0D%09%20%26%2F%7B%7D%7C%3D%23%5Cnormal-text%20%D1%80%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9-%D1%82%D0%B5%D0%BA%D1%81%D1%82";
    
    XCTAssert([[ABECRequest createStringFromParameters:@{@"param": testString}] isEqualToString:resultString]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
