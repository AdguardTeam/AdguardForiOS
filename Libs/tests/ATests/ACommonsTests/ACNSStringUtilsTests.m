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
#import "ACLang.h"

@interface ACNSStringUtilsTests : XCTestCase

@end

@implementation ACNSStringUtilsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // init logger (file, debug console)
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [DDLog removeAllLoggers];
}

- (void) testGetTextEncoding {
    
    NSString *enc = @"csISOlatin1";
    
    XCTAssert([NSString encodingFromString:enc default:NSASCIIStringEncoding] == NSISOLatin1StringEncoding, "Must be NSISOLatin1StringEncoding");
    XCTAssert([NSString encodingFromString:@"Zopa" default:NSASCIIStringEncoding] == NSASCIIStringEncoding, "Must be NSASCIIStringEncoding");
    XCTAssert([NSString encodingFromString:@"windows-1251" default:NSASCIIStringEncoding] == NSWindowsCP1251StringEncoding, "Must be NSWindowsCP1251StringEncoding");
    XCTAssert([NSString encodingFromString:@"asdas" default:0] == 0, "Must be nil");
    
}

- (void)testSplitByArray
{
    
    NSString *iUni = @"Напомним, накануне неизвестный молодой человек ворвался в храм, который также называют собором Воскресения Христова, и открыл там беспорядочную стрельбу.    На месте скончались служащая собора монахиня Людмила (Пряшникова) и один из прихожан, имя которого устанавливается. Также шесть человек получили ранения.";
    
    NSArray *aUni = @[@"Также", @"месте", @""];
    
    NSArray *result;
    
    result = [iUni splitByArray:aUni count:0 omitEmpty:NO];
    DDLogError(@"Uni-Uni: %@", result);
    XCTAssertFalse([result count], @"Must be empty array");
    
    result = [iUni splitByArray:aUni count:10 omitEmpty:NO];
    DDLogError(@"Uni-Uni: %@", result);
    XCTAssertTrue([result count] == 3, @"array != 3");
    
    result = [iUni splitByArray:aUni count:2 omitEmpty:YES];
    DDLogError(@"iMix-aMix: %@", result);
    XCTAssertTrue([result count] == 2, @"array != 2");
    
    result = [@"qwertyuiopasdfghjklzxcvbnm" splitByArray:@[@" "] count:2 omitEmpty:YES ];
    XCTAssert([result[0] isEqualToString:@"qwertyuiopasdfghjklzxcvbnm"], @"");
    
    result = [@"qwertyuiopasdfghjklzxcvbnm" splitByArray:@[@"opa", @"wertyuiopasdfghjklzxcvbn", @"опа по руски"] count:2 omitEmpty:YES ];
    XCTAssert([result[0] isEqualToString:@"q"], @"");
    XCTAssert([result[1] isEqualToString:@"m"], @"");
    
    NSArray *sArray = @[@"b", @"c", @"a"];
    XCTAssertNoThrow([@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" splitByArray:sArray count:10 omitEmpty:YES], @"Test inputRanges");
    XCTAssertNoThrow([@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" splitByArray:sArray count:10 omitEmpty:NO], @"Test inputRanges");
    
    result = [@"12344556667asdasdasdasd" splitByArray:@[@"45", @"667", @"66"] count:10 omitEmpty:NO];
    DDLogError(@"Repeated Patterns: %@", result);
    XCTAssertTrue([result count] == 3, @"array != 3");
    
    
}

- (void) testContainsAny {
    
    NSString *iUni = @"Напомним, накануне неизвестный молодой человек ворвался в храм, который также называют собором Воскресения Христова, и открыл там беспорядочную стрельбу.    На месте скончались служащая собора монахиня Людмила (Пряшникова) и один из прихожан, имя которого устанавливается. Также шесть человек получили ранения.";
    
    NSArray *aUni = @[@"test", @"месте", @""];

    XCTAssert([iUni containsAny:aUni]);
    
    aUni  = @[@"test", @"test2", @""];
    
    XCTAssertFalse([iUni containsAny:aUni]);
}

- (void)testSubstrinsBetween {
    
    NSString *string = @"Напомним, накануне неизвестный <b>молодой человек ворвался в храм</b>, <i>который также</i> называют собором Воскресения Христова</i>, и открыл там беспорядочную </B>стрельбу.    <B>На месте скончались</b> служащая <I>собора монахиня</i> Людмила (Пряшникова) и один из <B>прихожан, имя которого устанавливается. Также шесть человек получили ранения.";
    
    NSArray *result = [string substringsBetween:@"<b>" and:@"</b>" ignoreCase:YES];
    
    XCTAssert(result.count == 2);
    XCTAssert([result[0] isEqualToString:@"молодой человек ворвался в храм"]);
    XCTAssert([result[1] isEqualToString:@"На месте скончались"]);
    
    result = [string substringsBetween:@"<i>" and:@"</i>"];
    XCTAssert(result.count == 1);
    
    result = [string substringsBetween:@"<i>" and:@"qqq"];
    XCTAssert(result.count == 0);
    
    result = [string substringsBetween:@"qqq" and:@"<i>"];
    XCTAssert(result.count == 0);

    result = [string substringsBetween:@"qqq" and:@"/qqq"];
    XCTAssert(result.count == 0);
}

- (void)testAsciiContains{
    
    NSString *string = @"Напомним, накануне неизвестный <b>молодой человек ворвался в храм</b>, <i>который также</i> называют собором Воскресения Христова</i>, и открыл там беспорядочную </B>стрельбу.    <B>На месте скончались</b> служащая <I>собора монахиня</i> Людмила (Пряшникова) и один из <B>прихожан, имя которого устанавливается. Также шесть человек получили ранения.";
    
    XCTAssertFalse([string asciiContains:nil ignoreCase:NO]);
    XCTAssertFalse([string asciiContains:@"Также" ignoreCase:NO]);
    
    string = @"ASCII stands for American Standard Code for Information Interchange. Computers can only understand numbers, so an ASCII code is the numerical representation of a character such as 'a' or '@' or an action of some sort. ASCII was developed a long time ago and now the non-printing characters are rarely used for their original purpose. Below is the ASCII character table and this includes descriptions of the first 32 non-printing characters. ASCII was actually designed for use with teletypes and so the descriptions are somewhat obscure. If someone says they want your CV however in ASCII format, all this means is they want 'plain' text with no ";
    
    XCTAssertFalse([string asciiContains:@"РусскоеСлово" ignoreCase:YES]);
    XCTAssertFalse([string asciiContains:@"124rew" ignoreCase:NO]);
    XCTAssertTrue([string asciiContains:@"someone" ignoreCase:NO]);
    XCTAssertFalse([string asciiContains:@"SOMEONE" ignoreCase:NO]);
    XCTAssertTrue([string asciiContains:@"FIRST 32 " ignoreCase:YES]);
}

- (void)testAsciiSplitByDelimiter{
    
    NSArray *test = @[];
    XCTAssert([[@"    " asciiSplitByDelimiter:' ' escapeCharacter:'\\'] isEqual:@[]]);
    test = @[@" "];
    XCTAssert([test isEqualToArray:[@"\\     " asciiSplitByDelimiter:' ' escapeCharacter:'\\']]);
    test = @[@"str", @"str"];
    XCTAssert([test isEqualToArray:[@"str str" asciiSplitByDelimiter:' ' escapeCharacter:'\\']]);
    test = @[@"str", @"str"];
    XCTAssert([test isEqualToArray:[@" str str" asciiSplitByDelimiter:' ' escapeCharacter:'\\']]);
    test = @[@"str str"];
    XCTAssert([test isEqualToArray:[@"str\\ str" asciiSplitByDelimiter:' ' escapeCharacter:'\\']]);
    test = @[@"str,", @" ", @"\\st,r"];
    XCTAssert([test isEqualToArray:[@"str\\,, ,\\st\\,r" asciiSplitByDelimiter:',' escapeCharacter:'\\']]);
    
}

@end
