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
//#import "ACObject.h"
//#import "ABECConstants.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS
//#import <UIKit/UIKit.h>
#endif


@class ASDFilter, ASDFilterMetadata, ASDFilterGroup, ASDFiltersI18n, ASDGroupsI18n, ABECFilterClientMetadata, ABECFilterClientLocalization, ABECFilterClient;

/////////////////////////////////////////////////////////////////////
#pragma mark - ABECFilterAsyncProtocol


/////////////////////////////////////////////////////////////////////
#pragma mark - ABECFilterClientMetadata

/**
 Metadata representation.
 */
@interface ABECFilterClientMetadata : ACObject

/**
 List of filters metadata.
 */
@property (nonatomic, nullable) NSArray <ASDFilterMetadata *> *filters;
/**
 List of groups metadata.
 */
@property (nonatomic, nullable) NSArray <ASDFilterGroup *> *groups;

/**
 metadata update date
 */
@property (nonatomic, nullable) NSDate* date;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - ABECFilterClientLocalization

/**
 Localizations representation.
 */
@interface ABECFilterClientLocalization : ACObject

/**
 Filters localizations object.
 */
@property (nonatomic, nullable) ASDFiltersI18n *filters;
/**
 Groups localizations object
 */
@property (nonatomic, nullable) ASDGroupsI18n *groups;

/**
 i18n update date
 */
@property (nonatomic, nullable) NSDate* date;

@end
