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

@interface NSDate (Utils)

/**
    Create NSDate object from string representation of date time.
    @param description Date time conforms to ISO 8601 specification, example - 2014-04-15T20:01:25.873+04:00.
 */
+ (NSDate *)dateWithISO8601String:(NSString *)description;

/**
 Create NSDate object from string representation of date time.
 @param sqliteTimeStamp Date time conforms to TIMESTAMP field of SQlite database, example - 2014-04-15 20:01:25.
 */
+ (NSDate *)dateWithSQliteString:(NSString *)sqliteTimeStamp;


/**
    Convert NSDate object to string that conforms to ISO 8601 specification, example - 2014-04-15T20:01:25.873+04:00.
 */
- (NSString *)iso8601String;

/**
 * Parses HTTP date header
 *
 * @param dateValue Date value
 * @return Date parsed or nil if error
 */
+ (NSDate *)parseHttpDateFromString:(NSString *)dateValue;

/**
 * Formats date as HTTP Date header
 *
 * @param date Date to format
 * @return String in RFC 1123 format or nil if error
 */
+ (NSString *)formatHttpDate:(NSDate *)date;

@end
