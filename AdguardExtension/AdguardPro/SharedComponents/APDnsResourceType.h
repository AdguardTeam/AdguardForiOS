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

/**
 Class for holding DNS resource type value. 
 It main function is return name of the resource type as a description.
 For example: intValue = 1 and [self description] returns @"A".
 */
@interface APDnsResourceType : NSObject

/**
 Returns object with apropiate value.
 */
+ (APDnsResourceType *)type:(uint16_t)value;
/**
 Returns A resource type.
 */
+ (APDnsResourceType *)aType;
/**
 Returns AAAA resource type.
 */
+ (APDnsResourceType *)aaaaType;
/**
 Returns A6 resource type.
 */
+ (APDnsResourceType *)a6Type;

@property (nonatomic) uint16_t intValue;

/**
 Returns human readable description of the current resuorce type.
 */
- (NSString *)humanReadable;

@end
