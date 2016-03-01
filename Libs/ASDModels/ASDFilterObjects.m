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
#import "ASDFilterObjects.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "ADomain/ADomain.h"
#import "vendors/fmdb/FMResultSet.h"
#import "ASConstants.h"




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

@end





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
        _localizations = @{};
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

    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

- (ASDFilterGroupLocalization *)localization{
    
    ASDFilterGroupLocalization *localization = _localizations[[ADLocales lang]];
    if (!localization)
        localization = _localizations[ADL_DEFAULT_LANG];
    
    if (!localization) {

        localization = [ASDFilterGroupLocalization new];
        localization.name = _name;
    }
    
    return localization;
}

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
        _rulesCount = nil;
        _langs = @[];
        _localizations = @{};
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

- (ASDFilterLocalization *)localization{

    ASDFilterLocalization *localization = _localizations[[ADLocales lang]];
    if (!localization)
        localization = _localizations[ADL_DEFAULT_LANG];
    
    if (!localization) {
        localization = [ASDFilterLocalization new];
        localization.name = _name;
        localization.descr = _descr;
    }
    
    return localization;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[filterId=%@, enabled=%@, updateDate=%@, version=%@, displayNumber=%@, groupId=%@, name=%@, description=%@, homepage=%@, expires=%@, langs=%@, localizations=%@]", self.filterId, ([self.enabled boolValue] ? @"YES" : @"NO"), self.updateDate, self.version, self.displayNumber, self.groupId, self.name, self.descr, self.homepage, self.expires, self.langs, self.localizations];
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
#pragma mark Supporting set object from dictionary methods
/////////////////////////////////////////////////////////////////////////

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    //Do nothing
    // this is prevents raising exception when key is invalid.
    
    DDLogDebug(@"(ASDFilterMetadata) Can't set undefine key \"%@\" to value: %@", key, value);
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
        _ruleText = NSLocalizedString(@"!------- Enter a rule here.. ---------!", @"Create empty rule - ASDatabaseObjects");
        _isEnabled = @(0);
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[filterId=%lu, ruleId=%lu, ruleText=\"%@\", enabled=%@]", (unsigned long)[self.filterId unsignedIntegerValue], [self.ruleId unsignedIntegerValue], self.ruleText, ([self.isEnabled boolValue] ? @"YES" : @"NO")];
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

@end
