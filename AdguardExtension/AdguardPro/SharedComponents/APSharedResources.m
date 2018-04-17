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

#define APS_WHITELIST_DOAMINS              @"pro-whitelist-doamins.data"
#define APS_BLACKLIST_DOAMINS              @"pro-blacklist-doamins.data"
#define APS_TRACKERS_DOMAINS               @"pro-trackers-domains.data"
#define APS_HOSTS_DOMAINS                  @"pro-hosts-domains.data"
#define DNS_LOG_RECORD_FILE                @"dns-log-records.db"
#define BLOCKING_SUBSCRIPTIONS_FILE        @"blocking-subscriptions.db"
#define BLOCKING_SUBSCRIPTIONS_META_FILE   @"blocking-subscriptions-meta.db"
#define BLOCKING_SUBSCRIPTIONS_HOSTS_FILE  @"blocking-subscriptions-hosts.db"
#define BLOCKING_SUBSCRIPTIONS_RULES_FILE  @"blocking-subscriptions-rules.db"

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
@property (nonatomic) APDnsLogRecord *record;

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
static NSDictionary <NSString *, ABECService*> *_trackerslistDomains;

+ (void)initialize{
    
    if (self == [APSharedResources class]) {
        _dnsLogRecordsPath = [[[AESharedResources sharedResuorcesURL] path] stringByAppendingPathComponent:DNS_LOG_RECORD_FILE];
        
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and Class methods


+ (NSArray <NSString *> *)whitelistDomains {
    
    return [self domainsListWithName:APS_WHITELIST_DOAMINS];
}

+ (void)setWhitelistDomains:(NSArray<NSString *> *)whitelistDomains {
    
    [self setDomainsList:whitelistDomains forName:APS_WHITELIST_DOAMINS];
}

+ (NSArray <NSString *> *)blacklistDomains {
    
    return [self domainsListWithName:APS_BLACKLIST_DOAMINS];
}

+ (void)setBlacklistDomains:(NSArray<NSString *> *)blacklistDomains {
    
    [self setDomainsList:blacklistDomains forName:APS_BLACKLIST_DOAMINS];
}

+(NSDictionary<NSString *,ABECService *> *)loadTrackerslistDomainsAndCacheResult:(BOOL)cacheResult {
    
    NSDictionary* result = _trackerslistDomains;
    
    if(!result){
        result = [self domainsListWithName:APS_TRACKERS_DOMAINS];
        
        if(cacheResult)
            _trackerslistDomains = result;
    }
    
    return result;
}

+(void)saveTrackerslistDomains:(NSDictionary<NSString *,ABECService *> *)trackerslistDomains {
    
    _trackerslistDomains = trackerslistDomains;
    [self setDomainsList:trackerslistDomains forName:APS_TRACKERS_DOMAINS];
}

+ (ABECService *)serviceByDomain:(NSString*) domain {
    
    NSDictionary<NSString*, ABECService*>* hosts = [self loadTrackerslistDomainsAndCacheResult:YES];
    
    //fullmatch
    __block ABECService *service = hosts[domain];
    
    // mask search
    if(!service) {
        
        [hosts enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, ABECService * _Nonnull obj, BOOL * _Nonnull stop) {
            
            if([domain hasSuffix:key]) {
                
                service = obj;
                *stop = YES;
            }
        }];
    }
    
    return service;
}

+ (NSDictionary<NSString *,NSString *> *)hosts {
    
    return [self domainsListWithName:APS_HOSTS_DOMAINS];
}

+ (void)setHosts:(NSDictionary<NSString *,NSString *> *)hosts {
    
    [self setDomainsList:hosts forName:APS_HOSTS_DOMAINS];
}

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

+ (NSData *)host2tunnelMessageSystemWideDomainListReload {
    
    APHost2TunnelMessageType message = APHTMLSystemWideDomainListReload;
    
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
        [db executeUpdate:@"CREATE INDEX IF NOT EXISTS mainIndex ON APDnsLogTable (timeStamp)"];
    }
}

+ (void)purgeDnsLog{
    
    NSTimeInterval now = NSDate.date.timeIntervalSince1970;
    if(now - lastPurgeTime > PURGE_TIME_INTERVAL) {
        
        lastPurgeTime = now;
        
        [_writeDnsLogHandler inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            [db executeUpdate:@"DELETE FROM APDnsLogTable WHERE timeStamp > 0 ORDER BY timeStamp DESC LIMIT -1 OFFSET ?", @(LOG_RECORDS_LIMIT)];
        }];
    }
}

+ (id)domainsListWithName:(NSString *)name {

    AESharedResources *resources = [AESharedResources new];
    NSData *data = [resources loadDataFromFileRelativePath:name];
    if (data.length) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

+ (void)setDomainsList:(id)domainsList forName:(NSString *)name {
    
    AESharedResources *resources = [AESharedResources new];
    if (domainsList == nil) {
        [resources saveData:[NSData data] toFileRelativePath:name];
    }
    else {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:domainsList];
        if (!data) {
            data = [NSData data];
        }
        
        [resources saveData:data toFileRelativePath:name];
    }
}

+ (void)setSubscriptionsData:(NSData *)subscriptionsData {
    
    AESharedResources *resources = [AESharedResources new];
    
    if(!subscriptionsData) {
        subscriptionsData = [NSData data];
    }
    
    [resources saveData:subscriptionsData toFileRelativePath:BLOCKING_SUBSCRIPTIONS_FILE];
}

+ (NSData *)subscriptionsData {
    AESharedResources *resources = [AESharedResources new];
    
    return [resources loadDataFromFileRelativePath:BLOCKING_SUBSCRIPTIONS_FILE];
}

+ (NSString *)pathForSubscriptionsData {
    
    return [[AESharedResources new] pathForRelativePath:BLOCKING_SUBSCRIPTIONS_FILE];
}

+ (NSString *)pathForSubscriptionsMeta {
    
    return [[AESharedResources new] pathForRelativePath:BLOCKING_SUBSCRIPTIONS_META_FILE];
}

+ (NSString *)pathForSubscriptionsHosts {
    
    return [[AESharedResources new] pathForRelativePath:BLOCKING_SUBSCRIPTIONS_HOSTS_FILE];
}

+ (NSString *)pathForSubscriptionsRules {
    
    return [[AESharedResources new] pathForRelativePath:BLOCKING_SUBSCRIPTIONS_RULES_FILE];
}


@end
