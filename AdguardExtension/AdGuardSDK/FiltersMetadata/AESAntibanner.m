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
//#import "ACommons/ACLang.h"
//#import "ACommons/ACNetwork.h"
//#import "ADomain/ADomain.h"
#import "AESAntibanner.h"
#import "ASDatabase.h"
#import "ASDFilterObjects.h"
#import "AESharedResources.h"
#import "AASFilterSubscriptionParser.h"
//#import "Adguard-Swift.h"
#import "ASConstants.h"
#import "NSException+Utils.h"
#import "NSDate+Utils.h"
#import "NSString+Utils.h"

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
    
    BOOL    serviceReady;
    BOOL    serviceInstalled; // true if at least one antibanner filter installed in DB
    
    BOOL _updatesRightNow;
    BOOL _inTransaction;
    
    NSArray *_lastUpdateFilterIds;
    
    ABECFilterClientMetadata *_metadataCacheForFilterSubscription;
    NSDate *_metaCacheLastUpdated;
    ABECFilterClientLocalization *_i18nCacheForFilterSubscription;
    NSDate *_i18nCacheLastUpdated;
    
    ASDFiltersI18n *_dbFiltersI18nCache;
    ASDGroupsI18n *_dbGroupsI18nCache;
    
    UIBackgroundTaskIdentifier _transactionBackroundTaskID;
    
    ASDatabase *_asDataBase;
    id <AESharedResourcesProtocol> _resources;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (instancetype)initWithResources: (id<AESharedResourcesProtocol>) resources {
    
    self = [super init];
    if (self) {
        
        _resources = resources;
        observingDbStatus = NO;
        
        workQueue = dispatch_queue_create("ASAntibanner", DISPATCH_QUEUE_SERIAL);
        
        [self initParams];
    }
    
    return self;
}

- (void) initParams {
    serviceReady = NO;
    serviceInstalled = NO;
    _metadataForSubscribeOutdated = YES;
    _updatesRightNow = NO;
    _inTransaction = NO;
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

- (void)stop {
    dispatch_sync(workQueue, ^{
        [self initParams];
    });
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

- (NSArray<ASDFilterMetadata *> *)defaultDbFilters {
    
    __block NSArray<ASDFilterMetadata *> *result;
    [_asDataBase queryDefaultDB:^(FMDatabase *db) {
        result = [self filtersFromDb:db];
    }];
    
    return result;
}

- (NSArray<ASDFilterGroup *> *)defaultDbGroups {
    __block NSArray<ASDFilterGroup *> *result;
    [_asDataBase queryDefaultDB:^(FMDatabase *db) {
        result = [self groupsFromDb:db];
    }];
    
    return result;
}

-(ASDGroupsI18n *)defaultDbGroupsI18n {
    __block ASDGroupsI18n *result;
    [_asDataBase queryDefaultDB:^(FMDatabase *db) {
        result = [self groupsI18nFromDb:db];
    }];
    
    return result;
}

- (ASDFiltersI18n *)defaultDbFiltersI18n {
    __block ASDFiltersI18n *result;
    [_asDataBase queryDefaultDB:^(FMDatabase *db) {
        result = [self filtersI18nFromDb:db];
    }];
    
    return result;
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
            // todo:
//            DDLogInfo(@"Filter with filterId = %@ , and expected enabled state = %d, was added to db with result = %d", filterId, (int)enabled, (int)result);
            
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
                        
                        // todo:
//                        DDLogError(@"Can't add rule: \"%@\", for filter Id: %@", rule.ruleText, rule.filterId);
//                        DDLogError(@"Database error: %@", [[db lastError] localizedDescription]);
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
                    
                    // todo:
//                    DDLogError(@"Can't update rule: filterId-%@, ruleId-%@, ruleText-\"%@\"", rule.filterId, rule.ruleId, rule.ruleText);
//                    DDLogError(@"Database error: %@", [[db lastError] localizedDescription]);
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

- (BOOL)removeRulesForFilter:(NSNumber *)filterId {
    
    __block BOOL removed = YES;
    
    dispatch_sync(workQueue, ^{ @autoreleasepool {
        
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            removed = [db executeUpdate:@"delete from filter_rules where filter_id = %@", filterId];
            *rollback = NO;
        }];
    }});
    
    return removed;
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
                        
                        result = [self insertMetadataIntoDb:db filters:filtersMetaForSave];
                        if (!result)
                            return;
                        
                        *rollback = NO;
                    }
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

    // todo: magic number
    parserResult.meta.groupId = @(101);

    if(completionBlock){
        completionBlock();
    }

    if ([self updateFilter:parserResult.meta db:_asDataBase]) {
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

- (void) renameCustomFilter: (nonnull NSNumber*) filterId newName: (NSString *)newName {
    dispatch_sync(workQueue, ^{
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            BOOL result = [db executeUpdate:@"UPDATE filters SET name = ? WHERE filter_id = ?", newName, filterId];
            *rollback = !result;
        }];
    });
}

- (BOOL)updateFilter:(ASDFilterMetadata *)filter db:(ASDatabase *)theDB{
    
    __block BOOL result = NO;
    [theDB exec:^(FMDatabase *db, BOOL *rollback) {
        result = [db executeUpdate:@"delete from filter_rules where filter_id = ?", filter.filterId];
        result &= [self insertMetadataIntoDb:db filters:@[filter]];
        *rollback = !result;
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
            // todo:
//            DDLogError(@"Error of removing antibanner filter (filterId=%@): Can't remove stable filter.", filterId);
//            DDLogErrorTrace();
        }

    }];

    return removed;
}

#pragma mark update filters

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

- (BOOL)updateGroups:(NSArray<ASDFilterGroup *> *)groups {
    __block BOOL result = YES;
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        *rollback = YES;
        result = [self insertMetadataIntoDb:db groups:groups];
        if (!result)
            return;
        
        *rollback = NO;
    }];
    return result;
}

-(BOOL)updateFilters:(NSArray<ASDFilterMetadata *> *)filters {
    __block BOOL result = YES;
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        *rollback = YES;
        result = [self insertMetadataIntoDb:db filters:filters];
        if (!result)
            return;
        
        *rollback = NO;
    }];
    return result;
}

-(BOOL)updateGroupsI18n:(ASDGroupsI18n *)groups {
    __block BOOL result = YES;
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        *rollback = YES;
        result = [self insertI18nIntoDb:db filters:nil groups:groups];
        if (!result)
            return;
        
        *rollback = NO;
    }];
    return result;
}

- (BOOL)updateFiltersI18n:(ASDFiltersI18n *)filters {
    __block BOOL result = YES;
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        
        *rollback = YES;
        result = [self insertI18nIntoDb:db filters:filters groups:nil];
        if (!result)
            return;
        
        *rollback = NO;
    }];
    return result;
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
            // todo:
//            DDLogError(@"(AESAntibanner) beginTransaction - expiration handler fired");
            
            // unlocks database file to prevent crashes
            [_asDataBase resetIsolationQueue:workQueue];
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

- (void)applicationWillEnterForeground {
    if (_inTransaction) {
        [_asDataBase resetIsolationQueue:workQueue];
    }
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
#pragma mark Private methods
/////////////////////////////////////////////////////////////////////////

- (void)finishUpdateInBackgroundMode {
    
    [self beginTransaction];
    // todo:
//    DDLogInfo(@"(AESAntibanner) Begin of the Update Transaction from final stage of the update process (before DB updates).");

    dispatch_sync(workQueue, ^{
        [self updateStart];
    });
}

- (void)updateStart {
    
    if (self.updatesRightNow) {
        return;
    }
    
    self.updatesRightNow = YES;
    // todo:
//    DDLogInfo(@"(ASAntibanner) Started update process.");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerStartedUpdateNotification object:self];
    });
}

- (void)updateFinished:(NSArray *)updatedVersions {
    
    if (! _inTransaction) {
        self.updatesRightNow = NO;
    }
    
//todo:
//    DDLogInfo(@"(ASAntibanner) Finished update process.");
    
    dispatch_async(dispatch_get_main_queue(), ^{
//    todo:
//        DDLogInfo(@"Filters updated count: %lu", updatedVersions.count);
        for (ASDFilterMetadata *meta in updatedVersions) {
//        todo:
//            DDLogInfo(@"Filter id: %@, version: %@, updated: %@.", meta.filterId, meta.version, meta.updateDateString);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerFinishedUpdateNotification object:self userInfo:@{ASAntibannerUpdatedFiltersKey : updatedVersions}];
    });

}

- (void)updateFailure{
    
    if (! _inTransaction) {
        
        self.updatesRightNow = NO;
    }
//todo:
//    DDLogInfo(@"(ASAntibanner) update process failure.");
    
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

- (BOOL) disableUserRules {
    __block BOOL result = NO;
    
    dispatch_sync(workQueue, ^{
        
        if (!_asDataBase.ready) {
            return;
        }
        
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            
            *rollback = NO;
            NSString *queryString = [NSString stringWithFormat:@"update filter_rules set is_enabled = %i where filter_id = %@", NO, @(ASDF_USER_FILTER_ID)];
            [db executeUpdate:queryString];
            
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
    
    __weak typeof(self) wSelf = self;
    
    dispatch_async(workQueue, ^{ @autoreleasepool {
        
        typeof(self) sSelf = wSelf;
        
        if (_asDataBase.ready){
            
            [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
                
                *rollback = YES;
                
                FMResultSet *result = [db executeQuery:@"select * from filters limit 1"];
                if (![result next]) {
                    
                    // install default filters
                    if ([sSelf installFiltersIntoDb:db]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //todo:
//                            DDLogDebug(@"(ASAntibanner) ASAntibannerInstalledNotification");
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerInstalledNotification object: sSelf];
                        });
                    }
                    else{
                        
                        // Can't install filters metadata into DB.
                        // todo:
//                        DDLogError(@"Can't install filters metadata into DB.");
//                        DDLogErrorTrace();
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerNotInstalledNotification object: sSelf];
                        });
                        
                        return;
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                    todo:
//                        DDLogDebug(@"(ASAntibanner) antibanner has been allready installed.");
                        [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerInstalledNotification object:sSelf];
                   });
                }
                
                [result close];
                sSelf->serviceInstalled = YES;
                *rollback = NO;
                [sSelf setServiceToReady];
            }];
            
            [sSelf addCustomGroupIfNeeded];
            [sSelf updateUserfilterMetadata];
        }
        else if (!observingDbStatus){
            
            sSelf->observingDbStatus = YES;
            [_asDataBase addObserver:sSelf forKeyPath:@"ready" options:NSKeyValueObservingOptionNew context:nil];
            
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
        // todo:
//        NSString *langString = [NSString stringWithFormat:@"%@|%@", [ADLocales lang], [ADLocales region]];
        for (ASDFilterMetadata *filter in filters){
            BOOL recomended = NO;
            for (ASDFilterTagMeta* tagMeta in filter.tags) {
                if(tagMeta.type == ASDFilterTagTypeRecommended){
                    recomended = YES;
                    break;
                }
            }
//        todo:
//            if (recomended && ([langString containsAny:filter.langs] || filter.langs.count == 0)) {
//                [sFilters addObject:filter];
//            }
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
//        todo:
//            if ([AdGuardFilterGroupObjWrapper.enabledGroupIds containsObject:groupId])
//                [self setGroupEnabled:productionDb enabled:YES groupId:groupId];
        }
    }
    
    return YES;
}

- (BOOL)insertMetadataIntoDb:(FMDatabase *)db filters:(NSArray *)metadataList{
    
    if (metadataList.count == 0) {
        return true;
    }
    
    BOOL result = NO;
    for (ASDFilterMetadata *meta in metadataList) {
        
        result = [db executeUpdate:@"insert or replace into filters (filter_id, version, editable, display_number, group_id, name, description, homepage, is_enabled, last_update_time, last_check_time, removable, expires, subscriptionUrl) values (?, ?, ?, ?, ?, ?, ?, ?, ?, datetime(?), datetime(?), ?, ?, ?)",
                  meta.filterId, meta.version, meta.editable, meta.displayNumber, meta.groupId, meta.name, meta.descr, meta.homepage, meta.enabled, meta.updateDateString, meta.checkDateString, meta.removable, meta.expires, meta.subscriptionUrl];
        if (!result) {
//        todo:
//            DDLogError(@"(AESAntibanner) insertMetadataIntoDb error. Can not insert filters");
            break;
        }
        
        result = [db executeUpdate:@"delete from filter_langs where filter_id = ?", meta.filterId];
        if (!result) {
//        todo:
//            DDLogError(@"(AESAntibanner) insertMetadataIntoDb error. Can not delete filter %d from filter_langs", meta.filterId.intValue);
            break;
        }
        
        for (NSString *lang in meta.langs){
            
            result = [db executeUpdate:@"insert into filter_langs (filter_id, lang) values (?, ?)", meta.filterId, lang];
            if (!result) {
//            todo:
//                DDLogError(@"(AESAntibanner) insertMetadataIntoDb error. Can not insert filter into filter_langs");
                break;
            }
        }
        
        for (ASDFilterTagMeta *tag in meta.tags) {
            result = [db executeUpdate:@"insert or replace into filter_tags (filter_id, tag_id, type, name) values (?, ?, ?, ?)", meta.filterId, @(tag.tagId), @(tag.type), tag.name];
            if (!result) {
//            todo:
//                DDLogError(@"(AESAntibanner) insertMetadataIntoDb error. Can not insert filter_tags");
                break;
            }
        }
        
        if (!result) break;
    }
    
    if (!result) {
//    todo:
//        DDLogError(@"Error updating metadata in production DB: %@", [[db lastError] localizedDescription]);
    }
    
    return result;
}

- (BOOL)insertMetadataIntoDb:(FMDatabase *)db groups:(NSArray *)metadataList{
    
    BOOL result = NO;
    for (ASDFilterGroup *meta in metadataList) {
        
        result = [db executeUpdate:@"insert or replace into filter_groups (group_id, display_number, name, is_enabled) values (?, ?, ?, ?)",
                  meta.groupId, meta.displayNumber, meta.name, meta.enabled];
        if (!result) break;
    }
    
    if (!result) {
//    todo:
//        DDLogError(@"Error updating group metadata in production DB: %@", [[db lastError] localizedDescription]);
    }
    
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
//    todo:
//        DDLogError(@"Error updating i18n in production DB: %@", [[db lastError] localizedDescription]);
//        DDLogErrorTrace();
    }
    
    return result;
}

- (void)replaceRules:(NSArray *)rules forFilterID:(NSNumber *)filterID inDb:(FMDatabase *)db {
    
    if (rules.count) {
        
        [db executeUpdate:@"delete from filter_rules where filter_id = ?", filterID];
        BOOL result = YES;
        for (ASDFilterRule *item in rules) {
            
            result = [db executeUpdate:@"insert into filter_rules (filter_id, rule_id, rule_text, is_enabled, affinity) values (?, ?, ?, ?, ?)",
                      item.filterId, item.ruleId, item.ruleText, item.isEnabled, item.affinity];
            if (!result) {
//            todo:
//                DDLogError(@"Error install filter rules from default DB: %@", [[db lastError] localizedDescription]);
            }
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
//        todo:
//            DDLogInfo(@"Group with groupId = %@, was fetched from db with enabled state = %@", groupMetadata.groupId, groupMetadata.enabled.boolValue ? @"enabled" : @"disabled");
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
//    todo:
//        DDLogError(@"NULL was passed instead of db property, filtersFromDb function in AESAntibanner");
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

- (ASDFilterMetadata*) filtterWithId:(NSNumber *)filterId fromDb: (FMDatabase *)db {
    ASDFilterMetadata* meta;
    FMResultSet *result = [db executeQuery: @"select * from filters where filter_id = ?" , filterId];
    if ([result next]) {
        meta = [[ASDFilterMetadata alloc] initFromDbResult:result];
    }
    [result close];
    return  meta;
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
     // todo: magic number
    customGroup.groupId = [NSNumber numberWithInteger: 101];
    customGroup.enabled = [NSNumber numberWithBool:YES];
    
    return [self insertMetadataIntoDb:db groups:@[customGroup]];
}

- (BOOL) addCustomGroupIfNeeded {
    
    __block BOOL groupExists = NO;
    [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
        // todo: magic
        FMResultSet *result = [db executeQuery:@"select * from filter_groups where group_id = ? limit 1", @(101)];
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
        userFilter.updateDateString = [userFilter.updateDate iso8601String];
        userFilter.groupId = @(0);
        userFilter.editable = @(1);
        userFilter.removable = @(0);
        
        // todo:
//        NSDictionary *localizationResources = [ADLocales localizationsOfFilter:ASDF_USER_FILTER_ID];
        
//        NSDictionary *description = localizationResources[ADL_DEFAULT_LANG];
//        if (!([description isKindOfClass:[NSDictionary class]]
//              && description[ADL_FILTER_NAME]
//              && description[ADL_FILTER_DESCRIPTION])){
//
//            DDLogError(@"Error obtaining localization for \"User Antibanner Filter\"");
//            DDLogErrorTrace();
//            [[NSException appResourceUnavailableException:@"Localization of User Antibanner Filter"] raise];
//        }
//
//        userFilter.name = description[ADL_FILTER_NAME];
//        userFilter.descr = description[ADL_FILTER_DESCRIPTION];
        userFilter.langs = @[];
        
        ASDFilterLocalization *filterLocalization;
        NSString *string;
        NSMutableArray *localizations = [NSMutableArray array];
//    todo:
//        for (NSString *locale in [localizationResources allKeys]) {
//
//            description = localizationResources[locale];
//            if (![description isKindOfClass:[NSDictionary class]]){
                
                // todo:
//                DDLogError(@"Error obtaining localization for \"User Antibanner Filter\"");
//                DDLogErrorTrace();
//                [[NSException appResourceUnavailableException:@"Localization of User Antibanner Filter"] raise];
//            }
            
//            filterLocalization = [ASDFilterLocalization new];
//            filterLocalization.filterId = userFilter.filterId;
//            filterLocalization.lang = locale;
            
            // todo:
//            string = description[ADL_FILTER_NAME];
//            filterLocalization.name = string ? string : userFilter.name;
            
            // todo:
//            string = description[ADL_FILTER_DESCRIPTION];
//            filterLocalization.descr = string ? string : userFilter.descr;
//            
//            [localizations addObject:filterLocalization];
//        }
        
        //generate group metadata
        ASDFilterGroup *group = [ASDFilterGroup new];
        group.groupId = @(0);
        group.displayNumber = @(0);
        group.name = @"";
        
        // update production DB
        __block BOOL result = NO;
        [_asDataBase exec:^(FMDatabase *db, BOOL *rollback) {
            
            // todo:
//            BOOL result = [self insertI18nIntoDb:db filters:[[ASDFiltersI18n alloc] initWithLocalizations:localizations] groups:nil];
            
            if (result) {
                // todo:
//                result = [self insertMetadataIntoDb:db filters:@[userFilter]];
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
            
//        todo:
//            DDLogDebug(@"(AESAntibanner) ASAntibannerReadyNotification");
            [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerReadyNotification object:self];
        });
    }
    
}

- (void)copyUserSettingsFromMeta:(ASDFilterMetadata *)fromMeta toMeta:(ASDFilterMetadata *)toMeta {

    toMeta.enabled = [fromMeta.enabled copy];
    toMeta.editable = [fromMeta.editable copy];
    toMeta.removable = [fromMeta.removable copy];
}

- (void) beginBackgroundTaskWithExpirationHandler:(void (^)(void))expirationBlock {
//todo:
//    DDLogInfo(@"(AESAntibanner) begin background task");
#ifndef APP_EXTENSION
    _transactionBackroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithName:AES_TRANSACTION_TASK_NAME expirationHandler:^{
        
        if(expirationBlock)
            expirationBlock();
    }];
#endif
}

- (void) endBackgroundTask {
//todo:
//    DDLogInfo(@"(AESAntibanner) end background task");
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
            
            if (serviceInstalled) {
//            todo:
//                DDLogInfo(@"AESAntibanner - antibanner ready");
            }
            else
                [self checkInstalledFiltersInDB];
        });
    }
}

@end
