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

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "ASDatabase/ASDatabase.h"
#import "ADomain/ADomain.h"
#import "ACommons/ACLang.h"

@interface ASDatabaseTests : XCTestCase{

    ASDatabase *dbq;
    NSUInteger counter;
    NSTimer *timer;
}

@end

@implementation ASDatabaseTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    dbq = [ASDatabase singleton];
    [dbq initDbWithURL:[[ADLocations productDataDirectory] URLByAppendingPathComponent:@"testProduction.db"]];
    counter = 10;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
 
    NSURL *dbURL = [[ADLocations productDataDirectory] URLByAppendingPathComponent:@"testProduction.db"];
    
//    [[NSFileManager defaultManager] removeItemAtURL:dbURL error:nil];
}

- (void)testInit {

    if (dbq.ready) {
        XCTAssert(YES, @"Init Pass");
    } else {

        if (counter) {
            if (timer == nil) {
                timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    [self testInit];
                }];
                
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:counter + 1]];
            }
            counter--;
            return;
        }
        
        XCTAssert(NO, @"Time limit exceeded!");
    }
}


- (void)testIsolatedMode{
    
    @autoreleasepool {
        dispatch_queue_t workingQueue = dispatch_queue_create("testDBIsolatedModeQueue", NULL);
        
        XCTAssert(workingQueue, "Can't create working queue.");
        
//--------------- checking of object releasing ---------------------
        XCTAssert([dbq isolateQueue:workingQueue]);
        XCTAssertNoThrow([dbq resetIsolationQueue:workingQueue]);
        
        [dbq isolateQueue:workingQueue];
        workingQueue = nil;
    }

    DDLogError(@"Test massage");
    
//--------------- checking of a concurrency ----------------
    dispatch_queue_t workingQueue = dispatch_queue_create("testDBIsolatedModeQueue", NULL);
    
    XCTAssert(workingQueue, "Can't create working queue. when we check concurrency");
    
    
    [dbq isolateQueue:workingQueue];
    
    // open deffered transaction in isolated queue
    dispatch_sync(workingQueue, ^{
        [dbq rawExec:^(FMDatabase *db) {
            
            [db beginDeferredTransaction];
        }];
    });
    
    // create and fill table in standart queue (one transaction)
    [dbq exec:^(FMDatabase *db, BOOL *rollback) {
       
        [db executeUpdate:@"drop table if exists testTable"];
        [db executeUpdate:@"create table testTable (theString TEXT)"];
        [db executeUpdate:@"insert into testTable (theString) values ('test val')"];
    }];
    
    //try read from new table on working queue
    dispatch_sync(workingQueue, ^{
        [dbq exec:^(FMDatabase *db, BOOL *rollback) {
            FMResultSet *result = [db executeQuery:@"select * from testTable limit 1"];
            if ([result next]) {
                NSDictionary *dict = [result resultDictionary];
                XCTAssert([dict[@"theString"] isEqualToString:@"test val"]);
            }
            [result close];
            
            [db executeUpdate:@"insert into testTable (theString) values ('test val 2')"];
        }];
    });
    
    //try read after modification on main queue
    [dbq exec:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"select count(*) from testTable;"];
        if ([result next]) {
            NSNumber *count = result[0];
            XCTAssert([count integerValue] == 1);
        }
        [result close];
    }];
    
    // commit on working queue
    dispatch_sync(workingQueue, ^{
       
        [dbq rawExec:^(FMDatabase *db) {
           
            [db commit];
        }];
    });

    // modify on working queue
    dispatch_sync(workingQueue, ^{
        
        [dbq rawExec:^(FMDatabase *db) {
            
            [db beginDeferredTransaction];
        }];
        
        [dbq exec:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:@"insert into testTable (theString) values ('test val 3')"];
        }];
    });
    
    
    //try read committed state on main queue
    [dbq exec:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"select count(*) from testTable;"];
        if ([result next]) {
            NSNumber *count = result[0];
            XCTAssert([count integerValue] == 2);
        }
        [result close];
    }];
    
    [dbq readUncommited:YES];
    
    //try read uncommitted state on main queue
    [dbq exec:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"select count(*) from testTable;"];
        if ([result next]) {
            NSNumber *count = result[0];
            XCTAssert([count integerValue] == 3);
        }
        [result close];
    }];
    
    // rollback on working queue
    dispatch_sync(workingQueue, ^{
        
        [dbq rawExec:^(FMDatabase *db) {
            
            [db rollback];
        }];
    });
    
    //try read committed state on main queue
    [dbq exec:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"select count(*) from testTable;"];
        if ([result next]) {
            NSNumber *count = result[0];
            XCTAssert([count integerValue] == 2);
        }
        [result close];
    }];
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
