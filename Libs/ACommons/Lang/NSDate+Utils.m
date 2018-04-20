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
#import "NSDate+Utils.h"

/**
 * Date format pattern used to parse HTTP date headers in RFC 1123 format.
 */
#define HTTP_DATE_PATTERN_RFC1123       @"EEE, dd MMM yyyy HH:mm:ss zzz"
/**
 * Date format pattern used to parse HTTP date headers in RFC 1036 format.
 */
#define HTTP_DATE_PATTERN_RFC1036       @"EEEE, dd-MMM-yy HH:mm:ss zzz"
/**
 * Date format pattern used to parse HTTP date headers in ANSI C asctime() format.
 */
#define HTTP_DATE_PATTERN_ASCTIME       @"EEE MMM d HH:mm:ss yyyy"

/**
 Date format pattern used to parse sqlite date string.
 */
#define SQLITE_DATE_PATTERN             @"yyyy-MM-dd HH:mm:ss ZZZ"

@implementation NSDate (Utils)

static NSDateFormatter *ISO8601DateFormater;
static NSArray *httpFormatters;
static NSDateFormatter *baseHttpFormatter;
static NSDateFormatter *sqliteDateFormater;

+ (NSDate *)dateWithISO8601String:(NSString *)description{
    
    [NSDate initISO8601Formater];
    if (!description)
        return [NSDate distantPast];
    
    NSUInteger index = description.length;
    if (index < 3)
        return [NSDate distantPast];
    
    index -= 3;
    NSString *string = [[description substringToIndex:index] stringByAppendingString:[description substringFromIndex:(index + 1)]];
    
    @synchronized(ISO8601DateFormater){

        return [ISO8601DateFormater dateFromString:string];
    }
}

+ (NSDate *)dateWithSQliteString:(NSString *)sqliteTimeStamp{
    
    if (!(sqliteTimeStamp && [sqliteTimeStamp isKindOfClass:[NSString class]]))
        return [NSDate distantPast];
    
    [NSDate initSqliteFormater];
    @synchronized(sqliteDateFormater){
        return [sqliteDateFormater dateFromString:[sqliteTimeStamp stringByAppendingString:@" +0000"]];
    }
}


- (NSString *)iso8601String{
    
    [NSDate initISO8601Formater];
    @synchronized(ISO8601DateFormater){

        NSString *string = [ISO8601DateFormater stringFromDate:self];
        NSUInteger delimeter = string.length - 2;
        return [NSString stringWithFormat:@"%@:%@",[string substringToIndex:delimeter] , [string substringFromIndex:delimeter]];
    }
}

+ (NSDate *)parseHttpDateFromString:(NSString *)dateValue{
    
    // trim single quotes around date if present
    // see issue #5279
    if (dateValue.length > 1
        && [dateValue hasPrefix:@"'"]
        && [dateValue hasSuffix:@"'"]
        ) {
        
        dateValue = [dateValue substringWithRange:NSMakeRange(1, dateValue.length - 2)];
    }
    
    [NSDate initHttpFormatters];
    
    NSDate *result;
    @synchronized(httpFormatters){
        
        for (NSDateFormatter *formater in httpFormatters) {
            
            result = [formater dateFromString:dateValue];
            if (result) {
                
                break;
            }
        }
    }
    
    return result;
}

+ (NSString *)formatHttpDate:(NSDate *)date{
    
    if (!date) {
        
        return nil;
    }
    
    [NSDate initHttpFormatters];

    @synchronized(baseHttpFormatter){
        
        return [baseHttpFormatter stringFromDate:date];
    }
}

////////////////////////////////////////////////////////////////////////////
#pragma mark Private methods
////////////////////////////////////////////////////////////////////////////

+ (void)initISO8601Formater{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ISO8601DateFormater = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [ISO8601DateFormater setLocale:enUSPOSIXLocale];
        [ISO8601DateFormater setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZZZ"];
        [ISO8601DateFormater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });
}

+ (void)initSqliteFormater{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sqliteDateFormater = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [sqliteDateFormater setLocale:enUSPOSIXLocale];
        [sqliteDateFormater setDateFormat:SQLITE_DATE_PATTERN];
        [sqliteDateFormater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });
}

+ (void)initHttpFormatters{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSMutableArray *formaterArray = [NSMutableArray arrayWithCapacity:3];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        NSDateFormatter *formater =[[NSDateFormatter alloc] init];
        [formater setLocale:enUSPOSIXLocale];
        [formater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [formater setDateFormat:HTTP_DATE_PATTERN_RFC1123];
        [formaterArray addObject:formater];
        
        formater =[[NSDateFormatter alloc] init];
        [formater setLocale:enUSPOSIXLocale];
        [formater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [formater setDateFormat:HTTP_DATE_PATTERN_RFC1036];
        [formaterArray addObject:formater];
        
        formater =[[NSDateFormatter alloc] init];
        [formater setLocale:enUSPOSIXLocale];
        [formater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [formater setDateFormat:HTTP_DATE_PATTERN_ASCTIME];
        [formaterArray addObject:formater];
        
        httpFormatters = [formaterArray copy];
        
        baseHttpFormatter = [[NSDateFormatter alloc] init];
        [baseHttpFormatter setLocale:enUSPOSIXLocale];
        [baseHttpFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [baseHttpFormatter setDateFormat:HTTP_DATE_PATTERN_RFC1123];
    });
}

@end
