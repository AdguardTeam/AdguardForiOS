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

#import "ACommons/ACLang.h"
#import "APBlockingSubscriptionsManager.h"
#import "APSharedResources.h"
#import "ABECSubscription.h"

#define APBlockingSubscriptionsKey @"APBlockingSubscriptionsKey"
#define APBlockingSubscriptionsNextUpdateKey @"APBlockingSubscriptionsNextUpdateKey"

#define UPDATE_INTERVAL 60*60*24

/////////////////////////////////////////////////////////////////////
#pragma mark - APBlockingSubscriptionsManager

@implementation APBlockingSubscriptionsManager

static NSArray<APBlockingSubscription *> *_predefinedSubscriptions;

static NSArray<APBlockingSubscription *> *_subscriptions;

static NSArray<APBlockingSubscription *> *_subscriptionsMeta;

+ (NSArray<APBlockingSubscription *> *)subscriptions {
    
    if(!_subscriptions) {
        _subscriptions = _subscriptionsMeta = [self loadSubscriptions];
    }

    return _subscriptions;
}

+ (NSArray<APBlockingSubscription *> *)subscriptionsMeta {
    
    if(!_subscriptionsMeta) {
        _subscriptionsMeta = [self loadSubscriptionsMeta];
    }
    
    return _subscriptionsMeta;
}

+ (void)setSubscriptions:(NSArray<APBlockingSubscription *> *)subscriptions {

    _subscriptions = subscriptions;
    _subscriptionsMeta = _subscriptions;
    
    [self saveHostsForSubscriptions:subscriptions];
    [self saveRulesForSubscriptions:subscriptions];
    [self saveSubscriptions:subscriptions];
    [self saveSubscriptionsMeta:subscriptions];
}

+ (void) saveSubscriptions:(NSArray<APBlockingSubscription *>*) subscriptions {
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) save subscriptions data to file");
    NSMutableArray* arrayToStore = [NSMutableArray new];
    
    for(APBlockingSubscription* subscription in subscriptions) {
        NSData* subscriptionData = [NSKeyedArchiver archivedDataWithRootObject:subscription];
        [arrayToStore addObject:subscriptionData];
    }
    
    BOOL result = [arrayToStore writeToFile:[APSharedResources pathForSubscriptionsData] atomically:YES];
    DDLogInfo(@"(APBlockingSubscriptionsManager) save subscriptions data to file result: %@", result ? @"YES" : @"NO");
}

+ (NSArray<APBlockingSubscription *> *) loadSubscriptions {
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) read subscriptions data from file");
    NSArray* storedArray = [NSArray arrayWithContentsOfFile:[APSharedResources pathForSubscriptionsData]];
    
    NSMutableArray* subscriptions = [NSMutableArray new];
    
    for(NSData* subscriptionData in storedArray) {
        
        APBlockingSubscription* subscription = [NSKeyedUnarchiver unarchiveObjectWithData:subscriptionData];
        [subscriptions addObject:subscription];
    }
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) subscriptions read count: %lu", subscriptions.count);
    
    return subscriptions.copy;
}

+ (void)saveSubscriptionsMeta:(NSArray<APBlockingSubscription *>*) subscriptions {
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) save subscriptions meta info to file");
    NSMutableArray* arrayToStore = [NSMutableArray new];
    
    for(APBlockingSubscription* subscription in subscriptions) {
        
        APBlockingSubscription* subscriptionMeta = [subscription meta];
        NSData* subscriptionData = [NSKeyedArchiver archivedDataWithRootObject:subscriptionMeta];
        [arrayToStore addObject:subscriptionData];
    }
    
    
    BOOL result = [arrayToStore writeToFile:[APSharedResources pathForSubscriptionsMeta] atomically:YES];
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) save subscriptions meta to file result: %@", result ? @"YES" : @"NO");
}

+ (NSArray<APBlockingSubscription*>*) loadSubscriptionsMeta {
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) read subscriptions meta from file");
    NSArray* storedArray = [NSArray arrayWithContentsOfFile:[APSharedResources pathForSubscriptionsMeta]];
    
    NSMutableArray* subscriptions = [NSMutableArray new];
    
    for(NSData* subscriptionData in storedArray) {
        
        APBlockingSubscription* subscription = [NSKeyedUnarchiver unarchiveObjectWithData:subscriptionData];
        [subscriptions addObject:subscription];
    }
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) subscriptions meta read count: %lu", subscriptions.count);
    return subscriptions.copy;
}

+ (BOOL)saveHostsForSubscriptions:(NSArray<APBlockingSubscription *> *)subscriptions {
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) save subscriptions hosts to file");
    
    NSUInteger hostsCount = 0;
    
    NSMutableDictionary<NSString*, NSDictionary*> *subscriptionsHosts = [NSMutableDictionary new];
    
    // do not add one domain multiple times
    NSMutableSet* addedHosts = [NSMutableSet new];

    for(APBlockingSubscription* subscription in subscriptions) {
        
        NSMutableDictionary* hostsToAdd = subscription.hosts.mutableCopy;
        [hostsToAdd removeObjectsForKeys:addedHosts.allObjects];
        
        subscriptionsHosts[subscription.uuid] = hostsToAdd;
        hostsCount += hostsToAdd.count;
        [addedHosts addObjectsFromArray:hostsToAdd.allKeys];
    }
    
    NSData* plistData = [NSPropertyListSerialization dataWithPropertyList:subscriptionsHosts format:NSPropertyListBinaryFormat_v1_0 options:0 error:NULL];
    BOOL result = [plistData writeToFile:[APSharedResources pathForSubscriptionsHosts] atomically:YES];
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) save subscriptions hosts result: %@ hosts count: %lu", result ? @"YES" : @"NO", hostsCount);
    
    return result;
}

+ (NSDictionary<NSString*, NSDictionary*>*)loadHosts {
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) load subscriptions hosts from file");
    NSInputStream* inputStream = [NSInputStream inputStreamWithFileAtPath:[APSharedResources pathForSubscriptionsHosts]];
    [inputStream open];
    
    NSError *error;
    NSDictionary *dict = [NSPropertyListSerialization propertyListWithStream:inputStream options:NSPropertyListImmutable format:NULL error:&error];
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) load subscriptions hosts count:%lu", dict.count);
    return dict;
}

+ (BOOL)saveRulesForSubscriptions:(NSArray<APBlockingSubscription *> *) subscriptions {
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) save subscriptions rules to file");
    
    NSMutableDictionary<NSString*, NSArray*> *subscriptionsRules = [NSMutableDictionary new];
    NSUInteger rulesCount = 0;
    
    for(APBlockingSubscription* subscriprtion in subscriptions) {
        subscriptionsRules[subscriprtion.uuid] = subscriprtion.rules;
        rulesCount += subscriprtion.rules.count;
    }
    
    NSData* plistData = [NSPropertyListSerialization dataWithPropertyList:subscriptionsRules format:NSPropertyListBinaryFormat_v1_0 options:0 error:NULL];
    
    BOOL result = [plistData writeToFile:[APSharedResources pathForSubscriptionsRules] atomically:YES];
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) save subscriptions rules result: %@ hosts count: %lu", result ? @"YES" : @"NO", rulesCount);
    
    return result;
}

+ (NSDictionary<NSString*, NSArray<NSString*> *> *) loadRules {
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) load subscriptions rules from file");
    NSInputStream* inputStream = [NSInputStream inputStreamWithFileAtPath:[APSharedResources pathForSubscriptionsRules]];
    [inputStream open];
    
    NSError *error;
    NSDictionary *rules = [NSPropertyListSerialization propertyListWithStream:inputStream options:NSPropertyListImmutable format:NULL error:&error];
    
    DDLogInfo(@"(APBlockingSubscriptionsManager) load subscriptions rules count:%lu", rules.count);
    return rules;
}

+ (NSArray<APBlockingSubscription *> *)predefinedSubscriptions {
    
    if(!_predefinedSubscriptions) {
        
        NSMutableArray* predefinedSubscriptions = [NSMutableArray new];
        
        APBlockingSubscription* subscription = [APBlockingSubscription new];
        
        subscription.uuid = @"SUBS01";
        subscription.name = NSLocalizedString(@"adguard_subscription_name", @"predefined subscription name");
        subscription.subscriptionDescription = NSLocalizedString(@"adguard_subscription_description", @"predefined subscription description");
        subscription.url = @"https://filters.adtidy.org/ios/filters/15_optimized.txt";
        
        [predefinedSubscriptions addObject:subscription];
        
        subscription = [APBlockingSubscription new];
        
        subscription.uuid = @"SUBS02";
        subscription.name = NSLocalizedString(@"adaway_subscription_name", @"predefined subscription name");
        subscription.subscriptionDescription = NSLocalizedString(@"adaway_subscription_description", @"predefined subscription description");
        subscription.url = @"https://adaway.org/hosts.txt";
        
        [predefinedSubscriptions addObject:subscription];
        
        subscription = [APBlockingSubscription new];
        
        subscription.uuid = @"SUBS03";
        subscription.name = NSLocalizedString(@"hphosts_subscription_name", @"predefined subscription name");
        subscription.subscriptionDescription = NSLocalizedString(@"hphosts_subscription_description", @"predefined subscription description");
        subscription.url = @"https://hosts-file.net/ad_servers.txt";
        
        [predefinedSubscriptions addObject:subscription];
        
        _predefinedSubscriptions = predefinedSubscriptions.copy;
    }
    
    return _predefinedSubscriptions;
}

+ (BOOL)needUpdateSubscriptions {
    
    NSTimeInterval nextUpdateTimestamp = [AESharedResources.sharedDefaults doubleForKey:APBlockingSubscriptionsNextUpdateKey];
    
    return (!nextUpdateTimestamp || [[NSDate new] timeIntervalSince1970] > nextUpdateTimestamp);
}


+ (void)updateSubscriptionsWithSuccessBlock:(void (^)())successBlock errorBlock:(void (^)(NSError *))errorBlock completionBlock:(void (^)())completionBlock
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        DDLogInfo(@"(APBlockingSubscriptionsManager) update subscriptions");
        dispatch_group_t group = dispatch_group_create();
        
        for(APBlockingSubscription* subscription in self.subscriptionsMeta) {
            
            dispatch_group_enter(group);
            DDLogInfo(@"(APBlockingSubscriptionsManager) try to download subscription: %@ url:%@", subscription.name, subscription.url);
            [ABECSubscription.singleton downloadSubscription:subscription.url completionBlock:^(NSArray *rules, NSDictionary *hosts) {
                
                DDLogInfo(@"(APBlockingSubscriptionsManager) download subscription success: %@ url:%@ rules:%lu hosts:%lu", subscription.name, subscription.url, rules.count, hosts.count);
                
                subscription.hosts = hosts;
                
                subscription.rules = rules;
                
                subscription.updateDate = [NSDate new];
                
                dispatch_group_leave(group);
                
            } errorBlock:^(NSError *error) {
                DDLogInfo(@"(APBlockingSubscriptionsManager) download subscription failed: %@ url:%@ ", subscription.name, subscription.url);
                
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        _subscriptions = _subscriptionsMeta;
        
        [self saveSubscriptions: _subscriptions];
        [self saveSubscriptionsMeta: _subscriptions];
        [self saveHostsForSubscriptions: _subscriptions];
        [self saveRulesForSubscriptions:_subscriptions];
        
        [self setNextUpdateTime];
        
        if(successBlock)
            successBlock();
        
        if(completionBlock)
            completionBlock();
    });
}

+ (void) setNextUpdateTime{
    
    NSTimeInterval nextUpdate = [[NSDate new] timeIntervalSince1970] + UPDATE_INTERVAL;
    [AESharedResources.sharedDefaults setDouble:nextUpdate forKey:APBlockingSubscriptionsNextUpdateKey];
}

+ (APBlockingSubscription *)subscriptionByUUID:(NSString *)uuid {
    
    for(APBlockingSubscription* subscription in self.subscriptionsMeta) {
        if([subscription.uuid isEqualToString:uuid]) {
            return subscription;
        }
    }
    
    return nil;
}

+ (BOOL)saveHostsAndRulesForSubscriptions {
    
    BOOL result = [self saveHostsForSubscriptions:self.subscriptions];
    result = result && [self saveRulesForSubscriptions:self.subscriptions];
    
    return result;
}

@end
