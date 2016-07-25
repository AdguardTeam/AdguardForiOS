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
#import "AESharedResources.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - APSharedResources Constants

/**
 User Defaults key that define, create log of the DNS requests or not.
 */
extern NSString *APDefaultsDnsLoggingEnabled;


// Commands for controlling "DNS activity log", between tunnel provider extension and host application.
extern NSString *APMDnsLoggingEnabled;
extern NSString *APMDnsLoggingDisabled;
extern NSString *APMDnsLoggingGiveRecords;
extern NSString *APMDnsLoggingClearLog;

/////////////////////////////////////////////////////////////////////
#pragma mark - APSharedResources

/**
     (PRO) Class, which provides exchanging data between app and extension.
 */
@interface APSharedResources : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

@end
