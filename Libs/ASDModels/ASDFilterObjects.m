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

#import "ASDFilterObjects.h"
#import "ACommons/ACSystem.h"
#import "ADomain/ADomain.h"
#import "vendors/fmdb/FMResultSet.h"
#import "ASConstants.h"


/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilterGroup
/////////////////////////////////////////////////////////////////////

@implementation ASDFilterGroup

- (id)init{
    
    self = [super init];
    if (self) {
        
        _groupId = @(0);
        _name = ASDF_DEFAULT_GROUP_NAME;
        _displayNumber = @(NSIntegerMax);
    }
    return self;
}

- (id)initFromDbResult:(FMResultSet *)result{
    
    self = [self init];
    if (self){
        
        id value;
        
        value = result[@"group_id"];
        if (value)
            _groupId = value;
        
        value = result[@"name"];
        if (value)
            _name = value;
        
        value = result[@"display_number"];
        if (value)
            _displayNumber = value;
        
        value = result[@"is_enabled"];
        if (value && value != NSNull.null)
            _enabled = value;
        
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (NSString *)description
{
    return [NSString stringWithFormat:@"[groupId=%@, name=%@, displayNumber=%@]", self.groupId, self.name, self.displayNumber];
}

- (BOOL)isEqual:(id)object{
    
    if (object == self)
        return YES;
    if ([object isKindOfClass:[self class]])
        return [self.groupId isEqual:[object groupId]];
    
    else
        return NO;
}

@end


/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilterGroupLocalization
/////////////////////////////////////////////////////////////////////

@implementation ASDFilterGroupLocalization

- (id)init{
    
    self = [super init];
    if (self) {
        
        _groupId = ASDF_DEFAULT_GROUP_ID;
        _lang = ADL_DEFAULT_LANG;
        _name = ASDF_DEFAULT_GROUP_NAME;
    }
    return self;
}

- (id)initFromDbResult:(FMResultSet *)result{
    
    self = [self init];
    if (self){
        
        id value;
        
        value = result[@"group_id"];
        if (value)
            _groupId = value;
        
        value = result[@"lang"];
        if (value)
            _lang = value;
        
        value = result[@"name"];
        if (value)
            _name = value;
    }
    
    return self;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"Group localization - groupId: %@, lang: %@, name: %@", self.groupId, self.lang, self.name];
}

@end



/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDGroupsI18n

@implementation ASDGroupsI18n {
    
    NSMutableDictionary *_i18nDictionary;
}

- (id)initWithLocalizations:(NSArray <ASDFilterGroupLocalization *> *)localizations {
    
    if (localizations == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _localizations = localizations;
        
        _i18nDictionary = [NSMutableDictionary dictionary];
        for (ASDFilterGroupLocalization *item in localizations) {
            
            if (item.groupId && item.lang) {
                NSMutableDictionary *filterDict = _i18nDictionary[item.groupId];
                if (!filterDict) {
                    _i18nDictionary[item.groupId] = filterDict = [NSMutableDictionary dictionary];
                }
                filterDict[item.lang] = item;
            }
        }
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary <NSNumber *, NSDictionary <NSString *, ASDFilterGroupLocalization *> *> *)dictionary {
    
    if (dictionary == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        @autoreleasepool {
            
            NSMutableArray *localizations = [NSMutableArray array];
            _i18nDictionary = [dictionary mutableCopy];
            [_i18nDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [localizations addObjectsFromArray:[obj allValues]];
            }];
            _localizations = [localizations copy];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        _i18nDictionary = [aDecoder decodeObjectForKey:@"i18nDictionary"];
        _localizations = [aDecoder decodeObjectForKey:@"localizations"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_i18nDictionary forKey:@"i18nDictionary"];
    [aCoder encodeObject:_localizations forKey:@"localizations"];
}

- (ASDFilterGroupLocalization *)localizationForGroup:(ASDFilterGroup *)group{
    
    /*
     locale.getLanguage() + "-" + locale.getCountry()
     locale.getLanguage()
     */
    
    if (!group) {
        return nil;
    }
    
    NSString *langCode = [ADLocales canonicalLanguageIdentifier];
    
    ASDFilterGroupLocalization *localization = _i18nDictionary[group.groupId][langCode];
    
    if (!localization) {
        localization = _i18nDictionary[group.groupId][[ADLocales lang]];
    }
    
    if (!localization)
        localization = _i18nDictionary[group.groupId][ADL_DEFAULT_LANG];
    
    if (!localization) {
        localization = [ASDFilterGroupLocalization new];
        localization.groupId = group.groupId;
        localization.lang = ADL_DEFAULT_LANG;
        localization.name = group.name;
    }
    
    return localization;
    
}

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - ASDFilterTagMeta
/////////////////////////////////////////////////////////////////////

@implementation ASDFilterTagMeta

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.type = ((NSNumber*)[aDecoder decodeObjectForKey:@"tagType"]).intValue;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:@(_type) forKey:@"tagType"];
}

@end


/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilterMetadata
/////////////////////////////////////////////////////////////////////

@implementation ASDFilterMetadata

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)init{
    
    self = [super init];
    if (self) {
        
        _version = ASDF_DEFAULT_FILTER_VERSION;
        _filterId = @(ASDF_USER_FILTER_ID);
        _updateDate = [NSDate distantPast];
        _updateDateString = [_updateDate iso8601String];
        _checkDate = [NSDate distantPast];
        _checkDateString = [_checkDate iso8601String];
        _enabled = @(1);
        _editable = @(0);
        _removable = @(1);
        _displayNumber = @(NSIntegerMax);
        _groupId = ASDF_DEFAULT_GROUP_ID;
        _name = @"";
        _descr = @"";
        _homepage = @"";
        _expires = @(AS_CHECK_FILTERS_UPDATES_DEFAULT_PERIOD);
        _subscriptionUrl = @"";
        _langs = @[];
    }
    return self;
}

- (void)setEnabled:(NSNumber *)enabled {
    _enabled = enabled;
}

- (id)initFromDbResult:(FMResultSet *)result{
    
    self = [self init];
    if (self){
        
        id value;
        
        value = result[@"filter_id"];
        if (value)
            _filterId = value;
        
        value = result[@"version"];
        if (value)
            _version = value;
        
        value = result[@"last_check_time"];
        if (![NSString isNullOrEmpty:value]){
            
            _checkDateString = value;
            _checkDate = [NSDate dateWithSQliteString:_checkDateString];
        }
        
        value = result[@"last_update_time"];
        if (![NSString isNullOrEmpty:value]){
            
            _updateDateString = value;
            _updateDate = [NSDate dateWithSQliteString:_updateDateString];
        }
        
        value = result[@"is_enabled"];
        if (value)
            _enabled = value;
        
        value = result[@"editable"];
        if (value)
            _editable = value;
        
        value = result[@"removable"];
        if (value)
            _removable = value;
        
        value = result[@"display_number"];
        if (value)
            _displayNumber = value;
        
        value = result[@"expires"];
        if (value)
            _expires = value;
        
        value = result[@"group_id"];
        if (value)
            _groupId = value;
        
        value = result[@"name"];
        if (value)
            _name = value;
        
        value = result[@"description"];
        if (value)
            _descr = value;
        
        value = result[@"homepage"];
        if (value)
            _homepage = value;
        
        value = result[@"subscriptionUrl"];
        if (value)
            _subscriptionUrl = value;
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

- (NSString *)description
{
    return [NSString stringWithFormat:@"[filterId=%@, enabled=%@, updateDate=%@, version=%@, displayNumber=%@, groupId=%@, name=%@, description=%@, homepage=%@, expires=%@, langs=%@, tags=%@]", self.filterId, ([self.enabled boolValue] ? @"YES" : @"NO"), self.updateDate, self.version, self.displayNumber, self.groupId, self.name, self.descr, self.homepage, self.expires, self.langs, self.tags];
}

// Equal by key value - "filterId"
- (BOOL)isEqual:(id)object
{
    if (self == object) {
        
        return YES;
    }
    
    if ([object isKindOfClass:[ASDFilterMetadata class]]) {
        
        return [self.filterId isEqualToNumber:[(ASDFilterMetadata *)object filterId]];
    }
    
    return [super isEqual:object];
}

- (NSUInteger)hash{
    
    return [self.filterId unsignedIntegerValue];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Supporting set/get object from dictionary methods
/////////////////////////////////////////////////////////////////////////

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    //Do nothing
    // this is prevents raising exception when key is invalid.
    
    DDLogDebug(@"(ASDFilterMetadata) Can't set undefine key \"%@\" to value: %@", key, value);
}

- (id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
    // this is prevents raising exception when key is invalid.
    
    DDLogDebug(@"(ASDFilterMetadata) Can't get undefine key \"%@\"", key);
    
}


@end

/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilterLocalization
/////////////////////////////////////////////////////////////////////

@implementation ASDFilterLocalization

- (id)init{
    
    self = [super init];
    if (self) {
        
        _filterId = @(ASDF_USER_FILTER_ID);
        _lang = ADL_DEFAULT_LANG;
        _name = @"";
        _descr = @"";
    }
    return self;
}

- (id)initFromDbResult:(FMResultSet *)result{
    
    self = [self init];
    if (self){
        
        id value;
        
        value = result[@"filter_id"];
        if (value)
            _filterId = value;
        
        value = result[@"lang"];
        if (value)
            _lang = value;
        
        value = result[@"name"];
        if (value)
            _name = value;
        
        value = result[@"description"];
        if (value)
            _descr = value;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[filterId=%@, lang=%@, name=%@, description=%@]", self.filterId, self.lang, self.name, self.descr];
}

@end






/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFiltersI18n


@implementation ASDFiltersI18n {
    
    NSMutableDictionary *_i18nDictionary;
}

- (id)initWithLocalizations:(NSArray <ASDFilterLocalization *> *)localizations {
    
    if (localizations == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _localizations = localizations;
        
        _i18nDictionary = [NSMutableDictionary dictionary];
        for (ASDFilterLocalization *item in localizations) {
            
            if (item.filterId && item.lang) {
                NSMutableDictionary *filterDict = _i18nDictionary[item.filterId];
                if (!filterDict) {
                    _i18nDictionary[item.filterId] = filterDict = [NSMutableDictionary dictionary];
                }
                filterDict[item.lang] = item;
            }
        }
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary <NSNumber *, NSDictionary <NSString *, ASDFilterLocalization *> *> *)dictionary {
    
    if (dictionary == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        @autoreleasepool {
            
            NSMutableArray *localizations = [NSMutableArray array];
            _i18nDictionary = [dictionary mutableCopy];
            [_i18nDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [localizations addObjectsFromArray:[obj allValues]];
            }];
            _localizations = [localizations copy];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        _i18nDictionary = [aDecoder decodeObjectForKey:@"i18nDictionary"];
        _localizations = [aDecoder decodeObjectForKey:@"localizations"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_i18nDictionary forKey:@"i18nDictionary"];
    [aCoder encodeObject:_localizations forKey:@"localizations"];
}

- (ASDFilterLocalization *)localizationForFilter:(ASDFilterMetadata *)filterMetadata{
    
    if (!filterMetadata) {
        return nil;
    }
    
    NSString *langCode = [ADLocales canonicalLanguageIdentifier];
    
    ASDFilterLocalization *localization = _i18nDictionary[filterMetadata.filterId][langCode];
    
    if (!localization) {
        localization = _i18nDictionary[filterMetadata.filterId][[ADLocales lang]];
    }
    
    if (!localization)
        localization = _i18nDictionary[filterMetadata.filterId][ADL_DEFAULT_LANG];
    
    if (!localization) {
        localization = [ASDFilterLocalization new];
        localization.filterId = filterMetadata.filterId;
        localization.lang = ADL_DEFAULT_LANG;
        localization.name = filterMetadata.name;
        localization.descr = filterMetadata.descr;
    }
    
    return localization;
    
}

@end





/////////////////////////////////////////////////////////////////////
#pragma mark -  ABECFilter
/////////////////////////////////////////////////////////////////////

@implementation ASDFilter

- (id)init{
    
    self = [super init];
    if (self) {
        
        _filterId = @(ASDF_USER_FILTER_ID);
        _name = @"";
        _version = ASDF_DEFAULT_FILTER_VERSION;
        _updateDate = [NSDate distantPast];
        _updateDateString = [_updateDate iso8601String];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[filterId=%@, name=%@, updateDate=%@, version=%@, rules count=%lu]", self.filterId, self.name, self.updateDate, self.version, (unsigned long)self.rules.count];
}

@end

/////////////////////////////////////////////////////////////////////
#pragma mark -  ASDFilterRule
/////////////////////////////////////////////////////////////////////

@implementation ASDFilterRule

- (id)init{
    
    self = [super init];
    if (self){
        
        _filterId = @(ASDF_USER_FILTER_ID);
        _ruleId = @(0);
        _ruleText = @"";
        _isEnabled = @(0);
    }
    
    return self;
}

- (id)initWithText:(NSString *)ruleText enabled:(BOOL)enabled{
    
    self = [super init];
    if (self){
        
        _filterId = @(ASDF_USER_FILTER_ID);
        _ruleId = @(0);
        _ruleText = ruleText ?: [NSString string];
        _isEnabled = @(enabled);
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[filterId=%lu, ruleId=%lu, ruleText=\"%@\", enabled=%@]", [self.filterId unsignedIntegerValue], [self.ruleId unsignedIntegerValue], self.ruleText, ([self.isEnabled boolValue] ? @"YES" : @"NO")];
}

- (id)initFromDbResult:(FMResultSet *)result{
    
    self = [self init];
    if (self){
        
        id value;
        
        value = result[@"filter_id"];
        if (value)
            _filterId = value;
        
        value = result[@"rule_id"];
        if (value)
            _ruleId = value;
        
        value = result[@"rule_text"];
        if (value)
            _ruleText = value;
        
        value = result[@"is_enabled"];
        if (value)
            _isEnabled = value;
        
    }
    
    return self;
}

- (BOOL)isEqualRuleText:(id)object
{
    if (self == object) {
        
        return YES;
    }
    
    if ([object isKindOfClass:[ASDFilterRule class]]) {
        
        ASDFilterRule *rule = (ASDFilterRule *)object;
        return (self.hash == rule.hash
                && [self.ruleText isEqualToString:rule.ruleText]);
    }
    
    return NO;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        
        return YES;
    }
    
    if ([object isKindOfClass:[ASDFilterRule class]]) {
        
        ASDFilterRule *rule = (ASDFilterRule *)object;
        return ([self.filterId isEqualToNumber:rule.filterId]
                && [self.ruleId isEqualToNumber:rule.ruleId]
                && [self.ruleText isEqualToString:rule.ruleText]);
    }
    
    return [super isEqual:object];
}

- (NSUInteger)hash{
    
    return [self.ruleText hash];
}

@end
