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
#import "ACommons/ACLang.h"
#import "ACommons/ACNetwork.h"
#import "ADomain/ADomain.h"
#import "AESAntibanner.h"
#import "ASDatabase/ASDatabase.h"
#import "ABackEndClients/ABECFilter.h"
#import "ASDModels/ASDFilterObjects.h"

#define MAX_SQL_IN_STATEMENT_COUNT        100

NSString *ASAntibannerUpdatedFiltersKey = @"ASAntibannerUpdatedFiltersKey";
NSString *ASAntibannerInstalledNotification = @"ASAntibannerInstalledNotification";
NSString *ASAntibannerNotInstalledNotification = @"ASAntibannerNotInstalledNotification";
NSString *ASAntibannerReadyNotification = @"ASAntibannerReadyNotification";
NSString *ASAntibannerUpdateFilterMetadataNotification = @"ASAntibannerUpdateFilterMetadataNotification";
NSString *ASAntibannerUpdateFilterRulesNotification = @"ASAntibannerUpdateFilterRulesNotification";
NSString *ASAntibannerStartedUpdateNotification = @"ASAntibannerStartedUpdateNotification";
NSString *ASAntibannerFinishedUpdateNotification = @"ASAntibannerFinishedUpdateNotification";
NSString *ASAntibannerFailuredUpdateNotification = @"ASAntibannerFailuredUpdateNotification";
NSString *ASAntibannerUpdateFilterFromUINotification = @"ASAntibannerUpdateFilterFromUINotification";


/////////////////////////////////////////////////////////////////////////
#pragma mark - ASAntibanner
/////////////////////////////////////////////////////////////////////////

@interface AESAntibanner ()

@property BOOL updatesRightNow;

@end

@implementation AESAntibanner {
    
    
    dispatch_queue_t  workQueue;
    dispatch_source_t updateTimer;
    ACLExecuteBlockDelayed *updateFilterFromUI;
    
    BOOL    observingDbStatus;
    
    Reachability    *reach;
    BOOL    observingReachabilityStatus;
    
    BOOL    serviceEnabled;
    BOOL    serviceReady;
    BOOL    serviceInstalled; // true if at least one antibanner filter installed in DB
    
    NSArray *filtersMetadataCache;
    NSDate *filterMetaCacheLastUpdated;
    NSArray *groupsMetadataCache;
    
    BOOL _updatesRightNow;
    BOOL _inTransaction;
    
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)init{
    
    self = [super init];
    if (self) {
        
        observingReachabilityStatus = observingDbStatus = NO;
        
        workQueue = dispatch_queue_create("ASAntibanner", DISPATCH_QUEUE_SERIAL);
        
        updateFilterFromUI =
        [[ACLExecuteBlockDelayed alloc]
         initWithTimeout:AS_CHECK_FILTERS_UPDATES_FROM_UI_DELAY
         leeway:AS_CHECK_FILTERS_UPDATES_LEEWAY
         queue:workQueue
         block:^{
             
             if (!serviceEnabled) return;
             
             dispatch_async(workQueue, ^{
                 
                 [self updateAntibannerForced:NO];
             });
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerUpdateFilterFromUINotification object:self];
             });
             
         }];
        
        // set Reachability
        reach = [Reachability reachabilityWithHostname:[ABECFilterClient reachabilityHost]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:reach];
        
        serviceEnabled = NO;
        serviceReady = NO;
        serviceInstalled = NO;
        
        _metadataForSubscribeOutdated = YES;
        _updatesRightNow = NO;
        _inTransaction = NO;
        
    }
    
    return self;
}

- (void)dealloc{
    
    [self stopObservingReachabilityStatus];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [[ASDatabase singleton] removeObserver:self forKeyPath:@"ready"];
    }
    @catch (NSException *exception) {
        // Silent
    }
    
#if !OS_OBJECT_USE_OBJC
    if (workQueue) dispatch_release(workQueue);
#endif
    
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

@synthesize updatesRightNow = _updatesRightNow;

- (BOOL)enabled{
    return serviceEnabled;
}

- (void)setEnabled:(BOOL)enabled{
    
    dispatch_sync(workQueue, ^{
        
        if (enabled != serviceEnabled){
            
            serviceEnabled = enabled;
            if (serviceEnabled) {
                
                if ([self checkInstalledFiltersInDB]){
                    
                    [self setServiceToReady];
                }
            }
            else{
                
                [self stopObservingReachabilityStatus];
                serviceReady = NO;
            }
        }
    });
}

- (NSArray *)activeRules{
    
    NSMutableArray *rules = [NSMutableArray array];
    
    if (serviceEnabled) {
        
        [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
            
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
    }
    
    return rules;
}


- (NSArray *)activeRulesForFilter:(NSNumber *)filterId{
    
    NSMutableArray *rules = [NSMutableArray array];
    
    if (!filterId)
        [[NSException argumentException:@"filterId"] raise];
    
    if (serviceEnabled) {
        
        [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
            
            FMResultSet *result = [db executeQuery:@"select filter_id from filters where filter_id = ? and is_enabled = 1", filterId];
            if ([result next]){
                
                [self addActiveRulesFromDb:db forFilter:filterId to:rules];
            }
            
            [result close];
        }];
    }
    
    return rules;
}


- (NSArray *)groups{
    
    __block NSArray *groups;
    
    [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
        
        groups = [self groupsFromDb:db];
    }];
    
    return groups;
}

- (NSArray *)filters{
    
    __block NSArray *filters;
    
    [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
        
        filters = [self filtersFromDb:db];
    }];
    
    return filters;
}

- (NSArray *)rulesForFilter:(NSNumber *)filterId{
    
    __block NSArray *rules;
    [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
        
        rules = [self rulesFromDb:db filterId:filterId];
    }];
    
    return rules;
}

- (void)setFilter:(NSNumber *)filterId enabled:(BOOL)enabled fromUI:(BOOL)fromUI{
    
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS
    
    dispatch_sync(workQueue, ^{
        
        __block BOOL result = NO;
        [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
            
            *rollback = NO;
            result = [db executeUpdate:@"update filters set is_enabled = ? where filter_id = ?", @(enabled), filterId];
        }];
        
    });
    
#elif TARGET_OS_MAC
    
    dispatch_async(workQueue, ^{
        
        __block BOOL result = NO;
        [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
            
            *rollback = NO;
            result = [db executeUpdate:@"update filters set is_enabled = ? where filter_id = ?", @(enabled), filterId];
        }];
        
        if (fromUI && result && serviceEnabled){
            
            [updateFilterFromUI executeOnceAfterCalm];
        }
        
    });
    
#endif
    
}

- (void)setRules:(NSArray *)ruleIds filter:(NSNumber *)filterId enabled:(BOOL)enabled{
    
    dispatch_async(workQueue, ^{ @autoreleasepool {
        
        NSUInteger count = ruleIds.count;
        NSUInteger index = 0;
        NSUInteger len = MIN(MAX_SQL_IN_STATEMENT_COUNT, count);
        NSArray *ruleIdsSegment;
        while (len && count >= (index + len)) {
            
            ruleIdsSegment = [ruleIds objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, len)]];
            [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
                
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
        
        [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
            
            *rollback = YES;
            FMResultSet *result = [db executeQuery:@"select editable from filters where filter_id = ?", rule.filterId];
            if ([result next] && [result[0] isKindOfClass:[NSNumber class]] && [result[0] boolValue]){
                
                [result close];
                result = [db executeQuery:@"select max(rule_id) from filter_rules where filter_id = ?", rule.filterId];
                
                NSNumber *ruleId = @(0);
                if ([result next]) {
                    
                    id maxValue = result[0];
                    if ([maxValue isKindOfClass:[NSNumber class]])
                        ruleId = @([maxValue unsignedIntegerValue] + 1);
                    else
                        ruleId = @(1);
                    
                    added = [db executeUpdate:@"insert into filter_rules (filter_id, rule_id, rule_text, is_enabled) values (?, ?, ?, ?)", rule.filterId, ruleId, rule.ruleText, rule.isEnabled];
                    
                    if (added)
                        added = [db executeUpdate:@"update filters set last_update_time = datetime(?) where filter_id = ?", [[NSDate date] iso8601String], rule.filterId];
                    
                    if (added) {
                        
                        *rollback = NO;
                        rule.ruleId = ruleId;
                    }
                    else{
                        
                        DDLogError(@"Can't add rule: \"%@\", for filter Id: %@", rule.ruleText, rule.filterId);
                        DDLogError(@"Database error: %@", [[db lastError] localizedDescription]);
                        DDLogErrorTrace();
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
        
        [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
            
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
                    DDLogErrorTrace();
                }
            }
            
            [result close];
        } ];
        
    }});
    
    return updated;
}

- (BOOL)importRuleTexts:(NSArray *)ruleTexts filterId:(NSNumber *)filterId{
    
    if (!ruleTexts) {
        
        [[NSException argumentException:@"ruleTexts"] raise];
    }
    
    if (!filterId) {
        
        [[NSException argumentException:@"filterId"] raise];
    }
    
    __block BOOL imported = NO;
    
    dispatch_sync(workQueue, ^{ @autoreleasepool {
        
        [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
            
            *rollback = YES;
            FMResultSet *result = [db executeQuery:@"select editable from filters where filter_id = ?", filterId];
            if ([result next] && [result[0] isKindOfClass:[NSNumber class]] && [result[0] boolValue]){
                
                imported = [db executeUpdate:@"delete from filter_rules where filter_id = ?", filterId];
                if (imported) {
                    
                    NSUInteger count = 0;
                    for (NSString *ruleText in ruleTexts) {
                        
                        if ([NSString isNullOrEmpty:ruleText]) {
                            continue;
                        }
                        count++;
                        [db executeUpdate:@"insert into filter_rules (filter_id, rule_id, rule_text, is_enabled) values (?, ?, ?, ?)", filterId, @(count), ruleText, @(1)];
                    }
                    
                    imported = [db executeUpdate:@"update filters set last_update_time = datetime(?) where filter_id = ?", [[NSDate date] iso8601String], filterId];
                    
                    *rollback = NO;
                }
            }
            
            if (imported && serviceEnabled)
                [updateFilterFromUI executeOnceAfterCalm];
            
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
        
        [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
            
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

- (NSArray *)groupsForSubscribe:(BOOL)refresh{
    
    @autoreleasepool {
        
        __block NSArray *groups;
        if (!groupsMetadataCache || refresh) {
            // trying load metadata from backend service.
            if ([reach isReachable]) {
                
                ABECFilterClient *client = [ABECFilterClient new];
                groups = [client groupMetadataListForApp:[ADProductInfo applicationID]];
                if (groups) {
                    
                    groupsMetadataCache = groups;
                }
            }
        }
        
        if (groupsMetadataCache)
            groups = groupsMetadataCache;
        
        else {
            
            // Trying obtain groups metadata from default DB.
            [[ASDatabase singleton] queryDefaultDB:^(FMDatabase *db) {
                
                groups = [self groupsFromDb:db];
            }];
        }
        
        
        return groups;
    }
}

- (NSArray *)filtersForSubscribe:(BOOL)refresh{
    
    @autoreleasepool {
        
        __block NSArray *filters;
        if (!filtersMetadataCache
            || refresh
            || ([filterMetaCacheLastUpdated timeIntervalSinceNow] * -1) >= AS_CHECK_FILTERS_UPDATES_DEFAULT_PERIOD) {
            // trying load metadata from backend service.
            if ([reach isReachable]) {
                
                ABECFilterClient *client = [ABECFilterClient new];
                filters = [client filterMetadataListForApp:[ADProductInfo applicationID]];
                if (filters) {
                    
                    filtersMetadataCache = filters;
                    filterMetaCacheLastUpdated = [NSDate date];
                }
                else
                    _metadataForSubscribeOutdated = NO;
            }
        }
        
        if (filtersMetadataCache) {
            
            filters = filtersMetadataCache;
            _metadataForSubscribeOutdated = NO;
        }
        else {
            
            _metadataForSubscribeOutdated = YES;
            
            // Trying obtain filters metadata from default DB.
            [[ASDatabase singleton] queryDefaultDB:^(FMDatabase *db) {
                
                filters = [self filtersFromDb:db];
            }];
        }
        
        return filters;
    }
}

- (BOOL)subscribeFilters:(NSArray *)filters jobController:(ACLJobController *)jobController{
    
    if (!filters) {
        
        [NSException argumentException:@"filters"];
    }
    
    __block BOOL result = NO;
    dispatch_sync(workQueue, ^{
        
        @autoreleasepool {

            __block NSArray *defaultDbFilters;

            [[ASDatabase singleton] queryDefaultDB:^(FMDatabase *db) {

                defaultDbFilters = [self filtersFromDb:db];
            }];

            [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {

                *rollback = YES;

                if (groupsMetadataCache) {
                    // If were loaded metadata of groups from backend,
                    // updating the DB.
                    result = [self insertMetadataIntoDb:db groups:groupsMetadataCache];
                    if (!result) {

                        return;
                    }
                }
                NSMutableArray *filtersMetaForSave = [NSMutableArray new];
                for (ASDFilterMetadata *filter in filters) {

                    if (jobController && jobController.state != ACLJCExecuteState) {

                        result = NO;
                        return;
                    }

                    if ([self installRulesFromBackendWithFilter:filter db:db]) {

                        [filtersMetaForSave addObject:filter];
                    } else if ([self installRulesFromDefaultDbWithFilter:filter db:db]) {

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

                if (jobController && jobController.state != ACLJCExecuteState) {

                    result = NO;
                    return;
                }

                result = [self insertMetadataIntoDb:db filters:filtersMetaForSave];
                if (!result)
                    return;

                *rollback = NO;
            }];

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS
            
            //do nothing
#elif TARGET_OS_MAC

            // Notifying to all, that filter rules were updated
            if (result)
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerUpdateFilterRulesNotification object:self];
                });
#endif
        }
    });
    
    return result;
}

- (BOOL)unsubscribeFilter:(NSNumber *)filterId {
    
    __block BOOL removed = NO;
    
    dispatch_sync(workQueue, ^{ @autoreleasepool {
        
        [[ASDatabase singleton] exec:^(FMDatabase *db, BOOL *rollback) {
            
            *rollback = YES;
            
            FMResultSet *result = [db executeQuery:@"select removable from filters where filter_id = ?", filterId];
            if ([result next] && [result[0] isKindOfClass:[NSNumber class]] && [result[0] boolValue]){
                
                removed = [self deleteFilter:filterId fromDb:db];
                if (removed){
                    
                    *rollback = NO;
                    if (serviceEnabled)
                        [updateFilterFromUI executeOnceAfterCalm];
                }
            }
            else{
                
                DDLogError(@"Error of removing antibanner filter (filterId=%@): Can't remove stable filter.", filterId);
                DDLogErrorTrace();
            }
            [result close];
        }];
    }});
    
    return removed;
}

- (void)startUpdating{
    
    if (serviceEnabled && !self.updatesRightNow) {
        
        dispatch_async(workQueue, ^{
            
            [self updateAntibannerForced:YES];
        });
    }
}

- (BOOL)inTransaction{
    
    return _inTransaction;
}

- (void)beginTransaction{
    
    [[ASDatabase singleton] isolateQueue:workQueue];
    [[ASDatabase singleton] readUncommited:YES];
    dispatch_sync(workQueue, ^{
        
        if (_inTransaction) {
            return;
        }
        
        [[ASDatabase singleton] rawExec:^(FMDatabase *db) {
            [db beginDeferredTransaction];
        }];
        
        _inTransaction = YES;
    });
}

- (void)endTransaction{
    
    dispatch_sync(workQueue, ^{
        if (_inTransaction) {
            
            [[ASDatabase singleton] rawExec:^(FMDatabase *db) {
                
                [db commit];
            }];
        }
        _inTransaction = NO;
    });
    [[ASDatabase singleton] readUncommited:NO];
    [[ASDatabase singleton] resetIsolationQueue:workQueue];
}

- (void)rollbackTransaction{
    
    dispatch_sync(workQueue, ^{
        
        if (_inTransaction) {
            [[ASDatabase singleton] rawExec:^(FMDatabase *db) {
                
                [db rollback];
            }];
        }
        _inTransaction = NO;
    });
    [[ASDatabase singleton] readUncommited:NO];
    [[ASDatabase singleton] resetIsolationQueue:workQueue];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Private methods
/////////////////////////////////////////////////////////////////////////

// updateAntibanner method must call in workQueue
- (void)updateAntibannerForced:(BOOL)forced{
    
    // return if no antibanner filters in DB
    if (!(serviceInstalled && serviceEnabled))
        return;
    
    ASDatabase *theDB = [ASDatabase singleton];
    
    if (theDB.ready){
        
        @autoreleasepool {
            
            // Notifying to all, that filter rules may be obtained
            if (!serviceReady){
                
                serviceReady = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    DDLogInfo(@"(ASAntibanner) ASAntibannerReadyNotification");
                    [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerReadyNotification object:self];
                });
            }
            
            self.updatesRightNow = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                DDLogInfo(@"(ASAntibanner) Started update process.");
                [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerStartedUpdateNotification object:self];
            });
            
            // Checking reachability
            if (![reach isReachable]){
                
                DDLogWarn(@"Backend service for updating of antibanner filter do not available.");
                if (!observingReachabilityStatus) {
                    
                    observingReachabilityStatus = YES;
                    [reach startNotifier];
                }
                
                [self updateFailure];
                return;
            }
            else if (observingReachabilityStatus){
                
                [reach stopNotifier];
                observingReachabilityStatus = NO;
            }
            
            __block BOOL rulesUpdated = NO;
            __block BOOL metaUpdated = NO;
            ABECFilterClient *filterClient = [ABECFilterClient new];
            
            // Getting filter info from DB
            NSMutableSet *dbFilterMetas = [NSMutableSet setWithArray:[self filters]];
            
            ASDFilterMetadata *filterMeta;
            
            NSTimeInterval interval;
            NSMutableArray *filterIdsForUpdate = [NSMutableArray array];
            
            BOOL updateUserFilterMetadata = NO;
            
            // Determine filter list for updating metadata
            for (filterMeta in dbFilterMetas) {
                
                //determin interval
                interval = [filterMeta.checkDate timeIntervalSinceNow] * -1;
                // updated only enabled filters
                if ([filterMeta.enabled boolValue]
                    && interval >= [filterMeta.expires integerValue]){
                    
                    if ([filterMeta.filterId isEqual:@(ASDF_USER_FILTER_ID)])
                        updateUserFilterMetadata = YES;
                    else
                        [filterIdsForUpdate addObject:filterMeta.filterId];
                }
            }
            
            // Get filter metadata from back end and insert to  DB.
            NSArray *metadataList = @[];
            if (filterIdsForUpdate.count) {
                
                metadataList = [filterClient filterMetadataListForApp:[ADProductInfo applicationID]];
                if (metadataList)
                    metadataList = [metadataList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"filterId IN %@", filterIdsForUpdate]];
            }
            
            // Update groups metadata if..
            NSArray *groupMetadataList = @[];
            
            if (metadataList) {
                
                groupMetadataList = [filterClient groupMetadataListForApp:[ADProductInfo applicationID]];
                if (groupMetadataList) {
                    
                    NSArray *groupIdsForUpdate = [metadataList valueForKey:@"groupId"];
                    groupMetadataList = [groupMetadataList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"groupId IN %@", groupIdsForUpdate]];
                    
                }
            }
            
            if (updateUserFilterMetadata) {
                
                groupMetadataList = [@[[self generateUserFilterGroupMetadata]] arrayByAddingObjectsFromArray:groupMetadataList];
            }
            
            if (groupMetadataList.count) {
                
                [theDB exec:^(FMDatabase *db, BOOL *rollback) {
                    
                    BOOL result = [self insertMetadataIntoDb:db groups:groupMetadataList];
                    *rollback = !result;
                    metaUpdated |= result;
                }];
            }
            //----------------------------
            
            if (updateUserFilterMetadata) {
                
                metadataList = [@[[self generateUserFilterMetadata]] arrayByAddingObjectsFromArray:metadataList];
            }
            
            if (metadataList.count) {
                
                [theDB exec:^(FMDatabase *db, BOOL *rollback) {
                    
                    BOOL result = [self insertMetadataIntoDb:db filters:metadataList];
                    *rollback = !result;
                    metaUpdated |= result;
                }];
            }
            
            // Determine filter list for updating versions and rules
            [filterIdsForUpdate removeAllObjects];
            for (filterMeta in dbFilterMetas) {
                
                //determin not editable
                if (![filterMeta.editable boolValue]) {
                    
                    // determin interval
                    interval = [filterMeta.checkDate timeIntervalSinceNow] * -1;
                    // updated only enabled filters
                    if ([filterMeta.enabled boolValue]
                        && ( forced || interval >= [filterMeta.expires integerValue] )
                        )
                        
                        [filterIdsForUpdate addObject:filterMeta.filterId];
                }
            }
            
            // Get filters data from backend and insert to DB
            
            NSMutableArray *updatedVersions = [NSMutableArray arrayWithCapacity:filterIdsForUpdate.count];
            
            if (filterIdsForUpdate.count) {
                
                NSArray *versions = [filterClient filterVersionListForApp:[ADProductInfo applicationID] filterIds:filterIdsForUpdate];
                
                if (versions == nil) {
                    [self updateFailure];
                    return;
                }
                
                for (ASDFilterMetadata *version in versions) {
                    
                    // checking version
                    filterMeta = [dbFilterMetas member:version];
                    
                    if ([version.version compare:filterMeta.version options:NSNumericSearch] == NSOrderedDescending) {
                        
                        // needs update filter
                        [theDB exec:^(FMDatabase *db, BOOL *rollback) {
                            
                            *rollback = YES;
                            
                            ASDFilter *filterData = [filterClient filterForApp:[ADProductInfo applicationID] affiliateId:@"" filterId:[version.filterId integerValue]];
                            
                            if (!filterData) {
                                [self updateFailure];
                                return;
                            }
                            
                            //get disabled rules
                            NSArray *disabledRuleTexts = [self disabledRuleTextsForDb:db filterId:version.filterId];
                            
                            BOOL boolResult = [db executeUpdate:@"delete from filter_rules where filter_id = ?", version.filterId];
                            
                            boolResult &= [db executeUpdate:@"update filters set last_update_time = datetime(?), last_check_time = datetime(?), version = ? where filter_id = ?", version.updateDateString , version.checkDateString , version.version, version.filterId ];
                            
                            if (!boolResult)
                                return;
                            
                            if (filterData.rules.count)
                                for (ASDFilterRule *rule in filterData.rules){
                                    
                                    if ([disabledRuleTexts containsObject:rule.ruleText])
                                        rule.isEnabled = @(0);
                                    [db executeUpdate:@"insert into filter_rules (filter_id, rule_id, rule_text, is_enabled) values (?, ?, ?, ?)", rule.filterId, rule.ruleId, rule.ruleText, rule.isEnabled];
                                }
                            
                            *rollback = NO;
                            rulesUpdated = YES;
                            [updatedVersions addObject:version];
                        }];
                    }
                }
            }
            // Notifying to all, that filter rules were updated
            if (rulesUpdated)
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerUpdateFilterRulesNotification object:self];
                });
            
            // Notifying to all, that filter metadata were updated (if the rules have not been updated)
            else if (metaUpdated)
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerUpdateFilterMetadataNotification object:self];
                });
            
            self.updatesRightNow = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                DDLogInfo(@"(ASAntibanner) Finished update process.");
                DDLogInfo(@"Filters updated count: %lu", updatedVersions.count);
                for (ASDFilterMetadata *meta in updatedVersions) {
                    DDLogInfo(@"Filter id: %@, version: %@, updated: %@.", meta.filterId, meta.version, meta.updateDateString);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerFinishedUpdateNotification object:self userInfo:@{ASAntibannerUpdatedFiltersKey: updatedVersions}];
            });
            
            
        }
    }
    else if (!observingDbStatus){
        
        observingDbStatus = YES;
        [theDB addObserver:self forKeyPath:@"ready" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)updateFailure{
    
    self.updatesRightNow = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerFailuredUpdateNotification object:self];
    });
}

//// Set update timer
//- (void)enableUpdateTimer{
//    
//    updateTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, workQueue);
//    
//    dispatch_source_set_timer(updateTimer, DISPATCH_TIME_NOW,
//                              AS_CHECK_FILTERS_UPDATES_PERIOD * NSEC_PER_SEC,
//                              AS_CHECK_FILTERS_UPDATES_LEEWAY * NSEC_PER_SEC);
//    
//    dispatch_source_set_event_handler(updateTimer, ^{
//        
//        [self updateAntibannerForced:NO];
//    });
//    
//    dispatch_resume(updateTimer);
//    
//}
//
//- (void)disableUpdateTimer{
//    
//    if (updateTimer) {
//        
//        dispatch_source_cancel(updateTimer);
//        
//#if !OS_OBJECT_USE_OBJC
//        dispatch_release(updateTimer);
//#endif
//        updateTimer = nil;
//    }
//    
//}


- (BOOL)checkInstalledFiltersInDB{
    
    if (serviceInstalled)
        return YES;
    
    ASDatabase *theDB = [ASDatabase singleton];
    
    dispatch_async(workQueue, ^{ @autoreleasepool {
        
        if (theDB.ready){
            
            [theDB exec:^(FMDatabase *db, BOOL *rollback) {
                
                *rollback = YES;
                
                FMResultSet *result = [db executeQuery:@"select * from filters limit 1"];
                if (![result next]) {
                    
                    // install default filters
                    if ([self installFiltersIntoDb:db])
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            DDLogDebug(@"(ASAntibanner) ASAntibannerInstalledNotification");
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerInstalledNotification object:self];
                        });
                    
                    else{
                        
                        // Can't install filters metadata into DB.
                        DDLogError(@"Can't install filters metadata into DB.");
                        DDLogErrorTrace();
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerNotInstalledNotification object:self];
                        });
                        
                        self.enabled = NO;
                        return;
                    }
                }
                [result close];
                serviceInstalled = YES;
                *rollback = NO;
                if (serviceEnabled)
                    [self setServiceToReady];
            }];
        }
        else if (!observingDbStatus){
            
            observingDbStatus = YES;
            [theDB addObserver:self forKeyPath:@"ready" options:NSKeyValueObservingOptionNew context:nil];
            
        }
        
    }});
    
    return NO;
}

- (BOOL)installFiltersIntoDb:(FMDatabase *)productionDb{
    
    @autoreleasepool {
        
        __block NSArray *filters = nil;
        __block NSArray *groups = nil;
        // Trying obtain filter groups metadata from default DB.
        [[ASDatabase singleton] queryDefaultDB:^(FMDatabase* db) {

            groups = [self groupsFromDb:db];
        }];

        if (!groups)
            return NO;
        
        NSMutableArray *sGroups = [NSMutableArray arrayWithArray:groups];
        groups = nil;
        
        //Get group metadata for user custom filter
        [sGroups addObject:[self generateUserFilterGroupMetadata]];

        [[ASDatabase singleton] queryDefaultDB:^(FMDatabase* db) {

            filters = [self filtersFromDb:db];
        }];

        if (!filters)
            return NO;
        
        // Insert groups metadata into db
        if (![self insertMetadataIntoDb:productionDb groups:sGroups]) {
            
            return NO;
        }
        
        // Get suitable filters.
        NSMutableArray *sFilters = [NSMutableArray arrayWithCapacity:4];
        NSString *langString = [NSString stringWithFormat:@"%@|%@|%@", ADL_DEFAULT_LANG, [ADLocales lang], [ADLocales region]];
        for (ASDFilterMetadata *filter in filters)
            if ([langString containsAny:filter.langs]                   // Filters for user language and english
                || [filter.filterId isEqual:@(ASDF_SPYWARE_FILTER_ID)]   // Privacy Protection Filter
                
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS
                || [filter.filterId isEqual:@(ASDF_SOC_NETWORKS_FILTER_ID)] // Social networks filter identifier
                || [filter.filterId isEqual:@(ASDF_MOBILE_SAFARI_FILTER_ID)] // Mobile Safari FIlter
#elif TARGET_OS_MAC
                
                
#endif
                )
                [sFilters addObject:filter];
        
        if (!sFilters)
            return NO;
        
        //Get metadata for user custom filter
        [sFilters addObject:[self generateUserFilterMetadata]];
        
        if (![self insertMetadataIntoDb:productionDb filters:sFilters])
            return NO;
        
        // Trying obtain filter rules from default DB and to insert into production DB.
        for (ASDFilterMetadata *filter in sFilters) {
            
            [self installRulesFromDefaultDbWithFilter:filter db:productionDb];
        }
    }
    
    return YES;
}

- (BOOL)insertMetadataIntoDb:(FMDatabase *)db filters:(NSArray *)metadataList{
    
    BOOL result = NO;
    for (ASDFilterMetadata *meta in metadataList) {
        
        result = [db executeUpdate:@"insert or replace into filters (filter_id, version, editable, display_number, group_id, name, description, homepage, is_enabled, last_update_time, last_check_time, removable, expires) values (?, ?, ?, ?, ?, ?, ?, ?, ?, datetime(?), datetime(?), ?, ?)",
                  meta.filterId, meta.version, meta.editable, meta.displayNumber, meta.groupId, meta.name, meta.descr, meta.homepage, meta.enabled, meta.updateDateString, meta.checkDateString, meta.removable, meta.expires];
        if (!result) break;
        
        result = [db executeUpdate:@"delete from filter_langs where filter_id = ?", meta.filterId];
        if (!result) break;
        
        result = [db executeUpdate:@"delete from filter_localizations where filter_id = ?", meta.filterId];
        if (!result) break;
        
        for (NSString *lang in meta.langs){
            
            result = [db executeUpdate:@"insert into filter_langs (filter_id, lang) values (?, ?)", meta.filterId, lang];
            if (!result) break;
        }
        if (!result) break;
        
        for (ASDFilterLocalization *locale in [meta.localizations allValues]){
            
            result = [db executeUpdate:@"insert into filter_localizations (filter_id, lang, name, description) values (?, ?, ?, ?)",
                      meta.filterId, locale.lang, locale.name, locale.descr];
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
        
        result = [db executeUpdate:@"insert or replace into filter_groups (group_id, display_number, name) values (?, ?, ?)",
                  meta.groupId, meta.displayNumber, meta.name];
        if (!result) break;
        
        result = [db executeUpdate:@"delete from filter_group_localizations where group_id = ?", meta.groupId];
        if (!result) break;
        
        for (ASDFilterLocalization *locale in [meta.localizations allValues]){
            
            result = [db executeUpdate:@"insert into filter_group_localizations (group_id, lang, name) values (?, ?, ?)",
                      meta.groupId, locale.lang, locale.name];
            if (!result) break;
        }
        
        if (!result) break;
    }
    
    if (!result)
        DDLogError(@"Error updating group metadata in production DB: %@", [[db lastError] localizedDescription]);
    
    return result;
}

- (BOOL)installRulesFromDefaultDbWithFilter:(ASDFilterMetadata *)filter db:(FMDatabase *)db {

    __block NSArray *rules;
    
    // Trying obtain filter rules from default DB
    [[ASDatabase singleton] queryDefaultDB:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"select * from filter_rules where filter_id = ?", filter.filterId];
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
    
    [self replaceRules:rules forFilter:filter inDb:db];
    
    return YES;
}

- (BOOL)installRulesFromBackendWithFilter:(ASDFilterMetadata *)filter db:(FMDatabase *)db {
    
    NSArray *rules;
    // Trying obtain filter rules from backend
    if ([reach isReachable]) {
        
        ABECFilterClient *client = [ABECFilterClient new];
        
        ASDFilter *filterData = [client filterForApp:[ADProductInfo applicationID] affiliateId:@"" filterId:[filter.filterId unsignedIntegerValue]];
        if (filterData) {
            
            rules = filterData.rules;
        }
    }
    if (!rules.count) {
        return NO;
    }
    
    [self replaceRules:rules forFilter:filter inDb:db];
    
    return YES;
}

- (void)replaceRules:(NSArray *)rules forFilter:(ASDFilterMetadata *)filter inDb:(FMDatabase *)db {

    if (rules.count) {
        
        [db executeUpdate:@"delete from filter_rules where filter_id = ?", filter.filterId];
        BOOL result = YES;
        for (ASDFilterRule *item in rules) {
            
            result = [db executeUpdate:@"insert into filter_rules (filter_id, rule_id, rule_text, is_enabled) values (?, ?, ?, ?)",
                      item.filterId, item.ruleId, item.ruleText, item.isEnabled];
            if (!result)
                DDLogError(@"Error install filter rules from default DB: %@", [[db lastError] localizedDescription]);
        }
    }

}

- (NSArray *)groupsFromDb:(FMDatabase *)db{
    
    NSMutableArray *groups = [NSMutableArray array];
    
    if (!db)
        return groups;
    
    @autoreleasepool {
        
        FMResultSet *result = [db executeQuery:@"select * from filter_group_localizations"];
        
        NSMutableDictionary *localizationsDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *dict;
        ASDFilterGroupLocalization *localization;
        while ([result next]) {
            
            localization = [[ASDFilterGroupLocalization alloc] initFromDbResult:result];
            dict = localizationsDict[localization.groupId];
            if (!dict)
                localizationsDict[localization.groupId] = dict = [NSMutableDictionary dictionary];
            
            dict[localization.lang] = localization;
        }
        [result close];
        
        result = [db executeQuery:@"select * from filter_groups order by display_number, group_id"];
        ASDFilterGroup *groupMetadata;
        while ([result next]) {
            
            groupMetadata = [[ASDFilterGroup alloc] initFromDbResult:result];
            
            dict = localizationsDict[groupMetadata.groupId];
            if (dict)
                groupMetadata.localizations = [dict copy];
            
            [groups addObject:groupMetadata];
        }
        [result close];
    }
    
    return groups;
}

- (NSArray *)filtersFromDb:(FMDatabase *)db{
    
    NSMutableArray *filters = [NSMutableArray array];
    
    if (!db)
        return filters;
    
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
        
        result = [db executeQuery:@"select * from filter_localizations"];
        
        NSMutableDictionary *localizationsDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *dict;
        ASDFilterLocalization *localization;
        while ([result next]) {
            
            localization = [[ASDFilterLocalization alloc] initFromDbResult:result];
            dict = localizationsDict[localization.filterId];
            if (!dict)
                localizationsDict[localization.filterId] = dict = [NSMutableDictionary dictionary];
            
            dict[localization.lang] = localization;
        }
        [result close];
        
        result = [db executeQuery:@"select * from filters order by group_id, display_number, filter_id"];
        ASDFilterMetadata *filterMetadata;
        while ([result next]) {
            
            filterMetadata = [[ASDFilterMetadata alloc] initFromDbResult:result];
            filterId = filterMetadata.filterId;
            
            list = langsDict[filterId];
            if (list)
                filterMetadata.langs = [list copy];
            
            dict = localizationsDict[filterId];
            if (dict)
                filterMetadata.localizations = [dict copy];
            
            FMResultSet *ruleResult = [db executeQuery:@"select count(*) from filter_rules where filter_id = ?", filterMetadata.filterId];
            if ([ruleResult next]) {
                filterMetadata.rulesCount = [ruleResult objectForColumnIndex:0];
            }
            
            [filters addObject:filterMetadata];
        }
        [result close];
    }
    
    return filters;
}

- (NSArray *)rulesFromDb:(FMDatabase *)db filterId:(NSNumber *)filterId{
    
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

- (ASDFilterMetadata *)generateUserFilterMetadata{
    
    @autoreleasepool {
        
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
        
        NSMutableDictionary *localizations = [NSMutableDictionary dictionary];
        ASDFilterLocalization *filterLocalization;
        NSString *string;
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
            
            localizations[locale] = filterLocalization;
        }
        
        userFilter.localizations = localizations;
        
        return userFilter;
    }
}

- (BOOL)deleteFilter:(NSNumber *)filterId fromDb:(FMDatabase *)db{
    
    if (!filterId)
        return NO;
    
    [db executeUpdate:@"delete from filter_langs where filter_id = ?", filterId];
    [db executeUpdate:@"delete from filter_localizations where filter_id = ?", filterId];
    [db executeUpdate:@"delete from filter_rules where filter_id = ?", filterId];
    [db executeUpdate:@"delete from filters where filter_id = ?", filterId];
    
    return YES;
}

- (ASDFilterGroup *)generateUserFilterGroupMetadata{
    
    @autoreleasepool {
        
        ASDFilterGroup *group = [ASDFilterGroup new];
        group.groupId = @(0);
        group.displayNumber = @(0);
        group.name = @"";
        
        return group;
    }
}

- (void)stopObservingReachabilityStatus{
    
    if (observingReachabilityStatus){
        
        [reach stopNotifier];
        observingReachabilityStatus = NO;
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
    if (!serviceReady && [[ASDatabase singleton] ready]){
        
        serviceReady = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            DDLogDebug(@"(AESAntibanner) ASAntibannerReadyNotification");
            [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerReadyNotification object:self];
        });
    }
    
}


/////////////////////////////////////////////////////////////////////////
#pragma mark Notofications
/////////////////////////////////////////////////////////////////////////

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    // DB DELAYED READY
    ASDatabase * dbService = [ASDatabase singleton];
    if ([object isEqual: dbService]
        && [keyPath isEqualToString:@"ready"]
        && dbService.ready) {
        
        dispatch_async(workQueue, ^{
            
            [dbService removeObserver:self forKeyPath:@"ready"];
            observingDbStatus = NO;
            
            if (serviceInstalled)
                [self updateAntibannerForced:NO];
            else
                [self checkInstalledFiltersInDB];
        });
    }
}

-(void)reachabilityChanged:(NSNotification*)note
{
    dispatch_async(workQueue, ^{
        
        if([reach isReachable])
            [self updateAntibannerForced:NO];
    });
}


@end
/*
@implementation AESAntibanner{
    
    BOOL _inTransaction;
}

- (id)init{
    
    self = [super init];
    if (self) {
     
        _inTransaction = NO;
    }
    
    return self;
}

// Redefine this method that prevent running of the update timer
- (void)enableUpdateTimer{

    // Notifying to all, that filter rules may be obtained
    if (!serviceReady && [[ASDatabase singleton] ready]){
        
        serviceReady = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            DDLogDebug(@"(AESAntibanner) ASAntibannerReadyNotification");
            [[NSNotificationCenter defaultCenter] postNotificationName:ASAntibannerReadyNotification object:self];
        });
    }
    
}

- (void)disableUpdateTimer{
    
}

- (BOOL)inTransaction{
    
    return _inTransaction;
}

- (void)beginTransaction{
    
    [[ASDatabase singleton] isolateQueue:workQueue];
    [[ASDatabase singleton] readUncommited:YES];
    dispatch_sync(workQueue, ^{
        
        if (_inTransaction) {
            return;
        }
        
        [[ASDatabase singleton] rawExec:^(FMDatabase *db) {
            [db beginDeferredTransaction];
        }];
        
        _inTransaction = YES;
    });
}

- (void)endTransaction{
    
    dispatch_sync(workQueue, ^{
        if (_inTransaction) {

            [[ASDatabase singleton] rawExec:^(FMDatabase *db) {
                
                [db commit];
            }];
        }
        _inTransaction = NO;
    });
    [[ASDatabase singleton] readUncommited:NO];
    [[ASDatabase singleton] resetIsolationQueue:workQueue];
}

- (void)rollbackTransaction{
    
    dispatch_sync(workQueue, ^{
        
        if (_inTransaction) {
            [[ASDatabase singleton] rawExec:^(FMDatabase *db) {
                
                [db rollback];
            }];
        }
        _inTransaction = NO;
    });
    [[ASDatabase singleton] readUncommited:NO];
    [[ASDatabase singleton] resetIsolationQueue:workQueue];
}

@end
*/