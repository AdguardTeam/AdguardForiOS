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
#import <Adguard-Swift.h>

#define DNS_LOG_RECORD_FILE                @"dns-log-records.db"
#define DNS_STATISTICS_FILE                @"dns-statistics.db"

#define LOG_RECORDS_LIMIT           1000
#define PURGE_TIME_INTERVAL         60      // seconds

#define STATISTICS_REARRANGE_LIMIT  3600   // 1 hour
#define STATISTICS_RECORDS_LIMIT    1500   // 1500
#define STATISTICS_SECTORS_NUMBER   150   // 150

/////////////////////////////////////////////////////////////////////
#pragma mark - AESharedResources

@class RequestsStatisticsBlock;

@interface AESharedResources (internal)
- (NSData *)loadDataFromFileRelativePath:(NSString *)relativePath;
- (BOOL)saveData:(NSData *)data toFileRelativePath:(NSString *)relativePath;
- (NSString*) pathForRelativePath:(NSString*) relativePath;

@end

static NSTimeInterval lastPurgeTime;
static NSTimeInterval lastStatisticsPurgeTime;

/////////////////////////////////////////////////////////////////////
#pragma mark - APDnsLogTable

@interface APDnsLogTable : ADBTableRow

@property (nonatomic) NSDate *timeStamp;
@property (nonatomic) DnsLogRecord *record;

@end

@implementation APDnsLogTable
@end

/////////////////////////////////////////////////////////////////////
#pragma mark - APStatisticsTable

@interface APStatisticsTable : ADBTableRow

@property (nonatomic) NSDate *timeStamp;
@property (nonatomic) RequestsStatisticsBlock *allStatisticsBlocks;
@property (nonatomic) RequestsStatisticsBlock *blockedStatisticsBlocks;
@property (nonatomic) RequestsStatisticsBlock *countersStatisticsBlocks;

@end

@implementation APStatisticsTable
@end

/////////////////////////////////////////////////////////////////////
#pragma mark - APSharedResources

NSString* APAllRequestsString = @"APAllRequestsString";
NSString* APBlockedRequestsString = @"APBlockedRequestsString";
NSString* APCountersRequestsString = @"APCountersRequestsString";

@implementation APSharedResources

/////////////////////////////////////////////////////////////////////
#pragma mark Initialize

static NSString *_dnsLogRecordsPath;
static NSString *_statisticsPath;
static FMDatabaseQueue *_readDnsLogHandler;
static FMDatabaseQueue *_writeDnsLogHandler;
static FMDatabaseQueue *_writeStatisticsHandler;
static FMDatabaseQueue *_readStatisticsHandler;



+ (void)initialize{
    
    if (self == [APSharedResources class]) {
        _dnsLogRecordsPath = [[[AESharedResources sharedResuorcesURL] path] stringByAppendingPathComponent:DNS_LOG_RECORD_FILE];
        _statisticsPath = [[[AESharedResources sharedResuorcesURL] path] stringByAppendingPathComponent:DNS_STATISTICS_FILE];
        
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

- (NSDictionary<NSString *, NSArray<RequestsStatisticsBlock *> *> *)readStatisticsLog{
    [self initReadStatisticsLogHandler];
    
    __block NSArray *result;
    [_readStatisticsHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        ADBTable *table = [[ADBTable alloc] initWithRowClass:[APStatisticsTable class] db:db];
        
        result = [table selectWithKeys:nil inRowObject:nil];
    }];
    
    
    if (result.count) {
        NSDictionary<NSString *, NSArray<RequestsStatisticsBlock *> *> *stat = @{
            APAllRequestsString : [result valueForKey:@"allStatisticsBlocks"],
            APBlockedRequestsString : [result valueForKey:@"blockedStatisticsBlocks"],
            APCountersRequestsString : [result valueForKey:@"countersStatisticsBlocks"]
        };
        
        return stat;
    }
    
    return nil;
}

- (BOOL)removeStatisticsLog {
    [self initWriteStatisticsLogHandler];
    
    __block BOOL result = NO;
    [_writeStatisticsHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        ADBTable *table = [[ADBTable alloc] initWithRowClass:[APStatisticsTable class] db:db];
        
        result = [table deleteWithKeys:nil inRowObject:nil];
        *rollback = !result;
    }];
    
    return result;
}

- (void)writeToStatisticsRecords:(NSDictionary<NSString*, RequestsStatisticsBlock*> *)statistics {
    
    [self initWriteStatisticsLogHandler];
    
    [self rearrangeStatistics];

    APStatisticsTable *row = [APStatisticsTable new];

    row.timeStamp = [NSDate date];

    [_writeStatisticsHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {

        ADBTable *table = [[ADBTable alloc] initWithRowClass:[row class] db:db];
        
        if (statistics[APAllRequestsString]) {
            row.allStatisticsBlocks = statistics[APAllRequestsString];
        }
        
        if (statistics[APBlockedRequestsString]) {
            row.blockedStatisticsBlocks = statistics[APBlockedRequestsString];
        }
        
        if (statistics[APCountersRequestsString]) {
            row.countersStatisticsBlocks = statistics[APCountersRequestsString];
        }

        [table insertOrReplace:NO fromRowObject:row];
    }];
}

/////////////////////////////////////////////////////////////////////
#pragma mark User defaults methods for statistics

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

- (void)initWriteStatisticsLogHandler {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _writeStatisticsHandler = [FMDatabaseQueue databaseQueueWithPath:_statisticsPath flags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)];
        if (_writeStatisticsHandler){
            
            [_writeStatisticsHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {
                
                [self createTunnelStatisticsTable:db];
            }];
        }
    });
}

- (void)initReadStatisticsLogHandler {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _readStatisticsHandler = [FMDatabaseQueue databaseQueueWithPath:_statisticsPath flags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)];
    });
}


- (void)createDnsLogTable:(FMDatabase *)db {
    
    BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS APDnsLogTable (timeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, record BLOB)"];
    if (result) {
        [db executeUpdate:@"CREATE INDEX IF NOT EXISTS mainIndex ON APDnsLogTable (timeStamp)"];
    }
}

- (void)createTunnelStatisticsTable:(FMDatabase *)db {
    BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS APStatisticsTable (timeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, allStatisticsBlocks BLOB, blockedStatisticsBlocks BLOB, countersStatisticsBlocks BLOB)"];
    if (result) {
        [db executeUpdate:@"CREATE INDEX IF NOT EXISTS mainIndex ON APStatisticsTable (timeStamp)"];
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

- (void)rearrangeStatistics{
    NSTimeInterval now = NSDate.date.timeIntervalSince1970;
    if(now - lastStatisticsPurgeTime > STATISTICS_REARRANGE_LIMIT) {
        
        lastStatisticsPurgeTime = now;
        
        [self initReadStatisticsLogHandler];
        
        __block NSArray *result;
        [_readStatisticsHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            ADBTable *table = [[ADBTable alloc] initWithRowClass:[APStatisticsTable class] db:db];
            
            result = [table selectWithKeys:nil inRowObject:nil];
        }];
        
        // If number of statictics blocks is greater than 1500, then we need to cut the number of blocks and rearrange DB
        if (result.count > STATISTICS_RECORDS_LIMIT) {
            [self rearrangeDb:result];
        }
    }
}

- (void)rearrangeDb:(NSArray *)result{
    // Getting all blocks from db
    NSArray<RequestsStatisticsBlock *> *allRequests = [result valueForKey:@"allStatisticsBlocks"];
    NSArray<RequestsStatisticsBlock *> *blockedRequests = [result valueForKey:@"blockedStatisticsBlocks"];
    NSArray<RequestsStatisticsBlock *> *countersRequests = [result valueForKey:@"countersStatisticsBlocks"];
    
    // Rearranged blockes are returned here
    NSArray<RequestsStatisticsBlock *> *rearrangedAll = [self rearrangeRow:allRequests];
    NSArray<RequestsStatisticsBlock *> *rearrangedBlocked = [self rearrangeRow:blockedRequests];
    NSArray<RequestsStatisticsBlock *> *rearrangedCounters = [self rearrangeRow:countersRequests];
    
    // Clear previous statistics
    [self initWriteDnsLogHandler];
    
    BOOL success = [self removeStatisticsLog];
    
    // Paste a new generated one
    if (success == YES){
        for (int i = 0; i < rearrangedAll.count; i++){
            NSDictionary<NSString*, RequestsStatisticsBlock*> *statistics = @{
                APAllRequestsString : rearrangedAll[i],
                APBlockedRequestsString : rearrangedBlocked[i],
                APCountersRequestsString : rearrangedCounters[i]
            };
            [self writeToStatisticsRecords:statistics];
        }
    }
}

- (NSArray<RequestsStatisticsBlock *> *)rearrangeRow:(NSArray<RequestsStatisticsBlock *> *)values{
    // Number of new sectors in db, for example
    // We had 1500 blocks, after rearranging we'll have 150
    NSNumber *numberOfSectors = @(STATISTICS_SECTORS_NUMBER);
    
    // Sort all blocks by date
    NSArray<RequestsStatisticsBlock *> *sorted = [values sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *first = [(RequestsStatisticsBlock *)obj1 date];
        NSDate *second = [(RequestsStatisticsBlock *)obj2 date];
        
        return [first compare:second];
    }];
    
    // Getting dates from blocks
    NSMutableArray<NSDate *> *sortedDates = [NSMutableArray new];
    
    for (RequestsStatisticsBlock *block in sorted) {
        NSDate *date = block.date;
        [sortedDates addObject:date];
    }
    
    // Newest and oldest dates
    // sortedDates array looks like this
    // [oldest_date...some_date...some_date...some_date...newest_date]
    NSNumber *oldestDate = @([values firstObject].date.timeIntervalSinceReferenceDate);
    NSNumber *newestDate = @([values lastObject].date.timeIntervalSinceReferenceDate);
    
    // Devide all dates to equal sectors by date, not by number of elements
    NSNumber *step = @((newestDate.doubleValue - oldestDate.doubleValue) / numberOfSectors.doubleValue);
    
    // separatorsDates are borders for new blocks
    NSMutableArray <NSNumber *> *separatorsDates = [NSMutableArray new];
    NSNumber *dateIterator = oldestDate;
    while (dateIterator.intValue < newestDate.intValue) {
        [separatorsDates addObject:dateIterator];
        dateIterator = @(dateIterator.intValue + step.intValue);
    }
    [separatorsDates addObject:@(sortedDates.lastObject.timeIntervalSinceReferenceDate)];
    
    NSMutableArray<RequestsStatisticsBlock *> *copySorted = [[NSMutableArray alloc] initWithArray:sorted];
    NSMutableArray<RequestsStatisticsBlock *> *returnArray = [NSMutableArray new];
    
    NSNumber *iterator = @(0);
    NSNumber *elementsToCut = @(0);
    NSNumber *newSum = @(0);
    NSNumber *dateSum = @(0);
    
    // Iterating through array and summing up blocks between generated borders
    // If there were no blocks between two borders than we add a block with zero value
    while (copySorted.count != 0 && iterator.intValue < separatorsDates.count - 1) {
        NSNumber *leftBorder = separatorsDates[iterator.intValue];
        NSNumber *rightBorder = separatorsDates[iterator.intValue + 1];
        
        for (int i = 0; i < copySorted.count - 1; i++){
            RequestsStatisticsBlock *block = copySorted[i];
            RequestsStatisticsBlock *nextBlock = copySorted[i+1];
            
            NSNumber *date = @(block.date.timeIntervalSinceReferenceDate);
            NSNumber *nextDate = @(nextBlock.date.timeIntervalSinceReferenceDate);
            NSNumber *number = @(block.numberOfRequests);
            NSNumber *nextNumber = @(nextBlock.numberOfRequests);
            
            if (date.intValue >= leftBorder.intValue && date.intValue < rightBorder.intValue){
                newSum = @(newSum.intValue + number.intValue);
                dateSum = @(dateSum.intValue + date.intValue);
                elementsToCut = @(elementsToCut.intValue + 1);
                
                if (nextDate.intValue >= rightBorder.intValue) {
                    
                    if (nextDate.intValue == newestDate.intValue) {
                        newSum = @(newSum.intValue + nextNumber.intValue);
                        dateSum = @(dateSum.intValue + nextDate.intValue);
                        elementsToCut = @(elementsToCut.intValue + 1);
                    }
                    
                    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:(elementsToCut.intValue == 0 ? leftBorder.doubleValue : dateSum.doubleValue/elementsToCut.doubleValue)];
                        
                    RequestsStatisticsBlock *newBlock = [[RequestsStatisticsBlock alloc] initWithDate:newDate numberOfRequests:newSum.intValue];
                    [returnArray addObject:newBlock];
                    
                    iterator = @(iterator.intValue + 1);
                    newSum = @(0);
                    dateSum = @(0);
                    break;
                }
            } else {
                NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:leftBorder.doubleValue];
                RequestsStatisticsBlock *newBlock = [[RequestsStatisticsBlock alloc] initWithDate:newDate numberOfRequests: 0];
                [returnArray addObject:newBlock];
                
                iterator = @(iterator.intValue + 1);
                elementsToCut = @(0);
                break;
            }
        }
        
        [copySorted removeObjectsInRange:NSMakeRange(0, elementsToCut.intValue)];
        elementsToCut = @(0);
    }
    // returning new blocks
    return returnArray;
}

@end
