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
#pragma mark -  Filtering constants
/////////////////////////////////////////////////////////////////////

#define ASDF_DEFAULT_FILTER_VERSION              @"0.0.0.0"
#define ASDF_DEFAULT_GROUP_ID                    @(3)
#define ASDF_DEFAULT_GROUP_NAME                  @"Other"


/////////////////////////////////////////////////////////////////////
#pragma mark -  Filter id's
/////////////////////////////////////////////////////////////////////

/// User filter identifier
#define ASDF_USER_FILTER_ID              0
/// Russian filter identifier
#define ASDF_RUSSIAN_FILTER_ID           1
/// English filter identifier
#define ASDF_ENGLISH_FILTER_ID           2
/// Spyware filter identifier
#define ASDF_SPYWARE_FILTER_ID           3
/// Social networks filter identifier
#define ASDF_SOC_NETWORKS_FILTER_ID      4
/// An experimental filter identifier
#define ASDF_EXPERIMENTAL_FILTER_ID      5
/// German filter identifier
#define ASDF_GERMAN_FILTER_ID            6
/// Japanece filter identifier
#define ASDF_JAPANESE_FILTER_ID          7
/// Dutch filter identifier
#define ASDF_DUTCH_FILTER_ID             8
/// Espan filter identifier
#define ASDF_SPAIN_PORTUGAL_FILTER_ID    9
/// White list filter for useful ad
#define ASDF_USEFUL_AD_FILTER_ID         10
/// Privacy protection supplement for EasyList
#define ASDF_EASYPRIVACY_FILTER_ID       118
/// Дополнение против счетчиков
#define ASDF_RUADLIST_COUNTERS_FILTER_ID 212

/// Mobile Safari Filter
#define ASDF_MOBILE_SAFARI_FILTER_ID     12

/// List of filters Ids that block trackers.
#define ASDF_TRACKERS_BLOCKING_FILTERS   @[\
@(ASDF_EASYPRIVACY_FILTER_ID),\
@(ASDF_RUADLIST_COUNTERS_FILTER_ID),\
@(ASDF_SPYWARE_FILTER_ID),\
@(ASDF_SOC_NETWORKS_FILTER_ID)\
]

/////////////////////////////////////////////////////////////////////
#pragma mark -  AASDFilterGroupLocalization
/////////////////////////////////////////////////////////////////////

@class FMResultSet;

/**
 Filter representation in filter group localization context.
 */
@interface ASDFilterGroupLocalization : NSObject

- (id)initFromDbResult:(FMResultSet *)result;

@property (nonatomic) NSNumber *groupId;
@property (nonatomic) NSString *lang;
@property (nonatomic) NSString *name;

@end







/////////////////////////////////////////////////////////////////////
#pragma mark -  AASDFilterGroup
/////////////////////////////////////////////////////////////////////

/**
 Filter representation in filter group context.
 */
@interface ASDFilterGroup : NSObject

- (id)initFromDbResult:(FMResultSet *)result;

@property (nonatomic) NSNumber *groupId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *displayNumber;


/// Dictionary contains filter group localizations,
/// where key is NSString that contains language code,
/// and value is AASDFilterGroupLocalization object.
@property (nonatomic) NSDictionary *localizations;

/**
 Returns localization for string properties of receiver.
 Method tries to obtain localization for current locale,
 if failure, tries to obtain default locale (en).
 If failure, returns default values.
 */
- (ASDFilterGroupLocalization *)localization;

@end






/////////////////////////////////////////////////////////////////////
#pragma mark -  AASDFilterLocalization
/////////////////////////////////////////////////////////////////////

/**
 Filter representation in localization context.
 */
@interface ASDFilterLocalization : NSObject

/**
 Initializing using Database result object.
 */
- (id)initFromDbResult:(FMResultSet *)result;

@property (nonatomic) NSNumber *filterId;
@property (nonatomic) NSString *lang;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *descr;

@end






/////////////////////////////////////////////////////////////////////
#pragma mark -  AASDFilter
/////////////////////////////////////////////////////////////////////

/**
 Filter representation with rules.
 */
@interface ASDFilter : NSObject

@property (nonatomic) NSNumber *filterId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *version;
@property (nonatomic) NSString *updateDateString;
@property (nonatomic) NSDate *updateDate;

/// Array of AASDFilterRule objects.
@property (nonatomic) NSArray *rules;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark -  AASDFilterRule
/////////////////////////////////////////////////////////////////////

/**
 Filter rule representation.
 */
@interface ASDFilterRule : NSObject

/**
 Initializing using Database result object.
 */
- (id)initFromDbResult:(FMResultSet *)result;

@property (nonatomic) NSNumber *filterId;
@property (nonatomic) NSNumber *ruleId;
@property (nonatomic) NSString *ruleText;
@property (nonatomic) NSNumber *isEnabled;

@end








/////////////////////////////////////////////////////////////////////
#pragma mark -  AASDFilterMetadata
/////////////////////////////////////////////////////////////////////

/**
 Filter representation in metadata context.
 Two object of this class is equal if they have equal values of "filterId" property.
 */
@interface ASDFilterMetadata : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

/**
 Initializing using Database result object.
 */
- (id)initFromDbResult:(FMResultSet *)result;

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

@property (nonatomic) NSNumber *filterId;
@property (nonatomic) NSDate   *updateDate;
@property (nonatomic) NSString *updateDateString;
@property (nonatomic) NSDate   *checkDate;
@property (nonatomic) NSString *checkDateString;
@property (nonatomic) NSString *version;
@property (nonatomic) NSNumber *enabled;
@property (nonatomic) NSNumber *editable;
@property (nonatomic) NSNumber *removable;
@property (nonatomic) NSNumber *displayNumber;
@property (nonatomic) NSNumber *groupId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *descr;
@property (nonatomic) NSString *homepage;
@property (nonatomic) NSNumber *expires;
@property (nonatomic) NSString *subscriptionUrl;
@property (nonatomic) NSNumber *rulesCount;

/// List of NSString objects
/// that contains two-letter codes of languages, where this filter fits.
@property (nonatomic) NSArray *langs;

/// Dictionary contains filter localizations,
/// where key is NSString that contains language code,
/// and value is AASDFilterLocalization object.
@property (nonatomic) NSDictionary *localizations;

/**
    Returns localization for string properties of receiver. 
    Method tries to obtain localization for current locale, 
    if failure, tries to obtain default locale (en). 
    If failure, returns default values. 
 */
- (ASDFilterLocalization *)localization;

@end
