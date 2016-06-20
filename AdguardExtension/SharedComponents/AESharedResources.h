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

/////////////////////////////////////////////////////////////////////
#pragma mark - AESharedResources Constants
/////////////////////////////////////////////////////////////////////

#define AE_PRODUCT_NAME                     @AG_PRODUCT
#define AE_HOSTAPP_ID                       @ADGUARD_BUNDLE_ID
#define AE_EXTENSION_ID                     @ADGUARD_EXTENSION_BUNDLE_ID
#define AE_SHARED_RESOURCES_GROUP           @ADGUARD_SHARED_RESOURCES_GROUP

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
 User Defaults key that defines last time, when the application checked updates of filters.
 */
extern NSString *AEDefaultsCheckFiltersLastDate;

/**
 User Defaults key that define maximum of the rules count,
 which may be converted to content blocking JSON.
 */
extern NSString *AEDefaultsJSONMaximumConvertedRules;

/**
 User Defaults key that define current count of the converted rules.
 */
extern NSString *AEDefaultsJSONConvertedRules;

/**
 User Defaults key that define optimized procedure of the convertion for JSON Converter.
 */
extern NSString *AEDefaultsJSONConverterOptimize;

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

//TODO: need descriptions
+ (void)sharedDefaultsSetTempKey:(NSString *)key value:(id)value;
+ (id)sharedDefaultsValueOfTempKey:(NSString *)key;
+ (void)sharedDefaultsRemoveTempKey:(NSString *)key;

/**
 Performs flush of the shared user defaults.
 */
+ (void)synchronizeSharedDefaults;

/**
 Data with blocking content rules JSON.
 */
@property NSData *blockingContentRules;


@end
