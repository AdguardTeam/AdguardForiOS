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
*/
#import <UIKit/UIApplication.h>
#import "ACommons/ACLang.h"
#import "ACommons/ACNetwork.h"
#import "ADomain/ADomain.h"
#import "AESAntibanner.h"
#import "ASDatabase/ASDatabase.h"
#import "ASDModels/ASDFilterObjects.h"
#import "AESharedResources.h"
#import "AASFilterSubscriptionParser.h"
#import "Adguard-Swift.h"

#define MAX_SQL_IN_STATEMENT_COUNT        100
#define UPDATE_METADATA_TIMEOUT           3.0

#define ASDF_BASE_CUSTOM_FILTER_ID               100000

#define AES_TRANSACTION_TASK_NAME        @"AESAntibaner-Transaction_Task"


NSString *ASAntibannerUpdatedFiltersKey = @"ASAntibannerUpdatedFiltersKey";
NSString *ASAntibannerInstalledNotification = @"ASAntibannerInstalledNotification";
NSString *ASAntibannerNotInstalledNotification = @"ASAntibannerNotInstalledNotification";
NSString *ASAntibannerReadyNotification = @"ASAntibannerReadyNotification";
NSString *ASAntibannerUpdateFilterRulesNotification = @"ASAntibannerUpdateFilterRulesNotification";
NSString *ASAntibannerStartedUpdateNotification = @"ASAntibannerStartedUpdateNotification";
NSString *ASAntibannerDidntStartUpdateNotification = @"ASAntibannerDidntStartUpdateNotification";
NSString *ASAntibannerFinishedUpdateNotification = @"ASAntibannerFinishedUpdateNotification";
NSString *ASAntibannerFailuredUpdateNotification = @"ASAntibannerFailuredUpdateNotification";
NSString *ASAntibannerUpdateFilterFromUINotification = @"ASAntibannerUpdateFilterFromUINotification";
NSString *ASAntibannerUpdatePartCompletedNotification = @"ASAntibannerUpdatePartCompletedNotification";
NSString *ASAntibannerFilterEnabledNotification = @"ASAntibannerFilterEnabledNotification";

/////////////////////////////////////////////////////////////////////////
#pragma mark - ASAntibanner
/////////////////////////////////////////////////////////////////////////

@interface AESAntibanner ()

@property BOOL updatesRightNow;

@end

@implementation AESAntibanner {
    
    dispatch_queue_t  workQueue;
    
    BOOL    observingDbStatus;
    
    Reachability    *reach;
    
    BOOL    serviceReady;
    BOOL    serviceInstalled; // true if at least one antibanner filter installed in DB
    
    BOOL _updatesRightNow;
    BOOL _inTransaction;
    
    NSArray *_lastUpdateFilterIds;
    NSMutableDictionary *_lastUpdateFilters;
    
    ABECFilterClientMetadata *_metadataCacheForFilterSubscription;
    NSDate *_metaCacheLastUpdated;
    ABECFilterClientLocalization *_i18nCacheForFilterSubscription;
    NSDate *_i18nCacheLastUpdated;
    
    ASDFiltersI18n *_dbFiltersI18nCache;
    ASDGroupsI18n *_dbGroupsI18nCache;
    
    UIBackgroundTaskIdentifier _transactionBackroundTaskID;
    
    id<ACNNetworkingProtocol> _networking;
    
    ASDatabase *_asDataBase;
    id <AESharedResourcesProtocol> _resources;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (instancetype)initWithNetworking:(id<ACNNetworkingProtocol>)networking resources: (id<AESharedResourcesProtocol>) resources {
    
    self = [super init];
    if (self) {
        
        _networking = networking;
        _resources = resources;
        observingDbStatus = NO;
        
        workQueue = dispatch_queue_create("ASAntibanner", DISPATCH_QUEUE_SERIAL);
        
        // set Reachability
        reach = [Reachability reachabilityWithHostname:[ABECFilterClient reachabilityHost]];
        
        serviceReady = NO;
        serviceInstalled = NO;
        
        _metadataForSubscribeOutdated = YES;
        _updatesRightNow = NO;
        _inTransaction = NO;
    }
    
    return self;
}

- (void)dealloc{
    
    if (observingDbStatus) {
        [_asDataBase removeObserver:self forKeyPath:@"ready"];
        observingDbStatus = NO;
    }
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - Properties and public methods
/////////////////////////////////////////////////////////////////////////

@synthesize updatesRightNow = _updatesRightNow;

#pragma mark database initializing methods

- (void)setDatabase:(ASDatabase *)db {
    _asDataBase = db;
}

- (void)start{

    dispatch_sync(workQueue, ^{
        if ([self checkInstalledFiltersInDB]){
            [self setServiceToReady];
        }
    });
}

#pragma mark db access methods
- (NSMutableArray *)activeRules{
    
    NSMutableArray *rules = [NSMutableArray array];
        
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"select filter_id from filters where is_enabled = 1"];
        
        BOOL userFilterEnabled = NO;
        
        while ([result next]) {
            
            NSNumber *filterId = result[0];
            
            // Make sure that user filter rules are loaded after other filters
            // https://github.com/AdguardTeam/AdguardForMac/issues/41
            // https://github.com/AdguardTeam/AdguardForiOS/issues/64
            
            if ([filterId integerValue] == ASDF_USER_FILTER_ID) {
                userFilterEnabled = YES;
            }
            else{
                [self addActiveRulesFromDb:db forFilter:filterId to:rules];
            }
        }
        [result close];
        
        if (userFilterEnabled) {
            
            [self addActiveRulesFromDb:db forFilter:@(ASDF_USER_FILTER_ID) to:rules];
        }
    }];
    
    return rules;
}

- (NSArray*) enabledFilterIDs {
    
    NSMutableArray *filterIDs = [NSMutableArray array];
    
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"select filter_id from filters where is_enabled = 1"];
        
        while ([result next]) {
            
            NSNumber *filterId = result[0];
            
            if ([filterId integerValue] != ASDF_USER_FILTER_ID) {
                [filterIDs addObject:filterId];
            }
        }
        [result close];
    }];
   
    return filterIDs.copy;
}

- (NSArray*) activeFilterIDs {
    
    NSMutableArray *filterIDs = [NSMutableArray array];
    
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"select group_id from filter_groups where is_enabled = 1"];
        
        NSMutableSet<NSNumber*>* enabledGroupIds = [NSMutableSet new];
        
        while ([result next]) {
            [enabledGroupIds addObject:result[0]];
        }
        [result close];
        
        result = [db executeQuery:@"select filter_id, group_id from filters where is_enabled = 1"];
        
        while ([result next]) {
            
            NSNumber *filterId = result[0];
            NSNumber *groupId = result[1];
            
            if ([enabledGroupIds containsObject:groupId]) {
                [filterIDs addObject:filterId];
            }
        }
        [result close];
    }];
    
    return filterIDs.copy;
}

- (NSArray<NSNumber*> *)activeGroupIDs {
    NSMutableArray *groupIDs = [NSMutableArray array];
    
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"select group_id from filter_groups where is_enabled = 1"];
        
        while ([result next]) {
            NSNumber *groupId = result[0];
            [groupIDs addObject:groupId];
        }
        [result close];
    }];
    
    return groupIDs.copy;
}

- (NSArray<NSNumber*> *)activeFilterIDsByGroupID:(NSNumber*)groupID {
    NSMutableArray *filterIDs = [NSMutableArray array];
    
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery: [NSString stringWithFormat: @"select filter_id from filters where is_enabled = 1 and group_id = %@", groupID]];
        
        while ([result next]) {
            
            NSNumber *filterId = result[0];
            [filterIDs addObject:filterId];
        }
        [result close];
    }];
    
    return filterIDs.copy;
}

- (BOOL)checkIfFilterInstalled:(NSNumber *)filterId{
    
    if (!filterId)
        [[NSException argumentException:@"filterId"] raise];
    
    __block BOOL checkResult = NO;
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"select * from filters where filter_id = ? limit 1", filterId];
        
        checkResult = [result next];
        [result close];
    }];
    
    return checkResult;
}

- (NSArray<ASDFilterRule*> *)activeRulesForFilter:(NSNumber *)filterId{
    
    NSMutableArray *rules = [NSMutableArray array];
    
    if (!filterId)
        [[NSException argumentException:@"filterId"] raise];
    
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"select filter_id from filters where filter_id = ? and is_enabled = 1", filterId];
        if ([result next]){
            
            [self addActiveRulesFromDb:db forFilter:filterId to:rules];
        }
        
        [result close];
    }];
    
    return rules;
}

- (NSArray<ASDFilterGroup*> *)groups{
    
    __block NSArray *groups;
    
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        groups = [self groupsFromDb:db];
    }];
    
    return groups;
}

- (ASDGroupsI18n *)groupsI18n{
    
    __block ASDGroupsI18n *i18n = _dbGroupsI18nCache;
    if (!i18n) {
        
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            
            if (!_dbGroupsI18nCache) {
                _dbGroupsI18nCache = [self groupsI18nFromDb:db];
            }
            i18n = _dbGroupsI18nCache;
        }];
    }
    
    return i18n;
}

- (NSArray<ASDFilterMetadata*> *)filters{
    
    __block NSArray *filters;
    
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        filters = [self filtersFromDb:db];
    }];
    
    return filters;
}

- (NSArray<ASDFilterMetadata*> *)activeFilters{
    
    __block NSArray *filters;
    
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        filters = [self filtersFromDb:db];
    }];
    
    __block NSArray *groups;
    
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {

        groups = [self groupsFromDb:db];
    }];
    
    NSMutableSet<NSNumber*>* enabledGroups = [NSMutableSet new];
    
    for (ASDFilterGroup * group in groups) {
        if (group.enabled.boolValue) {
            [enabledGroups addObject:group.groupId];
        }
    }
    
    NSMutableArray* activeFilters = [NSMutableArray new];
    
    for (ASDFilterMetadata* filter in filters) {
        if ([enabledGroups containsObject:filter.groupId]) {
            [activeFilters addObject:filter];
        }
    }
    
    return activeFilters.copy;
}


- (NSArray<ASDFilterMetadata *> *)filtersForGroup:(NSNumber *)groupId {
    __block NSArray *filters;
    
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        filters = [self filtersFromDb:db groupId:groupId];
    }];
    
    return filters;
}

- (ASDFiltersI18n *)filtersI18n{
    
    __block ASDFiltersI18n *i18n = _dbFiltersI18nCache;
    if (!i18n) {
        
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            if (!_dbFiltersI18nCache) {
                _dbFiltersI18nCache = [self filtersI18nFromDb:db];
            }
            i18n = _dbFiltersI18nCache;
        }];
    }
    
    return i18n;
}

- (NSArray<ASDFilterRule*> *)rulesForFilter:(NSNumber *)filterId{
    
    __block NSArray *rules;
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        rules = [self rulesFromDb:db filterId:filterId];
    }];
    
    return rules;
}

- (int)rulesCountForFilter:(NSNumber *)filterId {
    
    __block int rulesCount;
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        rulesCount = [self rulesCountFromDb:db filterId:filterId];
    }];
    
    return rulesCount;
}

- (void)setFilter:(NSNumber *)filterId enabled:(BOOL)enabled fromUI:(BOOL)fromUI{
    
    dispatch_sync(workQueue, ^{
        
        __block BOOL result = NO;
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            
            *rollback = NO;
            result = [db executeUpdate:@"update filters set is_enabled = ? where filter_id = ?", @(enabled), filterId];
            DDLogInfo(@"Filter with filterId = %@ , and expected enabled state = %d, was added to db with result = %d", filterId, (int)enabled, (int)result);
            
            [NSNotificationCenter.defaultCenter postNotificationName:ASAntibannerFilterEnabledNotification object:nil userInfo:@{@"filter_id":filterId, @"enabled":@(enabled)}];
        }];
        
    });
}

- (BOOL)setGroupEnabled:(FMDatabase *)db enabled:(BOOL)enabled groupId:(NSNumber *)groupId {
    return [db executeUpdate:@"update filter_groups set is_enabled = ? where group_id = ?", @(enabled), groupId];
}

- (void)setFiltersGroup:(NSNumber *)groupId enabled:(BOOL)enabled {
    
    dispatch_sync(workQueue, ^{
        
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            
            *rollback = NO;
            [self setGroupEnabled:db enabled:enabled groupId:groupId];
        }];
        
    });
}

- (void)setRules:(NSArray *)ruleIds filter:(NSNumber *)filterId enabled:(BOOL)enabled{
    
    dispatch_async(workQueue, ^{ @autoreleasepool {
        
        NSUInteger count = ruleIds.count;
        NSUInteger index = 0;
        NSUInteger len = MIN(MAX_SQL_IN_STATEMENT_COUNT, count);
        NSArray *ruleIdsSegment;
        while (len && count >= (index + len)) {
            
            ruleIdsSegment = [ruleIds objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, len)]];
            [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
                
                *rollback = NO;
                NSString *queryString = [NSString stringWithFormat:@"update filter_rules set is_enabled = %i where filter_id = %@ and rule_id in (%@)", enabled, filterId, [ruleIdsSegment componentsJoinedByString:@", "]];
                [db executeUpdate:queryString];
                
            }];
            
            index += len;
            len = MIN(MAX_SQL_IN_STATEMENT_COUNT, (count - index));
        }
        
    }});
}

- (BOOL)addRule:(ASDFilterRule *)rule {
    
    __block BOOL added = NO;
    
    if (!rule) {
        
        [[NSException argumentException:@"rule"] raise];
    }
    
    dispatch_sync(workQueue, ^{ @autoreleasepool {
        
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            
            *rollback = YES;
            FMResultSet *result = [db executeQuery:@"select editable from filters where filter_id = ?", rule.filterId];
            if ([result next] && [result[0] isKindOfClass:[NSNumber class]] && [result[0] boolValue]){
                
                [result close];
                result = [db executeQuery:@"select max(rule_id) from filter_rules where filter_id = ?", rule.filterId];
                
                NSNumber *ruleId;
                if ([result next]) {
                    
                    id maxValue = result[0];
                    if ([maxValue isKindOfClass:[NSNumber class]])
                        ruleId = @([maxValue unsignedIntegerValue] + 1);
                    else
                        ruleId = @(1);
                    
                    added = [db executeUpdate:@"insert into filter_rules (filter_id, rule_id, rule_text, is_enabled, affinity) values (?, ?, ?, ?, ?)", rule.filterId, ruleId, rule.ruleText, rule.isEnabled, rule.affinity];
                    
                    if (added)
                        added = [db executeUpdate:@"update filters set last_update_time = datetime(?) where filter_id = ?", [[NSDate date] iso8601String], rule.filterId];
                    
                    if (added) {
                        
                        *rollback = NO;
                        rule.ruleId = ruleId;
                    }
                    else{
                        
                        DDLogError(@"Can't add rule: \"%@\", for filter Id: %@", rule.ruleText, rule.filterId);
                        DDLogError(@"Database error: %@", [[db lastError] localizedDescription]);
//                        DDLogErrorTrace();
                    }
                }
            }
            
            [result close];
        } ];
        
    }});

    return added;
}

- (BOOL)updateRule:(ASDFilterRule *)rule {
    
    __block BOOL updated = NO;
    
    if (!rule) {
        
        [[NSException argumentException:@"rule"] raise];
    }
    
    dispatch_sync(workQueue, ^{ @autoreleasepool {
        
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            
            *rollback = YES;
            FMResultSet *result = [db executeQuery:@"select editable from filters where filter_id = ?", rule.filterId];
            if ([result next] && [result[0] isKindOfClass:[NSNumber class]] && [result[0] boolValue]){
                
                updated = [db executeUpdate:@"update filter_rules set rule_text = ?, is_enabled = ? where filter_id = ? and rule_id = ?", rule.ruleText, rule.isEnabled, rule.filterId, rule.ruleId];
                
                if (updated) {
                    updated = (BOOL)[db changes];
                }
                
                if (updated)
                    updated = [db executeUpdate:@"update filters set last_update_time = datetime(?) where filter_id = ?", [[NSDate date] iso8601String], rule.filterId];
                
                if (updated) {
                    
                    *rollback = NO;
                }
                else{
                    
                    DDLogError(@"Can't update rule: filterId-%@, ruleId-%@, ruleText-\"%@\"", rule.filterId, rule.ruleId, rule.ruleText);
                    DDLogError(@"Database error: %@", [[db lastError] localizedDescription]);
//                    DDLogErrorTrace();
                }
            }
            
            [result close];
        } ];
        
    }});
    
    return updated;
}

- (BOOL)importRules:(NSArray <ASDFilterRule *> *)rules filterId:(NSNumber *)filterId{
    
    if (!rules) {
        
        [[NSException argumentException:@"rules"] raise];
    }
    
    if (!filterId) {
        
        [[NSException argumentException:@"filterId"] raise];
    }
    
    __block BOOL imported = NO;
    
    dispatch_sync(workQueue, ^{ @autoreleasepool {
        
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            
            *rollback = YES;
            FMResultSet *result = [db executeQuery:@"select editable from filters where filter_id = ?", filterId];
            if ([result next] && [result[0] isKindOfClass:[NSNumber class]] && [result[0] boolValue]){
                
                imported = [db executeUpdate:@"delete from filter_rules where filter_id = ?", filterId];
                if (imported) {
                    
                    NSUInteger count = 0;
                    for (ASDFilterRule *rule in rules) {
                        
                        if ([NSString isNullOrEmpty:rule.ruleText]) {
                            continue;
                        }
                        count++;
                        [db executeUpdate:@"insert into filter_rules (filter_id, rule_id, rule_text, is_enabled, affinity) values (?, ?, ?, ?, ?)", filterId, @(count), rule.ruleText, rule.isEnabled, rule.affinity];
                    }
                    
                    imported = [db executeUpdate:@"update filters set last_update_time = datetime(?) where filter_id = ?", [[NSDate date] iso8601String], filterId];
                    
                    *rollback = NO;
                }
            }
            
            [result close];
        }];
    }});
    
    return imported;
}

- (BOOL)removeRules:(NSArray *)ruleIds filterId:(NSNumber *)filterId {
    
    __block BOOL removed = YES;
    
    if (!ruleIds) {
        
        [[NSException argumentException:@"ruleIds"] raise];
    }
    
    if (!filterId) {
        
        [[NSException argumentException:@"FilterId"] raise];
    }
    
    dispatch_sync(workQueue, ^{ @autoreleasepool {
        
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            
            *rollback = YES;
            FMResultSet *result = [db executeQuery:@"select editable from filters where filter_id = ?", filterId];
            if ([result next] && [result[0] isKindOfClass:[NSNumber class]] && [result[0] boolValue]){
                
                NSUInteger count = ruleIds.count;
                NSUInteger index = 0;
                NSUInteger len = MIN(MAX_SQL_IN_STATEMENT_COUNT, count);
                NSArray *ruleIdsSegment;
                while (len && count >= (index + len)) {
                    
                    ruleIdsSegment = [ruleIds objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, len)]];
                    NSString *queryString = [NSString stringWithFormat:@"delete from filter_rules where filter_id = %@ and rule_id in (%@)", filterId, [ruleIdsSegment componentsJoinedByString:@", "]];
                    removed &= [db executeUpdate:queryString];
                    
                    if (!removed) {
                        
                        break;
                    }
                    
                    index += len;
                    len = MIN(MAX_SQL_IN_STATEMENT_COUNT, (count - index));
                }
                
                if (removed)
                    removed = [db executeUpdate:@"update filters set last_update_time = datetime(?) where filter_id = ?", [[NSDate date] iso8601String], filterId];
                
                if (removed) {
                    
                    *rollback = NO;
                }
                else{
                    
                    DDLogError(@"Can't remove rules for filter Id: %@", filterId);
                    DDLogError(@"Database error: %@", [[db lastError] localizedDescription]);
                    DDLogErrorTrace();
                }
                
            }
            
            [result close];
        }];
        
    }});
    
    return removed;
}

- (ABECFilterClientMetadata *)metadataForSubscribe:(BOOL)refresh {
    
    @autoreleasepool {
        
        if(!_metadataCacheForFilterSubscription) {
            _metadataCacheForFilterSubscription = _resources.filtersMetadataCache;
        }
        
        if (! _metadataCacheForFilterSubscription
            || refresh
            || ([_metaCacheLastUpdated timeIntervalSinceNow] * -1) >= AS_CHECK_FILTERS_UPDATES_DEFAULT_PERIOD) {
            // trying load metadata from backend service.
            if ([reach isReachable]) {
                
                ABECFilterClientMetadata *metadata = [[ABECFilterClient singleton] loadMetadataWithTimeoutInterval:@(UPDATE_METADATA_TIMEOUT)];
                if (metadata) {
                    
                    _metadataCacheForFilterSubscription = metadata;
                    _resources.filtersMetadataCache = _metadataCacheForFilterSubscription;
                    _metaCacheLastUpdated = [NSDate date];
                }
                _metadataForSubscribeOutdated = NO;
            }
        }
        
        if (_metadataCacheForFilterSubscription) {
            
            return _metadataCacheForFilterSubscription;
        }
        else {
            
            _metadataForSubscribeOutdated = YES;
            
            // Trying obtain filters metadata from default DB.
            ABECFilterClientMetadata *metadata = [ABECFilterClientMetadata new];
            [_asDataBase queryDefaultDB:^(FMDatabase *db) {
                
                metadata.filters = [self filtersFromDb:db];
                metadata.groups = [self groupsFromDb:db];
            }];
            
            return metadata;
        }
    }
}

- (ABECFilterClientLocalization *)i18nForSubscribe:(BOOL)refresh {
    
    @autoreleasepool {
        
        if(!_i18nCacheForFilterSubscription) {
            _i18nCacheForFilterSubscription = _resources.i18nCacheForFilterSubscription;
        }
        
        if (! _i18nCacheForFilterSubscription
            || refresh
            || ([_i18nCacheLastUpdated timeIntervalSinceNow] * -1) >= AS_CHECK_FILTERS_UPDATES_DEFAULT_PERIOD) {
            // trying load metadata from backend service.
            if ([reach isReachable]) {
                
                ABECFilterClientLocalization *i18n = [[ABECFilterClient singleton] loadI18nWithTimeoutInterval:@(UPDATE_METADATA_TIMEOUT)];
                if (i18n) {
                    
                    _i18nCacheForFilterSubscription = i18n;
                    _resources.i18nCacheForFilterSubscription = _i18nCacheForFilterSubscription;
                    _i18nCacheLastUpdated = [NSDate date];
                }
                _metadataForSubscribeOutdated = NO;
            }
        }
        
        if (_i18nCacheForFilterSubscription) {
            
            return _i18nCacheForFilterSubscription;
        }
        else {
            
            _metadataForSubscribeOutdated = YES;
            
            // Trying obtain filters metadata from default DB.
            ABECFilterClientLocalization *i18n = [ABECFilterClientLocalization new];
            [_asDataBase queryDefaultDB:^(FMDatabase *db) {
                
                i18n.filters = [self filtersI18nFromDb:db];
                i18n.groups = [self groupsI18nFromDb:db];
            }];
            
            return i18n;
        }
    }
}

- (BOOL)subscribeFilters:(NSArray<ASDFilterMetadata*> *)filters{
    
    if (!filters) {
        
        [NSException argumentException:@"filters"];
    }
    
    // getting of the filters, which need install
    NSMutableArray *filtersForUpdate = filters.mutableCopy;
    NSMutableArray *filtersForInstall = [NSMutableArray array];
    NSArray *installedFilters = [self filters];
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for (int i=0; i < filtersForUpdate.count; i++) {
        ASDFilterMetadata *item = filtersForUpdate[i];
        if (![installedFilters containsObject:item]) {
            
            item = [item copy];
            item.enabled = @YES;
            [filtersForInstall addObject:item];
            [indexes addIndex:i];
        }
    }
    [filtersForUpdate removeObjectsAtIndexes:indexes];
    
     __block BOOL result = NO;
    
    if (filtersForInstall.count) {
       
        dispatch_sync(workQueue, ^{
            
            @autoreleasepool {

                __block NSArray *defaultDbFilters;
                
                [_asDataBase queryDefaultDB:^(FMDatabase *db) {
                    
                    defaultDbFilters = [self filtersFromDb:db];
                }];
                
                [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
                    
                    *rollback = YES;
                    
                    if (_i18nCacheForFilterSubscription) {
                        
                        // If were loaded i18n from backend,
                        // updating the DB.
                        result = [self insertI18nIntoDb:db
                                                filters:_i18nCacheForFilterSubscription.filters
                                                 groups:_i18nCacheForFilterSubscription.groups];
                        if (result) {
                            _dbGroupsI18nCache = nil;
                            _dbFiltersI18nCache = nil;
                        }
                        else
                            return;
                    }
                    
                    NSMutableArray *filtersMetaForSave = [NSMutableArray new];
                    for (ASDFilterMetadata *filter in filters) {
                        
                        if ([self installRulesFromBackendWithFilterId:filter.filterId db:db]) {
                            
                            [filtersMetaForSave addObject:filter];
                        } else if ([self installRulesFromDefaultDbWithFilterId:filter.filterId db:db]) {
                            
                            NSUInteger index = [defaultDbFilters indexOfObject:filter];
                            if (index != NSNotFound) {
                                ASDFilterMetadata *dbFilter = defaultDbFilters[index];
                                if (dbFilter) {
                                    
                                    NSDictionary *values = [dbFilter dictionaryWithValuesForKeys:@[
                                                                                                   @"updateDate",
                                                                                                   @"updateDateString",
                                                                                                   @"checkDate",
                                                                                                   @"checkDateString",
                                                                                                   @"version",
                                                                                                   @"rulesCount"
                                                                                                   ]];
                                    [filter setValuesForKeysWithDictionary:values];
                                    [filtersMetaForSave addObject:filter];
                                }
                            }
                        }
                    }
                    
                    result = [self insertMetadataIntoDb:db filters:filtersMetaForSave];
                    if (!result)
                        return;
                    
                    *rollback = NO;
                }];
            }
        });
    }
    
    return result;
}

- (NSNumber*) nextCustomFilterId {
    __block NSInteger filterId = ASDF_BASE_CUSTOM_FILTER_ID;
    dispatch_sync(workQueue, ^{
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            FMResultSet *result = [db executeQuery:@"select max(filter_id) from filters;"];
            if ([result next]) {
                NSInteger value = [result longLongIntForColumnIndex:0];
                filterId = MAX(filterId, value) + 1;
            }
            [result close];
        }];
    });
    
    return [NSNumber numberWithInteger: filterId];
}

- (void)subscribeCustomFilterFromResult:(AASCustomFilterParserResult *)parserResult completion:(void (^)(void))completionBlock {
    
    dispatch_async(workQueue, ^{
        [self subscribeCustomFilterFromResultInternal:parserResult completion:completionBlock];
    });
}

- (void)subscribeCustomFilterFromResultInternal:(AASCustomFilterParserResult *)parserResult completion:(void (^)(void))completionBlock {
    
    if (!parserResult) {
        return;
    }
    
    parserResult.meta.groupId = @(FilterGroupId.custom);
    
    if(completionBlock){
        completionBlock();
    }
    
    if ([self updateFilter:parserResult.meta rules:parserResult.rules db:_asDataBase]) {
        // Notifying to all, that filter rules were updated
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerUpdateFilterRulesNotification object:self];
        });
    }
}

- (NSNumber *)customFilterIdByUrl:(NSString *)url {
    
    __block NSNumber *filterId = nil;
    
    dispatch_sync(workQueue, ^{
        
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            FMResultSet *result = [db executeQuery:@"select filter_id from filters where subscriptionUrl = ?", url];
            if ([result next]) {
                filterId = [NSNumber numberWithInteger: [result longLongIntForColumnIndex:0]];
            }
            [result close];
        }];
    });
    
    return filterId;
}

- (BOOL)updateFilter:(ASDFilterMetadata *)filter rules:(NSArray <ASDFilterRule *> *)rules db:(ASDatabase *)theDB{
    
    __block BOOL result = NO;
    [theDB exec:^(FMDatabase *db, BOOL *rollback) {
        
        *rollback = YES;
        
        //get disabled rules
        NSArray *disabledRuleTexts = [self disabledRuleTextsForDb:db filterId:filter.filterId];
        
        BOOL boolResult = [db executeUpdate:@"delete from filter_rules where filter_id = ?", filter.filterId];
        
        boolResult &= [self insertMetadataIntoDb:db filters:@[filter]];
        
        if (!boolResult)
            return;
        
        if (rules.count)
            for (ASDFilterRule *rule in rules){
                rule.filterId = filter.filterId;
                if ([disabledRuleTexts containsObject:rule.ruleText])
                    rule.isEnabled = @(0);
                [db executeUpdate:@"insert into filter_rules (filter_id, rule_id, rule_text, is_enabled, affinity) values (?, ?, ?, ?, ?)", rule.filterId, rule.ruleId, rule.ruleText, rule.isEnabled, rule.affinity];
            }
        
        *rollback = NO;
        result = YES;
    }];
    
    return result;
}

- (BOOL)unsubscribeFilter:(NSNumber *)filterId {
    
    __block BOOL removed = NO;
    
    dispatch_sync(workQueue, ^{ @autoreleasepool {
        
        removed = [self unsubscribeFilterInternal:filterId];
        
    }});
    
    return removed;
}

- (BOOL) unsubscribeFilterInternal:(NSNumber *)filterId {
    
    __block BOOL removed = NO;
    
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        *rollback = YES;
        
        FMResultSet *result = [db executeQuery:@"select removable from filters where filter_id = ?", filterId];
        if ([result next] && [result[0] isKindOfClass:[NSNumber class]] && [result[0] boolValue]){
            
            [result close];
            removed = [self deleteFilter:filterId fromDb:db];
            if (removed){
                
                *rollback = NO;
                
                __weak __typeof__(self) wSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), workQueue, ^{
                    __typeof__(self) sSelf = wSelf;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerUpdateFilterFromUINotification object:sSelf];
                    });
                });
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerUpdateFilterRulesNotification object:self];
                });
            }
        }
        else{
            [result close];
            DDLogError(@"Error of removing antibanner filter (filterId=%@): Can't remove stable filter.", filterId);
            DDLogErrorTrace();
        }

    }];
        
    return removed;
}

#pragma mark update filters

- (BOOL)startUpdatingForced:(BOOL)forced interactive:(BOOL)interactive{
    
    if (!self.updatesRightNow) {
        
        dispatch_async(workQueue, ^{
            
            [self updateAntibannerForced:forced interactive:interactive];
        });
        return YES;
    }
    
    return NO;
}

- (void)repairUpdateStateForBackground {

    dispatch_sync(workQueue, ^{
        
        DDLogInfo(@"(ASAntibanner) repair update state - background");
        self.updatesRightNow = YES;
        [[ABECFilterClient singleton] handleBackgroundWithSessionId:AE_FILTER_UPDATES_ID
                                                      updateTimeout:AS_FETCH_UPDATE_STATUS_PERIOD
                                                           delegate:self];
    });
}

- (void)repairUpdateStateWithCompletionBlock:(void (^)(void))block {
    
    DDLogDebugTrace();
    
    [self setLastUpdateFilters];
    if (_lastUpdateFilterIds.count && _lastUpdateFilters.count
        && _lastUpdateFilterIds.count == _lastUpdateFilters.count ) {
        
        DDLogInfo(@"(ASAntibanner) repair update state - finish update in background mode");
        [self finishUpdateInBackgroundMode];
        if (block) {
            block();
        }
        
        return;
    }
    
    if (self.updatesRightNow) {
        if (block) {
            block();
        }
        return;
    }
    
    DDLogInfo(@"(ASAntibanner) repair update state - reset download session");
    [[ABECFilterClient singleton] resetSession:AE_FILTER_UPDATES_ID
                                 updateTimeout:AS_FETCH_UPDATE_STATUS_PERIOD
                                      delegate:self
                               completionBlock:^(BOOL updateInProgress) {
        dispatch_sync(workQueue, ^{
            
            if (updateInProgress) {
                [self updateStart];
            }
        });
       if (block) {
           block();
       }
    }];
}

- (NSDate *)filtersLastUpdateTime {
    
    __block NSDate* date = nil;
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *result = [db executeQuery:@"select max(last_update_time) from filters where is_enabled = 1"];
        if([result next]) {
            NSString* dateString = result[@"max(last_update_time)"];
            date = [NSDate dateWithSQliteString:dateString];
        }
        
        [result close];
    }];
    
    return date;
}

#pragma mark transactions

- (BOOL)inTransaction{
    
    return _inTransaction;
}

- (void)beginTransaction{
    
    [_asDataBase isolateQueue:workQueue];
    [_asDataBase readUncommited:YES];
    dispatch_sync(workQueue, ^{
        
        if (_inTransaction) {
            return;
        }
        
        [self beginBackgroundTaskWithExpirationHandler:^{
            
            [self rollbackTransactionInternal:YES];
        }];
        
        [_asDataBase rawExec:^(FMDatabase *db) {
            [db beginDeferredTransaction];
        }];
        
        _inTransaction = YES;
    });
}

- (void)endTransaction{
    
    dispatch_sync(workQueue, ^{
        if (_inTransaction) {
            
            [_asDataBase rawExec:^(FMDatabase *db) {
                
                [db commit];
            }];
            
            self.updatesRightNow = NO;
        }
        
        [self endBackgroundTask];
        
        _inTransaction = NO;
    });
    [_asDataBase readUncommited:NO];
    [_asDataBase resetIsolationQueue:workQueue];
    
}

- (void)rollbackTransaction{
    
    [self rollbackTransactionInternal:NO];
}

- (void)rollbackTransactionInternal:(BOOL)backgroundTaskExpired{
    
    dispatch_sync(workQueue, ^{
        
        if (_inTransaction) {
            [_asDataBase rawExec:^(FMDatabase *db) {
                
                [db rollback];
            }];
            
            self.updatesRightNow = NO;
        }
        
        if(!backgroundTaskExpired)
            [self endBackgroundTask];
        
        _inTransaction = NO;
    });
    [_asDataBase readUncommited:NO];
    [_asDataBase resetIsolationQueue:workQueue];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark ABECFilterAsyncDelegateProtocol protocol methods

- (void)filterClient:(ABECFilterClient *)client metadata:(ABECFilterClientMetadata *)metadata {

    dispatch_sync(workQueue, ^{

        DDLogDebug(@"(AESAntibanner) filterClient:metadata:\n%@", metadata);
        
        if (metadata == nil) {
            [self updateFailure];
            return;
        }

        NSSet *metadataForUpdate = [NSSet setWithArray:_resources.lastUpdateFilterMetadata.filters];
        
        // get metadata only for filters, which must be updated
        metadata.filters = [metadata.filters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"filterId IN %@", [[metadataForUpdate allObjects] valueForKey:@"filterId"]]];
        
        NSMutableArray *filtersForUpdate = [NSMutableArray array];
        for (ASDFilterMetadata *version in metadata.filters) {
            
            ASDFilterMetadata *filterMeta = [metadataForUpdate member:version];
            [self copyUserSettingsFromMeta:filterMeta toMeta:version];
            
            // checking version
            if ([version.version compare:filterMeta.version options:NSNumericSearch] == NSOrderedDescending) {

                [filtersForUpdate addObject:version];
            }
        }

        if (filtersForUpdate.count) {
            
            //update stage 2
            NSArray *filterIds = [filtersForUpdate valueForKey:@"filterId"];
            NSError *error = [client filtersRequestWithFilterIds:filterIds];
            
            if (error) {
                [self updateFailure];
            }
            else {
                
                _resources.lastUpdateFilterMetadata = metadata;
                _resources.lastUpdateFilterIds = filterIds;
                
                DDLogDebug(@"(AESAntibanner) -filterClient: filters requested");
            }
        }
        else {
            
            [self updateMetadata:metadata filters:nil];
            [self updateFinished:@[]];
        }
    });
}

- (BOOL)filterClient:(ABECFilterClient *)client filterId:(NSNumber *)filterId filter:(ASDFilter *)filter {
    
    DDLogDebug(@"(AESAntibanner) filterClient:filterId:%@ filter:%@ ", filterId, filter);
    
    if (!filterId) {
        return NO;
    }
    
    [self setLastUpdateFilters];
    
    _lastUpdateFilters[filterId] = filter ?: [NSNull null];
    
    //save filters dictionary to disk
    AESharedResources.new.lastUpdateFilters = _lastUpdateFilters;
    
    DDLogDebug(@"(AESAntibanner) filterClient:filterId:filter: saved filters count-%lu", _lastUpdateFilters.count);
    
    if (_lastUpdateFilterIds.count == _lastUpdateFilters.count) {
        
        return YES;
    }
    
    return NO;
}

- (void)filterClient:(ABECFilterClient *)client localizations:(ABECFilterClientLocalization *)i18n {

   DDLogDebug(@"(AESAntibanner) filterClient:localizations:%@ ", i18n);
    
   if (i18n) {
        
        dispatch_sync(workQueue, ^{
            
            [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
                
                BOOL result = [self insertI18nIntoDb:db filters:i18n.filters groups:i18n.groups];
                if (result) {
                    _dbGroupsI18nCache = nil;
                    _dbFiltersI18nCache = nil;
                }
                *rollback = !result;
            }];
            
        });
    }

    
}


- (void)filterClientFinishedDownloading:(ABECFilterClient *)client error:(NSError *)error {

    DDLogDebugTrace();
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerUpdatePartCompletedNotification object:self];
    });
    
   
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Private methods
/////////////////////////////////////////////////////////////////////////

// updateAntibanner method must call in workQueue
- (void)updateAntibannerForced:(BOOL)forced interactive:(BOOL)interactive{
    
    // return if no antibanner filters in DB
    if (!serviceInstalled)
        return;

    if (_asDataBase.ready){
        
        @autoreleasepool {
            
#ifndef APP_EXTENSION
            UIBackgroundTaskIdentifier backgroundTaskIdentifier = [UIApplication.sharedApplication beginBackgroundTaskWithExpirationHandler:nil];
#endif
            
            // Notifying to all, that filter rules may be obtained
            if (!serviceReady){
                
                serviceReady = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    DDLogInfo(@"(ASAntibanner) ASAntibannerReadyNotification");
                    [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerReadyNotification object:self];
                });
            }
            
            // Getting filter info from DB
            NSMutableSet *dbFilterMetas = [NSMutableSet setWithArray:[self filters]];
            
            ASDFilterMetadata *filterMeta;
            
            NSTimeInterval interval;
            NSMutableSet *metadataForUpdate = [NSMutableSet set];
            
            // Determine filter list for updating metadata and rules
            for (filterMeta in dbFilterMetas) {
                
                // determin interval
                interval = [filterMeta.checkDate timeIntervalSinceNow] * -1;
                
                //determin not editable
                if (![filterMeta.editable boolValue]) {
                    
                    // updated only enabled filters
                    if (([filterMeta.enabled boolValue]
                         //Special case for Simplified domain names filter. We allow update of this filter in any case.
                         //https://github.com/AdguardTeam/AdguardForiOS/issues/302
                         || [filterMeta.filterId isEqual:@(ASDF_SIMPL_DOMAINNAMES_FILTER_ID)])
                        
                        && ( forced || interval >= [filterMeta.expires integerValue] )) {
                        
                        [metadataForUpdate addObject:filterMeta];
                    }
                }
            }
            
            if (metadataForUpdate.count) {
                
                [self updateStart];
                
                if (interactive) {
                    
                    // Interactive mode
                    [self updateInInteractiveModeWithMetadataForUpdate:metadataForUpdate];
                    
                }
                else {
                    
                    // Starting update process in background
                    [self startUpdateInBackgroundModeWithMetadataForUpdate:metadataForUpdate];
                }
            }
            else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    DDLogInfo(@"(ASAntibanner) Didn't start update process.");
                    [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerDidntStartUpdateNotification object:self];
                });
            }
#ifndef APP_EXTENSION
            [UIApplication.sharedApplication endBackgroundTask:backgroundTaskIdentifier];
#endif
        }
    }
    else if (!observingDbStatus){
        
        observingDbStatus = YES;
        [_asDataBase addObserver:self forKeyPath:@"ready" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)updateInInteractiveModeWithMetadataForUpdate:(NSSet *)metadataForUpdate {
    
    @autoreleasepool {
    
        ABECFilterClient *filterClient = [ABECFilterClient singleton];
        
        ASDFilterMetadata *filterMeta;
        
        // Get filters/groups metadata and i18n from backend and insert to  DB.
        // update i18n
        ABECFilterClientLocalization *i18n = [filterClient loadI18nWithTimeoutInterval:nil];
        if (i18n) {
            
            [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
                
                BOOL result = [self insertI18nIntoDb:db filters:i18n.filters groups:i18n.groups];
                if (result) {
                    _dbGroupsI18nCache = nil;
                    _dbFiltersI18nCache = nil;
                }
                *rollback = !result;
            }];
        }
        else {
            [self updateFailure];
            return;
        }
        
        // main updating work
        ABECFilterClientMetadata *metadata = [filterClient loadMetadataWithTimeoutInterval:nil];
        if (metadata) {
            
            // get metadata only for filters, which must be updated
            metadata.filters = [metadata.filters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"filterId IN %@", [[metadataForUpdate allObjects] valueForKey:@"filterId"]]];
            
            NSMutableSet <NSNumber*> *enabledGroups = [NSMutableSet new];
            for(ASDFilterGroup* group in self.groups) {
                if(group.enabled.boolValue)
                    [enabledGroups addObject:group.groupId];
            }
            
            for (ASDFilterGroup* group in metadata.groups) {
                group.enabled = [NSNumber numberWithBool: [enabledGroups containsObject:group.groupId]];
            }
            
            NSMutableDictionary <NSNumber *, ASDFilter *> *filters = [NSMutableDictionary dictionary];
            
            for (ASDFilterMetadata *version in metadata.filters) {
                
                filterMeta = [metadataForUpdate member:version];
                [self copyUserSettingsFromMeta:filterMeta toMeta:version];
                
                // checking version
                if ([version.version compare:filterMeta.version options:NSNumericSearch] == NSOrderedDescending) {
                    
                    ASDFilter *filterData = [filterClient filterWithFilterId:version.filterId];
                    filters[version.filterId] = filterData ?: (ASDFilter *)[NSNull null];
                }
            }
            
            [self updateCustomFilters];
            
            [self updateMetadata:metadata filters:filters];
        }
        else {
            [self updateFailure];
        }
    }
}

/** loads sync filters forom backend and update database
 */
- (void) updateCustomFilters {
    
    // Get custom filters from database
    
    NSMutableArray<ASDFilterMetadata *>* filtersToUpdate = [NSMutableArray new];
    
    if (!_asDataBase.ready) {
        return;
    }
    
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery: @"select * from filters where group_id = ?" , @(FilterGroupId.custom)];
        
        
        while ([result next]) {
            
            ASDFilterMetadata *filterMetadata = [[ASDFilterMetadata alloc] initFromDbResult:result];
            [filtersToUpdate addObject:filterMetadata];
        }
        [result close];
        
        
    }];

    // load filters from backend
    
    dispatch_group_t parseGroup = dispatch_group_create();
    
    NSMutableArray<AASCustomFilterParserResult*> * parseResults = [NSMutableArray new];
    
    for (ASDFilterMetadata * filter in filtersToUpdate) {
        
        AASFilterSubscriptionParser* parser = [[AASFilterSubscriptionParser alloc] initWithNetworking: _networking];
        NSURL* url = [NSURL URLWithString:filter.subscriptionUrl];
        
        dispatch_group_enter(parseGroup);
        
        [parser parseFromUrl:url completion:^(AASCustomFilterParserResult *result, NSError *error) {
            
            if (!result || error) {
                dispatch_group_leave(parseGroup);
                return;
            }
            
            result.meta.name = filter.name;
            result.meta.groupId = filter.groupId;
            result.meta.filterId = filter.filterId;
            result.meta.enabled = filter.enabled;

            [parseResults addObject:result];
            
            dispatch_group_leave(parseGroup);
        }];
    }
    
    dispatch_group_wait(parseGroup, DISPATCH_TIME_FOREVER);
    
    for (AASCustomFilterParserResult* parseResult in parseResults) {
        
        [self subscribeCustomFilterFromResultInternal:parseResult completion:nil];
    }
}

- (void)startUpdateInBackgroundModeWithMetadataForUpdate:(NSSet *)metadataForUpdate {
    // Get filters data from backend
    
    
    ABECFilterClientMetadata *metadata = [ABECFilterClientMetadata new];
    metadata.filters = [metadataForUpdate allObjects];
    //Temporary save metadata, which should be updated.
    _resources.lastUpdateFilterMetadata = metadata;

    NSError *error = [[ABECFilterClient singleton] i18nRequest];
    if (error) {
        [self updateFailure];
        return;
    }
    
    error = [[ABECFilterClient singleton] metadataRequest];
    if (error) {
        [self updateFailure];
        return;
    }
    
    DDLogDebug(@"(AESAntibanner) -updateAntibannerForced metadata/i18n requested");
}

- (void)finishUpdateInBackgroundMode {
    
    [self beginTransaction];
    DDLogInfo(@"(AESAntibanner) Begin of the Update Transaction from final stage of the update process (before DB updates).");

    dispatch_sync(workQueue, ^{
        [self updateStart];
    });
    
    // update fiters in DB
    [self updateMetadata:_resources.lastUpdateFilterMetadata filters:_resources.lastUpdateFilters];
    
    _resources.lastUpdateFilterMetadata = nil;
    _resources.lastUpdateFilters = nil;
    _resources.lastUpdateFilterIds = nil;
    _lastUpdateFilterIds = nil;
    _lastUpdateFilters = nil;
    _lastUpdateFilterIds = nil;
}

- (void)updateMetadata:(ABECFilterClientMetadata *)metadata filters:(NSDictionary<NSNumber *, ASDFilter *> *)filters {
    
    if (! metadata) {
        return;
    }
    
    dispatch_async(workQueue, ^{
        
        @autoreleasepool {
            
            NSMutableArray *filtersMetadataUpdateOnly = [NSMutableArray arrayWithCapacity:metadata.filters.count];
            
            __block BOOL rulesUpdated = NO;
            __block BOOL metadataUpdated = NO;
            
            NSMutableArray *updatedVersions = [NSMutableArray array];
            
            // set enabled state for groups
            NSMutableSet <NSNumber*> *enabledGroups = [NSMutableSet new];
            for(ASDFilterGroup* group in self.groups) {
                if(group.enabled.boolValue)
                    [enabledGroups addObject:group.groupId];
            }
            
            for (ASDFilterGroup* group in metadata.groups) {
                group.enabled = [NSNumber numberWithBool: [enabledGroups containsObject:group.groupId]];
            }
            
            for (ASDFilterMetadata *version in metadata.filters) {
                
                ASDFilter *filterData = filters[version.filterId];
                if (filterData) {
                    
                    // filterData == NSNull, this means that we couldn't obtain rules from backend server.
                    // In this case we must not update it.
                    if ((NSNull *)filterData == [NSNull null]) {
                        continue;
                    }
                    // needs update filter (metadata and rules)
                    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
                        
                        *rollback = YES;
                        
                        //get disabled rules
                        NSArray *disabledRuleTexts = [self disabledRuleTextsForDb:db filterId:version.filterId];
                        
                        BOOL boolResult = [db executeUpdate:@"delete from filter_rules where filter_id = ?", version.filterId];
                        
                        boolResult &= [self insertMetadataIntoDb:db filters:@[version]];
                        
                        if (!boolResult)
                            return;
                        
                        if (filterData.rules.count)
                            for (ASDFilterRule *rule in filterData.rules){
                                
                                if ([disabledRuleTexts containsObject:rule.ruleText])
                                    rule.isEnabled = @(0);
                                
                                [db executeUpdate:@"insert into filter_rules (filter_id, rule_id, rule_text, is_enabled, affinity) values (?, ?, ?, ?, ?)", rule.filterId, rule.ruleId, rule.ruleText, rule.isEnabled, rule.affinity];
                            }
                        
                        *rollback = NO;
                        rulesUpdated = YES;
                        [updatedVersions addObject:version];
                    }];
                }
                else{
                    // for such filter we update only metadata
                    [filtersMetadataUpdateOnly addObject:version];
                }
            }
            
            //update metadata
            [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
                
                BOOL result = [self insertMetadataIntoDb:db groups:metadata.groups];
                result = result && [self insertMetadataIntoDb:db filters:metadata.filters];
                if (filtersMetadataUpdateOnly.count && result) {
                    result = result && [self insertMetadataIntoDb:db filters:filtersMetadataUpdateOnly];
                    metadataUpdated = result;
                }
                
                *rollback = !result;
            }];
            
            // Notifying to all, that filter rules were updated
            if (rulesUpdated) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerUpdateFilterRulesNotification object:self];
                });
                
                [self updateFinished:updatedVersions];
            }
            else if (metadataUpdated) {
                [self updateFinished:@[]];
            }
            else {
                [self updateFailure];
            }
        }
    });
}

- (void)updateStart {
    
    if (self.updatesRightNow) {
        return;
    }
    
    self.updatesRightNow = YES;
    DDLogInfo(@"(ASAntibanner) Started update process.");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerStartedUpdateNotification object:self];
    });
}

- (void)updateFinished:(NSArray *)updatedVersions {
    
    if (! _inTransaction) {
        self.updatesRightNow = NO;
    }
    
    DDLogInfo(@"(ASAntibanner) Finished update process.");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        DDLogInfo(@"Filters updated count: %lu", updatedVersions.count);
        for (ASDFilterMetadata *meta in updatedVersions) {
            DDLogInfo(@"Filter id: %@, version: %@, updated: %@.", meta.filterId, meta.version, meta.updateDateString);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerFinishedUpdateNotification object:self userInfo:@{ASAntibannerUpdatedFiltersKey : updatedVersions}];
    });

}

- (void)updateFailure{
    
    if (! _inTransaction) {
        
        self.updatesRightNow = NO;
    }

    DDLogInfo(@"(ASAntibanner) update process failure.");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerFailuredUpdateNotification object:self];
    });
}

- (BOOL) enableGroupsWithEnabledFilters {
    
    __block BOOL result = NO;
    
    dispatch_sync(workQueue, ^{
        
        if (!_asDataBase.ready) {
            return;
        }
        
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            
            NSMutableSet *groupsToEnable = [NSMutableSet new];
            
            FMResultSet *queryResult = [db executeQuery:@"select group_id from filters where is_enabled = 1"];
            
            while ([queryResult next]) {
                
                NSNumber *groupId = queryResult[0];
                
                [groupsToEnable addObject:groupId];
            }
            
            [queryResult close];
            
            for(NSNumber* groupId in groupsToEnable) {
                if (![self setGroupEnabled:db enabled:YES groupId:groupId]) {
                    return;
                }
            }
            result = YES;
        }];
    });
    
    if (result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerUpdateFilterRulesNotification object:self];
        });
    }
    
    return result;
}

- (BOOL)checkInstalledFiltersInDB{
    
    if (serviceInstalled)
        return YES;
    
    ASSIGN_WEAK(self);
    
    dispatch_async(workQueue, ^{ @autoreleasepool {
        
        ASSIGN_STRONG(self);
        
        if (_asDataBase.ready){
            
            [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
                
                *rollback = YES;
                
                FMResultSet *result = [db executeQuery:@"select * from filters limit 1"];
                if (![result next]) {
                    
                    // install default filters
                    if ([USE_STRONG(self) installFiltersIntoDb:db])
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            DDLogDebug(@"(ASAntibanner) ASAntibannerInstalledNotification");
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerInstalledNotification object:USE_STRONG(self)];
                        });
                    
                    else{
                        
                        // Can't install filters metadata into DB.
                        DDLogError(@"Can't install filters metadata into DB.");
                        DDLogErrorTrace();
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerNotInstalledNotification object:USE_STRONG(self)];
                        });
                        
                        return;
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                                               
                       DDLogDebug(@"(ASAntibanner) antibanner has been allready installed. Post ASAntibannerInstalledNotification");
                       
                       [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerInstalledNotification object:USE_STRONG(self)];
                   });
                }
                
                [result close];
                USE_STRONG(self)->serviceInstalled = YES;
                *rollback = NO;
                [USE_STRONG(self) setServiceToReady];
            }];
            
            [USE_STRONG(self) addCustomGroupIfNeeded];
            [USE_STRONG(self) updateUserfilterMetadata];
        }
        else if (!observingDbStatus){
            
            USE_STRONG(self)->observingDbStatus = YES;
            [_asDataBase addObserver:USE_STRONG(self) forKeyPath:@"ready" options:NSKeyValueObservingOptionNew context:nil];
            
        }
        
    }});
    
    return NO;
}

- (BOOL)installFiltersIntoDb:(FMDatabase *)productionDb{
    
    @autoreleasepool {
        
        __block NSArray *filters = nil;
        __block ASDFiltersI18n *filtersI18n = nil;
        
        __block NSArray *groups = nil;
        __block ASDGroupsI18n *groupsI18n = nil;
        // Trying obtain objects from default DB.
        [_asDataBase queryDefaultDB:^(FMDatabase* db) {
            
            filters = [self filtersFromDb:db];
            filtersI18n = [self filtersI18nFromDb:db];
            
            groups = [self groupsFromDb:db];
            groupsI18n = [self groupsI18nFromDb:db];
        }];
        
        
        // Insert groups metadata into db
        if (![self insertMetadataIntoDb:productionDb groups:groups]) {
            
            return NO;
        }
        if (![self insertI18nIntoDb:productionDb filters:filtersI18n groups:groupsI18n]) {
            
            return NO;
        }
        
        // Get suitable filters.
        NSMutableArray *sFilters = [NSMutableArray arrayWithCapacity:4];
        NSString *langString = [NSString stringWithFormat:@"%@|%@", [ADLocales lang], [ADLocales region]];
        for (ASDFilterMetadata *filter in filters){
            BOOL recomended = NO;
            for (ASDFilterTagMeta* tagMeta in filter.tags) {
                if(tagMeta.type == ASDFilterTagTypeRecommended){
                    recomended = YES;
                    break;
                }
            }
            
            if (recomended && ([langString containsAny:filter.langs] || filter.langs.count == 0)) {
                [sFilters addObject:filter];
            }
        }
        
        if (!sFilters)
            return NO;
        
        if (![self insertMetadataIntoDb:productionDb filters:sFilters]){
            
            return NO;
        }
        
        NSMutableSet<NSNumber*> *groupIds = [NSMutableSet new];
        for (ASDFilterMetadata *filter in sFilters) {
            [groupIds addObject: filter.groupId];
        }
        
        for(NSNumber* groupId in groupIds) {
            if ([EnabledFilterGroups.groupIds containsObject:groupId])
                [self setGroupEnabled:productionDb enabled:YES groupId:groupId];
        }
        
        // Trying obtain filter rules from default DB and to insert into production DB.
        for (ASDFilterMetadata *filter in sFilters) {
            
            [self installRulesFromDefaultDbWithFilterId:filter.filterId db:productionDb];
        }
    }
    
    return YES;
}

- (BOOL)insertMetadataIntoDb:(FMDatabase *)db filters:(NSArray *)metadataList{
    
    BOOL result = NO;
    for (ASDFilterMetadata *meta in metadataList) {
        
        result = [db executeUpdate:@"insert or replace into filters (filter_id, version, editable, display_number, group_id, name, description, homepage, is_enabled, last_update_time, last_check_time, removable, expires, subscriptionUrl) values (?, ?, ?, ?, ?, ?, ?, ?, ?, datetime(?), datetime(?), ?, ?, ?)",
                  meta.filterId, meta.version, meta.editable, meta.displayNumber, meta.groupId, meta.name, meta.descr, meta.homepage, meta.enabled, meta.updateDateString, meta.checkDateString, meta.removable, meta.expires, meta.subscriptionUrl];
        if (!result) break;
        
        result = [db executeUpdate:@"delete from filter_langs where filter_id = ?", meta.filterId];
        if (!result) break;
        
        for (NSString *lang in meta.langs){
            
            result = [db executeUpdate:@"insert into filter_langs (filter_id, lang) values (?, ?)", meta.filterId, lang];
            if (!result) break;
        }
        
        for (ASDFilterTagMeta *tag in meta.tags) {
            result = [db executeUpdate:@"insert or replace into filter_tags (filter_id, tag_id, type, name) values (?, ?, ?, ?)", meta.filterId, @(tag.tagId), @(tag.type), tag.name];
            if (!result) break;
        }
        
        if (!result) break;
    }
    
    if (!result)
        DDLogError(@"Error updating metadata in production DB: %@", [[db lastError] localizedDescription]);
    
    return result;
}

- (BOOL)insertMetadataIntoDb:(FMDatabase *)db groups:(NSArray *)metadataList{
    
    BOOL result = NO;
    for (ASDFilterGroup *meta in metadataList) {
        
        result = [db executeUpdate:@"insert or replace into filter_groups (group_id, display_number, name, is_enabled) values (?, ?, ?, ?)",
                  meta.groupId, meta.displayNumber, meta.name, meta.enabled];
        if (!result) break;
    }
    
    if (!result)
        DDLogError(@"Error updating group metadata in production DB: %@", [[db lastError] localizedDescription]);
    
    return result;
}

- (BOOL)insertI18nIntoDb:(FMDatabase *)db filters:(ASDFiltersI18n *)filters groups:(ASDGroupsI18n *)groups {
    
    BOOL result = YES;
    
    for (ASDFilterGroupLocalization *locale in groups.localizations){
        
        result = [db executeUpdate:@"insert or replace into filter_group_localizations (group_id, lang, name) values (?, ?, ?)",
                  locale.groupId, locale.lang, locale.name];
        if (!result) break;
    }
    
    if (result) {
        for (ASDFilterLocalization *locale in filters.localizations){
            
            result = [db executeUpdate:@"insert or replace into filter_localizations (filter_id, lang, name, description) values (?, ?, ?, ?)",
                      locale.filterId, locale.lang, locale.name, locale.descr];
            if (!result) break;
        }
    }
    
    if (!result){
        DDLogError(@"Error updating i18n in production DB: %@", [[db lastError] localizedDescription]);
        DDLogErrorTrace();
    }
    
    return result;
}

- (BOOL)installRulesFromDefaultDbWithFilterId:(NSNumber *)filterId db:(FMDatabase *)db {

    __block NSArray *rules;
    
    // Trying obtain filter rules from default DB
    [_asDataBase queryDefaultDB:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"select * from filter_rules where filter_id = ?", filterId];
        if (resultSet) {
            
            NSMutableArray *_rules = [NSMutableArray array];
            ASDFilterRule *rule;
            while ([resultSet next]) {
                
                rule = [[ASDFilterRule alloc] initFromDbResult:resultSet];
                if (rule) {
                    
                    [_rules addObject:rule];
                }
            }
            rules = _rules;
        }
        [resultSet close];
    }];

    if (!rules.count) {
        return NO;
    }
    
    [self replaceRules:rules forFilterID:filterId inDb:db];
    
    return YES;
}

- (BOOL)installRulesFromBackendWithFilterId:(NSNumber *)filterId db:(FMDatabase *)db {
    
    NSArray *rules;
    // Trying obtain filter rules from backend
    if ([reach isReachable]) {
        
        ASDFilter *filterData = [[ABECFilterClient singleton] filterWithFilterId:filterId];
        if (filterData) {
            
            rules = filterData.rules;
        }
    }
    if (!rules.count) {
        return NO;
    }
    
    [self replaceRules:rules forFilterID:filterId inDb:db];
    
    return YES;
}

- (void)replaceRules:(NSArray *)rules forFilterID:(NSNumber *)filterID inDb:(FMDatabase *)db {
    
    if (rules.count) {
        
        [db executeUpdate:@"delete from filter_rules where filter_id = ?", filterID];
        BOOL result = YES;
        for (ASDFilterRule *item in rules) {
            
            result = [db executeUpdate:@"insert into filter_rules (filter_id, rule_id, rule_text, is_enabled, affinity) values (?, ?, ?, ?, ?)",
                      item.filterId, item.ruleId, item.ruleText, item.isEnabled, item.affinity];
            if (!result)
                DDLogError(@"Error install filter rules from default DB: %@", [[db lastError] localizedDescription]);
        }
    }
    
}

- (NSArray<ASDFilterGroup*> *)groupsFromDb:(FMDatabase *)db{
    
    NSMutableArray *groups = [NSMutableArray array];
    
    if (!db)
        return groups;
    
    @autoreleasepool {
        
        FMResultSet *result = [db executeQuery:@"select * from filter_groups order by display_number, group_id"];
        ASDFilterGroup *groupMetadata;
        while ([result next]) {
            
            groupMetadata = [[ASDFilterGroup alloc] initFromDbResult:result];
            DDLogInfo(@"Group with groupId = %@, was fetched from db with enabled state = %@", groupMetadata.groupId, groupMetadata.enabled.boolValue ? @"enabled" : @"disabled");
            [groups addObject:groupMetadata];
        }
        [result close];
    }
    
    return groups;
}

- (ASDGroupsI18n *)groupsI18nFromDb:(FMDatabase *)db {
    
    NSMutableArray <ASDFilterGroupLocalization *> *localizations = [NSMutableArray array];
    
    if (!db)
        return [ASDGroupsI18n new];
    
    @autoreleasepool {
        
        FMResultSet *result = [db executeQuery:@"select * from filter_group_localizations"];
        
        ASDFilterGroupLocalization *localization;
        while ([result next]) {
            
            localization = [[ASDFilterGroupLocalization alloc] initFromDbResult:result];
            [localizations addObject:localization];
        }
        [result close];
        
        return [[ASDGroupsI18n alloc] initWithLocalizations:localizations];
    }
}

- (NSArray *)filtersFromDb:(FMDatabase *)db{
    return [self filtersFromDb:db groupId:nil];
}

- (NSArray *)filtersFromDb:(FMDatabase *)db groupId:(NSNumber*) groupId{
    
    NSMutableArray *filters = [NSMutableArray array];
    
    if (!db){
        DDLogError(@"NULL was passed instead of db property, filtersFromDb function in AESAntibanner");
        return filters;
    }
    
    @autoreleasepool {
        
        FMResultSet *result = [db executeQuery:@"select * from filter_langs"];
        
        NSMutableDictionary *langsDict = [NSMutableDictionary dictionary];
        NSMutableArray *list;
        NSNumber *filterId;
        while ([result next]) {
            
            filterId = result[@"filter_id"];
            list = langsDict[filterId];
            if (!list)
                langsDict[filterId] = list = [NSMutableArray array];
            
            [list addObject:result[@"lang"]];
        }
        [result close];
        
        result = [db executeQuery:@"select * from filter_tags"];
        
        NSMutableDictionary *tagsDict = [NSMutableDictionary dictionary];
        while ([result next]) {
            
            filterId = result[@"filter_id"];
            list = tagsDict[filterId];
            if (!list)
                tagsDict[filterId] = list = [NSMutableArray array];
            
            ASDFilterTagMeta* tagMeta = [ASDFilterTagMeta new];
            
            NSNumber* tagId = result[@"tag_id"];
            NSNumber* tagType = result[@"type"];
            NSString* tagName = result[@"name"];
            
            if([tagId isKindOfClass:NSNumber.class])
                tagMeta.tagId = tagId.intValue;
            if([tagType isKindOfClass:NSNumber.class])
                tagMeta.type = tagType.intValue;
            if([tagName isKindOfClass:NSString.class])
                tagMeta.name = tagName;
            
            [list addObject:tagMeta];
        }
        [result close];
        
        if(groupId == nil) {
            result = [db executeQuery: @"select * from filters order by group_id, display_number, filter_id"];
        }
        else  {
            result = [db executeQuery: @"select * from filters where group_id = ?" , groupId];
        }
        
        ASDFilterMetadata *filterMetadata;
        while ([result next]) {
            
            filterMetadata = [[ASDFilterMetadata alloc] initFromDbResult:result];
            filterId = filterMetadata.filterId;
            
            list = langsDict[filterId];
            if (list)
                filterMetadata.langs = [list copy];
            
            list = tagsDict[filterId];
            if (list)
                filterMetadata.tags = [list copy];
            
            [filters addObject:filterMetadata];
        }
        [result close];
    }
    
    return filters;
}
- (ASDFiltersI18n *)filtersI18nFromDb:(FMDatabase *)db {
    
    NSMutableArray <ASDFilterLocalization *> *localizations = [NSMutableArray array];
    
    if (!db)
        return [ASDFiltersI18n new];
    
    @autoreleasepool {
        
        FMResultSet *result = [db executeQuery:@"select * from filter_localizations"];
        
        ASDFilterLocalization *localization;
        while ([result next]) {
            
            localization = [[ASDFilterLocalization alloc] initFromDbResult:result];
            [localizations addObject:localization];
        }
        [result close];
        
        return [[ASDFiltersI18n alloc] initWithLocalizations:localizations];
    }
}

- (NSArray<ASDFilterRule*> *)rulesFromDb:(FMDatabase *)db filterId:(NSNumber *)filterId{
    
    NSMutableArray *rules = [NSMutableArray array];
    
    if (!(db && filterId))
        return rules;
    
    @autoreleasepool {
        
        FMResultSet *result = [db executeQuery:@"select * from filter_rules where filter_id = ?", filterId];
        
        while ([result next])
            [rules addObject:[[ASDFilterRule alloc] initFromDbResult:result]];
        
        [result close];
    }
    
    return rules;
}

- (int) rulesCountFromDb:(FMDatabase *)db filterId:(NSNumber *)filterId{
    
    int count = 0;
    
    if (!(db && filterId))
        return 0;
    
    @autoreleasepool {
        count = [db intForQuery:@"select count(*) from filter_rules where filter_id = ?", filterId];
    }
    
    return count;
}

- (NSArray *)disabledRuleTextsForDb:(FMDatabase *)db filterId:(NSNumber *)filterId{
    
    NSMutableArray *ruleTexts = [NSMutableArray array];
    @autoreleasepool {
        
        FMResultSet *result = [db executeQuery:@"select rule_text from filter_rules where filter_id = ? and is_enabled = 0", filterId];
        
        while ([result next]) {
            
            [ruleTexts addObject:result[0]];
        }
        [result close];
    }
    
    return ruleTexts;
    
}

- (BOOL)deleteFilter:(NSNumber *)filterId fromDb:(FMDatabase *)db{
    
    if (!filterId)
        return NO;
    
    [db executeUpdate:@"delete from filter_langs where filter_id = ?", filterId];
    [db executeUpdate:@"delete from filter_rules where filter_id = ?", filterId];
    [db executeUpdate:@"delete from filters where filter_id = ?", filterId];
    
    return YES;
}

- (BOOL)insertCustomGroup {
    __block BOOL result = NO;
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback)  {
        result = [self insertCustomGroupInDb:db];
        *rollback = !result;
    }];
    
    return result;
}

 - (BOOL)insertCustomGroupInDb: (FMDatabase*) db {
    
    ASDFilterGroup *customGroup = [ASDFilterGroup new];
    customGroup.groupId = [NSNumber numberWithInteger: FilterGroupId.custom];
    customGroup.enabled = [NSNumber numberWithBool:YES];
    
    return [self insertMetadataIntoDb:db groups:@[customGroup]];
}

- (BOOL) addCustomGroupIfNeeded {
    
    __block BOOL groupExists = NO;
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *result = [db executeQuery:@"select * from filter_groups where group_id = ? limit 1", @(FilterGroupId.custom)];
        groupExists = [result next];
        [result close];
    }];
    
    if (groupExists) {
        return YES;
    }
    
    return [self insertCustomGroup];
}

- (BOOL)updateUserfilterMetadata {
    
    @autoreleasepool {
        
        //generate filter metadata
        ASDFilterMetadata *userFilter = [ASDFilterMetadata new];
        
        userFilter.filterId = @(ASDF_USER_FILTER_ID);
        userFilter.displayNumber = @(0);
        userFilter.version = @"1.0.0.0";
        userFilter.checkDate = [NSDate distantFuture];
        userFilter.checkDateString = [userFilter.checkDate iso8601String];
        userFilter.updateDate = [NSDate date];
        userFilter.updateDateString = [userFilter.updateDate iso8601String];
        userFilter.groupId = @(0);
        userFilter.editable = @(1);
        userFilter.removable = @(0);
        
        NSDictionary *localizationResources = [ADLocales localizationsOfFilter:ASDF_USER_FILTER_ID];
        
        NSDictionary *description = localizationResources[ADL_DEFAULT_LANG];
        if (!([description isKindOfClass:[NSDictionary class]]
              && description[ADL_FILTER_NAME]
              && description[ADL_FILTER_DESCRIPTION])){
            
            DDLogError(@"Error obtaining localization for \"User Antibanner Filter\"");
            DDLogErrorTrace();
            [[NSException appResourceUnavailableException:@"Localization of User Antibanner Filter"] raise];
        }
        
        userFilter.name = description[ADL_FILTER_NAME];
        userFilter.descr = description[ADL_FILTER_DESCRIPTION];
        userFilter.langs = @[];
        
        ASDFilterLocalization *filterLocalization;
        NSString *string;
        NSMutableArray *localizations = [NSMutableArray array];
        for (NSString *locale in [localizationResources allKeys]) {
            
            description = localizationResources[locale];
            if (![description isKindOfClass:[NSDictionary class]]){
                
                DDLogError(@"Error obtaining localization for \"User Antibanner Filter\"");
                DDLogErrorTrace();
                [[NSException appResourceUnavailableException:@"Localization of User Antibanner Filter"] raise];
            }
            
            filterLocalization = [ASDFilterLocalization new];
            filterLocalization.filterId = userFilter.filterId;
            filterLocalization.lang = locale;
            
            string = description[ADL_FILTER_NAME];
            filterLocalization.name = string ? string : userFilter.name;
            
            string = description[ADL_FILTER_DESCRIPTION];
            filterLocalization.descr = string ? string : userFilter.descr;
            
            [localizations addObject:filterLocalization];
        }
        
        //generate group metadata
        ASDFilterGroup *group = [ASDFilterGroup new];
        group.groupId = @(0);
        group.displayNumber = @(0);
        group.name = @"";
        
        // update production DB
        __block BOOL result = NO;
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            
            BOOL result = [self insertI18nIntoDb:db filters:[[ASDFiltersI18n alloc] initWithLocalizations:localizations] groups:nil];
            
            if (result) {
                result = [self insertMetadataIntoDb:db filters:@[userFilter]];
            }
            
            if (result) {
                result = [self insertMetadataIntoDb:db groups:@[group]];
            }
            
            *rollback = !result;
        }];
        
        return result;
    }
}

- (void)addActiveRulesFromDb:(FMDatabase *)db forFilter:(NSNumber *)filterId to:(NSMutableArray *)rules{
    
    FMResultSet *ruleResult;
    ruleResult = [db executeQuery:@"select * from filter_rules where filter_id = ? and is_enabled = 1", filterId];
    
    while ([ruleResult next]) {
        
        [rules addObject:[[ASDFilterRule alloc] initFromDbResult:ruleResult]];
    }
    [ruleResult close];
}

- (void)setServiceToReady{
    
    // Notifying to all, that filter rules may be obtained
    if (!serviceReady && [_asDataBase ready]){
        
        serviceReady = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            DDLogDebug(@"(AESAntibanner) ASAntibannerReadyNotification");
            [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerReadyNotification object:self];
        });
    }
    
}

- (void)setLastUpdateFilters {

    DDLogDebugTrace();
    //repair filters dictionary from disk
    if (!_lastUpdateFilters) {
        
        _lastUpdateFilters = [_resources.lastUpdateFilters mutableCopy];
        if (!_lastUpdateFilters) {
            _lastUpdateFilters = [NSMutableDictionary dictionary];
        }
    }
    //repair filter ids from disk
    if (!_lastUpdateFilterIds) {
        _lastUpdateFilterIds = _resources.lastUpdateFilterIds;
    }

}

- (void)copyUserSettingsFromMeta:(ASDFilterMetadata *)fromMeta toMeta:(ASDFilterMetadata *)toMeta {

    toMeta.enabled = [fromMeta.enabled copy];
    toMeta.editable = [fromMeta.editable copy];
    toMeta.removable = [fromMeta.removable copy];
}

- (void) beginBackgroundTaskWithExpirationHandler:(void (^)(void))expirationBlock {
    
    DDLogInfo(@"(AESAntibanner) begin background task");
#ifndef APP_EXTENSION
    _transactionBackroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithName:AES_TRANSACTION_TASK_NAME expirationHandler:^{
        
        if(expirationBlock)
            expirationBlock();
    }];
#endif
}

- (void) endBackgroundTask {
    
    DDLogInfo(@"(AESAntibanner) end background task");
#ifndef APP_EXTENSION
    [[UIApplication sharedApplication] endBackgroundTask:_transactionBackroundTaskID];
    _transactionBackroundTaskID = UIBackgroundTaskInvalid;
#endif
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Notofications
/////////////////////////////////////////////////////////////////////////

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    // DB DELAYED READY
    if ([object isEqual: _asDataBase]
        && [keyPath isEqualToString:@"ready"]
        && _asDataBase.ready) {
        
        dispatch_async(workQueue, ^{
            
            [_asDataBase removeObserver:self forKeyPath:@"ready"];
            observingDbStatus = NO;
            
            if (serviceInstalled)
                [self updateAntibannerForced:NO interactive:YES];
            else
                [self checkInstalledFiltersInDB];
        });
    }
}

@end
