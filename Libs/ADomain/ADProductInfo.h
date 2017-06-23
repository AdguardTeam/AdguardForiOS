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

/////////////////////////////////////////////////////////////////////
#pragma mark -  ADProductInfo
/////////////////////////////////////////////////////////////////////

/// Provides product information
@interface ADProductInfo : NSObject

/// Returns Product Version.
+ (NSString *)version;

/// Returns Product Version with build number. e.g. 1.2.2(88)
+ (NSString *)versionWithBuildNumber;

/// Returns Product Version With Build Number for logs. e.g. 1.2.2.88.DEBUG
+ (NSString *)buildVersion;

/// Returns Localized Product Name.
+ (NSString *)name;

/// Returns string that represents User-Agent HTTP Header.
+ (NSString *)userAgentString;

/// Returns Application ID for local machine.
+ (NSString *)applicationID;

@end
