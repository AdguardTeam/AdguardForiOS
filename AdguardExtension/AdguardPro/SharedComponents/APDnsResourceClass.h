/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2016 Performix LLC. All rights reserved.
 
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

/**
 Class for holding DNS resource class value.
 It main function is return name of the resource class as a description.
 For example: intValue = 1 and [self description] returns @"IN".
 */
@interface APDnsResourceClass : NSObject

/**
 Returns object with apropiate value.
 */
+ (APDnsResourceClass *)class:(uint16_t)value;

/**
 Returns object with internet (IN) resource class.
 */
+ (APDnsResourceClass *)internetClass;

@property (nonatomic) uint16_t intValue;

/**
 Returns human readable description of the current resource class.
 */
- (NSString *)humanReadable;

@end
