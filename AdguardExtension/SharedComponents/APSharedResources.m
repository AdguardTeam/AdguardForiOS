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
 #import "AESharedResources.h"
*/

#import "APSharedResources.h"
#import "AESharedResources.h"
#import "ACommons/ACLang.h"
#import "ADBHelpers/ADBTable.h"
#import "ADBHelpers/ADBTableRow.h"

#define DNS_LOG_RECORD_FILE                @"dns-log-records.db"

#define LOG_RECORDS_LIMIT           1000
#define PURGE_TIME_INTERVAL         60      // seconds

/////////////////////////////////////////////////////////////////////
#pragma mark - AESharedResources

@interface AESharedResources (internal)
- (NSData *)loadDataFromFileRelativePath:(NSString *)relativePath;
- (BOOL)saveData:(NSData *)data toFileRelativePath:(NSString *)relativePath;
- (NSString*) pathForRelativePath:(NSString*) relativePath;

@end

static NSTimeInterval lastPurgeTime;

/////////////////////////////////////////////////////////////////////
#pragma mark - APDnsLogTable

@interface APDnsLogTable : ADBTableRow

@property (nonatomic) NSDate *timeStamp;
@property (nonatomic) DnsLogRecord *record;

@end

@implementation APDnsLogTable
@end

/////////////////////////////////////////////////////////////////////
#pragma mark - APSharedResources

@implementation APSharedResources

/////////////////////////////////////////////////////////////////////
#pragma mark Initialize

static NSString *_dnsLogRecordsPath;
static FMDatabaseQueue *_readDnsLogHandler;
static FMDatabaseQueue *_writeDnsLogHandler;

+ (void)initialize{
    
    if (self == [APSharedResources class]) {
        _dnsLogRecordsPath = [[[AESharedResources sharedResuorcesURL] path] stringByAppendingPathComponent:DNS_LOG_RECORD_FILE];
        
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark public methods

- (NSArray <DnsLogRecord *> *)readDnsLog{
    
    [self initReadDnsLogHandler];
    
    __block NSArray *result;
    [_readDnsLogHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        ADBTable *table = [[ADBTable alloc] initWithRowClass:[APDnsLogTable class] db:db];
        
        result = [table selectWithKeys:nil inRowObject:nil];
    }];
    
    if (result.count) {
        
        return [result valueForKey:@"record"];
    }
    
    return nil;
}

- (BOOL)removeDnsLog{
    
    [self initWriteDnsLogHandler];
    
    __block BOOL result = NO;
    [_writeDnsLogHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        ADBTable *table = [[ADBTable alloc] initWithRowClass:[APDnsLogTable class] db:db];
        
        result = [table deleteWithKeys:nil inRowObject:nil];
        *rollback = !result;
    }];
    
    return result;
}

- (void)writeToDnsLogRecords:(NSArray<DnsLogRecord *> *)logRecords {
    
    [self initWriteDnsLogHandler];

    [self purgeDnsLog];

    APDnsLogTable *row = [APDnsLogTable new];

    row.timeStamp = [NSDate date];

    [_writeDnsLogHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {

        ADBTable *table = [[ADBTable alloc] initWithRowClass:[row class] db:db];

        for (DnsLogRecord *item in logRecords) {

            row.record = item;
            [table insertOrReplace:NO fromRowObject:row];
        }
    }];
}

- (void)setDefaultRequestsNumber:(NSNumber *)defaultRequestsNumber{
    [self.sharedDefaults setObject:defaultRequestsNumber forKey:AEDefaultsRequests];
}

- (NSNumber *)defaultRequestsNumber{
    NSNumber *returnValue = [self.sharedDefaults objectForKey:AEDefaultsRequests];
    return returnValue;
}

- (void)setBlockedRequestsNumber:(NSNumber *)blockedRequestsNumber{
    [self.sharedDefaults setObject:blockedRequestsNumber forKey:AEDefaultsBlockedRequests];
}

- (NSNumber *)blockedRequestsNumber{
    NSNumber *returnValue = [self.sharedDefaults objectForKey:AEDefaultsBlockedRequests];
    return returnValue;
}

- (void)setCountersRequestsNumber:(NSNumber *)countersRequestsNumber{
    [self.sharedDefaults setObject:countersRequestsNumber forKey:AEDefaultsCountersRequests];
}

- (NSNumber *)countersRequestsNumber{
    NSNumber *returnValue = [self.sharedDefaults objectForKey:AEDefaultsCountersRequests];
    return returnValue;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private methods

- (void)initWriteDnsLogHandler {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _writeDnsLogHandler = [FMDatabaseQueue databaseQueueWithPath:_dnsLogRecordsPath flags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)];
        if (_writeDnsLogHandler){
            
            [_writeDnsLogHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {
                
                [self createDnsLogTable:db];
            }];
        }
    });
}

- (void)initReadDnsLogHandler {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _readDnsLogHandler = [FMDatabaseQueue databaseQueueWithPath:_dnsLogRecordsPath flags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)];
    });
}

- (void)createDnsLogTable:(FMDatabase *)db {
    
    BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS APDnsLogTable (timeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, record BLOB)"];
    if (result) {
        [db executeUpdate:@"CREATE INDEX IF NOT EXISTS mainIndex ON APDnsLogTable (timeStamp)"];
    }
}

- (void)purgeDnsLog{
    
    NSTimeInterval now = NSDate.date.timeIntervalSince1970;
    if(now - lastPurgeTime > PURGE_TIME_INTERVAL) {
        
        lastPurgeTime = now;
        
        [_writeDnsLogHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            [db executeUpdate:@"DELETE FROM APDnsLogTable WHERE timeStamp > 0 ORDER BY timeStamp DESC LIMIT -1 OFFSET ?", @(LOG_RECORDS_LIMIT)];
        }];
    }
}


@end
