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
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    APVpnManagerTunnelModeSplit = 0,
    APVpnManagerTunnelModeFull = 1,
    APVpnManagerTunnelModeFullWithoutVPNIcon = 2,
} APVpnManagerTunnelMode;

@class ASDFilterMetadata, ASDFilter, ABECFilterClientMetadata, ASDFilterRule, AEInvertedWhitelistDomainsObject, ABECFilterClientLocalization, DnsServerInfo;

/////////////////////////////////////////////////////////////////////
#pragma mark - AESharedResources Constants
/////////////////////////////////////////////////////////////////////

#define AE_PRODUCT_NAME                     @AG_PRODUCT
#define AE_HOSTAPP_ID                       @ADGUARD_BUNDLE_ID
//#define AE_EXTENSION_ID                     @ADGUARD_EXTENSION_BUNDLE_ID
#define AE_SHARED_RESOURCES_GROUP           @ADGUARD_SHARED_RESOURCES_GROUP
#define AE_FILTER_UPDATES_ID                @ADGUARD_FILTER_UPDATES_ID

#define AE_PRODUCTION_DB                    @"adguard.db"

#define AE_URLSCHEME                        @ADGUARD_URL_SCHEME
#define AE_URLSCHEME_COMMAND_ADD            @"add"
#define AE_URLSCHEME_COMMAND_AUTH           @"auth"

#define AE_URLSCHEME_AUTH_PARAM_TOKEN       @"access_token"
#define AE_URLSCHEME_AUTH_PARAM_STATE       @"state"

/**
 User Defaults key that defines enable/disable filtration.
 */
extern NSString * _Nonnull AEDefaultsAdguardEnabled;

/**
 User Defaults key that defines app performs first start or not.
 */
extern NSString * _Nonnull AEDefaultsFirstRunKey;
/**
 User Defaults key that defines schema version for upgrade procedure.
 */
extern NSString * _Nonnull AEDefaultsProductSchemaVersion;

/**
 User Defaults key that defines last used build version for upgrade procedure.
 */
extern NSString * _Nonnull AEDefaultsProductBuildVersion;

/**
 User Defaults key that defines last time, when the application checked updates of filters.
 */
extern NSString * _Nonnull AEDefaultsCheckFiltersLastDate;

/**
 User Defaults key that define maximum of the rules count,
 which may be converted to content blocking JSON.
 */
extern NSString * _Nonnull AEDefaultsJSONMaximumConvertedRules;

/**
 User Defaults key that define current count of the rules, which put into converter.
 */
extern NSString * _Nonnull AEDefaultsJSONRulesForConvertion;

/**
 User Defaults key that define current count of the converted rules.
 */
extern NSString * _Nonnull AEDefaultsJSONConvertedRules;

/**
 User Defaults key, which define that overlimit of rules was reached.
 */
extern NSString * _Nonnull AEDefaultsJSONRulesOverlimitReached;

/**
 User Defaults key that define optimized procedure of the convertion for JSON Converter.
 */
extern NSString * _Nonnull AEDefaultsJSONConverterOptimize;

/**
 User Defaults key, which defines that filter updates will performed only in Wi-Fi network.
 */
extern NSString * _Nonnull AEDefaultsWifiOnlyUpdates;

/**
 User Defaults key, which defines that video tutorial cell must be hidden.
 */
extern NSString * _Nonnull AEDefaultsHideVideoTutorial;

/**
 User Defaults key, which defines that "manage adguard from safari" video tutorial cell must be hidden.
 */
extern NSString * _Nonnull AEDefaultsHideSafariVideoTutorial;

/**
 User Defaults key, which defines total request count.
 */
extern NSString * _Nonnull AEDefaultsTotalRequestsCount;

/**
 User Defaults key, which defines total request time.
 */
extern NSString * _Nonnull AEDefaultsTotalRequestsTime;
/**
 User Defaults key, which defines total trackers request count.
 */
extern NSString * _Nonnull AEDefaultsTotalTrackersCount;

/**
 User Defaults key, which defines that content blocker must use inverted whitelist - blocks ads ONLY on sites from this list.
 */
extern NSString * _Nonnull AEDefaultsInvertedWhitelist;

/**
 User Defaults key, which defines app first launch date. Used for show Rate me allert.
 */
extern NSString * _Nonnull AEDefaultsFirstLaunchDate;

/**
 User Defaults key, which defines that pro feature is purchased.
 */
extern NSString* _Nonnull  AEDefaultsIsProPurchasedThroughInApp;

/**
 User Defaults key, which defines that pro feature is purchased.
 */
extern NSString* _Nonnull  AEDefaultsIsProPurchasedThroughLogin;

/**
 User defaults key, which contains premium account expiration date (NSDate) */
extern NSString* _Nonnull AEDefaultsPremiumExpirationDate;

/**
 User defaults key, which defines tha user has premium license */
extern NSString* _Nonnull AEDefaultsHasPremiumLicense;


/**
 User defaults key, which contains In app purchase subscription expiration date (NSDate) */
extern NSString* _Nonnull AEDefaultsRenewableSubscriptionExpirationDate;

/**
 User defaults key, which defines that non consumable item has been purchased */
extern NSString* _Nonnull AEDefaultsNonConsumableItemPurchased;

/**
 User defaults key, which defines that "pro expired" message showed */
extern NSString*  _Nonnull AEDefaultsPremiumExpiredMessageShowed;

/**
 User defaults key, which defines dark theme is on */
extern NSString*  _Nonnull AEDefaultsDarkTheme;

/**
 User defaults key, which defines system appearence style */
extern NSString* _Nonnull AEDefaultsSystemAppearenceStyle;

/**
 User defaults key, which defines dark theme is on */
extern NSString*  _Nonnull AEDefaultsAppRated;

/**
 User defaults key, which defines dark theme is on */
extern NSString*  _Nonnull AEDefaultsAuthStateString;

/**
 User defaults key, which defines that appId allready saved with right access rights.
 */
// todo: remove this in future
extern NSString*  _Nonnull AEDefaultsAppIdSavedWithAccessRights;

/**
 User defaults keys, which contains number of rules for each content blocker*/
extern NSString*  _Nonnull AEDefaultsGeneralContentBlockerRulesCount;
extern NSString*  _Nonnull AEDefaultsPrivacyContentBlockerRulesCount;
extern NSString*  _Nonnull AEDefaultsSocialContentBlockerRulesCount;
extern NSString*  _Nonnull AEDefaultsOtherContentBlockerRulesCount;
extern NSString*  _Nonnull AEDefaultsCustomContentBlockerRulesCount;

/**
 User defaults keys, which contains number of over limited rules for each content blocker*/
extern NSString*  _Nonnull AEDefaultsGeneralContentBlockerRulesOverLimitCount;
extern NSString*  _Nonnull AEDefaultsPrivacyContentBlockerRulesOverLimitCount;
extern NSString*  _Nonnull AEDefaultsSocialContentBlockerRulesOverLimitCount;
extern NSString*  _Nonnull AEDefaultsOtherContentBlockerRulesOverLimitCount;
extern NSString*  _Nonnull AEDefaultsCustomContentBlockerRulesOverLimitCount;

/**
 User defaults key, which defines, whether vpn is enabled */
extern NSString* _Nonnull AEDefaultsVPNEnabled;

/**
 User defaults key, which defines, whether restart by reachability is enabled */
extern NSString* _Nonnull AEDefaultsRestartByReachability;

/**
 User defaults key, which defines vpn tunnel mode */
extern NSString* _Nonnull AEDefaultsVPNTunnelMode;

/////////////////////////////////////////////////////////////////////
#pragma mark - AESharedResources
/////////////////////////////////////////////////////////////////////

/**
     Class, which provides exchanging data between app and extension.
 */
@protocol AESharedResourcesProtocol

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

/**
 Returns URL where is shared resources.
 */
+ (nonnull NSURL *)sharedResuorcesURL;

/**
 Returns URL where must be current application logs.
 */
+ (nonnull NSURL *)sharedAppLogsURL;

/**
 Returns URL where must be the applications logs.
 */
+ (nonnull NSURL *)sharedLogsURL;

/**
 Returns shared user defaults object.
 */
- (nonnull NSUserDefaults *)sharedDefaults;

/**
 Saves defaults value in NSArgumentDomain.
 This lets to use defaults value in current process, 
 but this value did not save on disk (permanent domain).
 
 @param key Defaults key
 @param value Devaults value
 */
+ (void)sharedDefaultsSetTempKey:(nonnull NSString *)key value:(nonnull id)value;
/**
 Gets defaults value from NSArgumentDomain.

 @param key Defaults key.
 @return Defaults value or nil.
 */
+ (nullable id)sharedDefaultsValueOfTempKey:(nonnull NSString *)key;
/**
 Removes defaults value from NSArgumentDomain.

 @param key Defaults key.
 */
+ (void)sharedDefaultsRemoveTempKey:(nonnull NSString *)key;

/**
 Performs flush of the shared user defaults.
 */
+ (void)synchronizeSharedDefaults;

/**
 saves @data to file with @relativePath
 returns YES if succeded
 */
- (BOOL)saveData:(nonnull NSData *)data toFileRelativePath:(nonnull NSString *)relativePath;

/**
 read data from file
 */
- (nullable NSData *)loadDataFromFileRelativePath:(nonnull NSString *)relativePath;

/**
 Rules from whitelist, which used for Safari content-blocking.
 */
@property (nullable) NSMutableArray <ASDFilterRule *> *whitelistContentBlockingRules;

 /**
 Rules from inverted whitelist, which used for Safari content-blocking.
 */
@property (nullable) AEInvertedWhitelistDomainsObject *invertedWhitelistContentBlockingObject;

/**
 Filter metadata from last filter update process.
 We need it because filter update process is performed in two steps.
 */
@property (nullable) ABECFilterClientMetadata *lastUpdateFilterMetadata;

/**
 Filter metadata cache. We need this to work with subscriptions when the remote server is not reachable.
 */
@property (nullable) ABECFilterClientMetadata *filtersMetadataCache;

/**
 Filter localizations cache. We need this to work with subscriptions when the remote server is not reachable.
 */
@property (nullable) ABECFilterClientLocalization *i18nCacheForFilterSubscription;

/**
 Filter Ids from last filter update process.
 */
@property (nullable) NSArray <NSNumber *> *lastUpdateFilterIds;
/**
 Filter rules from last filter update process.
 We need it because filter update process is performed in two steps.
 */
@property (nullable) NSDictionary <NSNumber *, ASDFilter *> *lastUpdateFilters;

@property (nullable) DnsServerInfo* activeDnsServer;

- (nonnull NSString*) pathForRelativePath:(nonnull NSString*) relativePath;

@end

@interface AESharedResources: NSObject<AESharedResourcesProtocol>

@end
