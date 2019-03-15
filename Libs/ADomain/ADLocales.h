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
#pragma mark -  ADLocales Constants
/////////////////////////////////////////////////////////////////////

#define ADL_DEFAULT_LANG            @"en"
#define ADL_DEFAULT_REGION          @"us"

#define ADL_FILTER_NAME             @"name"
#define ADL_FILTER_DESCRIPTION      @"description"
#define ADL_FILTER_GROUPNAME        @"groupName"

/////////////////////////////////////////////////////////////////////
#pragma mark -  ADLocales
/////////////////////////////////////////////////////////////////////


@interface ADLocales : NSObject

/// Get 2 letters identifier of current application Language
+ (NSString *)lang;

/// Get 2 letters identifier of current application Region (Country Code)
+ (NSString *)region;

/**
 returns canonical language identifier for current locale
 */
+ (NSString *)canonicalLanguageIdentifier;

/**
    Obtain localized description of AdBlocker (Antibanner) filters.
    @return Array of NSDictionary objects that contains two keys: ADL_FILTER_NAME, ADL_FILTER_DESCRIPTION.
    Index of array element will correspond filter ID.
 */
+ (NSArray *)filtersDescription;

/**
    returns localizations dictionary for filter with filterId
 */
+ (NSDictionary *)localizationsOfFilter:(NSUInteger)filterId;

/**
 Obtain localized description of processes for filtering.
 
 @return    Returns dictionary, where key is bundle id of the application,
            and value contains description of process.
 */
+ (NSDictionary *)defaultProcessesDescription;

/**
 Obtain localized feedback message subjects.
 */
+ (NSArray *)localizedFeedbackSubjects;

@end
