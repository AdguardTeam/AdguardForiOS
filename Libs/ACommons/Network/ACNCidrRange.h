/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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
#pragma mark - ACNCidrRange

/**
 Represents IP address range with network mask
*/

@interface ACNCidrRange : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (instancetype) initWithAddress:(NSArray<NSNumber*>*) addr prefixLength: (int) prefixLen;
- (instancetype) initWithCidrString:(NSString*) cidrString;

/**
  Exclude given range from single original range
  @param originalRange Single original range
  @param excludedRange Single excluded range
  @return List of resulting ranges that cover all IPs from original ranges excluding all IPs from excluded ranges
 */
+ (NSArray<ACNCidrRange *> *)excludeFrom:(ACNCidrRange *) originalRange excludedRange: (ACNCidrRange *) excludedRange;

/**
  Exclude single range from original ranges
  @param originalRanges List of original ranges
  @param excludedRange List of excluded ranges
  @return List of resulting ranges that cover all IPs from original ranges excluding all IPs from excluded ranges
 */
+ (NSArray<ACNCidrRange*> *) excludeFrom:(NSArray<ACNCidrRange*> *)originalRanges excludedRanges:(NSArray<ACNCidrRange*> *)excludedRanges;

/**
  Utility method for expanding IPv6 address from short form
  @param addressString IPv6 address string (may be in short form)
  @return Expanded IPv6 address string
 */
+ (NSString*) expandIPv6String:(NSString*) addressString;

/**
  Utility method for converting IPv6 address string to short form
  @param addressString Address string
  @return Address string in short form
 */
+ (NSString*) shortenIPv6String:(NSString*) addressString;

/**
  Utility method for getting address bytes from string
  @param addressString Address string (IPv4 or IPv6)
  @return Address as array of numbers
 */
+ (NSArray<NSNumber*>*) getAddressFromString:(NSString*) addressString;

/////////////////////////////////////////////////////////////////////
#pragma mark instant methods

/**
  Checks if this range contains given range
  @param range CIDR range
  @return YES if this range contains given range, NO otherwise
 */
- (Boolean) contains:(ACNCidrRange*) range;

/**
  Splits this range into two with prefixLen increased by one
  @return Array of two CIDR ranges or nil if this range is single IP
 */
- (NSArray<ACNCidrRange*> *) split;

/**
 return cidr as String
 */
- (NSString*) toString;

@end
