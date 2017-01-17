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
 #import "AESharedResources.h"
*/

#import "APSharedResources.h"
#import "AESharedResources.h"
#import "ACommons/ACLang.h"
#import "ADBHelpers/ADBTable.h"
#import "ADBHelpers/ADBTableRow.h"

#define DNS_LOG_RECORD_FILE         @"dns-log-records.db"
#define LOG_RECORDS_TTL             12*60*60 // 12 hours

/////////////////////////////////////////////////////////////////////
#pragma mark - APDnsLogTable

@interface APDnsLogTable : ADBTableRow

@property (nonatomic) NSDate *timeStamp;
@property (nonatomic) APDnsLogRecord *record;

@end

@implementation APDnsLogTable
@end

/////////////////////////////////////////////////////////////////////
#pragma mark - APSharedResources Constants

NSString *APDefaultsDnsLoggingEnabled = @"APDefaultsDnsLoggingEnabled";
NSString *APDefaultsRemoteDnsServers = @"APDefaultsRemoteDnsServers";
NSString *APDefaultsDnsLocalFiltering = @"APDefaultsDnsLocalFiltering";

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
#pragma mark Class methods

+ (NSArray <APDnsLogRecord *> *)readDnsLog{
    
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

+ (BOOL)removeDnsLog{
    
    [self initWriteDnsLogHandler];
    
    __block BOOL result = NO;
    [_writeDnsLogHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        ADBTable *table = [[ADBTable alloc] initWithRowClass:[APDnsLogTable class] db:db];
        
        result = [table deleteWithKeys:nil inRowObject:nil];
        *rollback = !result;
    }];
    
    return result;
}

+ (void)writeToDnsLogRecords:(NSArray<APDnsLogRecord *> *)logRecords {
    
    [self initWriteDnsLogHandler];
    
    [self purgeDnsLog];
    
    APDnsLogTable *row = [APDnsLogTable new];
    
    row.timeStamp = [NSDate date];
    
    [_writeDnsLogHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        ADBTable *table = [[ADBTable alloc] initWithRowClass:[row class] db:db];
        
        for (APDnsLogRecord *item in logRecords) {
            
            row.record = item;
            [table insertOrReplace:NO fromRowObject:row];
        }
    }];
}

+ (APHost2TunnelMessageType)host2tunnelMessageType:(NSData *)messageData{
    
    if (!messageData) {
        return 0;
    }
    
    return (APHost2TunnelMessageType)*((Byte *)[messageData bytes]);
}

+ (NSData *)host2tunnelMessageLogEnabled {

    APHost2TunnelMessageType message = APHTMLoggingEnabled;
    
    return [NSData dataWithBytes:&message length:1];
}

+ (NSData *)host2tunnelMessageLogDisabled {
    
    APHost2TunnelMessageType message = APHTMLoggingDisabled;

    return [NSData dataWithBytes:&message length:1];
}

+ (NSData *)host2tunnelMessageUserfilterDataReload {
    
    APHost2TunnelMessageType message = APHTMUserfilterDataReload;
    
    return [NSData dataWithBytes:&message length:1];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private methods

+ (void)initWriteDnsLogHandler {
    
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

+ (void)initReadDnsLogHandler {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _readDnsLogHandler = [FMDatabaseQueue databaseQueueWithPath:_dnsLogRecordsPath flags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)];
    });
}

+ (void)createDnsLogTable:(FMDatabase *)db {
    
    BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS APDnsLogTable (timeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, record BLOB)"];
    if (result) {
        result = [db executeUpdate:@"CREATE INDEX IF NOT EXISTS mainIndex ON APDnsLogTable (timeStamp)"];
    }
}

+ (void)purgeDnsLog{
    
    [_writeDnsLogHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSDate *purgeDate = [NSDate dateWithTimeIntervalSinceNow:-(LOG_RECORDS_TTL)];
        [db executeUpdate:@"DELETE FROM APDnsLogTable WHERE timeStamp < datetime(?)", [purgeDate iso8601String]];
    }];
}

@end
