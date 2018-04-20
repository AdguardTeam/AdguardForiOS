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

#import "ASDFilterObjects.h"

#ifndef ABECFilterParsers_h
#define ABECFilterParsers_h

/////////////////////////////////////////////////////////////////////
#pragma mark - Backend Responses Parser Protocols
/////////////////////////////////////////////////////////////////////

@protocol ParserProtocol <NSObject>
- (BOOL)parseWithData:(NSData *)data;
@end

@protocol FilterParserProtocol <ParserProtocol>

@property (nonatomic) NSNumber *filterId;
- (ASDFilter *)filter;

@end

@protocol MetadataParserProtocol <ParserProtocol>


/**
 Returs list of the metadata for all filters from input data.
 */
- (NSArray <ASDFilterMetadata *> *)filterMetadataList;
/**
 Returns list of the filter groups.
 */
- (NSArray <ASDFilterGroup *> *)groupList;
@end

@protocol i18nParserProtocol <ParserProtocol>

/**
 Returns filters localizations.
 
 @return i18n object for filters.
 */
- (ASDFiltersI18n *)filtersI18n;
/**
 Returns groups localizations.
 
 @return i18n object for groups.
 */
- (ASDGroupsI18n *)groupsI18n;
@end

/////////////////////////////////////////////////////////////////////
#pragma mark - Backend JSON Response Parsers

@interface JSONMetadataParser : NSObject <MetadataParserProtocol>
@end

@interface JSONI18nParser : NSObject <i18nParserProtocol>
@end

/////////////////////////////////////////////////////////////////////
#pragma mark - Backend Plain Text Response Parsers
/////////////////////////////////////////////////////////////////////

@interface PlainFilterParser : NSObject <FilterParserProtocol>
@end


#endif /* ABECFilterParsers_h */
