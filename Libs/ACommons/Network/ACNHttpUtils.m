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
#import "ACLang.h"
#import "ACNHttpUtils.h"

@implementation ACNHttpUtils

/// Returns ISO-8859-1 encoding that is default for HTTP headers
+ (NSStringEncoding)defaultHttpEncoding
{
    return NSISOLatin1StringEncoding;
}

+ (NSStringEncoding)getCharsetFromContentType:(NSString *)contentType
{
    if (contentType && contentType.length > 0) {
        NSArray *parts = [contentType componentsSeparatedByString:@";"];
        for (NSString *t1 in parts) {
            NSString *t = [t1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSInteger index = [[t lowercaseString] indexOf:@"charset="];
            if (index != -1) {
                NSString *charset = [t substringFromIndex:index + 8];
                NSString *charset1 = [charset componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";,"]][0];
                NSStringEncoding encoding = [NSString encodingFromString:charset1 default:0];
                return encoding;
            }
        }
        return 0;
    }
    return 0;
}

+ (NSData *)CRLFData
{
	return [NSData dataWithBytes:"\x0D\x0A" length:2];
}

+ (NSData *)CRData
{
	return [NSData dataWithBytes:"\x0D" length:1];
}

+ (NSData *)LFData
{
	return [NSData dataWithBytes:"\x0A" length:1];
}

+ (NSData *)ZeroData
{
	return [NSData dataWithBytes:"" length:1];
}

@end
