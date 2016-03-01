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
#import "ABECFilterParsers.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACIO.h"

/////////////////////////////////////////////////////////////////////
#pragma mark -  XML Parsers implementation
/////////////////////////////////////////////////////////////////////

@implementation XMLParser

- (BOOL)parseWithData:(NSData *)data{
    
    // parse response data
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    [parser setDelegate:self];
    
    return [parser parse];
}

@end

@implementation XMLVersionParser{
    
    NSMutableArray *versionList;
    BOOL accumulatingParsedCharacterData;
    NSMutableString *currentParsedCharacterData;
    ASDFilterMetadata *currentFilterVersion;
}


- (id)init{
    
    self = [super init];
    if (self) {
        
        versionList = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray *)versionList{
    
    return versionList;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"filter-version"]) {
        
        currentFilterVersion = [ASDFilterMetadata new];
    }
    else if ([elementName isEqualToString:@"filter-id"]
             || [elementName isEqualToString:@"time-updated"]
             || [elementName isEqualToString:@"version"]) {
        
        accumulatingParsedCharacterData = YES;
        // The mutable string needs to be reset to empty.
        currentParsedCharacterData = [@"" mutableCopy];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"filter-id"])
        currentFilterVersion.filterId = @([currentParsedCharacterData integerValue]);
    
    else if ([elementName isEqualToString:@"time-updated"]){
        
        currentFilterVersion.updateDateString = currentParsedCharacterData;
        currentFilterVersion.updateDate = [NSDate dateWithISO8601String:currentParsedCharacterData];
    }
    else if ([elementName isEqualToString:@"version"])
        currentFilterVersion.version = currentParsedCharacterData;
    
    else if ([elementName isEqualToString:@"filter-version"]){
        
        // last_check_time creating
        currentFilterVersion.checkDate = [NSDate date];
        currentFilterVersion.checkDateString = [[NSDate date] iso8601String];
        //--
        [versionList addObject:currentFilterVersion];
    }
    
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;
}

/**
 This method is called by the parser when it find parsed character data ("PCDATA") in an element. The parser is not guaranteed to deliver all of the parsed character data for an element in a single invocation, so it is necessary to accumulate character data until the end of the element is reached.
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        //
        [currentParsedCharacterData appendString:string];
    }
}

/**
 An error occurred while parsing the sourceItem data, pass the error to the main thread for handling.
 (Note: don't report an error if we aborted the parse due to a max limit of sourceItems.)
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    DDLogError(@"XML Parsing error, when parsing filter-version-list xml:%@", [parseError localizedDescription]);
}

@end


@implementation XMLFilterParser{
    
    NSMutableArray *rules;
    BOOL accumulatingParsedCharacterData;
    NSMutableString *currentParsedCharacterData;
    ASDFilter *currentFilter;
    NSUInteger ruleCounter;
}

- (id)init{
    
    self = [super init];
    if (self) {
        
        ruleCounter = 0;
    }
    return self;
}

@synthesize filterId;

- (ASDFilter *)filter{
    
    return currentFilter;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"filter"]) {
        
        currentFilter = [ASDFilter new];
        rules = [NSMutableArray array];
        
        currentFilter.filterId = self.filterId;
        currentFilter.name  = attributeDict[@"name-en"];
        currentFilter.version  = attributeDict[@"version"];
        currentFilter.updateDateString = attributeDict[@"time-updated"];
        currentFilter.updateDate  = [NSDate dateWithISO8601String:currentFilter.updateDateString];
    }
    else if ([elementName isEqualToString:@"rule"]){
        
        accumulatingParsedCharacterData = YES;
        // The mutable string needs to be reset to empty.
        currentParsedCharacterData = [@"" mutableCopy];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"rule"]){
        
        ASDFilterRule *rule = [ASDFilterRule new];
        rule.filterId = currentFilter.filterId;
        rule.ruleId = @(++ruleCounter);
        rule.ruleText = currentParsedCharacterData;
        rule.isEnabled = @(1);
        [rules addObject:rule];
    }
    
    else if ([elementName isEqualToString:@"filter"])
        currentFilter.rules = rules;
    
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;
}

/**
 This method is called by the parser when it find parsed character data ("PCDATA") in an element. The parser is not guaranteed to deliver all of the parsed character data for an element in a single invocation, so it is necessary to accumulate character data until the end of the element is reached.
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        //
        [currentParsedCharacterData appendString:string];
    }
}

/**
 An error occurred while parsing the sourceItem data, pass the error to the main thread for handling.
 (Note: don't report an error if we aborted the parse due to a max limit of sourceItems.)
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    DDLogError(@"XML Parsing error, when parsing filter xml:%@", [parseError localizedDescription]);
}

@end

@implementation XMLMetadataParser{
    
    NSMutableArray *metadataList;
    BOOL accumulatingParsedCharacterData;
    NSMutableString *currentParsedCharacterData;
    ASDFilterMetadata *currentFilterVersion;
    ASDFilterLocalization *currentLocalization;
    NSMutableArray *currentLangs;
    NSMutableDictionary *currentLocalizations;
}


- (id)init{
    
    self = [super init];
    if (self) {
        
        metadataList = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray *)metadataList{
    
    return metadataList;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    // base ------------
    if ([elementName isEqualToString:@"filter"]) {
        
        currentFilterVersion = [ASDFilterMetadata new];
    }
    else if ([elementName isEqualToString:@"filterId"]
             || [elementName isEqualToString:@"name"]
             || [elementName isEqualToString:@"groupId"]
             || [elementName isEqualToString:@"homepage"]
             || [elementName isEqualToString:@"version"]
             || [elementName isEqualToString:@"timeUpdated"]
             || [elementName isEqualToString:@"displayNumber"]
             || [elementName isEqualToString:@"expires"]
             || [elementName isEqualToString:@"description"]) {
        
        accumulatingParsedCharacterData = YES;
        // The mutable string needs to be reset to empty.
        currentParsedCharacterData = [@"" mutableCopy];
    }
    
    // languages ---------
    else if ([elementName isEqualToString:@"languages"]){
        
        currentLangs = [NSMutableArray array];
    }
    else if ([elementName isEqualToString:@"language"]){
        
        accumulatingParsedCharacterData = YES;
        // The mutable string needs to be reset to empty.
        currentParsedCharacterData = [@"" mutableCopy];
    }
    
    // localizations -------------
    else if ([elementName isEqualToString:@"i18n"]){
        
        currentLocalizations = [NSMutableDictionary dictionary];
    }
    else if ([elementName isEqualToString:@"localization"]){
        
        currentLocalization = [ASDFilterLocalization new];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"filterId"])
        currentFilterVersion.filterId = @([currentParsedCharacterData integerValue]);
    
    else if ([elementName isEqualToString:@"name"]){
        
        if (currentLocalization)
            currentLocalization.name = currentParsedCharacterData;
        else
            currentFilterVersion.name = currentParsedCharacterData;
    }
    
    else if ([elementName isEqualToString:@"homepage"])
        currentFilterVersion.homepage = currentParsedCharacterData;
    
    else if ([elementName isEqualToString:@"version"])
        currentFilterVersion.version = currentParsedCharacterData;
    
    else if ([elementName isEqualToString:@"groupId"])
        currentFilterVersion.groupId = @([currentParsedCharacterData integerValue]);
    
    else if ([elementName isEqualToString:@"displayNumber"])
        currentFilterVersion.displayNumber = @([currentParsedCharacterData integerValue]);
    
    else if ([elementName isEqualToString:@"expires"])
        currentFilterVersion.expires = @([currentParsedCharacterData integerValue]);
    
    else if ([elementName isEqualToString:@"timeUpdated"]){
        
        currentFilterVersion.updateDateString = currentParsedCharacterData;
        currentFilterVersion.updateDate = [NSDate dateWithISO8601String:currentParsedCharacterData];
    }
    
    else if ([elementName isEqualToString:@"description"]){
        
        if (currentLocalization)
            currentLocalization.descr = currentParsedCharacterData;
        else
            currentFilterVersion.descr = currentParsedCharacterData;
    }
    
    else if ([elementName isEqualToString:@"language"]){
        
        if (currentLocalization)
            currentLocalization.lang = currentParsedCharacterData;
        else
            [currentLangs addObject:currentParsedCharacterData];
    }
    
    // languages ---------
    else if ([elementName isEqualToString:@"languages"]){
        
        currentFilterVersion.langs = currentLangs;
        currentLangs = nil;
    }
    
    // localizations ---------
    else if ([elementName isEqualToString:@"localization"]){
        
        currentLocalization.filterId = [currentFilterVersion.filterId copy];
        [currentLocalizations setObject:currentLocalization forKey:currentLocalization.lang];
        currentLocalization = nil;
    }
    else if ([elementName isEqualToString:@"i18n"]){
        
        currentFilterVersion.localizations = currentLocalizations;
        currentLocalizations = nil;
    }
    
    // base ------------------
    else if ([elementName isEqualToString:@"filter"]){
        
        // last_check_time creating
        currentFilterVersion.checkDate = [NSDate date];
        currentFilterVersion.checkDateString = [[NSDate date] iso8601String];
        //--
        [metadataList addObject:currentFilterVersion];
    }
    
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;
}

/**
 This method is called by the parser when it find parsed character data ("PCDATA") in an element. The parser is not guaranteed to deliver all of the parsed character data for an element in a single invocation, so it is necessary to accumulate character data until the end of the element is reached.
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        //
        [currentParsedCharacterData appendString:string];
    }
}

/**
 An error occurred while parsing the sourceItem data, pass the error to the main thread for handling.
 (Note: don't report an error if we aborted the parse due to a max limit of sourceItems.)
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    DDLogError(@"XML Parsing error, when parsing filters-list xml:%@", [parseError localizedDescription]);
}

@end


@implementation XMLGroupParser{
    
    NSMutableArray *groupList;
    BOOL accumulatingParsedCharacterData;
    NSMutableString *currentParsedCharacterData;
    ASDFilterGroup *currentGroup;
    ASDFilterGroupLocalization *currentLocalization;
    NSMutableDictionary *currentLocalizations;
}


- (id)init{
    
    self = [super init];
    if (self) {
        
        groupList = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray *)groupList{
    
    return groupList;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    // base ------------
    if ([elementName isEqualToString:@"group"]) {
        
        currentGroup = [ASDFilterGroup new];
    }
    else if ([elementName isEqualToString:@"groupId"]
             || [elementName isEqualToString:@"groupName"]
             || [elementName isEqualToString:@"language"]
             || [elementName isEqualToString:@"displayNumber"]) {
        
        accumulatingParsedCharacterData = YES;
        // The mutable string needs to be reset to empty.
        currentParsedCharacterData = [@"" mutableCopy];
    }
    // localizations -------------
    else if ([elementName isEqualToString:@"i18n"]){
        
        currentLocalizations = [NSMutableDictionary dictionary];
    }
    else if ([elementName isEqualToString:@"localization"]){
        
        currentLocalization = [ASDFilterGroupLocalization new];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"groupId"])
        currentGroup.groupId = @([currentParsedCharacterData integerValue]);
    
    else if ([elementName isEqualToString:@"groupName"]){
        
        if (currentLocalization)
            currentLocalization.name = currentParsedCharacterData;
        else
            currentGroup.name = currentParsedCharacterData;
    }
    
    else if ([elementName isEqualToString:@"language"]){
        
        if (currentLocalization)
            currentLocalization.lang = currentParsedCharacterData;
    }
    // localizations ---------
    else if ([elementName isEqualToString:@"localization"]){
        
        currentLocalization.groupId = [currentGroup.groupId copy];
        [currentLocalizations setObject:currentLocalization forKey:currentLocalization.lang];
        currentLocalization = nil;
    }
    else if ([elementName isEqualToString:@"i18n"]){
        
        currentGroup.localizations = currentLocalizations;
        currentLocalizations = nil;
    }
    
    // base ------------------
    else if ([elementName isEqualToString:@"group"]){
        
        [groupList addObject:currentGroup];
    }
    
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;
}

/**
 This method is called by the parser when it find parsed character data ("PCDATA") in an element. The parser is not guaranteed to deliver all of the parsed character data for an element in a single invocation, so it is necessary to accumulate character data until the end of the element is reached.
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        //
        [currentParsedCharacterData appendString:string];
    }
}

/**
 An error occurred while parsing the sourceItem data, pass the error to the main thread for handling.
 (Note: don't report an error if we aborted the parse due to a max limit of sourceItems.)
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    DDLogError(@"XML Parsing error, when parsing groups-list xml:%@", [parseError localizedDescription]);
}

@end

/////////////////////////////////////////////////////////////////////
#pragma mark -  JSON Parsers implementation
/////////////////////////////////////////////////////////////////////

@interface ABECFilterMetadata : ASDFilterMetadata
@end
@implementation ABECFilterMetadata

#pragma mark Supporting set object from dictionary

- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"timeUpdated"]) {
        self.updateDate = [NSDate
                           dateWithTimeIntervalSince1970:([value doubleValue] / 1000)];
        self.updateDateString = [self.updateDate iso8601String];

        // last_check_time creating
        self.checkDate = [NSDate date];
        self.checkDateString = [[NSDate date] iso8601String];
        //--

    }
    else if ([key isEqualToString:@"description"]){
        
        self.descr = value;
    }
    else if ([key isEqualToString:@"languages"]){
        
        self.langs = value[@"languages"];
    }
    else if ([key isEqualToString:@"localizations"]){
        
        NSMutableDictionary *localizations = [NSMutableDictionary dictionary];
        
        for (NSDictionary *item in value[@"localizations"]) {
            NSString *lang = item[@"languageCode"];
            if (lang) {
                localizations[lang] = [self localizationFromJSONDict:item];
            }
        }
        
        self.localizations = localizations;
    }
    else
    [super setValue:value forKey:key];
}

- (ASDFilterLocalization *)localizationFromJSONDict:(NSDictionary *)dict{
    
    ASDFilterLocalization *localization = [ASDFilterLocalization new];
    
    localization.filterId = self.filterId;
    localization.lang = dict[@"languageCode"];
    localization.name = dict[@"name"];
    localization.descr = dict[@"description"];
    
    return localization;
}

@end
@interface ABECFilterGroup : ASDFilterGroup
@end
@implementation ABECFilterGroup

#pragma mark Supporting set object from dictionary

- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"groupName"]) {
        
        self.name = value;
    }
    else if ([key isEqualToString:@"localizations"]){
        
        NSMutableDictionary *localizations = [NSMutableDictionary dictionary];
        
        for (NSDictionary *item in value[@"localizations"]) {
            NSString *lang = item[@"languageCode"];
            if (lang) {
                localizations[lang] = [self localizationFromJSONDict:item];
            }
        }
        
        self.localizations = localizations;
    }
    else
        [super setValue:value forKey:key];
}

- (ASDFilterGroupLocalization *)localizationFromJSONDict:(NSDictionary *)dict{
    
    ASDFilterGroupLocalization *localization = [ASDFilterGroupLocalization new];
    
    localization.groupId = self.groupId;
    localization.lang = dict[@"languageCode"];
    localization.name = dict[@"groupName"];
    
    return localization;
}

@end

@implementation JSONVersionParser{
    
    NSMutableArray *versionList;
}


- (id)init{
    
    self = [super init];
    if (self) {
        
        versionList = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray *)versionList{
    
    return versionList;
}

- (BOOL)parseWithData:(NSData *)data {

    NSError *error = nil;
    NSArray *versionArray =
        [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    if (error) {

        DDLogError(
            @"(ABECFilterParsers) Error when parsing filter version JSON:\n%@",
            [error localizedDescription]);
        return NO;
    }

    if (!versionArray) {

        return NO;
    }

    if (![versionArray isKindOfClass:[NSArray class]]) {

        DDLogError(@"(ABECFilterParsers) Error when parsing filter version "
                   @"JSON:\nReturned object is not array.");
        return NO;
    }

    for (NSDictionary *item in versionArray) {

        ASDFilterMetadata *meta = [ABECFilterMetadata new];
        [meta setValuesForKeysWithDictionary:item];

        [versionList addObject:meta];
    }

    return YES;
}

@end

@implementation JSONMetadataParser{
    
    NSMutableArray *metadataList;
}


- (id)init{
    
    self = [super init];
    if (self) {
        
        metadataList = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray *)metadataList{
    
    return metadataList;
}

- (BOOL)parseWithData:(NSData *)data{
    
    NSError *error = nil;
    NSDictionary *metaDict =
    [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        
        DDLogError(
                   @"(ABECFilterParsers) Error when parsing filter metadata JSON:\n%@",
                   [error localizedDescription]);
        return NO;
    }
    
    if (!metaDict) {
        
        return NO;
    }
    
    if (!([metaDict isKindOfClass:[NSDictionary class]] && metaDict[@"filterMetadataList"])) {
        
        DDLogError(@"(ABECFilterParsers) Error when parsing filter metadata "
                   @"JSON:\nReturned object is not valid dictionary.");
        return NO;
    }

    for (NSDictionary *item in metaDict[@"filterMetadataList"]) {
        
        ASDFilterMetadata *meta = [ABECFilterMetadata new];
        [meta setValuesForKeysWithDictionary:item];
        
        [metadataList addObject:meta];
    }
    
    return YES;
}

@end

@implementation JSONGroupParser{

    NSMutableArray *groupList;
}


- (id)init{
    
    self = [super init];
    if (self) {
        
        groupList = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray *)groupList{
    
    return groupList;
}

- (BOOL)parseWithData:(NSData *)data{
    NSError *error = nil;
    NSDictionary *groupDict =
    [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        
        DDLogError(
                   @"(ABECFilterParsers) Error when parsing filter group metadata JSON:\n%@",
                   [error localizedDescription]);
        return NO;
    }
    
    if (!groupDict) {
        
        return NO;
    }
    
    if (!([groupDict isKindOfClass:[NSDictionary class]] && groupDict[@"filterGroupMetadataList"])) {
        
        DDLogError(@"(ABECFilterParsers) Error when parsing filter group metadata "
                   @"JSON:\nReturned object is not valid dictionary.");
        return NO;
    }
 
    for (NSDictionary *item in groupDict[@"filterGroupMetadataList"]) {
        
        ASDFilterGroup *group = [ABECFilterGroup new];
        
        [group setValuesForKeysWithDictionary:item];
        
        [groupList addObject:group];
    }
    
    return YES;
}

@end

/////////////////////////////////////////////////////////////////////
#pragma mark -  Plain Text Parsers implementation
/////////////////////////////////////////////////////////////////////

@implementation PlainFilterParser{
    
    ASDFilter *filter;
}

@synthesize filterId;

- (BOOL)parseWithData:(NSData *)data {

    NSMutableArray *rules = [NSMutableArray array];
    NSUInteger ruleCounter = 0;
    filter = [ASDFilter new];
    filter.rules = rules;

    filter.filterId = self.filterId;
    NSInputStream *stream = [NSInputStream inputStreamWithData:data];
    [stream open];

    NSString *line;
    while ((line = [ACIOUtils readLine:(id<ACIOUtilReadProtocol>)stream
                              encoding:NSUTF8StringEncoding])) {

        ASDFilterRule *rule = [ASDFilterRule new];
        rule.filterId = filter.filterId;
        rule.ruleId = @(++ruleCounter);
        rule.ruleText = line;
        rule.isEnabled = @(1);
        [rules addObject:rule];
    }
    [stream close];

    return YES;
}

- (ASDFilter *)filter{

    return filter;
}

@end