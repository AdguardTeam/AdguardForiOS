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

@interface ACNHttpUtils : NSObject

/// Returns ISO-8859-1 encoding that is default for HTTP headers
+ (NSStringEncoding)defaultHttpEncoding;

+ (NSStringEncoding)getCharsetFromContentType:(NSString *)contentType;

/**
 Return NSData bytes buffer with CRLF
 */
+ (NSData *)CRLFData;

/**
 Return NSData byte buffer with CR
 */
+ (NSData *)CRData;

/**
 Return NSData byte buffer with LF
 */
+ (NSData *)LFData;

/**
 Return NSData byte buffer with 0
 */
+ (NSData *)ZeroData;

@end
