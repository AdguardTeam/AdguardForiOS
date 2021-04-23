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

- (nullable id)initFromDbResult:(nonnull FMResultSet *)result;

@property (nonatomic, nonnull) NSNumber *groupId;
@property (nonatomic, nonnull) NSString *name;
@property (nonatomic, nonnull) NSNumber *displayNumber;
@property (nonatomic, nonnull) NSNumber *enabled;

@end




/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilterGroupLocalization
/////////////////////////////////////////////////////////////////////

/**
 Filter representation in filter group localization context.
 */
@interface ASDFilterGroupLocalization : ACObject

- (nullable id)initFromDbResult:(nonnull FMResultSet *)result;

@property (nonatomic, nullable) NSNumber *groupId;
@property (nonatomic, nullable) NSString *lang;
@property (nonatomic, nullable) NSString *name;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDGroupsI18n

/**
 Service class for holding and operating with group localizations.
 */
@interface ASDGroupsI18n : ACObject

/**
 Initializes object with appropriate localizations data.
 
 @return Returns receiver, or nil if errors occurs.
 */
- (nullable id)initWithLocalizations:(nonnull NSArray <ASDFilterGroupLocalization *> *)localizations;
/**
 Initializes object with appropriate dictionary data
 
 @return Returns receiver, or nil if errors occurs.
 */
- (nullable id)initWithDictionary:(nonnull NSDictionary <NSNumber *, NSDictionary <NSString *, ASDFilterGroupLocalization *> *> *)dictionary;

@property (nonatomic, readonly, nullable) NSArray <ASDFilterGroupLocalization *> *localizations;

/**
 Returns localization for current system language.
 
 @param group Group metadata.
 @return localization object or nil if error occurs.
 If i18n will not found returns description from group object.
 */
- (nullable ASDFilterGroupLocalization *)localizationForGroup:(nonnull ASDFilterGroup *)group;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - ASDFilterTagType
/////////////////////////////////////////////////////////////////////

typedef enum : NSUInteger {
    ASDFilterTagTypePurpose,
    ASDFilterTagTypeLang,
    ASDFilterTagTypeRecommended,
    ASDFilterTagTypeReference,
    ASDFilterTagTypePlatform,
    ASDFilterTagTypeProblematic,
    ASDFilterTagTypeObsolete,
    ASDFilterTagTypeIos
} ASDFilterTagType;

/////////////////////////////////////////////////////////////////////
#pragma mark - ASDFilterTagMeta
/////////////////////////////////////////////////////////////////////

@interface ASDFilterTagMeta : ACObject

@property (nonatomic) ASDFilterTagType type;
@property (nonatomic) NSInteger tagId;
@property (nonatomic, nullable) NSString *name;

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
- (nullable id)initFromDbResult:(nonnull FMResultSet *)result;

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

@property (nonatomic, nonnull) NSNumber *filterId;
@property (nonatomic, nullable) NSDate   *updateDate;
@property (nonatomic, nullable) NSString *updateDateString;
@property (nonatomic, nullable) NSDate   *checkDate;
@property (nonatomic, nullable) NSString *checkDateString;
@property (nonatomic, nullable) NSString *version;
@property (nonatomic, nonnull) NSNumber *enabled;
@property (nonatomic, nonnull) NSNumber *editable;
@property (nonatomic, nonnull) NSNumber *removable;
@property (nonatomic, nonnull) NSNumber *displayNumber;
@property (nonatomic, nonnull) NSNumber *groupId;
@property (nonatomic, nonnull) NSString *name;
@property (nonatomic, nullable) NSString *descr;
@property (nonatomic, nullable) NSString *homepage;
@property (nonatomic, nullable) NSNumber *expires;
@property (nonatomic, nonnull) NSString *subscriptionUrl;
@property (nonatomic, nullable) NSString *timeAdded;

/// List of NSString objects
/// that contains two-letter codes of languages, where this filter fits.
@property (nonatomic, nullable) NSArray<NSString*> *langs;

@property (nonatomic, nullable) NSArray<ASDFilterTagMeta*> *tags;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilterLocalization
/////////////////////////////////////////////////////////////////////

/**
 Filter representation in localization context.
 */
@interface ASDFilterLocalization : ACObject

/**
 Initializing using Database result object.
 */
- (nullable id)initFromDbResult:(nonnull FMResultSet *)result;

@property (nonatomic, nonnull) NSNumber *filterId;
@property (nonatomic, nonnull) NSString *lang;
@property (nonatomic, nonnull) NSString *name;
@property (nonatomic, nullable) NSString *descr;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFiltersI18n

/**
 Service class for holding and operating with filter localizations.
 */
@interface ASDFiltersI18n : ACObject

/**
 Initializes object with appropriate localizations data.
 
 @return Returns receiver, or nil if errors occurs.
 */
- (nullable id)initWithLocalizations:(nonnull NSArray <ASDFilterLocalization *> *)localizations;
/**
 Initializes object with appropriate dictionary data
 
 @return Returns receiver, or nil if errors occurs.
 */
- (nullable id)initWithDictionary:(nonnull NSDictionary <NSNumber *, NSDictionary <NSString *, ASDFilterLocalization *> *> *)dictionary;

@property (nonatomic, readonly, nullable) NSArray <ASDFilterLocalization *> *localizations;

/**
 Returns localization for current system language.
 
 @param filterMetadata Filter metadata.
 @return localization object or nil if error occurs.
 If i18n will not found returns description from filterMetadata object.
 */
- (nullable ASDFilterLocalization *)localizationForFilter:(nonnull ASDFilterMetadata *)filterMetadata;

@end




/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilter
/////////////////////////////////////////////////////////////////////

/**
 Filter representation with rules.
 */
@interface ASDFilter : ACObject

@property (nonatomic, nonnull) NSNumber *filterId;
@property (nonatomic, nonnull) NSString *name;
@property (nonatomic, nullable) NSString *version;
@property (nonatomic, nullable) NSString *updateDateString;
@property (nonatomic, nullable) NSDate *updateDate;

/// Array of ASDFilterRule objects.
@property (nonatomic, nullable) NSArray *rules;

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
- (nullable id)initFromDbResult:(nonnull FMResultSet *)result;

/**
 Initializing using parameters.
 
 @param ruleText Text of the rule
 @param enabled isEnabled value
 
 @return Initialized instance.
 If ruleText is nil, then object.ruleText is empty string.
 */
- (nonnull id)initWithText:(nonnull NSString *)ruleText enabled:(BOOL)enabled;

/**
 Initializing using parameters.
 
 @param ruleText Text of the rule
 @param enabled isEnabled value
 @param affinity affinity value
 
 @return Initialized instance.
 If ruleText is nil, then object.ruleText is empty string.
 */
- (nonnull id)initWithText:(nonnull NSString *)ruleText enabled:(BOOL)enabled affinity:(nullable NSNumber *)affinity;

@property (nonatomic, nonnull) NSNumber *filterId;
@property (nonatomic, nonnull) NSNumber *ruleId;
@property (nonatomic, nonnull) NSString *ruleText;
@property (nonatomic, nonnull) NSNumber *isEnabled;
@property (nonatomic, nullable) NSNumber *affinity;

/**
 Checks object if it is kind of ASDFilterRule class, 
 and has ruleText is equal receaver ruleText.

 @param object Candidate object
 */
- (BOOL)isEqualRuleText:(nonnull id)object;

@end



