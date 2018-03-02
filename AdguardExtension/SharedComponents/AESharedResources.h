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
#import <Foundation/Foundation.h>

@class ASDFilterMetadata, ASDFilter, ABECFilterClientMetadata, ASDFilterRule, AEInvertedWhitelistDomainsObject;

/////////////////////////////////////////////////////////////////////
#pragma mark - AESharedResources Constants
/////////////////////////////////////////////////////////////////////

#define AE_PRODUCT_NAME                     @AG_PRODUCT
#define AE_HOSTAPP_ID                       @ADGUARD_BUNDLE_ID
#define AE_EXTENSION_ID                     @ADGUARD_EXTENSION_BUNDLE_ID
#define AE_SHARED_RESOURCES_GROUP           @ADGUARD_SHARED_RESOURCES_GROUP
#define AE_FILTER_UPDATES_ID                @ADGUARD_FILTER_UPDATES_ID

#define AE_PRODUCTION_DB                    @"adguard.db"

#define AE_URLSCHEME                        @ADGUARD_URL_SCHEME
#define AE_URLSCHEME_COMMAND_ADD            @"add"

/**
 User Defaults key that defines enable/disable filtration.
 */
extern NSString *AEDefaultsAdguardEnabled;

/**
 User Defaults key that defines app performs first start or not.
 */
extern NSString *AEDefaultsFirstRunKey;
/**
 User Defaults key that defines schema version for upgrade procedure.
 */
extern NSString *AEDefaultsProductSchemaVersion;

/**
 User Defaults key that defines last time, when the application checked updates of filters.
 */
extern NSString *AEDefaultsCheckFiltersLastDate;

/**
 User Defaults key that define maximum of the rules count,
 which may be converted to content blocking JSON.
 */
extern NSString *AEDefaultsJSONMaximumConvertedRules;

/**
 User Defaults key that define current count of the rules, which put into converter.
 */
extern NSString *AEDefaultsJSONRulesForConvertion;

/**
 User Defaults key that define current count of the converted rules.
 */
extern NSString *AEDefaultsJSONConvertedRules;

/**
 User Defaults key, which define that overlimit of rules was reached.
 */
extern NSString *AEDefaultsJSONRulesOverlimitReached;

/**
 User Defaults key that define optimized procedure of the convertion for JSON Converter.
 */
extern NSString *AEDefaultsJSONConverterOptimize;

/**
 User Defaults key, which defines that filter updates will performed only in Wi-Fi network.
 */
extern NSString *AEDefaultsWifiOnlyUpdates;

/**
 User Defaults key, which defines that content blocker must use inverted whitelist - blocks ads ONLY on sites from this list.
 */
extern NSString *AEDefaultsInvertedWhitelist;

/////////////////////////////////////////////////////////////////////
#pragma mark - AESharedResources
/////////////////////////////////////////////////////////////////////

/**
     Class, which provides exchanging data between app and extension.
 */
@interface AESharedResources : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

/**
 Returns URL where is shared resources.
 */
+ (NSURL *)sharedResuorcesURL;

/**
 Returns URL where must be current application logs.
 */
+ (NSURL *)sharedAppLogsURL;

/**
 Returns URL where must be the applications logs.
 */
+ (NSURL *)sharedLogsURL;

/**
 Returns shared user defaults object.
 */
+ (NSUserDefaults *)sharedDefaults;

/**
 Saves defaults value in NSArgumentDomain.
 This lets to use defaults value in current process, 
 but this value did not save on disk (permanent domain).
 
 @param key Defaults key
 @param value Devaults value
 */
+ (void)sharedDefaultsSetTempKey:(NSString *)key value:(id)value;
/**
 Gets defaults value from NSArgumentDomain.

 @param key Defaults key.
 @return Defaults value or nil.
 */
+ (id)sharedDefaultsValueOfTempKey:(NSString *)key;
/**
 Removes defaults value from NSArgumentDomain.

 @param key Defaults key.
 */
+ (void)sharedDefaultsRemoveTempKey:(NSString *)key;

/**
 Performs flush of the shared user defaults.
 */
+ (void)synchronizeSharedDefaults;

/**
 Data with blocking content rules JSON.
 */
@property NSData *blockingContentRules;
/**
 Rules from whitelist, which used for Safari content-blocking.
 */
@property NSMutableArray <ASDFilterRule *> *whitelistContentBlockingRules;

 /**
 Rules from inverted whitelist, which used for Safari content-blocking.
 */
@property AEInvertedWhitelistDomainsObject *invertedWhitelistContentBlockingObject;

/**
 Filter metadata from last filter update process.
 We need it because filter update process is performed in two steps.
 */
@property ABECFilterClientMetadata *lastUpdateFilterMetadata;
/**
 Filter Ids from last filter update process.
 */
@property NSArray <NSNumber *> *lastUpdateFilterIds;
/**
 Filter rules from last filter update process.
 We need it because filter update process is performed in two steps.
 */
@property NSDictionary <NSNumber *, ASDFilter *> *lastUpdateFilters;


@end
