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
#import "ADBTableRow.h"
#import "ADBTable.h"
#import "FMDB.h"

//////////////////////////////////////////////////////////////////////////////

@interface testRow : ADBTableRow

@property (nonatomic) BOOL boolP;
@property (nonatomic) NSInteger integerP;
@property (nonatomic) NSString *stringP;
@property (nonatomic) NSDate *dateP;
@property (nonatomic) NSData *dataP;
@property (nonatomic) NSArray *arrayP;
@property (nonatomic) NSMutableArray *marrayP;
@property (nonatomic) NSDictionary *dictP;
@property (nonatomic) NSMutableDictionary *mdictP;
@property (nonatomic) testRow *rowP;
@property (nonatomic, weak) id fakeWeakObject;
@property (readonly) NSString *fakeReadonly;
@property NSString *fakeString;

- (id)initWithIntegerP:(NSInteger)integerP;

@end

@implementation testRow

+ (NSString *)tableName{
    
    return @"testTable";
}

- (id)initWithIntegerP:(NSInteger)integerP{
    self = [super init];
    if (self) {
        
        _integerP = integerP;
    }
    return self;
}

@end

@interface versionRow : ADBTableRow

@property NSString *schema_version;

@end

//////////////////////////////////////////////////////////////////////////////

@interface testRowDescendant : testRow

@property BOOL man;
@property BOOL woman;

@end

@implementation testRowDescendant

- (id)initWithMan:(BOOL)man orWoman:(BOOL)women{
    
    self = [super init];
    if (self) {
        
        _man = man;
        _woman = women;
    }
    return self;
}

@end
//////////////////////////////////////////////////////////////////////////////


@interface ADBHelperTests : XCTestCase{
    FMDatabase *db;
}

@end

@implementation ADBHelperTests

- (void)setUp {
    [super setUp];
    db = [FMDatabase databaseWithPath:nil];
    [db open];
}

- (void)tearDown {
    
    [db close];
    
    [super tearDown];
}

- (void)testTableAndRow
{
    
    BOOL result = [db executeUpdate:@"CREATE TABLE testTable (boolP BOOLEAN NOT NULL DEFAULT 1, integerP INTEGER NOT NULL DEFAULT 0, stringP TEXT, dateP TIMESTAMP DEFAULT CURRENT_TIMESTAMP, dataP BLOB, arrayP BLOB, marrayP TEXT, dictP TEXT, mdictP BLOB, rowP TEXT)"];
    
    XCTAssert(result, @"Creatinf table error!!!");
    
    ADBTable *testTable = [[ADBTable alloc] initWithRowClass:[testRow class] db:db];
    
    testRow *object = [testRow new];
    
    // test insert
    
    object.boolP = YES;
    object.integerP = 100;
    object.stringP = @"Ok string!";
    object.dateP = [NSDate date];
    object.dataP = [@"data string" dataUsingEncoding:NSUTF8StringEncoding];
    object.arrayP = @[@"One", @2, @3.0, @{@"key": @[@"object"]}];
    object.marrayP = [object.arrayP mutableCopy];
    object.dictP = @{@"key1": @"value1", @"key2": @"value2"};
    object.mdictP = [object.dictP mutableCopy];
    object.fakeWeakObject = testTable;
    
    XCTAssertFalse([@"fakeReadonly" containsAny:[testRow propertyNamesArray]]);
    XCTAssertFalse([@"fakeWeakObject" containsAny:[testRow propertyNamesArray]]);
    
    XCTAssert([@"rowP" containsAny:[testRow propertyNamesArray]]);
    
    object.fakeString = @"fake string!";
    
    testRow *rowP = [testRow new];
    rowP.integerP = 1000;
    rowP.arrayP = @[@"rowP_One", @2, @3.0, @{@"key": @[@"object"]}];
    object.rowP = rowP;
    
    XCTAssert([testTable insertOrReplace:NO fromRowObject:object]);
    
    object.integerP = 200;
    
    XCTAssert([testTable insertOrReplace:YES fromRowObject:object]);
    
    //test select
    NSArray *aResult = [testTable selectWithKeys:nil inRowObject:nil];
    
    XCTAssert([aResult count] == 2);
    
    testRow *fromDb = aResult[1];
    
    XCTAssert(object.boolP == fromDb.boolP);
    XCTAssert(object.integerP == fromDb.integerP);
    XCTAssert([object.stringP isEqual:fromDb.stringP]);
    XCTAssert([object.dateP compare:fromDb.dateP] == NSOrderedDescending);
    XCTAssert([object.dataP isEqual:fromDb.dataP]);
    XCTAssert([object.arrayP isEqual:fromDb.arrayP]);
    XCTAssert([object.marrayP isEqual:fromDb.marrayP]);
    XCTAssert([object.dictP isEqual:fromDb.dictP]);
    XCTAssert([object.mdictP isEqual:fromDb.mdictP]);
    
    XCTAssert(object.rowP.integerP == fromDb.rowP.integerP);
    XCTAssert([object.rowP.arrayP[0] isEqualToString:@"rowP_One"]);
    
    XCTAssertFalse([object.fakeString isEqual:fromDb.fakeString]);
    
    XCTAssertNil([testTable selectWithKeys:@[@"fakeKey"] inRowObject:object]);
    
    aResult = [testTable selectWithKeys:@[@"integerP",@"fakeKey", @100] inRowObject:object];
    
    XCTAssert([aResult count] == 1);
    
    fromDb = aResult[0];
    XCTAssert(object.boolP == fromDb.boolP);
    XCTAssert(object.integerP == fromDb.integerP);
    XCTAssert([object.stringP isEqual:fromDb.stringP]);
    XCTAssert([object.dateP compare:fromDb.dateP] == NSOrderedDescending);
    XCTAssert([object.dataP isEqual:fromDb.dataP]);
    XCTAssert([object.arrayP isEqual:fromDb.arrayP]);
    XCTAssert([object.marrayP isEqual:fromDb.marrayP]);
    XCTAssert([object.dictP isEqual:fromDb.dictP]);
    XCTAssert([object.mdictP isEqual:fromDb.mdictP]);
    
    
    // test update
    object.integerP = 300;
    
    [testTable insertOrReplace:NO fromRowObject:object];
    
    XCTAssert([testTable updateWithKeys:@[@"integerP"] fromRowObject:[[testRow alloc] initWithIntegerP:100] updateFields:@[@"integerP"] fromRowObject:object]);
    
    aResult = [testTable selectWithKeys:@[@"integerP"] inRowObject:object];
    
    XCTAssert([aResult count] == 2);
    
    XCTAssert([testTable updateWithKeys:nil fromRowObject:nil updateFields:nil fromRowObject:object]);
    
    aResult = [testTable selectWithKeys:@[@"integerP"] inRowObject:object];
    
    XCTAssert([aResult count] == 3);
    
    // test delete
    object.boolP = NO;
    [testTable insertOrReplace:YES fromRowObject:object];
    
    XCTAssert([testTable deleteWithKeys:@[@"boolP"] inRowObject:object]);
    
    aResult = [testTable selectWithKeys:nil inRowObject:nil];
    XCTAssert(aResult.count == 3);
    
    
    XCTAssert([testTable deleteWithKeys:nil inRowObject:nil]);
    
    aResult = [testTable selectWithKeys:nil inRowObject:nil];
    XCTAssert(aResult.count == 0);
        
    NSArray *props = [[testRowDescendant propertyNames] allObjects];
    
    XCTAssert(props.count == 15);
    
    
}

@end

@implementation versionRow

+ (NSString *)tableName{
    
    return @"version";
}

@end
