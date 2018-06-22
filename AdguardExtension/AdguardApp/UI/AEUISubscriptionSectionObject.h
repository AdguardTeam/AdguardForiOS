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
#import <UIKit/UIKit.h>
#import "ASDFilterObjects.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUISubscriptionSectionFilterMetadata
/////////////////////////////////////////////////////////////////////

@interface AEUISubscriptionSectionFilterMetadata : ASDFilterMetadata

+ (AEUISubscriptionSectionFilterMetadata *)copyFromMetadata:(ASDFilterMetadata *)filterMetadata;

@property NSNumber *editedEnabled;
/**
 Localized object name.
 */
@property NSString *i18nName;
/**
 Localized object description if exists.
 */
@property NSString *i18nDescription;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUISubscriptionObject
/////////////////////////////////////////////////////////////////////


/**
    Class represents sections with rows for table, which displays list of ad-block filters.
 */
@interface AEUISubscriptionSectionObject : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

/**
 Method loads filters asynchronously from backend server and calls completion block when done.
 As parameter in completionBlock will transfer array of the AEUISubscriptionSectionObject objects.
 If error occured, filters parameter of the completionBlock will be nil.
 
 @param refresh  Makes attempting to download metadata from the backend forced. 
 */
+ (void)load:(BOOL)refresh completionBlock:(void (^)(NSArray *subscriptionSectionObjects))completionBlock;

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

@property NSString *name;

/**
 Contains list of the AEUISubscriptionSectionFilterMetadata objects.
 */
@property NSArray *filters;

@end
