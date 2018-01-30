/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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
#import "ACommons/ACLang.h"

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
/// Simplified domain names filter
#define ASDF_SIMPL_DOMAINNAMES_FILTER_ID 15
/// Mobile Ads filter
#define MOBILE_ADS_FILTER_ID 11

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

/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilterGroup
/////////////////////////////////////////////////////////////////////

/**
 Filter representation in filter group context.
 */
@interface ASDFilterGroup : ACObject

- (id)initFromDbResult:(FMResultSet *)result;

@property (nonatomic) NSNumber *groupId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *displayNumber;

@end




/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilterGroupLocalization
/////////////////////////////////////////////////////////////////////

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
#pragma mark -  ASDGroupsI18n

/**
 Service class for holding and operating with group localizations.
 */
@interface ASDGroupsI18n : NSObject

/**
 Initializes object with appropriate localizations data.
 
 @return Returns receiver, or nil if errors occurs.
 */
- (id)initWithLocalizations:(NSArray <ASDFilterGroupLocalization *> *)localizations;
/**
 Initializes object with appropriate dictionary data
 
 @return Returns receiver, or nil if errors occurs.
 */
- (id)initWithDictionary:(NSDictionary <NSNumber *, NSDictionary <NSString *, ASDFilterGroupLocalization *> *> *)dictionary;

@property (nonatomic, readonly) NSArray <ASDFilterGroupLocalization *> *localizations;

/**
 Returns localization for current system language.
 
 @param group Group metadata.
 @return localization object or nil if error occurs.
 If i18n will not found returns description from group object.
 */
- (ASDFilterGroupLocalization *)localizationForGroup:(ASDFilterGroup *)group;

@end


/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilterMetadata
/////////////////////////////////////////////////////////////////////

/**
 Filter representation in metadata context.
 Two object of this class is equal if they have equal values of "filterId" property.
 */
@interface ASDFilterMetadata : ACObject

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

@end

/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilterLocalization
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
#pragma mark -  ASDFiltersI18n

/**
 Service class for holding and operating with filter localizations.
 */
@interface ASDFiltersI18n : NSObject

/**
 Initializes object with appropriate localizations data.
 
 @return Returns receiver, or nil if errors occurs.
 */
- (id)initWithLocalizations:(NSArray <ASDFilterLocalization *> *)localizations;
/**
 Initializes object with appropriate dictionary data
 
 @return Returns receiver, or nil if errors occurs.
 */
- (id)initWithDictionary:(NSDictionary <NSNumber *, NSDictionary <NSString *, ASDFilterLocalization *> *> *)dictionary;

@property (nonatomic, readonly) NSArray <ASDFilterLocalization *> *localizations;

/**
 Returns localization for current system language.
 
 @param filterMetadata Filter metadata.
 @return localization object or nil if error occurs.
 If i18n will not found returns description from filterMetadata object.
 */
- (ASDFilterLocalization *)localizationForFilter:(ASDFilterMetadata *)filterMetadata;

@end




/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilter
/////////////////////////////////////////////////////////////////////

/**
 Filter representation with rules.
 */
@interface ASDFilter : ACObject

@property (nonatomic) NSNumber *filterId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *version;
@property (nonatomic) NSString *updateDateString;
@property (nonatomic) NSDate *updateDate;

/// Array of ASDFilterRule objects.
@property (nonatomic) NSArray *rules;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilterRule
/////////////////////////////////////////////////////////////////////

/**
 Filter rule representation.
 */
@interface ASDFilterRule : ACObject

/**
 Initializing using Database result object.
 */
- (id)initFromDbResult:(FMResultSet *)result;

/**
 Initializing using parameters.
 
 @param ruleText Text of the rule
 @param enabled isEnabled value
 
 @return Initialized instance.
 If ruleText is nil, then object.ruleText is empty string.
 */
- (id)initWithText:(NSString *)ruleText enabled:(BOOL)enabled;

@property (nonatomic) NSNumber *filterId;
@property (nonatomic) NSNumber *ruleId;
@property (nonatomic) NSString *ruleText;
@property (nonatomic) NSNumber *isEnabled;

/**
 Checks object if it is kind of ASDFilterRule class, 
 and has ruleText is equal receaver ruleText.

 @param object Candidate object
 */
- (BOOL)isEqualRuleText:(id)object;

@end


