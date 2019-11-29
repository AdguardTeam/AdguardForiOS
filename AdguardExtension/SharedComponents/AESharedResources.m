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
#import "AESharedResources.h"
#import "ACommons/ACLang.h"
#import "ABECFilter.h"

NSString *AE_URLSCHEME = @ADGUARD_URL_SCHEME;
NSString *AE_URLSCHEME_COMMAND_ADD = @"add";

NSString *AEDefaultsFirstRunKey = @"AEDefaultsFirstRunKey";
NSString *AEDefaultsProductSchemaVersion = @"AEDefaultsProductSchemaVersion";
NSString *AEDefaultsProductBuildVersion = @"AEDefaultsProductBuildVersion";
NSString *AEDefaultsCheckFiltersLastDate = @"AEDefaultsCheckFiltersLastDate";
NSString *AEDefaultsJSONMaximumConvertedRules = @"AEDefaultsJSONMaximumConvertedRules";
NSString *AEDefaultsJSONConvertedRules = @"AEDefaultsJSONConvertedRules";
NSString *AEDefaultsJSONRulesForConvertion = @"AEDefaultsJSONRulesForConvertion";
NSString *AEDefaultsJSONRulesOverlimitReached = @"AEDefaultsJSONRulesOverlimitReached";
NSString *AEDefaultsJSONConverterOptimize = @"AEDefaultsJSONConverterOptimize";
NSString *AEDefaultsWifiOnlyUpdates = @"AEDefaultsWifiOnlyUpdates";
NSString *AEDefaultsHideVideoTutorial = @"AEDefaultsHideVideoTutorialCell";
NSString *AEDefaultsHideSafariVideoTutorial = @"AEDefaultsHideSafariVideoTutorialCell";
NSString *AEDefaultsInvertedWhitelist = @"AEDefaultsInvertedWhitelist";
NSString *AEDefaultsFirstLaunchDate = @"AEDefaultsFirstLaunchDate";
NSString *AEDefaultsIsProPurchasedThroughInApp = @"AEDefaultsIsProPurchasedThroughInApp";
NSString *AEDefaultsIsProPurchasedThroughLogin = @"AEDefaultsIsProPurchasedThroughLogin";
NSString *AEDefaultsPremiumExpirationDate = @"AEDefaultsPremiumExpirationDate";
NSString *AEDefaultsHasPremiumLicense = @"AEDefaultsHasPremiumLicense";
NSString *AEDefaultsRenewableSubscriptionExpirationDate = @"AEDefaultsRenewableSubscriptionExpirationDate";
NSString* AEDefaultsNonConsumableItemPurchased = @"AEDefaultsNonConsumableItemPurchased";
NSString* AEDefaultsPremiumExpiredMessageShowed = @"AEDefaultsPremiumExpiredMessageShowed";
NSString* AEDefaultsDarkTheme = @"AEDefaultsDarkTheme";
NSString* AEDefaultsSystemAppearenceStyle = @"AEDefaultsSystemAppearenceStyle";
NSString* AEDefaultsAppRated = @"AEDefaultsAppRated";
NSString* AEDefaultsAuthStateString = @"AEDefaultsAuthStateString";
NSString* AEDefaultsAppIdSavedWithAccessRights = @"AEDefaultsAppIdSavedWithAccessRights";
NSString* AEDefaultsUserFilterEnabled = @"AEDefaultsUserFilterEnabled";
NSString* AEDefaultsSafariWhitelistEnabled = @"AEDefaultsWhitelistEnabled";
NSString* AEDefaultsFilterWifiEnabled = @"AEDefaultsWifiExceptionsEnabled";
NSString* AEDefaultsFilterMobileEnabled = @"AEDefaultsFilterMobileEnabled";
NSString* AEDefaultsDnsWhitelistEnabled = @"AEDefaultsDnsWhitelistEnabled";
NSString* AEDefaultsDnsBlacklistEnabled = @"AEDefaultsDnsBlacklistEnabled";

NSString* AEDefaultsGeneralContentBlockerRulesCount = @"AEDefaultsGeneralContentBlockerRulesCount";
NSString* AEDefaultsPrivacyContentBlockerRulesCount = @"AEDefaultsPrivacyContentBlockerRulesCount";
NSString* AEDefaultsSocialContentBlockerRulesCount = @"AEDefaultsSocialContentBlockerRulesCount";
NSString* AEDefaultsOtherContentBlockerRulesCount = @"AEDefaultsOtherContentBlockerRulesCount";
NSString* AEDefaultsCustomContentBlockerRulesCount = @"AEDefaultsCustomContentBlockerRulesCount";
NSString* AEDefaultsSecurityContentBlockerRulesCount = @"AEDefaultsSecurityContentBlockerRulesCount";

NSString* AEDefaultsGeneralContentBlockerRulesOverLimitCount = @"AEDefaultsGeneralContentBlockerRulesOverLimitCount";
NSString* AEDefaultsPrivacyContentBlockerRulesOverLimitCount = @"AEDefaultsPrivacyContentBlockerRulesOverLimitCount";
NSString* AEDefaultsSocialContentBlockerRulesOverLimitCount = @"AEDefaultsSocialContentBlockerRulesOverLimitCount";
NSString* AEDefaultsOtherContentBlockerRulesOverLimitCount = @"AEDefaultsOtherContentBlockerRulesOverLimitCount";
NSString* AEDefaultsCustomContentBlockerRulesOverLimitCount = @"AEDefaultsCustomContentBlockerRulesOverLimitCount";
NSString* AEDefaultsSecurityContentBlockerRulesOverLimitCount = @"AEDefaultsSecurityContentBlockerRulesOverLimitCount";

NSString* AEDefaultsVPNEnabled = @"AEDefaultsVPNEnabled";
NSString* AEDefaultsRestartByReachability = @"AEDefaultsRestartByReachability";
NSString* AEDefaultsVPNTunnelMode = @"AEDefaultsVPNTunnelMode";
NSString* AEDefaultsDeveloperMode = @"AEDefaultsDeveloperMode";
NSString* AEDefaultsShowStatusBar = @"AEDefaultsShowStatusBar";
NSString* AEDefaultsDNSRequestsBlocking = @"AEDefaultsDNSRequestsBlocking";

NSString* AEDefaultsShowStatusViewInfo = @"AEDefaultsShowStatusViewInfo";
NSString *ShowStatusViewNotification = @"ShowStatusViewNotification";
NSString *HideStatusViewNotification = @"HideStatusViewNotification";

NSString* SafariProtectionState = @"SafariProtectionState";

#define AES_LAST_UPDATE_FILTERS_META            @"lastupdate-metadata.data"
#define AES_LAST_UPDATE_FILTER_IDS              @"lastupdate-filter-ids.data"
#define AES_LAST_UPDATE_FILTERS                 @"lastupdate-filters-v2.data"
#define AES_HOST_APP_USERDEFAULTS               @"host-app-userdefaults.data"
#define AES_SAFARI_WHITELIST_RULES              @"safari-whitelist-rules.data"
#define AES_SAFARI_INVERTED_WHITELIST_RULES     @"safari-inverdet-whitelist-rules.data"
#define AES_FILTERS_META_CACHE                  @"metadata-cache.data"
#define AES_FILTERS_I18_CACHE                   @"i18-cache.data"
#define AES_ACTIVE_DNS_SERVER                   @"active-dns-server.data"

/////////////////////////////////////////////////////////////////////
#pragma mark - AESharedResources
/////////////////////////////////////////////////////////////////////

@implementation AESharedResources

/////////////////////////////////////////////////////////////////////
#pragma mark Initialize
/////////////////////////////////////////////////////////////////////

static NSURL *_containerFolderUrl;
static NSUserDefaults *_sharedUserDefaults;

+ (void)initialize{
    
    if (self == [AESharedResources class]) {
        
        NSString* groupId = AE_SHARED_RESOURCES_GROUP;
        _containerFolderUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:groupId];
        _sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:AE_SHARED_RESOURCES_GROUP];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

+ (NSURL *)sharedResuorcesURL{
    
    return _containerFolderUrl;
}

+ (NSURL *)sharedAppLogsURL{
    
    NSString *ident = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
    
    NSURL *logsUrl = [AESharedResources sharedLogsURL];
    if (ident) {
        logsUrl = [logsUrl URLByAppendingPathComponent:ident];
    }
    
    return logsUrl;
}

+ (NSURL *)sharedLogsURL{
    
    return [_containerFolderUrl URLByAppendingPathComponent:@"Logs"];
}

- (NSMutableArray <ASDFilterRule *> *)whitelistContentBlockingRules {
    
    NSData *data = [self loadDataFromFileRelativePath:AES_SAFARI_WHITELIST_RULES];
    if (data.length) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (void)setWhitelistContentBlockingRules:(NSMutableArray<ASDFilterRule *> *)whitelistContentBlockingRules {
    
    if (whitelistContentBlockingRules == nil) {
        [self saveData:[NSData data] toFileRelativePath:AES_SAFARI_WHITELIST_RULES];
    }
    else {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:whitelistContentBlockingRules];
        if (!data) {
            data = [NSData data];
        }
        
        [self saveData:data toFileRelativePath:AES_SAFARI_WHITELIST_RULES];
    }
}

-(AEInvertedWhitelistDomainsObject *)invertedWhitelistContentBlockingObject {
    
    NSData *data = [self loadDataFromFileRelativePath:AES_SAFARI_INVERTED_WHITELIST_RULES];
    if (data.length) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (void)setInvertedWhitelistContentBlockingObject:(AEInvertedWhitelistDomainsObject *)invertedWhitelistContentBlockingObject{
    
    if (invertedWhitelistContentBlockingObject == nil) {
        [self saveData:[NSData data] toFileRelativePath:AES_SAFARI_INVERTED_WHITELIST_RULES];
    }
    else {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:invertedWhitelistContentBlockingObject];
        if (!data) {
            data = [NSData data];
        }
        
        [self saveData:data toFileRelativePath:AES_SAFARI_INVERTED_WHITELIST_RULES];
    }
}


- (ABECFilterClientMetadata *)lastUpdateFilterMetadata {
    
    NSData *data = [self loadDataFromFileRelativePath:AES_LAST_UPDATE_FILTERS_META];
    if (data.length) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (void)setLastUpdateFilterMetadata:(ABECFilterClientMetadata *)lastUpdateFilterMetadata {
    
    if (lastUpdateFilterMetadata == nil) {
        [self saveData:[NSData data] toFileRelativePath:AES_LAST_UPDATE_FILTERS_META];
    }
    else {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:lastUpdateFilterMetadata];
        if (!data) {
            data = [NSData data];
        }
        
        [self saveData:data toFileRelativePath:AES_LAST_UPDATE_FILTERS_META];
    }
}

- (ABECFilterClientMetadata *)filtersMetadataCache {
    
    NSData *data = [self loadDataFromFileRelativePath:AES_FILTERS_META_CACHE];
    if (data.length) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (void)setFiltersMetadataCache:(ABECFilterClientMetadata *)filtersMetadataCache {
    
    if (filtersMetadataCache == nil) {
        [self saveData:[NSData data] toFileRelativePath:AES_FILTERS_META_CACHE];
    }
    else {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:filtersMetadataCache];
        if (!data) {
            data = [NSData data];
        }
        
        [self saveData:data toFileRelativePath:AES_FILTERS_META_CACHE];
    }
}

- (ABECFilterClientLocalization *)i18nCacheForFilterSubscription {
    
    NSData *data = [self loadDataFromFileRelativePath:AES_FILTERS_I18_CACHE];
    if (data.length) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (void)setI18nCacheForFilterSubscription:(ABECFilterClientLocalization *)i18nCacheForFilterSubscription {
    
    if (i18nCacheForFilterSubscription == nil) {
        [self saveData:[NSData data] toFileRelativePath:AES_FILTERS_I18_CACHE];
    }
    else {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:i18nCacheForFilterSubscription];
        if (!data) {
            data = [NSData data];
        }
        
        [self saveData:data toFileRelativePath:AES_FILTERS_I18_CACHE];
    }
}

- (NSDictionary <NSNumber *, ASDFilter *> *)lastUpdateFilters {
    
    NSData *data = [self loadDataFromFileRelativePath:AES_LAST_UPDATE_FILTERS];
    if (data.length) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (void)setLastUpdateFilters:(NSDictionary <NSNumber *, ASDFilter *> *)lastUpdateFilters {
    
    if (lastUpdateFilters == nil) {
        [self saveData:[NSData data] toFileRelativePath:AES_LAST_UPDATE_FILTERS];
    }
    else {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:lastUpdateFilters];
        if (!data) {
            data = [NSData data];
        }
        
        [self saveData:data toFileRelativePath:AES_LAST_UPDATE_FILTERS];
    }
}

- (NSArray <NSNumber *> *)lastUpdateFilterIds {
    
    NSData *data = [self loadDataFromFileRelativePath:AES_LAST_UPDATE_FILTER_IDS];
    if (data.length) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (void)setLastUpdateFilterIds:(NSArray<NSNumber *> *)lastUpdateFilterIds {
    
    if (lastUpdateFilterIds == nil) {
        [self saveData:[NSData data] toFileRelativePath:AES_LAST_UPDATE_FILTER_IDS];
    }
    else {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:lastUpdateFilterIds];
        if (!data) {
            data = [NSData data];
        }
        
        [self saveData:data toFileRelativePath:AES_LAST_UPDATE_FILTER_IDS];
    }
}

- (void)reset {
    // clear user defaults
    DDLogInfo(@"(AESharedResources) reset settings");
    
    for (NSString* key in _sharedUserDefaults.dictionaryRepresentation.allKeys) {
        [_sharedUserDefaults removeObjectForKey:key];
    }
    [_sharedUserDefaults synchronize];
    
    // remove all files in shared directory
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:_containerFolderUrl.path error:&error]) {
        
        if ([file contains:@".db"]) continue;
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", _containerFolderUrl.path, file] error:&error];
        if (!success || error) {
            DDLogError(@"(AEsharedResources) reset. Error - can not delete file. Error: %@", error.localizedDescription);
        }
    }
}

- (NSUserDefaults *)sharedDefaults{
    
    return _sharedUserDefaults;
}

+ (void)synchronizeSharedDefaults{
    
    [_sharedUserDefaults synchronize];
}

+ (void)sharedDefaultsSetTempKey:(NSString *)key value:(id)value{
    
    if (!(key && value)) {
        [[NSException argumentException:@"key or value - nil"] raise];
    }
    
    @synchronized(_sharedUserDefaults) {
        @autoreleasepool {
            
            NSMutableDictionary *dict = [[_sharedUserDefaults volatileDomainForName:NSArgumentDomain] mutableCopy];
            if (dict) {
                
                dict[key] = value;
                [_sharedUserDefaults setVolatileDomain:dict forName:NSArgumentDomain];
            }
        }
    }
    
}

+ (id)sharedDefaultsValueOfTempKey:(NSString *)key{
    
    if (!key) {
        return nil;
    }
    
    @synchronized(_sharedUserDefaults) {
        @autoreleasepool {
            
            NSDictionary *dict = [_sharedUserDefaults volatileDomainForName:NSArgumentDomain];
            if (dict) {

                return dict[key];
            }
        }
    }
    
    return nil;
}

+ (void)sharedDefaultsRemoveTempKey:(NSString *)key{

    if (!key) {
        return;
    }
    
    @synchronized(_sharedUserDefaults) {
        @autoreleasepool {
            
            NSMutableDictionary *dict = [[_sharedUserDefaults volatileDomainForName:NSArgumentDomain] mutableCopy];
            if (dict) {
                
                [dict removeObjectForKey:key];
                [_sharedUserDefaults setVolatileDomain:dict forName:NSArgumentDomain];
            }
        }
    }
}

- (void)setActiveDnsServer:(DnsServerInfo *)activeDnsServer {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:activeDnsServer];
    if (!data) {
        data = [NSData data];
    }
    
    [self saveData:data toFileRelativePath:AES_ACTIVE_DNS_SERVER];
}

- (DnsServerInfo *)activeDnsServer {
    NSData *data = [self loadDataFromFileRelativePath:AES_ACTIVE_DNS_SERVER];
    
    if (data.length) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Storage methods (private)
/////////////////////////////////////////////////////////////////////


- (NSData *)loadDataFromFileRelativePath:(NSString *)relativePath{
    
    if (!relativePath) {
        [[NSException argumentException:@"relativePath"] raise];
    }
    
    @autoreleasepool {
        if (_containerFolderUrl) {
            
            NSURL *dataUrl = [_containerFolderUrl URLByAppendingPathComponent:relativePath];
            if (dataUrl) {
                ACLFileLocker *locker = [[ACLFileLocker alloc] initWithPath:[dataUrl path]];
                if ([locker lock]) {
                    
                    NSData *data = [NSData dataWithContentsOfURL:dataUrl];
                    
                    [locker unlock];
                    
                    return data;
                }
            }
        }
        
        return nil;
    }
}

- (BOOL)saveData:(NSData *)data toFileRelativePath:(NSString *)relativePath{

    if (!(data && relativePath)) {
        [[NSException argumentException:@"data/relativePath"] raise];
    }
    
    @autoreleasepool {
        if (_containerFolderUrl) {
            
            NSURL *dataUrl = [_containerFolderUrl URLByAppendingPathComponent:relativePath];
            if (dataUrl) {
                ACLFileLocker *locker = [[ACLFileLocker alloc] initWithPath:[dataUrl path]];
                if ([locker lock]) {
                    
                    BOOL result = [data writeToURL:dataUrl atomically:YES];
                    
                    [locker unlock];
                    
                    return result;
                }
            }
        }
        
        return NO;;
    }
}

- (NSString*) pathForRelativePath:(NSString*) relativePath {
    
    NSURL *dataUrl = [_containerFolderUrl URLByAppendingPathComponent:relativePath];
    
    return dataUrl.path;
}

@end

